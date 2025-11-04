-- Set 5: Online Order Management

CREATE DATABASE Online_Order_Management;
USE Online_Order_Management; 

CREATE TABLE OnlineOrders (
    OrderID INT,
    CustomerID INT,
    CustomerName VARCHAR(100),
    CustomerEmail VARCHAR(100),
    ProductID INT,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    SupplierName VARCHAR(100),
    OrderDate DATE,
    Quantity INT,
    Price DECIMAL(10,2));

INSERT INTO OnlineOrders 
VALUES
(701,9001,'Alok Mehta','alok@example.com',501,'USB Cable','Electronics','CableCorp','2025-09-01',2,199.00),
(702,9002,'Tina Roy','tina@example.com',502,'Notebook','Stationery','PaperPlus','2025-09-02',5,50.00),
(703,9001,'Alok Mehta','alok@example.com',503,'Wireless Mouse','Electronics','GadgetHub','2025-09-05',1,799.00),
(704,9003,'Kamal Nair','kamal@example.com',501,'USB Cable','Electronics','CableCorp','2025-09-06',3,199.00),
(705,9004,'Rhea Das','rhea@example.com',504,'Water Bottle','Home','HomeWare','2025-09-07',2,299.00);

INSERT INTO Suppliers (SupplierID,SupplierName) 
VALUES 
(1,'CableCorp'),(2,'PaperPlus'),(3,'GadgetHub'),(4,'HomeWare');

INSERT INTO Customers 
VALUES 
(9001,'Alok Mehta','alok@example.com'),(9002,'Tina Roy','tina@example.com'),(9003,'Kamal Nair','kamal@example.com'),(9004,'Rhea Das','rhea@example.com');

INSERT INTO Products 
VALUES
(501,'USB Cable','Electronics',1,199.00),
(502,'Notebook','Stationery',2,50.00),
(503,'Wireless Mouse','Electronics',3,799.00),
(504,'Water Bottle','Home',4,299.00);

INSERT INTO Orders 
VALUES
(701,9001,'2025-09-01'),
(702,9002,'2025-09-02'),
(703,9001,'2025-09-05'),
(704,9003,'2025-09-06'),
(705,9004,'2025-09-07');

INSERT INTO OrderItems 
VALUES
(701,501,2,199.00),
(702,502,5,50.00),
(703,503,1,799.00),
(704,501,3,199.00),
(705,504,2,299.00);

-- 1. Find insertion anomalies.
-- Insertion Anomaly: You can't add a new product or a new customer to the database unless they are part of a completed order. For example, if a new customer signs up, their information can't be stored until they make a purchase.

-- 2. Find update anomalies.
-- Update Anomaly: If a product's price or a supplier's name changes, you must update every record containing that product. For instance, if the price of 'USB Cable' changes, it must be updated for every order where it appears. This is inefficient and can lead to data inconsistencies if not all records are updated.

-- 3. Find deletion anomalies.
-- Deletion Anomaly: Deleting an order can result in the loss of crucial information. If the last order for a customer is deleted, their information (CustomerID, CustomerName, CustomerEmail) is also lost.

-- 4. Is schema in 1NF? Explain.
-- Yes, the OnlineOrders table is in 1NF. All values within the table are atomic. There are no repeating groups or lists in any of the columns.

-- 5. Convert schema to 1NF.
-- Since the table is already in 1NF, no conversion is needed. The next step is to move to 2NF.

-- 6. State primary key.
-- The primary key for this unnormalized table is a composite key of (OrderID, ProductID). This combination uniquely identifies each item within an order.

-- 7. Write FDs.
-- The functional dependencies (FDs) are:
-- {OrderID} -> {CustomerID, CustomerName, CustomerEmail, OrderDate}
-- {ProductID} -> {ProductName, Category, SupplierName, Price}
-- {OrderID, ProductID} -> {Quantity, Price} (The price here is a specific order item price, which may differ from the product's listed price).
-- {CustomerID} -> {CustomerName, CustomerEmail}
-- {SupplierName} -> {SupplierName} (trivial dependency)

-- 8. Identify partial dependencies.
-- The table fails 2NF due to partial dependencies. Attributes are dependent on only a part of the composite primary key (OrderID, ProductID).
-- CustomerID, CustomerName, CustomerEmail, and OrderDate depend only on OrderID.
-- ProductName, Category, SupplierName, and Price depend only on ProductID.

-- 9. Convert schema to 2NF.
-- To achieve 2NF, we split the table to eliminate partial dependencies. This results in the following tables:
-- Customers: {CustomerID, CustomerName, CustomerEmail}
-- Orders: {OrderID, CustomerID, OrderDate}
-- Products: {ProductID, ProductName, Category, SupplierName, Price}
-- OrderItems: {OrderID, ProductID, Quantity, Price}

-- 10. Write SQL for 2NF schema.
CREATE TABLE Customers (
  CustomerID INT PRIMARY KEY,
  CustomerName VARCHAR(100),
  CustomerEmail VARCHAR(100));

CREATE TABLE Orders (
  OrderID INT PRIMARY KEY,
  CustomerID INT,
  OrderDate DATE,
  FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID));

