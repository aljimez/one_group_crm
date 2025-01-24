<?php
session_start();
require_once 'config.php';

header('Content-Type: application/json');

$data = json_decode(file_get_contents('php://input'), true);
$email = $data['email'] ?? '';
$password = $data['password'] ?? '';

if (empty($email) || empty($password)) {
    echo json_encode(['success' => false, 'message' => 'Email y contraseña son requeridos']);
    exit;
}

try {
    $stmt = $pdo->prepare("SELECT * FROM investors WHERE email = ?");
    $stmt->execute([$email]);
    $investor = $stmt->fetch();

    if ($investor && password_verify($password, $investor['password'])) {
        $_SESSION['investor_id'] = $investor['id'];
        $_SESSION['investor_name'] = $investor['name'];
        $_SESSION['last_activity'] = time();
        echo json_encode(['success' => true, 'name' => $investor['name']]);
    } else {
        echo json_encode(['success' => false, 'message' => 'Email o contraseña incorrectos']);
    }
} catch (PDOException $e) {
    error_log($e->getMessage());
    echo json_encode(['success' => false, 'message' => 'Error en el servidor']);
}
?>