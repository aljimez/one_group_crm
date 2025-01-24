// php/utils.php
<?php
function logError($message) {
    $logFile = __DIR__ . '/error.log';
    $timestamp = date('[Y-m-d H:i:s]');
    error_log("$timestamp $message\n", 3, $logFile);
}

function sendJsonResponse($data, $statusCode = 200) {
    http_response_code($statusCode);
    header('Content-Type: application/json');
    echo json_encode($data);
    exit;
}

function validateInvestor($investor) {
    if (empty($investor['email']) || empty($investor['password'])) {
        return false;
    }
    return true;
}

function formatCurrency($amount) {
    return number_format($amount, 2, ',', '.') . ' €';
}

function calculateInvestmentGrowth($initial, $rate, $months) {
    $monthlyRate = $rate / 100 / 12;
    $growth = [];
    
    for ($i = 1; $i <= $months; $i++) {
        $growth[] = $initial * pow(1 + $monthlyRate, $i);
    }
    
    return $growth;
}

function getInvestmentStatus($status) {
    $statusMap = [
        'active' => 'Activa',
        'pending' => 'Pendiente',
        'completed' => 'Completada',
        'cancelled' => 'Cancelada'
    ];
    
    return $statusMap[$status] ?? 'Desconocido';
}
