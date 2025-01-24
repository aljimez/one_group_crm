<?php
session_start();
require_once 'config.php';
require_once 'utils.php';

// Verify user is logged in
if (!isset($_SESSION['user_id'])) {
    sendJsonResponse(['error' => 'No autorizado'], 401);
}

try {
    // Get and validate required fields
    $type = $_POST['type'] ?? '';
    $description = $_POST['description'] ?? '';
    $leadId = $_POST['leadId'] ?? '';

    if (empty($type) || empty($description) || empty($leadId)) {
        throw new Exception('Faltan campos requeridos');
    }

    // Start transaction
    $pdo->beginTransaction();

    // Verify user has access to the lead
    $stmt = $pdo->prepare("
        SELECT 1 FROM leads 
        WHERE id = ? AND (user_id = ? OR EXISTS (
            SELECT 1 FROM user_lead_permissions 
            WHERE user_id = ? AND lead_id = ? AND can_edit = 1
        ))
    ");
    $stmt->execute([$leadId, $_SESSION['user_id'], $_SESSION['user_id'], $leadId]);
    
    if (!$stmt->fetch()) {
        throw new Exception('No tienes permiso para modificar este lead');
    }

    // Insert the new communication with explicit field names
    $stmt = $pdo->prepare("
        INSERT INTO communication_history 
            (lead_id, user_id, type, description, contact_date) 
        VALUES 
            (?, ?, ?, ?, CURRENT_TIMESTAMP)
    ");

    $result = $stmt->execute([
        $leadId,
        $_SESSION['user_id'],
        $type,
        $description
    ]);

    if (!$result) {
        throw new Exception('Error al guardar la comunicación');
    }

    // Update lead's last contact date
    $stmt = $pdo->prepare("
        UPDATE leads 
        SET last_contact = CURRENT_TIMESTAMP,
            updated_at = CURRENT_TIMESTAMP 
        WHERE id = ?
    ");
    $stmt->execute([$leadId]);

    $pdo->commit();
    sendJsonResponse(['success' => true]);

} catch (Exception $e) {
    if ($pdo->inTransaction()) {
        $pdo->rollBack();
    }
    logError('Error in add_communication.php: ' . $e->getMessage());
    sendJsonResponse(['error' => $e->getMessage()], 500);
}