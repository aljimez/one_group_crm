<?php
session_start();
require_once 'config.php';
require_once 'utils.php';

if (!isset($_SESSION['user_id'])) {
    sendJsonResponse(['error' => 'Unauthorized'], 401);
}

try {
    // Obtener recontactos pendientes para hoy
    $stmt = $pdo->prepare("
        SELECT l.*, 
               s.name as stage_name,
               TIMESTAMPDIFF(MINUTE, NOW(), l.recontact_date) as minutes_until_recontact
        FROM leads l
        JOIN lead_stages s ON l.stage_id = s.id
        WHERE l.user_id = ?
        AND l.recontact_date IS NOT NULL
        AND l.recontact_date <= DATE_ADD(NOW(), INTERVAL 1 HOUR)
        AND s.name = 'ReContactar'
        ORDER BY l.recontact_date ASC
    ");
    
    $stmt->execute([$_SESSION['user_id']]);
    $dueRecontacts = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    sendJsonResponse([
        'success' => true,
        'dueRecontacts' => $dueRecontacts
    ]);

} catch (Exception $e) {
    logError('Error in get_due_recontacts.php: ' . $e->getMessage());
    sendJsonResponse(['error' => $e->getMessage()], 500);
}