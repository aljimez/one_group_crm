<?php
session_start();
require_once 'config.php';
require_once 'lead_operations.php';

if (!isset($_SESSION['user_id'])) {
    echo json_encode(['error' => 'No autorizado']);
    exit;
}

try {
    // Si es el usuario admin (ID 0), obtener TODOS los leads
    if ($_SESSION['user_id'] == 0) {
        $stmt = $pdo->prepare("
            SELECT l.*, 
                   s.name as stage_name, 
                   u.name as user_name,
                   (SELECT JSON_ARRAYAGG(
                       JSON_OBJECT(
                           'stage_id', lh.stage_id,
                           'changed_at', lh.changed_at,
                           'action_type', lh.action_type
                       )
                   )
                   FROM lead_history lh
                   WHERE lh.lead_id = l.id
               ) as history
            FROM leads l
            JOIN lead_stages s ON l.stage_id = s.id
            JOIN users u ON l.user_id = u.id
            ORDER BY l.created_at DESC
        ");
        $stmt->execute();
    } else {
        // Para usuarios normales, solo sus propios leads
        $stmt = $pdo->prepare("
            SELECT l.*, 
                   s.name as stage_name, 
                   (SELECT JSON_ARRAYAGG(
                       JSON_OBJECT(
                           'stage_id', lh.stage_id,
                           'changed_at', lh.changed_at,
                           'action_type', lh.action_type
                       )
                   )
                   FROM lead_history lh
                   WHERE lh.lead_id = l.id
               ) as history
            FROM leads l
            JOIN lead_stages s ON l.stage_id = s.id
            WHERE l.user_id = ?
            ORDER BY l.created_at DESC
        ");
        $stmt->execute([$_SESSION['user_id']]);
    }

    $leadsWithHistory = $stmt->fetchAll(PDO::FETCH_ASSOC);

    foreach ($leadsWithHistory as &$lead) {
        $lead['history'] = json_decode($lead['history'], true);
    }

    $stages = getLeadStages();

    echo json_encode(['success' => true, 'leadsWithHistory' => $leadsWithHistory, 'stages' => $stages]);
} catch (Exception $e) {
    echo json_encode(['error' => 'Error al obtener los leads: ' . $e->getMessage()]);
}