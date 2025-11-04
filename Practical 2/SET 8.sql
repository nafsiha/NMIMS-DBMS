-- Set 8: Retail Store Sales

CREATE DATABASE Retail_Store_Sales; 
USE Retail_Store_Sales; 

CREATE TABLE StoreSales (
    SaleID INT,
    StoreID INT,
    StoreLocation VARCHAR(100),
    CashierName VARCHAR(100),
    ProductID INT,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    SaleDate DATE,
    Quantity INT,
    TotalAmount DECIMAL(10,2));

INSERT INTO StoreSales 
VALUES
(1001,11,'Mumbai','Ramesh',201,'Shampoo','Personal Care','2025-09-01',2,398.00),
(1002,11,'Mumbai','Ramesh',202,'Soap','Personal Care','2025-09-01',3,150.00),
(1003,12,'Pune','Seema',201,'Shampoo','Personal Care','2025-09-02',1,199.00),
(1004,11,'Mumbai','Amit',203,'Toothpaste','Personal Care','2025-09-03',4,499.00),
(1005,13,'Delhi','Ritu',204,'T-Shirt','Clothing','2025-09-04',2,998.00);

INSERT INTO Stores 
VALUES 
(11,'Mumbai'),(12,'Pune'),(13,'Delhi');

INSERT INTO Cashiers (CashierID,CashierName) 
VALUES 
(1,'Ramesh'),(2,'Seema'),(3,'Amit'),(4,'Ritu');

INSERT INTO Products 
VALUES 
(201,'Shampoo','Personal Care'),(202,'Soap','Personal Care'),(203,'Toothpaste','Personal Care'),(204,'T-Shirt','Clothing');

INSERT INTO Sales 
VALUES 
(1001,11,1,'2025-09-01'),(1002,11,1,'2025-09-01'),(1003,12,2,'2025-09-02'),(1004,11,3,'2025-09-03'),(1005,13,4,'2025-09-04');

INSERT INTO SaleItems VALUES
(1001,201,2,398.00),
(1002,202,3,150.00),
(1003,201,1,199.00),
(1004,203,4,499.00),
(1005,204,2,998.00);

-- 1. Identify anomalies.
-- Insertion Anomaly: You can't add a new store, a new cashier, or a new product to the database unless it's part of a sale transaction. For instance, a new product can't be added to the catalog until it's sold.
-- Update Anomaly: If a product's category or a store's location changes, you must update every row where that product or store appears. This is inefficient and can easily lead to data inconsistencies.
-- Deletion Anomaly: Deleting the last sales record for a specific store or product will also delete all information about that store or product.

-- 2. Does schema satisfy 1NF? Explain.
-- Yes, the StoreSales table is in 1NF. All values in the table are atomic, and there are no repeating groups. Each cell contains a single, indivisible value.

-- 3. Normalize to 1NF.
-- Since the table is already in 1NF, no normalization is needed at this stage.

-- 4. State primary key.
-- The primary key for this unnormalized table is the composite key of (SaleID, ProductID). This combination uniquely identifies each item within a sales transaction.

-- 5. Write FDs.
-- The functional dependencies (FDs) are:
-- {SaleID} -> {StoreID, StoreLocation, CashierName, SaleDate}
-- {ProductID} -> {ProductName, Category}
-- {SaleID, ProductID} -> {Quantity, TotalAmount}
-- {StoreID} -> {StoreLocation}
-- {CashierName} -> {CashierID} (if CashierName is unique)

-- 6. Identify partial dependencies.
-- The table fails 2NF due to partial dependencies. Attributes are dependent on only part of the composite primary key (SaleID, ProductID).
-- StoreID, StoreLocation, CashierName, and SaleDate depend only on SaleID.
-- ProductName and Category depend only on ProductID.

-- 7. Convert to 2NF.
-- To achieve 2NF, we split the table to eliminate partial dependencies.
-- Stores: {StoreID, StoreLocation}
-- Cashiers: {CashierID, CashierName}
-- Products: {ProductID, ProductName, Category}
-- Sales: {SaleID, StoreID, CashierID, SaleDate}
-- SaleItems: {SaleID, ProductID, Quantity, TotalAmount}

