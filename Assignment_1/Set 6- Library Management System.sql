-- set 6
CREATE DATABASE LibraryManagement;
USE LibraryManagement;

CREATE TABLE Authors (
  AuthorID INT PRIMARY KEY,
  Name VARCHAR(100),
  Nationality VARCHAR(50)
);

CREATE TABLE Books (
  BookID INT PRIMARY KEY,
  Title VARCHAR(150),
  AuthorID INT,
  Category VARCHAR(50),
  Price DECIMAL(10,2),
  Stock INT,
  FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID)
);

CREATE TABLE Members (
  MemberID INT PRIMARY KEY,
  Name VARCHAR(100),
  Email VARCHAR(100),
  Phone VARCHAR(15),
  Address VARCHAR(255)
);

CREATE TABLE Loans (
  LoanID INT PRIMARY KEY,
  BookID INT,
  MemberID INT,
  IssueDate DATE,
  ReturnDate DATE,
  Status VARCHAR(20),
  FOREIGN KEY (BookID) REFERENCES Books(BookID),
  FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);

CREATE TABLE Fines (
  FineID INT PRIMARY KEY,
  LoanID INT,
  Amount DECIMAL(10,2),
  PaymentStatus VARCHAR(20),
  FOREIGN KEY (LoanID) REFERENCES Loans(LoanID)
);

-- Insert sample Authors
INSERT INTO Authors VALUES
  (1, 'Isaac Asimov', 'American'),
  (2, 'J.K. Rowling', 'British'),
  (3, 'Agatha Christie', 'British'),
  (4, 'Chetan Bhagat', 'Indian'),
  (5, 'Arthur C. Clarke', 'British');

-- Insert sample Books
INSERT INTO Books VALUES
  (1, 'Foundation', 1, 'Science Fiction', 550.00, 6),
  (2, 'Harry Potter and the Sorcerer''s Stone', 2, 'Fantasy', 850.00, 12),
  (3, 'Murder on the Orient Express', 3, 'Mystery', 620.00, 4),
  (4, 'One Night at the Call Center', 4, 'Fiction', 450.00, 8),
  (5, '2001: A Space Odyssey', 5, 'Science Fiction', 700.00, 10);

-- Insert sample Members
INSERT INTO Members VALUES
  (1, 'Amit Sharma', 'amit@mail.com', '9876543210', 'Mumbai'),
  (2, 'Priya Singh', 'priya@mail.com', '9812345678', 'Delhi'),
  (3, 'Rohit Kumar', 'rohit@mail.com', '9900112233', 'Bangalore'),
  (4, 'Sneha Verma', 'sneha@mail.com', '9888776655', 'Chennai'),
  (5, 'John Doe', 'john@mail.com', '9654321789', 'Kolkata');

-- Insert sample Loans
INSERT INTO Loans VALUES
  (1, 1, 1, '2025-08-01', '2025-08-15', 'Returned'),
  (2, 2, 2, '2025-08-10', '2025-08-24', 'Overdue'),
  (3, 3, 3, '2025-07-15', '2025-07-30', 'Returned'),
  (4, 4, 4, '2025-08-05', NULL, 'Issued'),
  (5, 5, 5, '2025-08-12', '2025-08-25', 'Returned');

-- Insert sample Fines
INSERT INTO Fines VALUES
  (1, 2, 500.00, 'Unpaid'),
  (2, 4, 300.00, 'Paid');

-- 1. List books in 'Science Fiction' category.
SELECT * FROM Books WHERE Category = 'Science Fiction';

-- 2. Show books with stock less than 5.
SELECT * FROM Books WHERE Stock < 5;

-- 3. Find members with overdue books.
SELECT DISTINCT m.*
FROM Members m
JOIN Loans l ON m.MemberID = l.MemberID
WHERE l.Status = 'Overdue';

-- 4. Show top 3 most expensive books.
SELECT * FROM Books ORDER BY Price DESC LIMIT 3;

-- 5. List all authors from 'India'.
SELECT * FROM Authors WHERE Nationality LIKE '%Indian%';

