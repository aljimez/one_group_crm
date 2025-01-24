<?php
session_start();
require_once 'config.php';
require_once 'utils.php';

if (!isset($_SESSION['user_id'])) {
    sendJsonResponse(['error' => 'No autorizado'], 401);
}

try {
    if (!isset($_POST['leadId']) || empty($_FILES['file'])) {
        throw new Exception('Faltan datos requeridos');
    }

    $leadId = $_POST['leadId'];
    $file = $_FILES['file'];

    // Validaciones básicas
    $maxSize = 5 * 1024 * 1024; // 5MB
    if ($file['size'] > $maxSize) {
        throw new Exception('El archivo excede el tamaño máximo permitido (5MB)');
    }

    // Validar tipos de archivo permitidos
    $allowedTypes = [
        'application/pdf',
        'application/msword',
        'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
        'application/vnd.ms-excel',
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        'image/jpeg',
        'image/png',
        'image/gif',
        'text/plain'
    ];

    $finfo = finfo_open(FILEINFO_MIME_TYPE);
    $mimeType = finfo_file($finfo, $file['tmp_name']);
    finfo_close($finfo);

    if (!in_array($mimeType, $allowedTypes)) {
        throw new Exception('Tipo de archivo no permitido');
    }

    // Verificar que el lead existe y el usuario tiene acceso
    $stmt = $pdo->prepare("
        SELECT 1 FROM leads 
        WHERE id = ? AND (user_id = ? OR EXISTS (
            SELECT 1 FROM user_lead_permissions 
            WHERE user_id = ? AND lead_id = ? AND can_edit = 1
        ))
    ");
    $stmt->execute([$leadId, $_SESSION['user_id'], $_SESSION['user_id'], $leadId]);
    
    if (!$stmt->fetch()) {
        throw new Exception('No tienes permiso para modificar este lead');
    }

    // Crear directorio si no existe
    $uploadDir = "../uploads/leads/{$leadId}/";
    if (!file_exists($uploadDir)) {
        mkdir($uploadDir, 0777, true);
    }

    // Generar nombre único para el archivo
    $fileExtension = strtolower(pathinfo($file['name'], PATHINFO_EXTENSION));
    $uniqueName = uniqid() . '_' . preg_replace("/[^a-zA-Z0-9.]/", "_", $file['name']);
    $uploadPath = $uploadDir . $uniqueName;

    // Mover archivo
    if (move_uploaded_file($file['tmp_name'], $uploadPath)) {
        // Registrar en la base de datos
        $stmt = $pdo->prepare("
            INSERT INTO lead_files (
                lead_id,
                file_name,
                file_path,
                original_name,
                file_type,
                file_size,
                uploaded_by,
                upload_date
            ) VALUES (?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)
        ");

        $stmt->execute([
            $leadId,
            $uniqueName,
            str_replace("../", "", $uploadPath),
            $file['name'],
            $mimeType,
            $file['size'],
            $_SESSION['user_id']
        ]);

        // Obtener el archivo recién subido con información del usuario
        $stmt = $pdo->prepare("
            SELECT f.*, u.name as uploaded_by_name 
            FROM lead_files f
            LEFT JOIN users u ON f.uploaded_by = u.id
            WHERE f.file_name = ?
        ");
        $stmt->execute([$uniqueName]);
        $fileInfo = $stmt->fetch(PDO::FETCH_ASSOC);

        sendJsonResponse([
            'success' => true,
            'message' => 'Archivo subido correctamente',
            'file' => $fileInfo
        ]);
    } else {
        throw new Exception('Error al subir el archivo');
    }

} catch (Exception $e) {
    logError('Error en upload_file.php: ' . $e->getMessage());
    sendJsonResponse([
        'error' => $e->getMessage()
    ], 500);
}