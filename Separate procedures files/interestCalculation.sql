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