-- 6. Show books written by a given author ('J.K. Rowling').
SELECT b.*
FROM Books b
JOIN Authors a ON b.AuthorID = a.AuthorID
WHERE a.Name = 'J.K. Rowling';

-- 7. Count total books per category.
SELECT Category, COUNT(BookID) AS BookCount
FROM Books
GROUP BY Category;

-- 8. Find members who borrowed more than 5 books.
SELECT m.MemberID, m.Name, COUNT(l.LoanID) AS BorrowCount
FROM Members m
JOIN Loans l ON m.MemberID = l.MemberID
GROUP BY m.MemberID, m.Name
HAVING BorrowCount > 5;

-- 9. Show loans with status 'Returned'.
SELECT * FROM Loans WHERE Status = 'Returned';

-- 10. Display members who never borrowed any book.
SELECT * FROM Members
WHERE MemberID NOT IN (SELECT DISTINCT MemberID FROM Loans);

-- 11. List all unpaid fines.
SELECT * FROM Fines WHERE PaymentStatus = 'Unpaid';

-- 12. Show total fines paid per member.
SELECT m.Name, SUM(f.Amount) AS TotalFinesPaid
FROM Members m
JOIN Loans l ON m.MemberID = l.MemberID
JOIN Fines f ON l.LoanID = f.LoanID
WHERE f.PaymentStatus = 'Paid'
GROUP BY m.MemberID, m.Name;

-- 13. Find books issued in the last month.
SELECT DISTINCT b.*
FROM Books b
JOIN Loans l ON b.BookID = l.BookID
WHERE l.IssueDate >= CURDATE() - INTERVAL 1 MONTH;

-- 14. Show members who borrowed books in a specific category ('Fantasy').
SELECT DISTINCT m.*
FROM Members m
JOIN Loans l ON m.MemberID = l.MemberID
JOIN Books b ON l.BookID = b.BookID
WHERE b.Category = 'Fantasy';

-- 15. Find authors who wrote more than 3 books.
SELECT a.Name, COUNT(b.BookID) AS BookCount
FROM Authors a
JOIN Books b ON a.AuthorID = b.AuthorID
GROUP BY a.AuthorID, a.Name
HAVING BookCount > 3;

-- 16. List books with price between 200 and 500.
SELECT * FROM Books WHERE Price BETWEEN 200 AND 500;

-- 17. Show average fine amount.
SELECT AVG(Amount) AS AvgFineAmount FROM Fines;

-- 18. Find members with phone numbers starting with '9'.
SELECT * FROM Members WHERE Phone LIKE '9%';

-- 19. Display all loans with book and member details.
SELECT l.LoanID, b.Title, m.Name, l.IssueDate, l.ReturnDate, l.Status
FROM Loans l
JOIN Books b ON l.BookID = b.BookID
JOIN Members m ON l.MemberID = m.MemberID;

-- 20. Show books whose title contains 'History'.
SELECT * FROM Books WHERE Title LIKE '%History%';

-- 21. List members with more than one unpaid fine.
SELECT m.Name, COUNT(f.FineID) AS UnpaidFines
FROM Members m
JOIN Loans l ON m.MemberID = l.MemberID
JOIN Fines f ON l.LoanID = f.LoanID
WHERE f.PaymentStatus = 'Unpaid'
GROUP BY m.MemberID, m.Name
HAVING UnpaidFines > 1;

-- 22. Find books with no loans.
SELECT b.*
FROM Books b
LEFT JOIN Loans l ON b.BookID = l.BookID
WHERE l.LoanID IS NULL;

-- 23. Show most borrowed book.
SELECT b.Title, COUNT(l.LoanID) AS LoanCount
FROM Books b
JOIN Loans l ON b.BookID = l.BookID
GROUP BY b.BookID, b.Title
ORDER BY LoanCount DESC
LIMIT 1;

-- 24. Display top 5 members by total borrowings.
SELECT m.Name, COUNT(l.LoanID) AS BorrowCount
FROM Members m
JOIN Loans l ON m.MemberID = l.MemberID
GROUP BY m.MemberID, m.Name
ORDER BY BorrowCount DESC
LIMIT 5;

-- 25. Show all categories of books available.
SELECT DISTINCT Category FROM Books;
