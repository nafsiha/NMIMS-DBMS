INSERT INTO StudentDetails
VALUES
(01, 'Ram', 30, 'Male', 01),
(02, 'Sana', 31, 'Female', 02),
(03, 'Advait', 29, 'Male', 02),
(04, 'Adithi', 70, 'Female', 01),
(05, 'Pratham', 81, 'Female', 02);

create table Sales(
OrderID TINYINT,
ProductID TINYINT,
Quantity INT,
Price FLOAT,
OrderDate DATE,
CustomerID INT
);

alter table Sales modify column CustomerID VARCHAR(4);

show create table Sales;

INSERT INTO Sales (OrderID, ProductID, Quantity, Price, OrderDate, CustomerID)
VALUES 
(1, 101, 50, 15.00, '2023-02-10', 'C001'),
(2, 102, 30, 10.00, '2023-03-15', 'C002'),
(3, 101, 60, 15.00, '2023-04-20', 'C003'),
(4, 103, 40, 20.00, '2023-05-05', 'C004'),
(5, 102, 75, 10.00, '2023-06-10', 'C005'),
(6, 104, 90, 25.00, '2023-07-15', 'C006'),
(7, 101, 30, 15.00, '2023-08-20', 'C007'),
(8, 102, 70, 10.00, '2023-09-10', 'C008'),
(9, 101, 80, 15.00, '2023-08-20', 'C009'),
(10, 103, 50, 20.00, '2023-12-12', 'C010');


SELECT ProductID, SUM(Quantity) AS TotalQuantity, COUNT(ProductID) AS NumberOfOrders
FROM Sales 
WHERE OrderDate BETWEEN '2023-01-01' AND '2023-06-30'
GROUP BY ProductID 
HAVING SUM(QUANTITY) > 100
ORDER BY SUM(QUANTITY) DESC 
LIMIT 5;
