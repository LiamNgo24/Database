-- GENERATE RANDOM DATA
DELIMITER $$
CREATE PROCEDURE InsertRandomProperties(IN NumRows INT)
BEGIN
    DECLARE i INT;
    SET i = 1;
    START TRANSACTION;
    WHILE i <= NumRows DO
        INSERT INTO Properties (PropertyID, Address, PropertyType, Size, Amenities, Status, RentalPrice, ListingStatus) VALUES (
            i,
            CONCAT('Address ', i),
            ELT(1 + FLOOR(RAND() * 2), 'Commercial', 'Residential'),
            FLOOR(1000 + RAND() * 10000),
            'Amenities ',
            ELT(1 + FLOOR(RAND() * 3), 'Occupied', 'Available', 'Under Maintenance'),
            FLOOR(500 + RAND() * 1500), -- Assuming rental price is between 500 to 2000
            ELT(1 + FLOOR(RAND() * 2), 'Listed', 'Not Listed') -- Assuming these are the only two statuses
        );
        SET i = i + 1;
    END WHILE;
    COMMIT;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE InsertRandomOwners(IN NumRows INT)
BEGIN
   DECLARE i INT;
   SET i = 1;
   START TRANSACTION;
   WHILE i <= NumRows DO
       INSERT INTO Owners VALUES (
           i,
           FLOOR(1 + RAND() * 100),
           'Contact Information ',
           RAND(),
           'Payment Details '
       );
       SET i = i + 1;
   END WHILE;
   COMMIT;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE InsertRandomTenants(IN NumRows INT)
BEGIN
   DECLARE i INT;
   SET i = 1;
   START TRANSACTION;
   WHILE i <= NumRows DO
       INSERT INTO Tenants VALUES (
           i,
           FLOOR(1 + RAND() * 100),
           'Lease Terms ',
           'Contact Information ',
           ELT(1 + FLOOR(RAND() * 2), 'Current', 'Past')
       );
       SET i = i + 1;
   END WHILE;
   COMMIT;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE InsertRandomLeases(IN NumRows INT)
BEGIN
   DECLARE i INT;
   SET i = 1;
   START TRANSACTION;
   WHILE i <= NumRows DO
       INSERT INTO Leases VALUES (
           i,
           FLOOR(1 + RAND() * 100),
           FLOOR(1 + RAND() * 100),
           CURDATE() - INTERVAL FLOOR(RAND() * 365) DAY,
           CURDATE() - INTERVAL FLOOR(RAND() * 365) DAY,
           RAND() * 1000,
           RAND() * 100,
           'Lease Terms '
       );
       SET i = i + 1;
   END WHILE;
   COMMIT;
END$$
DELIMITER ;

-- DELIMITER $$
-- CREATE PROCEDURE InsertRandomMaintenanceRequests(IN NumRows INT)
-- BEGIN
--    DECLARE i INT;
--    SET i = 1;
--    START TRANSACTION;
--    WHILE i <= NumRows DO
--        INSERT INTO MaintenanceRequests VALUES (
--            i,
--            FLOOR(1 + RAND() * 100),
--            'Issue Reported ',
--            'Unit Affected ',
--            ELT(1 + FLOOR(RAND() * 3), 'Low', 'Medium', 'High'),
--            ELT(1 + FLOOR(RAND() * 3), 'Pending', 'In Progress', 'Completed'),
--            '0',
--            CURDATE()
--        );
--        SET i = i + 1;
--    END WHILE;
--    COMMIT;
-- END$$
-- DELIMITER ;

