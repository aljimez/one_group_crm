<?php
require_once 'config.php';

function createLead($userId, $stageId, $name, $email, $phone, $source, $notes) {
    global $pdo;
    $sql = "INSERT INTO leads (user_id, stage_id, name, email, phone, source, notes) VALUES (?, ?, ?, ?, ?, ?, ?)";
    $stmt = $pdo->prepare($sql);
    return $stmt->execute([$userId, $stageId, $name, $email, $phone, $source, $notes]);
}

function getLeadsByUser($userId) {
    global $pdo;
    $sql = "SELECT l.*, s.name as stage_name FROM leads l JOIN lead_stages s ON l.stage_id = s.id WHERE l.user_id = ? ORDER BY s.order_num, l.created_at";
    $stmt = $pdo->prepare($sql);
    $stmt->execute([$userId]);
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}

function updateLead($leadId, $stageId, $name, $email, $phone, $notes, $additionalFields = []) {
    global $pdo;
    $sql = "UPDATE leads SET name = ?, email = ?, phone = ?, notes = ?, stage_id = ?, source = ?";
    $params = [$name, $email, $phone, $notes, $stageId, $additionalFields['source'] ?? null];
    
    foreach ($additionalFields as $field => $value) {
        if ($field !== 'source') {
            $sql .= ", $field = ?";
            $params[] = $value;
        }
    }
    
    $sql .= " WHERE id = ?";
    $params[] = $leadId;

    $stmt = $pdo->prepare($sql);
    return $stmt->execute($params);
}

function deleteLead($leadId) {
    global $pdo;
    $sql = "DELETE FROM leads WHERE id = ?";
    $stmt = $pdo->prepare($sql);
    return $stmt->execute([$leadId]);
}

function getLeadStages() {
    global $pdo;
    $sql = "SELECT * FROM lead_stages ORDER BY order_num";
    $stmt = $pdo->prepare($sql);
    $stmt->execute();
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}

function getLeadById($leadId) {
    global $pdo;
    $sql = "SELECT * FROM leads WHERE id = ?";
    $stmt = $pdo->prepare($sql);
    $stmt->execute([$leadId]);
    return $stmt->fetch(PDO::FETCH_ASSOC);
}

function getAllLeads() {
    global $pdo;
    $sql = "SELECT l.*, 
                   s.name as stage_name, 
                   u.name as user_name 
            FROM leads l 
            JOIN lead_stages s ON l.stage_id = s.id 
            JOIN users u ON l.user_id = u.id 
            ORDER BY l.created_at DESC";
    $stmt = $pdo->prepare($sql);
    $stmt->execute();
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}