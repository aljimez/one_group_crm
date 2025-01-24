<?php
session_start();
require_once 'config.php';
require_once 'lead_operations.php';
require_once 'utils.php';

// Activar logs de error
ini_set('display_errors', 1);
error_reporting(E_ALL);

function logDebug($message) {
    error_log("[DEBUG] " . $message);
}

if (!isset($_SESSION['user_id'])) {
    sendJsonResponse(['error' => 'Unauthorized'], 401);
}

$input = json_decode(file_get_contents('php://input'), true);
logDebug("Input recibido: " . print_r($input, true));

if (!isset($input['leadId']) || !isset($input['stageId'])) {
    sendJsonResponse(['error' => 'Missing required fields'], 400);
}

try {
    $pdo->beginTransaction();

    // Obtener información de la etapa
    $stmt = $pdo->prepare("SELECT name FROM lead_stages WHERE id = ?");
    $stmt->execute([$input['stageId']]);
    $stage = $stmt->fetch(PDO::FETCH_ASSOC);
    logDebug("Etapa encontrada: " . print_r($stage, true));

    // Verificar si el lead pertenece al usuario actual y obtener sus datos
    $stmt = $pdo->prepare("SELECT * FROM leads WHERE id = ? AND user_id = ?");
    $stmt->execute([$input['leadId'], $_SESSION['user_id']]);
    $lead = $stmt->fetch(PDO::FETCH_ASSOC);
    logDebug("Lead encontrado: " . print_r($lead, true));

    if (!$lead) {
        throw new Exception('Lead not found or access denied');
    }

    // Actualizar la etapa del lead
    $stmt = $pdo->prepare("
        UPDATE leads 
        SET stage_id = ?, 
            updated_at = CURRENT_TIMESTAMP 
        WHERE id = ?
    ");
    $result = $stmt->execute([$input['stageId'], $input['leadId']]);
    logDebug("Resultado de actualización de etapa: " . ($result ? "éxito" : "fallo"));

    if (!$result) {
        throw new Exception('Failed to update lead stage');
    }

    // Registrar en el historial
    $stmt = $pdo->prepare("
        INSERT INTO lead_history (lead_id, stage_id) 
        VALUES (?, ?)
    ");
    $result = $stmt->execute([$input['leadId'], $input['stageId']]);
    logDebug("Resultado de inserción en historial: " . ($result ? "éxito" : "fallo"));

    if (!$result) {
        throw new Exception('Failed to record lead history');
    }

    // Si la nueva etapa es "ReContactar", enviar datos a Zapier
    if ($stage['name'] === 'ReContactar' && !empty($lead['email'])) {
        logDebug("Etapa es ReContactar - Enviando a Zapier");
        
        // Calcular fecha de recontacto (3 días desde hoy)
        $fechaRecontacto = date('Y-m-d H:i:s', strtotime('+3 days'));
        
        // Actualizar la fecha de recontacto en el lead
        $stmt = $pdo->prepare("
            UPDATE leads 
            SET recontact_date = ?,
                updated_at = CURRENT_TIMESTAMP 
            WHERE id = ?
        ");
        $stmt->execute([$fechaRecontacto, $input['leadId']]);
        
        // Enviar datos a Zapier
        $zapierWebhookUrl = 'https://hooks.zapier.com/hooks/catch/14654628/25rzsc8/';
        $zapierData = [
            'lead_id' => $lead['id'],
            'name' => $lead['name'],
            'email' => $lead['email'],
            'phone' => $lead['phone'],
            'recontact_date' => $fechaRecontacto,
            'source' => $lead['source'],
            'notes' => $lead['notes']
        ];

        $ch = curl_init($zapierWebhookUrl);
        curl_setopt($ch, CURLOPT_POST, 1);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($zapierData));
        curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json']);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        
        $zapierResponse = curl_exec($ch);
        $zapierHttpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);
        
        logDebug("Respuesta de Zapier: " . $zapierResponse . " (HTTP: " . $zapierHttpCode . ")");
    }

    $pdo->commit();
    sendJsonResponse([
        'success' => true,
        'message' => 'Lead actualizado correctamente',
        'debug_info' => [
            'stage_name' => $stage['name'],
            'has_email' => !empty($lead['email']),
            'email' => $lead['email'] ?? 'no email'
        ]
    ]);

} catch (Exception $e) {
    $pdo->rollBack();
    logError('Error in update_lead_stage.php: ' . $e->getMessage(), __FILE__, __LINE__);
    sendJsonResponse([
        'error' => $e->getMessage(),
        'debug_info' => [
            'file' => $e->getFile(),
            'line' => $e->getLine()
        ]
    ], 500);
}