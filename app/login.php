<?php
require_once 'config.php';

header('Content-Type: application/json');

$data = json_decode(file_get_contents('php://input'), true);
$email = $data['email'] ?? '';
$password = $data['password'] ?? '';

if (empty($email) || empty($password)) {
    echo json_encode(['success' => false, 'message' => 'Correo electrónico y contraseña son requeridos']);
    exit;
}

try {
    $stmt = $pdo->prepare("SELECT * FROM users WHERE email = ?");
    $stmt->execute([$email]);
    $user = $stmt->fetch();

    if ($user && password_verify($password, $user['password'])) {
        session_start();
        $_SESSION['user_id'] = $user['id'];
        $_SESSION['user_name'] = $user['name']; // Guardamos el nombre en la sesión
        $_SESSION['last_activity'] = time();
        setcookie('session_token', bin2hex(random_bytes(32)), time() + 86400, '/', '', true, true);
        echo json_encode(['success' => true, 'name' => $user['name']]); // Devolvemos el nombre
    } else {
        echo json_encode(['success' => false, 'message' => 'Correo electrónico o contraseña incorrectos']);
    }
} catch (PDOException $e) {
    error_log($e->getMessage());
    echo json_encode(['success' => false, 'message' => 'Error en el servidor']);
}
?>