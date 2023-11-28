DELIMITER $$
CREATE PROCEDURE InsertRandomProperties(IN NumRows INT)
BEGIN
   DECLARE i INT;
   SET i = 1;
   START TRANSACTION;
   WHILE i <= NumRows DO
       INSERT INTO Properties VALUES (
           i,
           CONCAT('Address ', i),
           ELT(1 + FLOOR(RAND() * 2), 'Commercial', 'Residential'),
           FLOOR(1000 + RAND() * 10000),
           'Amenities ',
           ELT(1 + FLOOR(RAND() * 3), 'Occupied', 'Available', 'Under Maintenance')
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

DELIMITER $$
CREATE PROCEDURE InsertRandomMaintenanceRequests(IN NumRows INT)
BEGIN
   DECLARE i INT;
   SET i = 1;
   START TRANSACTION;
   WHILE i <= NumRows DO
       INSERT INTO MaintenanceRequests VALUES (
           i,
           FLOOR(1 + RAND() * 100),
           'Issue Reported ',
           'Unit Affected ',
           ELT(1 + FLOOR(RAND() * 3), 'Low', 'Medium', 'High'),
           ELT(1 + FLOOR(RAND() * 3), 'Pending', 'In Progress', 'Completed')
       );
       SET i = i + 1;
   END WHILE;
   COMMIT;
END$$
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
