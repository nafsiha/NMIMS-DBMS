-- set 4
CREATE DATABASE AirlineReservation;
USE AirlineReservation;

CREATE TABLE Airlines (
  AirlineID INT PRIMARY KEY,
  AirlineName VARCHAR(100),
  Country VARCHAR(50)
);

CREATE TABLE Flights (
  FlightID INT PRIMARY KEY,
  AirlineID INT,
  Source VARCHAR(50),
  Destination VARCHAR(50),
  DepartureTime TIME,
  ArrivalTime TIME,
  Price DECIMAL(10,2),
  FOREIGN KEY (AirlineID) REFERENCES Airlines(AirlineID)
);

CREATE TABLE Passengers (
  PassengerID INT PRIMARY KEY,
  Name VARCHAR(100),
  PassportNo VARCHAR(20),
  Nationality VARCHAR(50),
  DOB DATE
);

CREATE TABLE Bookings (
  BookingID INT PRIMARY KEY,
  FlightID INT,
  PassengerID INT,
  BookingDate DATE,
  SeatNo VARCHAR(10),
  Status VARCHAR(20),
  FOREIGN KEY (FlightID) REFERENCES Flights(FlightID),
  FOREIGN KEY (PassengerID) REFERENCES Passengers(PassengerID)
);

CREATE TABLE Payments (
  PaymentID INT PRIMARY KEY,
  BookingID INT,
  Amount DECIMAL(10,2),
  PaymentDate DATE,
  Method VARCHAR(50),
  FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID)
);

-- Insert sample Airlines
INSERT INTO Airlines VALUES
  (1, 'Air India', 'India'),
  (2, 'American Airlines', 'USA'),
  (3, 'Emirates', 'UAE'),
  (4, 'British Airways', 'UK'),
  (5, 'Lufthansa', 'Germany');

-- Insert sample Flights
INSERT INTO Flights VALUES
  (1, 1, 'Delhi', 'Mumbai', '18:30:00', '20:30:00', 6500.00),
  (2, 2, 'New York', 'London', '22:00:00', '10:00:00', 12000.00),
  (3, 3, 'Dubai', 'Paris', '15:00:00', '19:30:00', 9000.00),
  (4, 4, 'London', 'Delhi', '09:00:00', '21:00:00', 8500.00),
  (5, 5, 'Frankfurt', 'New York', '13:00:00', '16:00:00', 11000.00);

-- Insert sample Passengers
INSERT INTO Passengers VALUES
  (1, 'Amit Sharma', 'M1234567', 'India', '1990-05-15'),
  (2, 'John Doe', 'N7654321', 'USA', '1985-10-22'),
  (3, 'Sara Khan', 'P2345678', 'UAE', '1995-03-12'),
  (4, 'Michael Smith', 'Q8765432', 'UK', '1980-07-30'),
  (5, 'Anna Mueller', 'R3456789', 'Germany', '1992-12-05');

-- Insert sample Bookings
INSERT INTO Bookings VALUES
  (1, 1, 1, '2025-08-15', '12A', 'Confirmed'),
  (2, 2, 2, '2025-08-10', '14B', 'Cancelled'),
  (3, 3, 3, '2025-08-18', '22C', 'Confirmed'),
  (4, 4, 4, '2025-08-20', '18D', 'Confirmed'),
  (5, 1, 5, '2025-08-25', '20E', 'Confirmed'),
  (6, 1, 1, '2025-08-28', '13A', 'Confirmed');

-- Insert sample Payments
INSERT INTO Payments VALUES
  (1, 1, 6500.00, '2025-08-16', 'Credit Card'),
  (2, 3, 9000.00, '2025-08-19', 'Cash'),
  (3, 4, 8500.00, '2025-08-21', 'Online'),
  (4, 5, 6500.00, '2025-08-26', 'Credit Card'),
  (5, 6, 6500.00, '2025-08-29', 'Debit Card');

-- 1. List all flights from 'Delhi' to 'Mumbai'.
SELECT * FROM Flights WHERE Source = 'Delhi' AND Destination = 'Mumbai';

-- 2. Show flights departing after 6 PM.
SELECT * FROM Flights WHERE DepartureTime > '18:00:00';

-- 3. Find passengers with nationality 'India'.
SELECT * FROM Passengers WHERE Nationality = 'India';

