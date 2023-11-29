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
