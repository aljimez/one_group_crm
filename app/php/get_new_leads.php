<?php
session_start();
require_once 'config.php';
require_once 'lead_operations.php';
require_once 'utils.php';

if (!isset($_SESSION['user_id'])) {
    sendJsonResponse(['error' => 'Unauthorized'], 401);
}

$lastId = isset($_GET['lastId']) ? intval($_GET['lastId']) : 0;

try {
    $stmt = $pdo->prepare("SELECT l.*, s.name as stage_name FROM leads l 
                           JOIN lead_stages s ON l.stage_id = s.id 
                           WHERE l.user_id = ? AND l.id > ? 
                           ORDER BY l.id ASC");
    $stmt->execute([$_SESSION['user_id'], $lastId]);
    $newLeads = $stmt->fetchAll(PDO::FETCH_ASSOC);

    sendJsonResponse(['success' => true, 'leads' => $newLeads]);
} catch (Exception $e) {
    logError('Error in get_new_leads.php: ' . $e->getMessage(), __FILE__, __LINE__);
    sendJsonResponse(['error' => 'An error occurred while fetching new leads'], 500);
}