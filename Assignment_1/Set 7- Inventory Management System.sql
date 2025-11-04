-- set 7
CREATE DATABASE InventoryManagement;
USE InventoryManagement;

CREATE TABLE Suppliers (
  SupplierID INT PRIMARY KEY,
  SupplierName VARCHAR(100),
  Contact VARCHAR(50),
  City VARCHAR(50)
);

CREATE TABLE Categories (
  CategoryID INT PRIMARY KEY,
  CategoryName VARCHAR(50)
);

CREATE TABLE Products (
  ProductID INT PRIMARY KEY,
  ProductName VARCHAR(100),
  CategoryID INT,
  SupplierID INT,
  Price DECIMAL(10,2),
  Stock INT,
  FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
  FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

CREATE TABLE Purchases (
  PurchaseID INT PRIMARY KEY,
  ProductID INT,
  Quantity INT,
  PurchaseDate DATE,
  SupplierID INT,
  FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
  FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

CREATE TABLE Sales (
  SaleID INT PRIMARY KEY,
  ProductID INT,
  Quantity INT,
  SaleDate DATE,
  CustomerName VARCHAR(100),
  FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Insert sample Suppliers
INSERT INTO Suppliers VALUES
  (1, 'ABC Supplies', 'Rahul Kumar', 'Delhi'),
  (2, 'XYZ Traders', 'Anita Sharma', 'Mumbai'),
  (3, 'PQR Distributors', 'Suresh Patel', 'Bangalore'),
  (4, 'LMN Wholesalers', 'Priya Singh', 'Chennai'),
  (5, 'RST Enterprises', 'Vikram Joshi', 'Delhi');

-- Insert sample Categories
INSERT INTO Categories VALUES
  (1, 'Electronics'),
  (2, 'Furniture'),
  (3, 'Stationery'),
  (4, 'Clothing'),
  (5, 'Groceries');

-- Insert sample Products
INSERT INTO Products VALUES
  (1, 'Laptop', 1, 1, 55000.00, 15),
  (2, 'Office Chair', 2, 2, 4500.00, 30),
  (3, 'Notebook', 3, 3, 50.00, 100),
  (4, 'T-Shirt', 4, 4, 300.00, 60),
  (5, 'Rice', 5, 5, 40.00, 200),
  (6, 'Tablet', 1, 1, 22000.00, 7);

-- Insert sample Purchases
INSERT INTO Purchases VALUES
  (1, 1, 10, '2025-08-01', 1),
  (2, 2, 50, '2025-08-05', 2),
  (3, 3, 200, '2025-08-10', 3),
  (4, 4, 100, '2025-08-15', 4),
  (5, 5, 300, '2025-08-20', 5);

-- Insert sample Sales
INSERT INTO Sales VALUES
  (1, 1, 5, '2025-08-12', 'Customer A'),
  (2, 2, 20, '2025-08-13', 'Customer B'),
  (3, 3, 50, '2025-08-14', 'Customer C'),
  (4, 4, 30, '2025-08-15', 'Customer D'),
  (5, 5, 100, '2025-08-16', 'Customer E');

-- 1. List products with stock below 10.
SELECT * FROM Products WHERE Stock < 10;

-- 2. Show top 5 most expensive products.
SELECT * FROM Products ORDER BY Price DESC LIMIT 5;

-- 3. Find suppliers from 'Delhi'.
SELECT * FROM Suppliers WHERE City = 'Delhi';

-- 4. Show products supplied by a given supplier (SupplierID = 1).
SELECT * FROM Products WHERE SupplierID = 1;

-- 5. Count products in each category.
SELECT c.CategoryName, COUNT(p.ProductID) AS ProductCount
FROM Categories c
LEFT JOIN Products p ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryName;

-- 6. Find total purchases for a specific product (ProductID = 1).
SELECT ProductID, SUM(Quantity) AS TotalPurchased
FROM Purchases
WHERE ProductID = 1
GROUP BY ProductID;

-- 7. Show products never sold.
SELECT p.*
FROM Products p
LEFT JOIN Sales s ON p.ProductID = s.ProductID
WHERE s.SaleID IS NULL;

-- 8. Display sales in the last week.
SELECT * FROM Sales WHERE SaleDate >= CURDATE() - INTERVAL 7 DAY;

-- 9. Show products with sales quantity above 50.
SELECT p.ProductName, SUM(s.Quantity) AS TotalSold
FROM Products p
JOIN Sales s ON p.ProductID = s.ProductID
GROUP BY p.ProductID, p.ProductName
HAVING TotalSold > 50;

-- 10. List suppliers who supplied more than 5 products.
SELECT s.SupplierName, COUNT(p.ProductID) AS ProductCount
FROM Suppliers s
JOIN Products p ON s.SupplierID = p.SupplierID
GROUP BY s.SupplierID, s.SupplierName
HAVING ProductCount > 5;

-- 11. Show average price per category.
SELECT c.CategoryName, AVG(p.Price) AS AvgPrice
FROM Categories c
JOIN Products p ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryName;

-- 12. Find top selling product.
SELECT p.ProductName, SUM(s.Quantity) AS TotalSold
FROM Products p
JOIN Sales s ON p.ProductID = s.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY TotalSold DESC
LIMIT 1;

-- 13. Show categories without products.
SELECT c.*
FROM Categories c
LEFT JOIN Products p ON c.CategoryID = p.CategoryID
WHERE p.ProductID IS NULL;

-- 14. List all sales with product names.
SELECT s.SaleID, p.ProductName, s.Quantity, s.SaleDate, s.CustomerName
FROM Sales s
JOIN Products p ON s.ProductID = p.ProductID;

-- 15. Show purchases with supplier names.
SELECT pu.PurchaseID, pr.ProductName, su.SupplierName, pu.Quantity, pu.PurchaseDate
FROM Purchases pu
JOIN Products pr ON pu.ProductID = pr.ProductID
JOIN Suppliers su ON pu.SupplierID = su.SupplierID;

-- 16. Display suppliers with no purchases.
SELECT su.*
FROM Suppliers su
LEFT JOIN Purchases pu ON su.SupplierID = pu.SupplierID
WHERE pu.PurchaseID IS NULL;

-- 17. Show most recent purchase date for each product.
SELECT ProductID, MAX(PurchaseDate) AS LastPurchaseDate
FROM Purchases
GROUP BY ProductID;

-- 18. List customers who bought more than 3 products.
SELECT CustomerName, COUNT(DISTINCT ProductID) AS ProductsBought
FROM Sales
GROUP BY CustomerName
HAVING ProductsBought > 3;

-- 19. Show total stock value (Price × Stock).
SELECT ProductName, Price, Stock, (Price * Stock) AS StockValue
FROM Products;

-- 20. Find product with maximum stock.
SELECT * FROM Products ORDER BY Stock DESC LIMIT 1;

-- 21. Show sales grouped by customer.
SELECT CustomerName, SUM(Quantity) AS TotalItemsBought
FROM Sales
GROUP BY CustomerName;

-- 22. Display top 3 customers by sales value.
SELECT CustomerName, SUM(s.Quantity * p.Price) AS TotalSpent
FROM Sales s
JOIN Products p ON s.ProductID = p.ProductID
GROUP BY CustomerName
ORDER BY TotalSpent DESC
LIMIT 3;

-- 23. Show monthly sales totals.
SELECT YEAR(SaleDate) AS Year, MONTH(SaleDate) AS Month, SUM(Quantity) AS TotalSales
FROM Sales
GROUP BY Year, Month
ORDER BY Year, Month;

-- 24. List products purchased but not sold.
SELECT pr.ProductID, pr.ProductName
FROM Products pr
JOIN Purchases pu ON pr.ProductID = pu.ProductID
LEFT JOIN Sales sa ON pr.ProductID = sa.ProductID
GROUP BY pr.ProductID
HAVING COUNT(sa.SaleID) = 0;

-- 25. Find suppliers who supply products in multiple categories.
SELECT s.SupplierName, COUNT(DISTINCT p.CategoryID) AS CategoryCount
FROM Suppliers s
JOIN Products p ON s.SupplierID = p.SupplierID
GROUP BY s.SupplierID, s.SupplierName
HAVING CategoryCount > 1;
