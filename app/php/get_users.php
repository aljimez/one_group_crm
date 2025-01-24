<?php
session_start();
require_once 'config.php';
require_once 'utils.php';

// Verificar autenticación
if (!isset($_SESSION['user_id'])) {
    sendJsonResponse(['error' => 'No autorizado'], 401);
}

try {
    // Obtener todos los usuarios excepto el actual
    $stmt = $pdo->prepare("
        SELECT 
            id,
            name,
            email,
            role
        FROM users 
        WHERE id != ?
        ORDER BY name ASC
    ");
    
    $stmt->execute([$_SESSION['user_id']]);
    $users = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    // Verificar si se obtuvieron usuarios
    if (empty($users)) {
        // Si no hay otros usuarios, devolver un array vacío pero éxito = true
        sendJsonResponse([
            'success' => true,
            'users' => [],
            'message' => 'No hay otros usuarios disponibles'
        ]);
    } else {
        // Si hay usuarios, devolverlos
        sendJsonResponse([
            'success' => true,
            'users' => $users
        ]);
    }

} catch (Exception $e) {
    // Log del error
    logError('Error en get_users.php: ' . $e->getMessage());
    
    // Respuesta de error al cliente
    sendJsonResponse([
        'success' => false,
        'error' => 'Error al obtener usuarios'
    ], 500);
}