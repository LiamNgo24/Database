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
