<?php
function logError($message, $file = null, $line = null) {
    $logMessage = date('[Y-m-d H:i:s] ') . $message;
    if ($file && $line) {
        $logMessage .= " in $file on line $line";
    }
    error_log($logMessage . PHP_EOL, 3, 'error.log');
}

function sendJsonResponse($data, $statusCode = 200) {
    http_response_code($statusCode);
    header('Content-Type: application/json');
    echo json_encode($data);
    exit;
}
