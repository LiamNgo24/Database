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
