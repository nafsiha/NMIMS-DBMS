-- set 5
CREATE DATABASE HotelManagement;
USE HotelManagement;

CREATE TABLE Hotels (
  HotelID INT PRIMARY KEY,
  HotelName VARCHAR(100),
  Location VARCHAR(100),
  Rating DECIMAL(2,1)
);

CREATE TABLE Rooms (
  RoomID INT PRIMARY KEY,
  HotelID INT,
  RoomType VARCHAR(50),
  PricePerNight DECIMAL(10,2),
  Availability BOOLEAN,
  FOREIGN KEY (HotelID) REFERENCES Hotels(HotelID)
);

CREATE TABLE Guests (
  GuestID INT PRIMARY KEY,
  Name VARCHAR(100),
  Phone VARCHAR(15),
  Email VARCHAR(100),
  Address VARCHAR(255)
);

CREATE TABLE Reservations (
  ReservationID INT PRIMARY KEY,
  RoomID INT,
  GuestID INT,
  CheckInDate DATE,
  CheckOutDate DATE,
  Status VARCHAR(20),
  FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID),
  FOREIGN KEY (GuestID) REFERENCES Guests(GuestID)
);

CREATE TABLE Payments (
  PaymentID INT PRIMARY KEY,
  ReservationID INT,
  Amount DECIMAL(10,2),
  PaymentDate DATE,
  Method VARCHAR(50),
  FOREIGN KEY (ReservationID) REFERENCES Reservations(ReservationID)
);

-- Insert sample Hotels
INSERT INTO Hotels VALUES
  (1, 'The Grand', 'Mumbai', 4.5),
  (2, 'Sunrise Palace', 'Delhi', 4.2),
  (3, 'Ocean View', 'Goa', 3.9),
  (4, 'Mountain Retreat', 'Manali', 4.8),
  (5, 'City Inn', 'Mumbai', 3.5);

-- Insert sample Rooms
INSERT INTO Rooms VALUES
  (1, 1, 'Deluxe', 3500.00, TRUE),
  (2, 1, 'Suite', 7000.00, TRUE),
  (3, 2, 'Standard', 2500.00, TRUE),
  (4, 3, 'Deluxe', 3000.00, FALSE),
  (5, 4, 'Suite', 8000.00, TRUE),
  (6, 5, 'Standard', 1800.00, TRUE);

-- Insert sample Guests
INSERT INTO Guests VALUES
  (1, 'Rahul Singh', '9876543210', 'rahul@mail.com', 'Mumbai'),
  (2, 'Anita Desai', '9812345678', 'anita@mail.com', 'Delhi'),
  (3, 'Suresh Kumar', '9900112233', 'suresh@mail.com', 'Goa'),
  (4, 'Priya Nair', '9888776655', 'priya@mail.com', 'Manali'),
  (5, 'John Smith', '9654321789', 'john@mail.com', 'Mumbai');

-- Insert sample Reservations
INSERT INTO Reservations VALUES
  (1, 1, 1, '2025-08-15', '2025-08-20', 'Checked-Out'),
  (2, 2, 2, '2025-08-25', '2025-08-30', 'Checked-In'),
  (3, 3, 3, '2025-08-10', '2025-08-15', 'Cancelled'),
  (4, 5, 4, '2025-08-05', '2025-08-10', 'Checked-Out'),
  (5, 6, 5, '2025-08-20', '2025-08-25', 'Checked-In');

-- Insert sample Payments
INSERT INTO Payments VALUES
  (1, 1, 17500.00, '2025-08-20', 'Credit Card'),
  (2, 2, 35000.00, '2025-08-26', 'Cash'),
  (3, 4, 40000.00, '2025-08-10', 'Debit Card'),
  (4, 5, 9000.00, '2025-08-22', 'Credit Card');

-- 1. List all hotels in 'Mumbai'.
SELECT * FROM Hotels WHERE Location = 'Mumbai';

-- 2. Show rooms with price above 3000 per night.
SELECT * FROM Rooms WHERE PricePerNight > 3000;

-- 3. Find available rooms in a given hotel (HotelID = 1 example).
SELECT * FROM Rooms WHERE HotelID = 1 AND Availability = TRUE;

-- 4. List guests with reservations in a specific hotel (HotelID = 1 example).
SELECT DISTINCT g.*
FROM Guests g
JOIN Reservations r ON g.GuestID = r.GuestID
JOIN Rooms rm ON r.RoomID = rm.RoomID
WHERE rm.HotelID = 1;

-- 5. Show reservations with status 'Checked-In'.
SELECT * FROM Reservations WHERE Status = 'Checked-In';

