<?php
session_start();
require_once 'config.php';
require_once 'lead_operations.php';
require_once 'utils.php';

if (!isset($_SESSION['user_id'])) {
    sendJsonResponse(['error' => 'Unauthorized'], 401);
}

if (!isset($_POST['leadId'])) {
    sendJsonResponse(['error' => 'Missing lead ID'], 400);
}

try {
    $pdo->beginTransaction();

    // Actualizar el lead
    $result = updateLead(
        $_POST['leadId'],
        $_POST['leadStage'],
        $_POST['leadName'],
        $_POST['leadEmail'],
        $_POST['leadPhone'],
        $_POST['leadNotes'],
        ['source' => $_POST['leadSource']]
    );

    if ($result) {
        // Obtener los datos actualizados del lead
        $stmt = $pdo->prepare("
            SELECT l.*, s.name as stage_name, u.name as user_name 
            FROM leads l
            LEFT JOIN lead_stages s ON l.stage_id = s.id
            LEFT JOIN users u ON l.user_id = u.id
            WHERE l.id = ?
        ");
        $stmt->execute([$_POST['leadId']]);
        $updatedLead = $stmt->fetch(PDO::FETCH_ASSOC);

        $pdo->commit();
        
        sendJsonResponse([
            'success' => true, 
            'lead' => $updatedLead,
            'message' => 'Lead actualizado con éxito'
        ]);
    } else {
        throw new Exception('Failed to update lead');
    }
} catch (Exception $e) {
    $pdo->rollBack();
    logError('Error in edit_lead.php: ' . $e->getMessage(), __FILE__, __LINE__);
    sendJsonResponse(['error' => 'An error occurred while updating the lead'], 500);
}