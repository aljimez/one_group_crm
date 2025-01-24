// delete_file.php
<?php
session_start();
require_once 'config.php';
require_once 'utils.php';

if (!isset($_SESSION['user_id'])) {
    sendJsonResponse(['error' => 'No autorizado'], 401);
}

try {
    $data = json_decode(file_get_contents('php://input'), true);
    $fileId = $data['fileId'] ?? null;
    
    if (!$fileId) {
        throw new Exception('ID de archivo no proporcionado');
    }

    // Obtener información del archivo
    $stmt = $pdo->prepare("
        SELECT * FROM lead_files 
        WHERE id = ? AND uploaded_by = ?
    ");
    $stmt->execute([$fileId, $_SESSION['user_id']]);
    $file = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$file) {
        throw new Exception('Archivo no encontrado o sin permisos');
    }

    // Eliminar archivo físico
    $fullPath = "../" . $file['file_path'];
    if (file_exists($fullPath)) {
        unlink($fullPath);
    }

    // Eliminar registro de la base de datos
    $stmt = $pdo->prepare("DELETE FROM lead_files WHERE id = ?");
    $stmt->execute([$fileId]);

    sendJsonResponse([
        'success' => true,
        'message' => 'Archivo eliminado correctamente'
    ]);

} catch (Exception $e) {
    logError('Error en delete_file.php: ' . $e->getMessage());
    sendJsonResponse([
        'error' => $e->getMessage()
    ], 500);
}