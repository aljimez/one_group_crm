<?php
session_start();
require_once 'config.php';
require_once 'utils.php';

if (!isset($_SESSION['user_id'])) {
    sendJsonResponse(['error' => 'No autorizado'], 401);
}

$input = json_decode(file_get_contents('php://input'), true);

if (!isset($input['leadId']) || !isset($input['userId'])) {
    sendJsonResponse(['error' => 'Faltan campos requeridos'], 400);
}

try {
    // Verificar si el usuario destino existe - Modificado para permitir userId 0
    $stmt = $pdo->prepare("SELECT id, name FROM users WHERE id = ? OR (? = '0' AND id = '0')");
    $stmt->execute([$input['userId'], $input['userId']]);
    $newUser = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if (!$newUser && $input['userId'] !== '0') {
        throw new Exception('Usuario no encontrado');
    }

    // Si es el admin (ID 0) o el propietario actual del lead
    $stmt = $pdo->prepare("
        SELECT l.*, u.name as current_owner_name 
        FROM leads l
        LEFT JOIN users u ON l.user_id = u.id
        WHERE l.id = ? AND (? = 0 OR l.user_id = ? OR EXISTS (
            SELECT 1 FROM user_lead_permissions 
            WHERE user_id = ? AND lead_id = l.id AND can_edit = 1
        ))
    ");
    
    $stmt->execute([
        $input['leadId'], 
        $_SESSION['user_id'], 
        $_SESSION['user_id'], 
        $_SESSION['user_id']
    ]);
    $lead = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$lead) {
        throw new Exception('Lead no encontrado o sin permisos');
    }

    $pdo->beginTransaction();

    // Actualizar la asignación del lead
    $stmt = $pdo->prepare("
        UPDATE leads 
        SET user_id = ?, 
            updated_at = CURRENT_TIMESTAMP 
        WHERE id = ?
    ");
    
    $stmt->execute([
        $input['userId'] === '0' ? '0' : $input['userId'],
        $input['leadId']
    ]);

    // Registrar el cambio en el historial
    $stmt = $pdo->prepare("
        INSERT INTO lead_history 
        (lead_id, action_type, stage_id, notes, created_by) 
        VALUES (?, 'assignment_change', ?, ?, ?)
    ");
    
    $changeNote = sprintf(
        "Lead reasignado de %s a %s",
        $lead['current_owner_name'] ?? 'Sin asignar',
        $input['userId'] === '0' ? 'Admin' : $newUser['name']
    );
    
    $stmt->execute([
        $input['leadId'],
        $lead['stage_id'],
        $changeNote,
        $_SESSION['user_id']
    ]);

    $pdo->commit();
    sendJsonResponse([
        'success' => true,
        'message' => 'Lead asignado correctamente'
    ]);

} catch (Exception $e) {
    if ($pdo->inTransaction()) {
        $pdo->rollBack();
    }
    logError('Error en assign_lead.php: ' . $e->getMessage());
    sendJsonResponse(['error' => $e->getMessage()], 500);
}