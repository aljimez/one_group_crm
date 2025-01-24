<?php
session_start();
require_once 'config.php';
require_once 'utils.php';

// Verificar si el usuario está logueado
if (!isset($_SESSION['user_id'])) {
    sendJsonResponse(['error' => 'No autorizado'], 401);
}

// Verificar si el usuario es admin (ID = 0)
$isAdmin = ($_SESSION['user_id'] === '0' || $_SESSION['user_id'] === 0);

sendJsonResponse([
    'success' => true,
    'isAdmin' => $isAdmin
]);