-- 6. Count rooms by type for each hotel.
SELECT h.HotelName, rm.RoomType, COUNT(rm.RoomID) AS RoomCount
FROM Hotels h
JOIN Rooms rm ON h.HotelID = rm.HotelID
GROUP BY h.HotelName, rm.RoomType;

-- 7. Find guests who stayed more than 5 nights.
SELECT g.Name, DATEDIFF(r.CheckOutDate, r.CheckInDate) AS NightsStayed
FROM Guests g
JOIN Reservations r ON g.GuestID = r.GuestID
WHERE DATEDIFF(r.CheckOutDate, r.CheckInDate) > 5;

-- 8. Show top 3 most expensive room types.
SELECT DISTINCT RoomType, PricePerNight
FROM Rooms
ORDER BY PricePerNight DESC
LIMIT 3;

-- 9. List all reservations in the last month.
SELECT * FROM Reservations WHERE CheckInDate >= CURDATE() - INTERVAL 1 MONTH;

-- 10. Display guests who made more than 2 reservations.
SELECT g.Name, COUNT(r.ReservationID) AS ReservationCount
FROM Guests g
JOIN Reservations r ON g.GuestID = r.GuestID
GROUP BY g.GuestID, g.Name
HAVING ReservationCount > 2;

-- 11. Show hotels with average room price above 4000.
SELECT h.HotelName, AVG(r.PricePerNight) AS AvgPrice
FROM Hotels h
JOIN Rooms r ON h.HotelID = r.HotelID
GROUP BY h.HotelName
HAVING AvgPrice > 4000;

-- 12. List guests from a specific city ('Mumbai').
SELECT * FROM Guests WHERE Address = 'Mumbai';

-- 13. Find hotels without any reservations.
SELECT h.*
FROM Hotels h
LEFT JOIN Rooms r ON h.HotelID = r.HotelID
LEFT JOIN Reservations res ON r.RoomID = res.RoomID
WHERE res.ReservationID IS NULL;

-- 14. Show reservations with guest name, hotel name, and room type.
SELECT res.ReservationID, g.Name AS GuestName, h.HotelName, rm.RoomType
FROM Reservations res
JOIN Guests g ON res.GuestID = g.GuestID
JOIN Rooms rm ON res.RoomID = rm.RoomID
JOIN Hotels h ON rm.HotelID = h.HotelID;

-- 15. Find total revenue for each hotel.
SELECT h.HotelName, SUM(p.Amount) AS TotalRevenue
FROM Hotels h
JOIN Rooms r ON h.HotelID = r.HotelID
JOIN Reservations res ON r.RoomID = res.RoomID
JOIN Payments p ON res.ReservationID = p.ReservationID
GROUP BY h.HotelName;

-- 16. List reservations where check-out date is before check-in date (data check).
SELECT * FROM Reservations WHERE CheckOutDate < CheckInDate;

-- 17. Show payment methods used.
SELECT DISTINCT Method FROM Payments;

-- 18. Find guests who haven’t made any payments.
SELECT g.*
FROM Guests g
LEFT JOIN Reservations res ON g.GuestID = res.GuestID
LEFT JOIN Payments p ON res.ReservationID = p.ReservationID
WHERE p.PaymentID IS NULL;

-- 19. Display reservations sorted by check-in date.
SELECT * FROM Reservations ORDER BY CheckInDate;

-- 20. Find hotels with rating above 4.
SELECT * FROM Hotels WHERE Rating > 4;

-- 21. Show guests who booked suites.
SELECT DISTINCT g.*
FROM Guests g
JOIN Reservations r ON g.GuestID = r.GuestID
JOIN Rooms rm ON r.RoomID = rm.RoomID
WHERE rm.RoomType LIKE '%Suite%';

-- 22. List available rooms in 'Delhi'.
SELECT rm.*
FROM Rooms rm
JOIN Hotels h ON rm.HotelID = h.HotelID
WHERE h.Location = 'Delhi' AND rm.Availability = TRUE;

-- 23. Show total nights stayed per guest.
SELECT g.Name, SUM(DATEDIFF(r.CheckOutDate, r.CheckInDate)) AS TotalNights
FROM Guests g
JOIN Reservations r ON g.GuestID = r.GuestID
GROUP BY g.GuestID, g.Name;

-- 24. Find reservations with overlapping dates for the same room.
SELECT r1.ReservationID, r2.ReservationID, r1.RoomID
FROM Reservations r1
JOIN Reservations r2 ON r1.RoomID = r2.RoomID AND r1.ReservationID <> r2.ReservationID
WHERE r1.CheckInDate < r2.CheckOutDate AND r2.CheckInDate < r1.CheckOutDate;

-- 25. List all distinct cities where hotels are located.
SELECT DISTINCT Location FROM Hotels;
