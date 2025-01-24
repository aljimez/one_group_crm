<?php
session_start();
require_once 'config.php';

header('Content-Type: application/json');

if (!isset($_SESSION['investor_id'])) {
    echo json_encode(['success' => false, 'error' => 'No autorizado']);
    exit;
}

try {
    // Get investor and project data
    $stmt = $pdo->prepare("
        SELECT i.*, p.name as project_name, p.description as project_description
        FROM investors i
        LEFT JOIN projects p ON i.project_id = p.id
        WHERE i.id = ?
    ");
    $stmt->execute([$_SESSION['investor_id']]);
    $investor = $stmt->fetch();

    if (!$investor) {
        echo json_encode(['success' => false, 'error' => 'Inversor no encontrado']);
        exit;
    }

    // Get investment performance
    $stmt = $pdo->prepare("
        SELECT ip.* 
        FROM investment_performance ip
        WHERE ip.investor_id = ?
        ORDER BY ip.date DESC 
        LIMIT 6
    ");
    $stmt->execute([$_SESSION['investor_id']]);
    $performance = $stmt->fetchAll();

    // Get investor documents
    $stmt = $pdo->prepare("
        SELECT *
        FROM investor_documents 
        WHERE investor_id = ?
        ORDER BY upload_date DESC
    ");
    $stmt->execute([$_SESSION['investor_id']]);
    $documents = $stmt->fetchAll();

    echo json_encode([
        'success' => true,
        'investor' => $investor,
        'performance' => $performance,
        'documents' => $documents
    ]);

} catch (PDOException $e) {
    error_log($e->getMessage());
    echo json_encode(['success' => false, 'error' => 'Error en el servidor']);
}
?>