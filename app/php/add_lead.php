<?php
session_start();
require_once 'config.php';
require_once 'lead_operations.php';
require_once 'utils.php';

if (!isset($_SESSION['user_id'])) {
    sendJsonResponse(['error' => 'Unauthorized'], 401);
}

try {
    $name = $_POST['leadName'] ?? null;
    $email = $_POST['leadEmail'] ?? null;
    $phone = $_POST['leadPhone'] ?? null;
    $source = $_POST['leadSource'] ?? null;
    $notes = $_POST['leadNotes'] ?? null;
    $stageId = $_POST['leadStage'] ?? 1;

    if (empty($name)) {
        throw new Exception('El nombre es requerido');
    }

    // Check if email already exists
    if (!empty($email)) {
        $stmt = $pdo->prepare("SELECT id FROM leads WHERE email = ?");
        $stmt->execute([$email]);
        if ($stmt->fetch()) {
            sendJsonResponse([
                'success' => false,
                'message' => 'Ya existe un lead con este correo electrónico'
            ], 400);
            exit;
        }
    }

    $stmt = $pdo->prepare("
        INSERT INTO leads (
            user_id, 
            stage_id, 
            name, 
            email, 
            phone, 
            source, 
            notes, 
            created_at, 
            updated_at
        ) 
        VALUES (?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    ");

    $result = $stmt->execute([
        $_SESSION['user_id'],
        $stageId,
        $name,
        $email,
        $phone,
        $source,
        $notes
    ]);

    if (!$result) {
        throw new Exception('Error al insertar el lead en la base de datos');
    }

    $leadId = $pdo->lastInsertId();

    // Register in history
    $stmt = $pdo->prepare("
        INSERT INTO lead_history (lead_id, stage_id) 
        VALUES (?, ?)
    ");
    $stmt->execute([$leadId, $stageId]);

    sendJsonResponse([
        'success' => true,
        'message' => 'Lead añadido correctamente',
        'leadId' => $leadId
    ]);

} catch (Exception $e) {
    logError('Error in add_lead.php: ' . $e->getMessage());
    sendJsonResponse([
        'error' => 'Error al añadir el lead: ' . $e->getMessage()
    ], 500);
}