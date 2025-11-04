-- set 1
CREATE DATABASE OnlineBookstore;
USE OnlineBookstore;

CREATE TABLE Authors (
  AuthorID INT PRIMARY KEY,
  Name VARCHAR(100),
  Country VARCHAR(50),
  DOB DATE
);

CREATE TABLE Categories (
  CategoryID INT PRIMARY KEY,
  CategoryName VARCHAR(50)
);

CREATE TABLE Books (
  BookID INT PRIMARY KEY,
  Title VARCHAR(150),
  AuthorID INT,
  CategoryID INT,
  Price DECIMAL(10,2),
  Stock INT,
  PublishedYear YEAR,
  FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID),
  FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

CREATE TABLE Customers (
  CustomerID INT PRIMARY KEY,
  Name VARCHAR(100),
  Email VARCHAR(100),
  Phone VARCHAR(15),
  Address VARCHAR(255)
);

CREATE TABLE Orders (
  OrderID INT PRIMARY KEY,
  CustomerID INT,
  OrderDate DATE,
  Status VARCHAR(20),
  FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Insert data into Authors
INSERT INTO Authors VALUES
  (1, 'R. K. Narayan', 'India', '1906-10-10'),
  (2, 'J.K. Rowling', 'UK', '1965-07-31'),
  (3, 'Agatha Christie', 'UK', '1890-09-15'),
  (4, 'Chetan Bhagat', 'India', '1974-04-22'),
  (5, 'Dan Brown', 'USA', '1964-06-22');

-- Insert data into Categories
INSERT INTO Categories VALUES
  (1, 'Fiction'),
  (2, 'Mystery'),
  (3, 'Guide'),
  (4, 'Children'),
  (5, 'Technology');

-- Insert data into Books
INSERT INTO Books VALUES
  (1, 'Malgudi Days', 1, 1, 350.00, 8, 2010),
  (2, 'Harry Potter', 2, 4, 950.50, 32, 2016),
  (3, 'The Mystery of the Blue Train', 3, 2, 600.00, 4, 2018),
  (4, 'Five Point Someone', 4, 1, 435.00, 7, 2009),
  (5, 'Digital Fortress Guide', 5, 3, 1200.00, 17, 2021);

-- Insert data into Customers
INSERT INTO Customers VALUES
  (1, 'Amit Sharma', 'amit@mail.com', '9876543210', 'Mumbai'),
  (2, 'Sneha Verma', 'sneha@mail.com', '9854471200', 'Delhi'),
  (3, 'Rohit Kumar', 'rohit@mail.com', '9012349876', 'Bangalore'),
  (4, 'Priya Singh', 'priya@mail.com', '8822456198', 'Chennai'),
  (5, 'John Doe', 'john@mail.com', '9095673450', 'Kolkata');

-- Insert data into Orders
INSERT INTO Orders VALUES
  (1, 1, '2025-08-20', 'Completed'),
  (2, 1, '2025-08-28', 'Pending'),
  (3, 2, '2025-07-19', 'Completed'),
  (4, 4, '2025-09-01', 'Pending'),
  (5, 2, '2025-08-22', 'Completed');

-- 1. List all books with price above 500.
SELECT * FROM Books WHERE Price > 500;

-- 2. Show books published after 2015.
SELECT * FROM Books WHERE PublishedYear > 2015;

-- 3. Find customers from a specific city ('Delhi' example).
SELECT * FROM Customers WHERE Address = 'Delhi';

-- 4. Display books by a given author name ('J.K. Rowling' example).
SELECT b.* FROM Books b
JOIN Authors a ON b.AuthorID = a.AuthorID
WHERE a.Name = 'J.K. Rowling';

-- 5. List top 3 most expensive books.
SELECT * FROM Books ORDER BY Price DESC LIMIT 3;

-- 6. Count total number of books in each category.
SELECT c.CategoryName, COUNT(b.BookID) AS BookCount
FROM Categories c
LEFT JOIN Books b ON c.CategoryID = b.CategoryID
GROUP BY c.CategoryID, c.CategoryName;

-- 7. Show orders placed in the last 30 days.
SELECT * FROM Orders WHERE OrderDate >= CURDATE() - INTERVAL 30 DAY;

-- 8. Display customer name and total orders placed.
SELECT c.Name, COUNT(o.OrderID) AS TotalOrders
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.Name;

-- 9. List books with stock less than 10.
SELECT * FROM Books WHERE Stock < 10;

-- 10. Find authors with more than 5 books.
SELECT a.Name, COUNT(b.BookID) AS BookCount
FROM Authors a
JOIN Books b ON a.AuthorID = b.AuthorID
GROUP BY a.AuthorID, a.Name
HAVING COUNT(b.BookID) > 5;

-- 11. Show books with category name.
SELECT b.Title, c.CategoryName
FROM Books b
JOIN Categories c ON b.CategoryID = c.CategoryID;

-- 12. Find total sales amount for a given order (Note: Assumes relevant order-item linking table exists. Adapt if needed.)
SELECT o.OrderID, SUM(b.Price) AS TotalAmount
FROM Orders o
JOIN Books b ON b.BookID IN (SELECT BookID FROM Books LIMIT 1) -- Placeholder for actual order items
WHERE o.OrderID = 1
GROUP BY o.OrderID;

-- 13. Show orders with status "Pending".
SELECT * FROM Orders WHERE Status = 'Pending';

-- 14. List authors from 'India'.
SELECT * FROM Authors WHERE Country = 'India';

-- 15. Find customers who have never placed an order.
SELECT * FROM Customers WHERE CustomerID NOT IN (SELECT CustomerID FROM Orders);

-- 16. Show average price of books in each category.
SELECT c.CategoryName, AVG(b.Price) AS AvgPrice
FROM Categories c
JOIN Books b ON c.CategoryID = b.CategoryID
GROUP BY c.CategoryID, c.CategoryName;

-- 17. List all books sorted by PublishedYear descending.
SELECT * FROM Books ORDER BY PublishedYear DESC;

-- 18. Show most recent order for each customer.
SELECT o.*
FROM Orders o
JOIN (
  SELECT CustomerID, MAX(OrderDate) AS LatestOrder
  FROM Orders
  GROUP BY CustomerID
) recent
ON o.CustomerID = recent.CustomerID AND o.OrderDate = recent.LatestOrder;

-- 19. Find categories with no books.
SELECT c.*
FROM Categories c
LEFT JOIN Books b ON c.CategoryID = b.CategoryID
WHERE b.BookID IS NULL;

-- 20. List all distinct cities from customers.
SELECT DISTINCT Address FROM Customers;

-- 21. Show total number of customers.
SELECT COUNT(*) AS TotalCustomers FROM Customers;

-- 22. Display orders with customer name and order date.
SELECT o.OrderID, c.Name, o.OrderDate
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID;

-- 23. Find the cheapest book in each category.
SELECT b.*
FROM Books b
JOIN (
  SELECT CategoryID, MIN(Price) AS MinPrice
  FROM Books
  GROUP BY CategoryID
) cheap
ON b.CategoryID = cheap.CategoryID AND b.Price = cheap.MinPrice;

-- 24. List customers who ordered books by a specific author ('R. K. Narayan').
SELECT DISTINCT c.*
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN Books b ON b.AuthorID = (SELECT AuthorID FROM Authors WHERE Name = 'R. K. Narayan')
WHERE b.BookID IN (SELECT BookID FROM Books WHERE AuthorID = b.AuthorID);

-- 25. Show books whose title contains the word 'Guide'.
SELECT * FROM Books WHERE Title LIKE '%Guide%';
