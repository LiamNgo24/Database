DELIMITER //
CREATE PROCEDURE SubmitMaintenanceRequest(
    IN p_PropertyID INT,
    IN p_IssueReported TEXT,
    IN p_UnitAffected VARCHAR(255),
    IN p_UrgencyLevel VARCHAR(50)
)
BEGIN
    INSERT INTO MaintenanceRequests (PropertyID, IssueReported, UnitAffected, UrgencyLevel, RequestStatus) 
    VALUES (p_PropertyID, p_IssueReported, p_UnitAffected, p_UrgencyLevel, 'Pending');
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE AssignTaskToVendor(
    IN p_RequestID INT,
    IN p_VendorID INT,
    IN p_ScheduledDate DATE
)
BEGIN
    UPDATE MaintenanceRequests
    SET VendorID = p_VendorID, ScheduledDate = p_ScheduledDate, RequestStatus = 'In Progress'
    WHERE RequestID = p_RequestID;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE UpdateMaintenanceRequestStatus(
    IN p_RequestID INT,
    IN p_RequestStatus VARCHAR(50)
)
BEGIN
    UPDATE MaintenanceRequests
    SET RequestStatus = p_RequestStatus
    WHERE RequestID = p_RequestID;
END //
DELIMITER ;
