-- set 8
CREATE DATABASE OnlineFoodDelivery;
USE OnlineFoodDelivery;

CREATE TABLE Restaurants (
  RestaurantID INT PRIMARY KEY,
  Name VARCHAR(100),
  City VARCHAR(50),
  Rating DECIMAL(2,1)
);

CREATE TABLE MenuItems (
  MenuItemID INT PRIMARY KEY,
  RestaurantID INT,
  ItemName VARCHAR(100),
  Price DECIMAL(10, 2),
  Category VARCHAR(50),
  FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID)
);

CREATE TABLE Customers (
  CustomerID INT PRIMARY KEY,
  Name VARCHAR(100),
  Phone VARCHAR(15),
  Address VARCHAR(255)
);

CREATE TABLE Orders (
  OrderID INT PRIMARY KEY,
  CustomerID INT,
  RestaurantID INT,
  OrderDate DATE,
  Status VARCHAR(20),
  FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
  FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID)
);

CREATE TABLE DeliveryAgents (
  AgentID INT PRIMARY KEY,
  Name VARCHAR(100),
  Phone VARCHAR(15),
  VehicleNo VARCHAR(20)
);

-- Insert sample Restaurants
INSERT INTO Restaurants VALUES
  (1, 'Spice Villa', 'Bangalore', 4.5),
  (2, 'Ocean Delight', 'Mumbai', 4.2),
  (3, 'Pizza World', 'Delhi', 3.9),
  (4, 'Sweet Tooth', 'Bangalore', 4.7),
  (5, 'Burger Hub', 'Chennai', 4.0);

-- Insert sample MenuItems
INSERT INTO MenuItems VALUES
  (1, 1, 'Paneer Butter Masala', 250.00, 'Main Course'),
  (2, 1, 'Garlic Naan', 50.00, 'Bread'),
  (3, 2, 'Grilled Fish', 450.00, 'Main Course'),
  (4, 3, 'Margherita Pizza', 300.00, 'Pizza'),
  (5, 4, 'Chocolate Brownie', 150.00, 'Dessert'),
  (6, 5, 'Cheese Burger', 200.00, 'Fast Food');

-- Insert sample Customers
INSERT INTO Customers VALUES
  (1, 'Rahul Kumar', '9876543210', 'Bangalore'),
  (2, 'Anita Sharma', '9812345678', 'Mumbai'),
  (3, 'Suresh Patel', '9900112233', 'Delhi'),
  (4, 'Priya Singh', '9888776655', 'Bangalore'),
  (5, 'John Smith', '9654321789', 'Chennai');

-- Insert sample Orders
INSERT INTO Orders VALUES
  (1, 1, 1, '2025-08-15', 'Delivered'),
  (2, 1, 3, '2025-08-16', 'Cancelled'),
  (3, 2, 2, '2025-08-17', 'Delivered'),
  (4, 3, 3, '2025-08-18', 'Delivered'),
  (5, 4, 4, '2025-08-19', 'Pending');

-- Insert sample DeliveryAgents
INSERT INTO DeliveryAgents VALUES
  (1, 'Ramesh Kumar', '9876543201', 'KA01AB1234'),
  (2, 'Sanjay Singh', '9812345602', 'MH02CD5678'),
  (3, 'Vikram Patel', '9900112234', 'DL03EF9012'),
  (4, 'Amit Nair', '9888776656', 'KA04GH3456'),
  (5, 'John Doe', '9654321780', 'TN05IJ7890');

-- 1. List restaurants in 'Bangalore'.
SELECT * FROM Restaurants WHERE City = 'Bangalore';

-- 2. Show menu items priced above 300.
SELECT * FROM MenuItems WHERE Price > 300;

-- 3. Find orders placed in the last week.
SELECT * FROM Orders WHERE OrderDate >= CURDATE() - INTERVAL 7 DAY;

-- 4. Show top 5 highest rated restaurants.
SELECT * FROM Restaurants ORDER BY Rating DESC LIMIT 5;

-- 5. List customers from a specific city ('Mumbai').
SELECT * FROM Customers WHERE Address = 'Mumbai';

-- 6. Show orders with status 'Delivered'.
SELECT * FROM Orders WHERE Status = 'Delivered';

-- 7. Count menu items per restaurant.
SELECT r.Name, COUNT(m.MenuItemID) AS ItemCount
FROM Restaurants r
JOIN MenuItems m ON r.RestaurantID = m.RestaurantID
GROUP BY r.Name;

-- 8. Find customers who ordered from more than 3 restaurants.
SELECT c.Name, COUNT(DISTINCT o.RestaurantID) AS RestaurantCount
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.Name
HAVING RestaurantCount > 3;

-- 9. Show most expensive item in each restaurant.
SELECT m.RestaurantID, r.Name AS RestaurantName, m.ItemName, m.Price
FROM MenuItems m
JOIN Restaurants r ON m.RestaurantID = r.RestaurantID
WHERE (m.Price, m.RestaurantID) IN (
  SELECT MAX(Price), RestaurantID FROM MenuItems GROUP BY RestaurantID
);

-- 10. List delivery agents with more than 10 deliveries (Assuming there is a Delivery table – placeholder).
-- Placeholder since Delivery table not specified.

-- 11. Find restaurants with no orders.
SELECT r.*
FROM Restaurants r
LEFT JOIN Orders o ON r.RestaurantID = o.RestaurantID
WHERE o.OrderID IS NULL;

-- 12. Show average price of items per category.
SELECT Category, AVG(Price) AS AvgPrice
FROM MenuItems
GROUP BY Category;

-- 13. List orders with customer and restaurant names.
SELECT o.OrderID, c.Name AS CustomerName, r.Name AS RestaurantName, o.OrderDate, o.Status
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Restaurants r ON o.RestaurantID = r.RestaurantID;

-- 14. Find customers who ordered the same item multiple times (Assuming Order-Items not present, placeholder).

-- 15. Show delivery agent with maximum orders (Assuming Delivery table not present, placeholder).

-- 16. List orders with status 'Cancelled'.
SELECT * FROM Orders WHERE Status = 'Cancelled';

-- 17. Find restaurants serving 'Pizza'.
SELECT DISTINCT r.*
FROM Restaurants r
JOIN MenuItems m ON r.RestaurantID = m.RestaurantID
WHERE m.Category = 'Pizza';

-- 18. Show most popular item overall (Assuming order details table required, placeholder).

-- 19. Display top 3 customers by order value (Assuming amount details missing, placeholder).

-- 20. Show orders sorted by date.
SELECT * FROM Orders ORDER BY OrderDate;

-- 21. Find customers with no orders.
SELECT * FROM Customers
WHERE CustomerID NOT IN (SELECT CustomerID FROM Orders);

-- 22. Show menu items with category 'Dessert'.
SELECT * FROM MenuItems WHERE Category = 'Dessert';

-- 23. List orders assigned to a specific delivery agent (Assuming Delivery table missing, placeholder).

-- 24. Show daily order count.
SELECT OrderDate, COUNT(*) AS OrderCount
FROM Orders
GROUP BY OrderDate;

-- 25. Find restaurants with menu items in multiple categories.
SELECT r.RestaurantID, r.Name, COUNT(DISTINCT m.Category) AS CategoryCount
FROM Restaurants r
JOIN MenuItems m ON r.RestaurantID = m.RestaurantID
GROUP BY r.RestaurantID, r.Name
HAVING CategoryCount > 1;
