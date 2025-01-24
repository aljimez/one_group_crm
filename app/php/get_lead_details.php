<?php
// get_lead_details.php
session_start();
require_once 'config.php';
require_once 'utils.php';

if (!isset($_SESSION['user_id']) || !isset($_GET['id'])) {
    sendJsonResponse(['error' => 'Unauthorized or missing lead ID'], 401);
}

try {
    $stmt = $pdo->prepare("
        SELECT * FROM leads 
        WHERE id = ? AND user_id = ?
    ");
    $stmt->execute([$_GET['id'], $_SESSION['user_id']]);
    $lead = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($lead) {
        sendJsonResponse(['success' => true, 'lead' => $lead]);
    } else {
        sendJsonResponse(['error' => 'Lead not found'], 404);
    }
} catch (Exception $e) {
    logError('Error in get_lead_details.php: ' . $e->getMessage());
    sendJsonResponse(['error' => 'Server error'], 500);
}

// get_lead_files.php
session_start();
require_once 'config.php';
require_once 'utils.php';

if (!isset($_SESSION['user_id']) || !isset($_GET['id'])) {
    sendJsonResponse(['error' => 'Unauthorized or missing lead ID'], 401);
}

try {
    $stmt = $pdo->prepare("
        SELECT * FROM lead_files 
        WHERE lead_id = ? AND user_id = ?
        ORDER BY created_at DESC
    ");
    $stmt->execute([$_GET['id'], $_SESSION['user_id']]);
    $files = $stmt->fetchAll(PDO::FETCH_ASSOC);

    sendJsonResponse(['success' => true, 'files' => $files]);
} catch (Exception $e) {
    logError('Error in get_lead_files.php: ' . $e->getMessage());
    sendJsonResponse(['error' => 'Server error'], 500);
}

// upload_files.php
session_start();
require_once 'config.php';
require_once 'utils.php';

if (!isset($_SESSION['user_id']) || !isset($_POST['leadId'])) {
    sendJsonResponse(['error' => 'Unauthorized or missing lead ID'], 401);
}

try {
    if (!isset($_FILES['files'])) {
        throw new Exception('No files uploaded');
    }

    $uploadDir = '../uploads/leads/' . $_POST['leadId'] . '/';
    if (!file_exists($uploadDir)) {
        mkdir($uploadDir, 0777, true);
    }

    $uploadedFiles = [];
    foreach ($_FILES['files']['tmp_name'] as $key => $tmp_name) {
        $fileName = $_FILES['files']['name'][$key];
        $filePath = $uploadDir . basename($fileName);
        
        if (move_uploaded_file($tmp_name, $filePath)) {
            $stmt = $pdo->prepare("
                INSERT INTO lead_files (lead_id, user_id, file_name, file_path) 
                VALUES (?, ?, ?, ?)
            ");
            $stmt->execute([
                $_POST['leadId'],
                $_SESSION['user_id'],
                $fileName,
                str_replace('../', '', $filePath)
            ]);
            
            $uploadedFiles[] = [
                'id' => $pdo->lastInsertId(),
                'name' => $fileName,
                'path' => str_replace('../', '', $filePath)
            ];
        }
    }

    sendJsonResponse(['success' => true, 'files' => $uploadedFiles]);
} catch (Exception $e) {
    logError('Error in upload_files.php: ' . $e->getMessage());
    sendJsonResponse(['error' => 'Error uploading files'], 500);
}

// delete_file.php
session_start();
require_once 'config.php';
require_once 'utils.php';

$input = json_decode(file_get_contents('php://input'), true);

if (!isset($_SESSION['user_id']) || !isset($input['fileId'])) {
    sendJsonResponse(['error' => 'Unauthorized or missing file ID'], 401);
}

try {
    // Obtener información del archivo
    $stmt = $pdo->prepare("
        SELECT * FROM lead_files 
        WHERE id = ? AND user_id = ?
    ");
    $stmt->execute([$input['fileId'], $_SESSION['user_id']]);
    $file = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$file) {
        throw new Exception('File not found or unauthorized');
    }

    // Eliminar el archivo físico
    $filePath = '../' . $file['file_path'];
    if (file_exists($filePath)) {
        unlink($filePath);
    }

    // Eliminar el registro de la base de datos
    $stmt = $pdo->prepare("DELETE FROM lead_files WHERE id = ?");
    $stmt->execute([$input['fileId']]);

    sendJsonResponse(['success' => true]);
} catch (Exception $e) {
    logError('Error in delete_file.php: ' . $e->getMessage());
    sendJsonResponse(['error' => 'Error deleting file'], 500);
}

// save_notes.php
session_start();
require_once 'config.php';
require_once 'utils.php';

$input = json_decode(file_get_contents('php://input'), true);

if (!isset($_SESSION['user_id']) || !isset($input['leadId']) || !isset($input['notes'])) {
    sendJsonResponse(['error' => 'Unauthorized or missing required data'], 401);
}

try {
    $stmt = $pdo->prepare("
        INSERT INTO lead_notes (lead_id, user_id, content) 
        VALUES (?, ?, ?)
    ");
    $stmt->execute([
        $input['leadId'],
        $_SESSION['user_id'],
        $input['notes']
    ]);

    sendJsonResponse(['success' => true]);
} catch (Exception $e) {
    logError('Error in save_notes.php: ' . $e->getMessage());
    sendJsonResponse(['error' => 'Error saving notes'], 500);
}

// get_lead_notes.php
session_start();
require_once 'config.php';
require_once 'utils.php';

if (!isset($_SESSION['user_id']) || !isset($_GET['id'])) {
    sendJsonResponse(['error' => 'Unauthorized or missing lead ID'], 401);
}

try {
    $stmt = $pdo->prepare("
        SELECT * FROM lead_notes 
        WHERE lead_id = ? AND user_id = ?
        ORDER BY created_at DESC
    ");
    $stmt->execute([$_GET['id'], $_SESSION['user_id']]);
    $notes = $stmt->fetchAll(PDO::FETCH_ASSOC);

    sendJsonResponse(['success' => true, 'notes' => $notes]);
} catch (Exception $e) {
    logError('Error in get_lead_notes.php: ' . $e->getMessage());
    sendJsonResponse(['error' => 'Server error'], 500);
}
