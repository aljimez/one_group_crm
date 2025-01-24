<?php
session_start();
require_once 'config.php';

header('Content-Type: application/json');

try {
    $data = json_decode(file_get_contents('php://input'), true);
    
    // Validación básica
    $required = ['name', 'email', 'project_id', 'investment_amount', 'investment_date', 'expected_return'];
    foreach ($required as $field) {
        if (empty($data[$field])) {
            throw new Exception("El campo {$field} es requerido");
        }
    }

    // Generar contraseña aleatoria
    $password = bin2hex(random_bytes(8));
    $hashedPassword = password_hash($password, PASSWORD_DEFAULT);

    $pdo->beginTransaction();

    // Insertar inversor
    $stmt = $pdo->prepare("
        INSERT INTO investors (
            name, email, phone, password, project_id,
            investment_amount, investment_date, expected_return,
            status, notes, created_at
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())
    ");

    $stmt->execute([
        $data['name'],
        $data['email'],
        $data['phone'] ?? null,
        $hashedPassword,
        $data['project_id'],
        $data['investment_amount'],
        $data['investment_date'],
        $data['expected_return'],
        $data['status'] ?? 'active',
        $data['notes'] ?? null
    ]);

    $investorId = $pdo->lastInsertId();

    // Enviar email con credenciales
    $to = $data['email'];
    $subject = "Credenciales de acceso - ONE CLUB GROUP";
    $message = "
    Hola {$data['name']},

    Tus credenciales de acceso al portal de inversores son:
    Email: {$data['email']}
    Contraseña: {$password}

    Por favor, cambia tu contraseña en tu primer acceso.

    Saludos,
    ONE CLUB GROUP
    ";
    
    $headers = "From: noreply@oneclubgroup.com";

    mail($to, $subject, $message, $headers);

    $pdo->commit();
    
    echo json_encode([
        'success' => true,
        'message' => 'Inversor creado correctamente'
    ]);

} catch (Exception $e) {
    if ($pdo->inTransaction()) {
        $pdo->rollBack();
    }
    error_log($e->getMessage());
    echo json_encode([
        'success' => false,
        'message' => $e->getMessage()
    ]);
}
?>