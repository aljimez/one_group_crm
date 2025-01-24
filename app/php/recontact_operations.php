<?php
// recontact_operations.php

function scheduleRecontact($leadId, $userId, $recontactDate, $notes = null) {
    global $pdo;
    
    try {
        $pdo->beginTransaction();
        
        // Actualizar el lead
        $stmt = $pdo->prepare("
            UPDATE leads 
            SET recontact_date = ?,
                recontact_notes = ?,
                stage_id = (SELECT id FROM lead_stages WHERE name = 'ReContactar'),
                updated_at = CURRENT_TIMESTAMP
            WHERE id = ? AND user_id = ?
        ");
        
        $stmt->execute([$recontactDate, $notes, $leadId, $userId]);
        
        // Registrar en la tabla de recontactos
        $stmt = $pdo->prepare("
            INSERT INTO lead_recontacts 
            (lead_id, scheduled_date, notes, created_by)
            VALUES (?, ?, ?, ?)
        ");
        
        $stmt->execute([$leadId, $recontactDate, $notes, $userId]);
        
        // Registrar en el historial
        $stmt = $pdo->prepare("
            INSERT INTO lead_history 
            (lead_id, action_type, notes, created_by)
            VALUES (?, 'recontact_scheduled', ?, ?)
        ");
        
        $stmt->execute([$leadId, $notes, $userId]);
        
        $pdo->commit();
        return true;
        
    } catch (Exception $e) {
        $pdo->rollBack();
        logError('Error in scheduleRecontact: ' . $e->getMessage());
        return false;
    }
}

function getRecontactLeads($userId) {
    global $pdo;
    
    $stmt = $pdo->prepare("
        SELECT l.*, s.name as stage_name, 
               lr.scheduled_date as recontact_date,
               lr.notes as recontact_notes,
               DATEDIFF(lr.scheduled_date, CURRENT_TIMESTAMP) as days_until_recontact
        FROM leads l
        JOIN lead_stages s ON l.stage_id = s.id
        LEFT JOIN lead_recontacts lr ON l.id = lr.lead_id AND lr.status = 'pending'
        WHERE l.user_id = ? 
        AND (s.name = 'ReContactar' OR lr.id IS NOT NULL)
        ORDER BY lr.scheduled_date ASC
    ");
    
    $stmt->execute([$userId]);
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}

function completeRecontact($leadId, $userId, $notes = null) {
    global $pdo;
    
    try {
        $pdo->beginTransaction();
        
        // Actualizar el estado del recontacto
        $stmt = $pdo->prepare("
            UPDATE lead_recontacts
            SET status = 'completed',
                updated_at = CURRENT_TIMESTAMP
            WHERE lead_id = ? AND status = 'pending'
        ");
        
        $stmt->execute([$leadId]);
        
        // Actualizar el lead
        $stmt = $pdo->prepare("
            UPDATE leads
            SET last_contact = CURRENT_TIMESTAMP,
                recontact_date = NULL,
                recontact_notes = NULL,
                stage_id = (SELECT id FROM lead_stages WHERE name = 'Contactado')
            WHERE id = ? AND user_id = ?
        ");
        
        $stmt->execute([$leadId, $userId]);
        
        // Registrar en el historial
        $stmt = $pdo->prepare("
            INSERT INTO lead_history 
            (lead_id, action_type, notes, created_by)
            VALUES (?, 'recontact_completed', ?, ?)
        ");
        
        $stmt->execute([$leadId, $notes, $userId]);
        
        $pdo->commit();
        return true;
        
    } catch (Exception $e) {
        $pdo->rollBack();
        logError('Error in completeRecontact: ' . $e->getMessage());
        return false;
    }
}
