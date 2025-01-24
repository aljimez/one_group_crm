<?php
session_start();

function checkSession() {
    if (!isset($_SESSION['user_id']) || !isset($_SESSION['last_activity'])) {
        return false;
    }

    $inactive = 86400; // 24 horas en segundos

    if ((time() - $_SESSION['last_activity']) > $inactive) {
        session_unset();
        session_destroy();
        return false;
    }

    $_SESSION['last_activity'] = time();
    return true;
}

$isLoggedIn = checkSession();

// Si se hace una petición AJAX, devolver JSON
if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
    header('Content-Type: application/json');
    echo json_encode(['isLoggedIn' => $isLoggedIn]);
    exit;
}

// Si no es una petición AJAX y el usuario no está logueado, redirigir
if (!$isLoggedIn) {
    header('Location: login.html');
    exit();
}
?>