-- Assuming you are inserting random maintenance requests and assigning them to random vendors
DELIMITER $$
CREATE PROCEDURE `InsertRandomMaintenanceRequests`(IN NumRequests INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE randVendorID, randPropertyID INT;
    DECLARE maxVendorID, maxPropertyID INT;

    SELECT MAX(VendorID) INTO maxVendorID FROM Vendors;
    SELECT MAX(PropertyID) INTO maxPropertyID FROM Properties;

    WHILE i <= NumRequests DO
        -- Ensure the random IDs exist in their respective tables
        SET randVendorID = FLOOR(1 + RAND() * maxVendorID);
        SET randPropertyID = FLOOR(1 + RAND() * maxPropertyID);

        INSERT INTO MaintenanceRequests (PropertyID, IssueReported, UnitAffected, UrgencyLevel, RequestStatus, VendorID, ScheduledDate)
        VALUES (
            randPropertyID,
            CONCAT('Issue ', i),
            CONCAT('Unit ', i),
            ELT(1 + FLOOR(RAND() * 3), 'Low', 'Medium', 'High'),
            'Pending',
            randVendorID,
            CURDATE() -- Or however you determine the date
        );

        SET i = i + 1;
    END WHILE;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE InsertRandomVendors(IN NumRows INT)
BEGIN
   DECLARE i INT;
   SET i = 1;
   START TRANSACTION;
   WHILE i <= NumRows DO
       INSERT INTO Vendors VALUES (
           i,
           'Contact Information ',
           'Services Offered ',
           RAND() * 1000,
           'Performance Ratings '
       );
       SET i = i + 1;
   END WHILE;
   COMMIT;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE InsertRandomFinancialTransactions(IN NumRows INT)
BEGIN
   DECLARE i INT;
   SET i = 1;
   START TRANSACTION;
   WHILE i <= NumRows DO
       INSERT INTO FinancialTransactions VALUES (
           i,
           FLOOR(1 + RAND() * 100),
           FLOOR(1 + RAND() * 100),
           FLOOR(1 + RAND() * 100),
           ELT(1 + FLOOR(RAND() * 5), 'Rent', 'Maintenance', 'Taxes', 'Insurance', 'Income'),
           RAND() * 1000,
           CURDATE() - INTERVAL FLOOR(RAND() * 365) DAY
       );
       SET i = i + 1;
   END WHILE;
   COMMIT;
END$$
DELIMITER ;


-- PROCEDURES TO CREATE LISTINGS
DELIMITER $$
CREATE PROCEDURE CreateListing(IN p_PropertyID INT, IN p_Description TEXT, IN p_LeaseTerms TEXT, IN p_RentalPrice DECIMAL)
BEGIN
    INSERT INTO Listings (PropertyID, ListingDescription, PublishedDate, LeaseTerms) 
    VALUES (p_PropertyID, p_Description, CURDATE(), p_LeaseTerms);

    UPDATE Properties 
    SET RentalPrice = p_RentalPrice, ListingStatus = 'Listed' 
    WHERE PropertyID = p_PropertyID;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE UpdateListing(IN p_ListingID INT, IN p_Description TEXT, IN p_LeaseTerms TEXT, IN p_RentalPrice DECIMAL)
BEGIN
    UPDATE Listings 
    SET ListingDescription = p_Description, LeaseTerms = p_LeaseTerms
    WHERE ListingID = p_ListingID;

    UPDATE Properties 
    SET RentalPrice = p_RentalPrice
    WHERE PropertyID = (SELECT PropertyID FROM Listings WHERE ListingID = p_ListingID);
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE PublishListing(IN p_ListingID INT)
BEGIN
    UPDATE Listings 
    SET PublishedDate = CURDATE()
    WHERE ListingID = p_ListingID;

    UPDATE Properties 
    SET ListingStatus = 'Listed'
    WHERE PropertyID = (SELECT PropertyID FROM Listings WHERE ListingID = p_ListingID);
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE UnpublishListing(IN p_ListingID INT)
BEGIN
    UPDATE Properties 
    SET ListingStatus = 'Not Listed'
    WHERE PropertyID = (SELECT PropertyID FROM Listings WHERE ListingID = p_ListingID);
END $$
DELIMITER ;


-- PROCEDURES TO CREATE MAINTENANCE REQUESTS
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
