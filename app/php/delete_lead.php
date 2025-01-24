<?php
session_start();
require_once 'config.php';
require_once 'lead_operations.php';
require_once 'utils.php';

if (!isset($_SESSION['user_id'])) {
    sendJsonResponse(['error' => 'Unauthorized'], 401);
}

$input = json_decode(file_get_contents('php://input'), true);

if (!isset($input['leadId'])) {
    sendJsonResponse(['error' => 'Missing lead ID'], 400);
}

try {
    $result = deleteLead($input['leadId']);

    if ($result) {
        sendJsonResponse(['success' => true]);
    } else {
        sendJsonResponse(['error' => 'Failed to delete lead'], 500);
    }
} catch (Exception $e) {
    logError('Error in delete_lead.php: ' . $e->getMessage(), __FILE__, __LINE__);
    sendJsonResponse(['error' => 'An error occurred while deleting the lead'], 500);
}
