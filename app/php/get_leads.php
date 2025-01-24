<?php
session_start();
require_once 'config.php';
require_once 'lead_operations.php';

if (!isset($_SESSION['user_id'])) {
    echo json_encode(['error' => 'No autorizado']);
    exit;
}

try {
    // Si es el usuario admin (ID 0), obtener todos los leads
    if ($_SESSION['user_id'] == 0) {
        $leads = getAllLeads();
    } else {
        $leads = getLeadsByUser($_SESSION['user_id']);
    }
    
    $stages = getLeadStages();
    echo json_encode(['success' => true, 'leads' => $leads, 'stages' => $stages]);
} catch (Exception $e) {
    echo json_encode(['error' => 'Error al obtener los leads: ' . $e->getMessage()]);
}
?>