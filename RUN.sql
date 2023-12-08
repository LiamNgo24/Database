DROP SCHEMA IF EXISTS `REPMS` ;
CREATE SCHEMA IF NOT EXISTS `REPMS` DEFAULT CHARACTER SET latin1 ;
USE `REPMS` ;

-- SQL Script to create the database tables

-- Creating Properties Table
CREATE TABLE Properties (
    PropertyID INT PRIMARY KEY,
    Address VARCHAR(255),
    PropertyType VARCHAR(50), -- 'Commercial' or 'Residential'
    Size INT,
    Amenities TEXT,
    Status VARCHAR(50), -- 'Occupied', 'Available', 'Under Maintenance'
    RentalPrice DECIMAL,
    ListingStatus VARCHAR(50)
);

-- Creating Owners Table
CREATE TABLE Owners (
    OwnerID INT PRIMARY KEY,
    PropertyID INT,
    ContactInformation VARCHAR(255),
    OwnershipPercentage FLOAT,
    PaymentDetails TEXT,
    FOREIGN KEY (PropertyID) REFERENCES Properties(PropertyID)
);

-- Creating Tenants Table
CREATE TABLE Tenants (
    TenantID INT PRIMARY KEY,
    PropertyID INT,
    LeaseTerms TEXT,
    ContactInformation VARCHAR(255),
    TenantHistory VARCHAR(50), -- 'Current' or 'Past'
    FOREIGN KEY (PropertyID) REFERENCES Properties(PropertyID)
);

-- Creating Leases Table
CREATE TABLE Leases (
    LeaseID INT PRIMARY KEY,
    PropertyID INT,
    TenantID INT,
    StartDate DATE,
    EndDate DATE,
    RentalAmount DECIMAL,
    SecurityDeposit DECIMAL,
    LeaseTerms TEXT,
    PaymentStatus TEXT,
    FOREIGN KEY (PropertyID) REFERENCES Properties(PropertyID),
    FOREIGN KEY (TenantID) REFERENCES Tenants(TenantID)
);

-- Creating Vendors Table
CREATE TABLE Vendors (
    VendorID INT PRIMARY KEY,
    ContactInformation VARCHAR(255),
    ServicesOffered TEXT,
    Rates DECIMAL,
    PerformanceRatings VARCHAR(255)
);

-- Creating Maintenance Requests Table
CREATE TABLE MaintenanceRequests (
    RequestID INT AUTO_INCREMENT PRIMARY KEY,
    PropertyID INT,
    IssueReported TEXT,
    UnitAffected VARCHAR(255),
    UrgencyLevel VARCHAR(50), -- e.g., 'Low', 'Medium', 'High'
    RequestStatus VARCHAR(50), -- 'Pending', 'In Progress', 'Completed'
    VendorID INT,
    ScheduledDate DATE,
    FOREIGN KEY (VendorID) REFERENCES Vendors(VendorID),
    FOREIGN KEY (PropertyID) REFERENCES Properties(PropertyID)
);

-- Creating Financial Transactions Table
CREATE TABLE FinancialTransactions (
    TransactionID INT AUTO_INCREMENT PRIMARY KEY,
    PropertyID INT,
    TenantID INT,
    OwnerID INT,
    TransactionType VARCHAR(50), -- e.g., 'Rent', 'Maintenance', 'Taxes', 'Insurance', 'Income'
    Amount DECIMAL,
    Date DATE,
    FOREIGN KEY (PropertyID) REFERENCES Properties(PropertyID),
    FOREIGN KEY (TenantID) REFERENCES Tenants(TenantID),
    FOREIGN KEY (OwnerID) REFERENCES Owners(OwnerID)
);

-- Creating Listings Table
CREATE TABLE Listings (
    ListingID INT AUTO_INCREMENT PRIMARY KEY,
    PropertyID INT,
    ListingDescription TEXT,
    PublishedDate DATE,
    LeaseTerms TEXT,
    FOREIGN KEY (PropertyID) REFERENCES Properties(PropertyID)
);


-- Procedures.sql
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
            ELT(1 + FLOOR(RAND() * 4), 'Occupied', 'Available', 'Under Maintenance', 'Available'),
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
    DECLARE startDate DATE;
    DECLARE endDate DATE;
    SET i = 1;
    
    START TRANSACTION;
    
    WHILE i <= NumRows DO
        -- Generate a random start date from now to 365 days in the past
        SET startDate = CURDATE() - INTERVAL FLOOR(RAND() * 365) DAY;
        
        -- Generate a random end date from the start date to 365 days in the future
        SET endDate = startDate + INTERVAL FLOOR(RAND() * 365) DAY;

        INSERT INTO Leases (LeaseID, PropertyID, TenantID, StartDate, EndDate, RentalAmount, SecurityDeposit, LeaseTerms, PaymentStatus)
        VALUES (
            i,
            FLOOR(1 + RAND() * 100), -- Random PropertyID
            FLOOR(1 + RAND() * 100), -- Random TenantID
            startDate,
            endDate,
            RAND() * 1000, -- Random RentalAmount
            RAND() * 100,  -- Random SecurityDeposit
            'Lease Terms ', -- Example Lease Terms
            'Unpaid'       -- PaymentStatus
        );
        
        SET i = i + 1;
    END WHILE;
    
    COMMIT;