CREATE TABLE Products (
  ProductID INT PRIMARY KEY,
  ProductName VARCHAR(100),
  Category VARCHAR(50),
  SupplierName VARCHAR(100),
  Price DECIMAL(10,2));

CREATE TABLE OrderItems (
  OrderID INT,
  ProductID INT,
  Quantity INT,
  Price DECIMAL(10,2),
  PRIMARY KEY (OrderID, ProductID),
  FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
  FOREIGN KEY (ProductID) REFERENCES Products(ProductID));
  
-- 11. Identify transitive dependencies.
-- The 2NF schema still has a transitive dependency in the Products table: {ProductID} -> {SupplierName}. A product is sold by a supplier, but a supplier's name is not uniquely identified by the product. To properly normalize, we should have a SupplierID as a foreign key. The dependency {ProductID} -> {SupplierName} becomes a problem because if we had SupplierName -> SupplierAddress, then SupplierAddress would be transitively dependent on ProductID.

-- 12. Convert schema to 3NF.
-- To achieve 3NF, we remove transitive dependencies by creating a separate Suppliers table. The Products table will then reference the SupplierID as a foreign key. This leads to the schema provided in the prompt's CREATE TABLE statements for the normalized schema.

-- 13. Write SQL for 3NF schema.
CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY AUTO_INCREMENT,
    SupplierName VARCHAR(100) UNIQUE);

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    CustomerEmail VARCHAR(100));

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    SupplierID INT,
    Price DECIMAL(10,2),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID));

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID));

CREATE TABLE OrderItems (
    OrderID INT,
    ProductID INT,
    Quantity INT,
    Price DECIMAL(10,2),
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)); 

-- 14. Check BCNF compliance.
-- The 3NF schema provided meets BCNF. For every functional dependency, the determinant (the left side) is a superkey. There are no non-trivial dependencies where a non-superkey determines a key or a non-key attribute.

-- 15. Query: List all orders with products and suppliers.
SELECT o.OrderID,c.CustomerName,o.OrderDate,p.ProductName,s.SupplierName,oi.Quantity,oi.Price
FROM Orders o
JOIN Customers c ON o.CustomerID=c.CustomerID
JOIN OrderItems oi ON o.OrderID=oi.OrderID
JOIN Products p ON oi.ProductID=p.ProductID
JOIN Suppliers s ON p.SupplierID=s.SupplierID;

-- 16. Query: Find total sales per customer.
SELECT c.CustomerID,c.CustomerName,SUM(oi.Quantity*oi.Price) AS TotalSales
FROM Customers c JOIN Orders o ON c.CustomerID=o.CustomerID
JOIN OrderItems oi ON o.OrderID=oi.OrderID
GROUP BY c.CustomerID,c.CustomerName;

-- 17. Query: Count orders per supplier.
SELECT s.SupplierName, COUNT(DISTINCT oi.OrderID) AS OrdersCount
FROM Suppliers s
JOIN Products p ON s.SupplierID=p.SupplierID
JOIN OrderItems oi ON p.ProductID=oi.ProductID
GROUP BY s.SupplierName;

-- 18. Query: Find customers who ordered more than 5 times.
-- 19. Query: Find most ordered product.
SELECT p.ProductID,p.ProductName,SUM(oi.Quantity) AS TotalQty
FROM Products p JOIN OrderItems oi ON p.ProductID=oi.ProductID
GROUP BY p.ProductID,p.ProductName
ORDER BY TotalQty DESC
LIMIT 1;

-- 20. Discuss advantages of normalization.
-- Normalization dramatically reduces data redundancy. In the unnormalized OnlineOrders table, customer information, product details, and supplier names are repeated for every order item. For example, Alok Mehta's details are stored twice because he placed two orders. The normalized schema eliminates this by storing each type of entity (customers, products, suppliers, orders) in its own table. These tables are then linked together using foreign keys. This reduces storage space, improves data integrity, and makes the database easier to manage and query. For example, changing a product's name or price only requires a single update in the Products table.