-- 4. List bookings with status 'Confirmed'.
SELECT * FROM Bookings WHERE Status = 'Confirmed';

-- 5. Show all bookings for a given passenger name ('Amit Sharma').
SELECT b.*
FROM Bookings b
JOIN Passengers p ON b.PassengerID = p.PassengerID
WHERE p.Name = 'Amit Sharma';

-- 6. Count total flights operated by each airline.
SELECT a.AirlineName, COUNT(f.FlightID) AS TotalFlights
FROM Airlines a
LEFT JOIN Flights f ON a.AirlineID = f.AirlineID
GROUP BY a.AirlineID, a.AirlineName;

-- 7. Find passengers who booked more than 3 flights.
SELECT p.Name, COUNT(b.BookingID) AS FlightCount
FROM Passengers p
JOIN Bookings b ON p.PassengerID = b.PassengerID
GROUP BY p.PassengerID, p.Name
HAVING FlightCount > 3;

-- 8. Show the most expensive flight.
SELECT * FROM Flights ORDER BY Price DESC LIMIT 1;

-- 9. List all airlines operating in 'USA'.
SELECT * FROM Airlines WHERE Country = 'USA';

-- 10. Display bookings made in the last 7 days.
SELECT * FROM Bookings WHERE BookingDate >= CURDATE() - INTERVAL 7 DAY;

-- 11. Show average price of flights per airline.
SELECT a.AirlineName, AVG(f.Price) AS AvgPrice
FROM Airlines a
JOIN Flights f ON a.AirlineID = f.AirlineID
GROUP BY a.AirlineID, a.AirlineName;

-- 12. List passengers without any bookings.
SELECT * FROM Passengers WHERE PassengerID NOT IN (SELECT PassengerID FROM Bookings);

-- 13. Find flights with no bookings.
SELECT f.*
FROM Flights f
LEFT JOIN Bookings b ON f.FlightID = b.FlightID
WHERE b.BookingID IS NULL;

-- 14. Show passengers with passport numbers starting with 'M'.
SELECT * FROM Passengers WHERE PassportNo LIKE 'M%';

-- 15. List all bookings along with passenger names and flight details.
SELECT b.BookingID, p.Name AS PassengerName, f.Source, f.Destination, f.DepartureTime, f.ArrivalTime, b.Status
FROM Bookings b
JOIN Passengers p ON b.PassengerID = p.PassengerID
JOIN Flights f ON b.FlightID = f.FlightID;

-- 16. Show top 5 highest payment transactions.
SELECT * FROM Payments ORDER BY Amount DESC LIMIT 5;

-- 17. Count number of passengers on each flight.
SELECT f.FlightID, COUNT(b.BookingID) AS PassengerCount
FROM Flights f
LEFT JOIN Bookings b ON f.FlightID = b.FlightID AND b.Status = 'Confirmed'
GROUP BY f.FlightID;

-- 18. Find flights arriving before 10 AM.
SELECT * FROM Flights WHERE ArrivalTime < '10:00:00';

-- 19. Show flights along with airline names.
SELECT f.*, a.AirlineName
FROM Flights f
JOIN Airlines a ON f.AirlineID = a.AirlineID;

-- 20. Find passengers with multiple bookings on the same date.
SELECT p.Name, b.BookingDate, COUNT(*) AS BookingCount
FROM Bookings b
JOIN Passengers p ON b.PassengerID = p.PassengerID
GROUP BY p.Name, b.BookingDate
HAVING BookingCount > 1;

-- 21. Show payment methods used and their total amounts.
SELECT Method, SUM(Amount) AS TotalAmount
FROM Payments
GROUP BY Method;

-- 22. List passengers who booked flights in the last month.
SELECT DISTINCT p.*
FROM Passengers p
JOIN Bookings b ON p.PassengerID = b.PassengerID
WHERE b.BookingDate >= CURDATE() - INTERVAL 1 MONTH;

-- 23. Show all flights priced between 5000 and 10000.
SELECT * FROM Flights WHERE Price BETWEEN 5000 AND 10000;

-- 24. Find passengers whose DOB is after 2000.
SELECT * FROM Passengers WHERE DOB > '2000-01-01';

-- 25. List airlines with no flights scheduled.
SELECT a.*
FROM Airlines a
LEFT JOIN Flights f ON a.AirlineID = f.AirlineID
WHERE f.FlightID IS NULL;