-- 8. Write SQL for 2NF schema.
CREATE TABLE Stores (
    StoreID INT PRIMARY KEY,
    StoreLocation VARCHAR(100));

CREATE TABLE Cashiers (
    CashierID INT PRIMARY KEY,
    CashierName VARCHAR(100));

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50));

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    StoreID INT,
    CashierID INT,
    SaleDate DATE,
    FOREIGN KEY (StoreID) REFERENCES Stores(StoreID),
    FOREIGN KEY (CashierID) REFERENCES Cashiers(CashierID));

CREATE TABLE SaleItems (
    SaleID INT,
    ProductID INT,
    Quantity INT,
    TotalAmount DECIMAL(10,2),
    PRIMARY KEY (SaleID, ProductID),
    FOREIGN KEY (SaleID) REFERENCES Sales(SaleID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID));
    
-- 9. Identify transitive dependencies.
-- The 2NF schema does not have any transitive dependencies. Attributes like StoreLocation depend directly on their primary key StoreID, and Category depends on ProductID. This structure already satisfies 3NF.

-- 10. Convert to 3NF.
-- Since the 2NF schema is already in 3NF, no further conversion is needed.

-- 11. Write SQL for 3NF schema.
-- The SQL for the 3NF schema is the same as the one for the 2NF schema, as they are identical.
    
-- 12. Check BCNF.
-- Yes, the 3NF schema also satisfies BCNF. For every functional dependency, the determinant (the left side) is a superkey. There are no non-trivial dependencies where a non-superkey determines a key or a non-key attribute.

-- 13. Query: List sales per store.
SELECT st.StoreLocation, COUNT(s.SaleID) AS SalesCount, SUM(si.TotalAmount) AS Revenue
FROM Stores st JOIN Sales s ON st.StoreID=s.StoreID
JOIN SaleItems si ON s.SaleID=si.SaleID
GROUP BY st.StoreLocation;

-- 14. Query: Count products sold per category.
SELECT p.Category, SUM(si.Quantity) AS TotalSold
FROM Products p JOIN SaleItems si ON p.ProductID=si.ProductID
GROUP BY p.Category;

-- 15. Query: Find cashiers handling > 10 sales.
SELECT c.CashierName, COUNT(s.SaleID) AS SalesHandled
FROM Cashiers c JOIN Sales s ON c.CashierID=s.CashierID
GROUP BY c.CashierName
HAVING COUNT(s.SaleID) > 10;

-- 16. Query: Total sales per store location.
SELECT st.StoreLocation, SUM(si.TotalAmount) AS TotalRevenue
FROM Stores st
JOIN Sales s ON st.StoreID = s.StoreID
JOIN SaleItems si ON s.SaleID = si.SaleID
GROUP BY st.StoreLocation;

-- 17. Query: Top 5 selling products.
SELECT p.ProductID,p.ProductName,SUM(si.Quantity) AS TotalQty
FROM Products p JOIN SaleItems si ON p.ProductID=si.ProductID
GROUP BY p.ProductID,p.ProductName
ORDER BY TotalQty DESC
LIMIT 5;

-- 18. Query: Find categories with max revenue.
SELECT p.Category, SUM(si.TotalAmount) AS TotalRevenue
FROM Products p
JOIN SaleItems si ON p.ProductID = si.ProductID
GROUP BY p.Category
ORDER BY TotalRevenue DESC
LIMIT 1;

-- 19. Query: Sales trend per date.
SELECT s.SaleDate, SUM(si.TotalAmount) AS DailyRevenue
FROM Sales s
JOIN SaleItems si ON s.SaleID = si.SaleID
GROUP BY s.SaleDate
ORDER BY s.SaleDate;

-- 20. Compare redundancy before & after normalization.
-- Normalization drastically reduces data redundancy. In the unnormalized StoreSales table, information about stores (StoreID, StoreLocation), cashiers (CashierName), and products (ProductName, Category) is repeated for every sale item. For example, the StoreID and StoreLocation for Mumbai are repeated four times. The normalized schema eliminates this by storing each entity in a dedicated table (Stores, Cashiers, Products, Sales, SaleItems). These tables are linked via foreign keys, which means data is stored only once. This saves storage space, improves data integrity, and makes the database more efficient and easier to manage.