END$$

DELIMITER ;

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

-- Interest Calculation
DELIMITER $$

CREATE PROCEDURE CalculateLatePaymentInterest()
BEGIN
    -- Define variables
    DECLARE today DATE;
    DECLARE finished INTEGER DEFAULT 0;
    DECLARE v_TenantID INT;
    DECLARE v_LeaseID INT;
    DECLARE v_InterestDue DECIMAL(10,2);

    -- Cursor declaration
    DECLARE cur CURSOR FOR 
        SELECT TenantID, LeaseID, InterestDue 
        FROM OverduePayments;

    -- Continue handler declaration
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;

    SET today = CURDATE();
    
    -- Temporary table to hold overdue payments
    CREATE TEMPORARY TABLE IF NOT EXISTS OverduePayments (
        TenantID INT,
        LeaseID INT,
        DaysLate INT,
        AmountDue DECIMAL(10,2),
        InterestDue DECIMAL(10,2)
    );

    -- Insert overdue payments into temporary table
    INSERT INTO OverduePayments (TenantID, LeaseID, DaysLate, AmountDue)
    -- The below SELECT statement should be customized to match your database schema
    SELECT TenantID, LeaseID, DATEDIFF(today, EndDate) AS DaysLate, RentalAmount
    FROM Leases
    WHERE EndDate < today AND PaymentStatus = 'Unpaid';

    -- Calculate the interest due for each overdue payment
    -- Customize this calculation based on your specific interest rules
    UPDATE OverduePayments
    SET InterestDue = AmountDue * (5 / 100) * (DaysLate / 365);

    -- Open the cursor
    OPEN cur;

    -- Loop through all records
    loop1: LOOP
        FETCH cur INTO v_TenantID, v_LeaseID, v_InterestDue;
        IF finished = 1 THEN 
            LEAVE loop1;
        END IF;

        -- Insert a new financial transaction for the interest due
        -- The INSERT statement should be customized to match your database schema
        INSERT INTO FinancialTransactions (TenantID, PropertyID, TransactionType, Amount, Date)
        VALUES (v_TenantID, (SELECT PropertyID FROM Leases WHERE LeaseID = v_LeaseID), 'Interest', v_InterestDue, today);
    END LOOP loop1;

    -- Close the cursor
    CLOSE cur;

    -- Drop the temporary table
    DROP TEMPORARY TABLE OverduePayments;
END$$

DELIMITER ;


-- AnalyseProcedures.sql
-- Property Type Preferences: This query categorizes properties by type, shedding light on customer preferences.-- 
DELIMITER //
CREATE PROCEDURE PropertyTypePreferences()
BEGIN
   SELECT PropertyType, COUNT(*) AS NumberOfProperties
   FROM Properties
   GROUP BY PropertyType;
END //
DELIMITER ;

-- Geographic Dynamics: This query identifies properties with the highest and lowest rental prices. This data assists in understanding the geographical variations in demand.-- 
DELIMITER //
CREATE PROCEDURE GeographicDynamics()
BEGIN
   SELECT Address, RentalPrice
   FROM Properties
   ORDER BY RentalPrice DESC
   LIMIT 5;
END //
DELIMITER ;

-- Fluctuations in Property Prices: Examining properties with significant fluctuations in rental prices provides crucial insights into changing market dynamics.
DELIMITER //
CREATE PROCEDURE FluctuationsInPropertyPrices()
BEGIN
   SELECT PropertyID, RentalPrice
   FROM Properties
   WHERE RentalPrice IN (
      SELECT RentalPrice
      FROM Properties
      GROUP BY RentalPrice
      HAVING COUNT(*) > 1
   );
END //
DELIMITER ;

-- Price Range Insights: The analysis highlights properties with wider ranges between lowest and highest rental prices.
DELIMITER //
CREATE PROCEDURE PriceRangeInsights()
BEGIN
   SELECT Address, RentalPrice
   FROM Properties
   ORDER BY RentalPrice DESC
   LIMIT 5;
END //
DELIMITER ;

-- Investment Opportunities: Identifying properties with consistent growth in average rental prices and high rental volumes presents lucrative investment opportunities.
DELIMITER //
CREATE PROCEDURE InvestmentOpportunities()
BEGIN
   SELECT PropertyID, AVG(RentalPrice) AS AverageRentalPrice
   FROM Properties
   GROUP BY PropertyID
   HAVING COUNT(*) > 1
   ORDER BY AverageRentalPrice DESC
   LIMIT 5;
