<?php
require_once 'config.php';
require_once 'lead_operations.php';
require_once 'utils.php';

$api_key = 'rogelio';
$headers = getallheaders();
if (!isset($headers['X-Api-Key']) || $headers['X-Api-Key'] !== $api_key) {
    sendJsonResponse(['error' => 'Unauthorized'], 401);
}

$input = json_decode(file_get_contents('php://input'), true);

if (!isset($input['facebook_page_id']) || !isset($input['name'])) {
    sendJsonResponse(['error' => 'Missing required fields'], 400);
}

try {
    // Verificar usuario basado en facebook_page_id
    $stmt = $pdo->prepare("SELECT id FROM users WHERE facebook_page_id = ?");
    $stmt->execute([$input['facebook_page_id']]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$user) {
        sendJsonResponse(['error' => 'User not found'], 404);
    }

    // Verificar si el email ya existe
    if (!empty($input['email'])) {
        $stmt = $pdo->prepare("SELECT id FROM leads WHERE email = ?");
        $stmt->execute([$input['email']]);
        if ($stmt->fetch()) {
            sendJsonResponse([
                'success' => false,
                'message' => 'Ya existe un lead con este correo electrónico'
            ], 400);
            exit;
        }
    }

    $result = createLead(
        $user['id'],
        1,
        $input['name'],
        $input['email'] ?? null,
        $input['phone'] ?? null,
        $input['source'] ?? null,
        $input['notes'] ?? null
    );

    if ($result) {
        sendJsonResponse(['success' => true, 'message' => 'Lead created successfully']);
    } else {
        sendJsonResponse(['error' => 'Failed to create lead'], 500);
    }
} catch (Exception $e) {
    logError('Error in zapier_webhook.php: ' . $e->getMessage(), __FILE__, __LINE__);
    sendJsonResponse(['error' => 'An error occurred while processing the webhook'], 500);
}