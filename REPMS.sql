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
    FOREIGN KEY (PropertyID) REFERENCES Properties(PropertyID),
    FOREIGN KEY (TenantID) REFERENCES Tenants(TenantID)
);

-- Creating Maintenance Requests Table
CREATE TABLE MaintenanceRequests (
    RequestID INT PRIMARY KEY,
    PropertyID INT,
    IssueReported TEXT,
    UnitAffected VARCHAR(255),
    UrgencyLevel VARCHAR(50), -- e.g., 'Low', 'Medium', 'High'
    RequestStatus VARCHAR(50), -- 'Pending', 'In Progress', 'Completed'
    FOREIGN KEY (PropertyID) REFERENCES Properties(PropertyID)
);

-- Creating Vendors Table
CREATE TABLE Vendors (
    VendorID INT PRIMARY KEY,
    ContactInformation VARCHAR(255),
    ServicesOffered TEXT,
    Rates DECIMAL,
    PerformanceRatings VARCHAR(255)
);

-- Creating Financial Transactions Table
CREATE TABLE FinancialTransactions (
    TransactionID INT PRIMARY KEY,
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
    ListingID INT PRIMARY KEY,
    PropertyID INT,
    ListingDescription TEXT,
    PublishedDate DATE,
    LeaseTerms TEXT,
    FOREIGN KEY (PropertyID) REFERENCES Properties(PropertyID)
);