END //
DELIMITER ;

-- Neighborhood Sales Trends Over Time: The analysis of sales trends over different years uncovers valuable insights into the market’s evolution.
DELIMITER //
CREATE PROCEDURE NeighborhoodSalesTrendsOverTime()
BEGIN
   SELECT YEAR(StartDate) AS Year, COUNT(*) AS NumberOfLeases
   FROM Leases
   GROUP BY Year;
END //
DELIMITER ;

-- Neighborhoods with Upward-Trending Prices: The analysis reveals properties with low average rental prices but upward-trending prices.
DELIMITER //
CREATE PROCEDURE NeighborhoodsWithUpwardTrendingPrices()
BEGIN
   SELECT PropertyID, AVG(RentalPrice) AS AverageRentalPrice
   FROM Properties
   GROUP BY PropertyID
   HAVING COUNT(*) > 1
   ORDER BY AverageRentalPrice ASC
   LIMIT 5;
END //
DELIMITER ;

-- Find the Average rental price for each property type
DELIMITER //
CREATE PROCEDURE AverageRentalPrice()
BEGIN
  SELECT PropertyType, AVG(RentalPrice) AS AverageRentalPrice
  FROM Properties
  GROUP BY PropertyType;
END //
DELIMITER ;

-- Find out the average ownership percentage
DELIMITER //
CREATE PROCEDURE AverageOwnershipPercentage()
BEGIN
  SELECT AVG(OwnershipPercentage) AS AverageOwnershipPercentage
  FROM Owners;
END //
DELIMITER ;

-- Number of tenants per property
DELIMITER //
CREATE PROCEDURE NumberOfTenants()
BEGIN
  SELECT PropertyID, COUNT(*) AS NumberOfTenants
  FROM Tenants
  GROUP BY PropertyID;
END //
DELIMITER ;

-- find average rental amount for each lease term
DELIMITER //
CREATE PROCEDURE AverageRentalAmount()
BEGIN
  SELECT LeaseTerms, AVG(RentalAmount) AS AverageRentalAmount
  FROM Leases
  GROUP BY LeaseTerms;
END //
DELIMITER ;

-- Average rating for each vendors
DELIMITER //
CREATE PROCEDURE AverageRating()
BEGIN
  SELECT VendorID, AVG(PerformanceRatings) AS AverageRating
  FROM Vendors
  GROUP BY VendorID;
END //
DELIMITER ;

-- Number of requests per property
DELIMITER //
CREATE PROCEDURE NumberOfRequests()
BEGIN
  SELECT PropertyID, COUNT(*) AS NumberOfRequests
  FROM MaintenanceRequests
  GROUP BY PropertyID;
END //
DELIMITER ;

-- Find the total income and expenses per proerty
DELIMITER //
CREATE PROCEDURE TotalIncomeAndExpenses()
BEGIN
  SELECT PropertyID, 
         SUM(CASE WHEN TransactionType = 'Income' THEN Amount ELSE 0 END) AS TotalIncome,
         SUM(CASE WHEN TransactionType != 'Income' THEN Amount ELSE 0 END) AS TotalExpenses
  FROM FinancialTransactions
  GROUP BY PropertyID;
END //
DELIMITER ;

-- Find the number of listings per property
DELIMITER //
CREATE PROCEDURE NumberOfListings()
BEGIN
  SELECT PropertyID, COUNT(*) AS NumberOfListings
  FROM Listings
  GROUP BY PropertyID;
END //
DELIMITER ;

-- This query provides the number of maintenance requests for each urgency level.
DELIMITER //
CREATE PROCEDURE MaintenanceRequestTrends()
BEGIN
 SELECT UrgencyLevel, COUNT(*) AS NumberOfRequests
 FROM MaintenanceRequests
 GROUP BY UrgencyLevel;
END //
DELIMITER ;

-- This query provides the number of sales for each property.
DELIMITER //
CREATE PROCEDURE PropertySalesTrends()
BEGIN
 SELECT PropertyID, COUNT(*) AS NumberOfSales
 FROM FinancialTransactions
 WHERE TransactionType = 'Rent'
 GROUP BY PropertyID;
END //
DELIMITER ;

-- This query provides the number of real estate sales each year.
DELIMITER //
CREATE PROCEDURE YearlySalesTrends()
BEGIN
 SELECT YEAR(Date) AS Year, COUNT(*) AS NumberOfSales
 FROM FinancialTransactions
 WHERE TransactionType = 'Rent'
 GROUP BY Year;
END //
DELIMITER ;


-- Call_procedure1.sql
CALL `repms`.`InsertRandomProperties`(100);
CALL `repms`.`InsertRandomOwners`(100);
CALL `repms`.`InsertRandomTenants`(100);
CALL `repms`.`InsertRandomVendors`(100);
CALL `repms`.`InsertRandomFinancialTransactions`(100);
CALL `repms`.`InsertRandomLeases`(100);