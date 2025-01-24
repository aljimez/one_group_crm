<?php
// get_lead_files.php
session_start();
require_once 'config.php';
require_once 'utils.php';

if (!isset($_SESSION['user_id'])) {
    sendJsonResponse(['error' => 'No autorizado'], 401);
}

try {
    $leadId = $_GET['leadId'] ?? null;
    
    if (!$leadId) {
        throw new Exception('ID de lead no proporcionado');
    }

    $stmt = $pdo->prepare("
        SELECT f.*, u.name as uploaded_by_name
        FROM lead_files f
        LEFT JOIN users u ON f.uploaded_by = u.id
        WHERE f.lead_id = ?
        ORDER BY f.upload_date DESC
    ");

    $stmt->execute([$leadId]);
    $files = $stmt->fetchAll(PDO::FETCH_ASSOC);

    sendJsonResponse([
        'success' => true,
        'files' => $files
    ]);

} catch (Exception $e) {
    logError('Error en get_lead_files.php: ' . $e->getMessage());
    sendJsonResponse([
        'error' => $e->getMessage()
    ], 500);
}
