-- Set 3: Library Book Borrowing

CREATE DATABASE LibraryBookBorrowing;
USE LibraryBookBorrowing;

CREATE TABLE LibraryBorrowing (
    BorrowID INT,
    MemberID INT,
    MemberName VARCHAR(100),
    MemberAddress VARCHAR(200),
    BookID VARCHAR(100),
    BookTitle VARCHAR(200),
    Author VARCHAR(100),
    Publisher VARCHAR(100),
    BorrowDate DATE,
    ReturnDate DATE);

INSERT INTO LibraryBorrowing 
VALUES
(401,1001,'Kiran Shah','Mumbai','B001','Intro to Databases','A. Silberschatz','Pearson','2025-09-01','2025-09-15'),
(402,1002,'Manish Verma','Pune','B002','Computer Networks','J. Kurose','McGraw-Hill','2025-09-03','2025-09-17'),
(403,1001,'Kiran Shah','Mumbai','B003','Operating Systems','A. Tanenbaum','Pearson','2025-09-05',NULL),
(404,1003,'Sana Khan','Delhi','B001','Intro to Databases','A. Silberschatz','Pearson','2025-09-07','2025-09-21'),
(405,1004,'Ravi Patel','Mumbai','B004','Algorithms','Cormen','MIT Press','2025-09-10','2025-09-24');

INSERT INTO Members 
VALUES
(1001,'Kiran Shah','Mumbai'),
(1002,'Manish Verma','Pune'),
(1003,'Sana Khan','Delhi'),
(1004,'Ravi Patel','Mumbai');

INSERT INTO Books 
VALUES
('B001','Intro to Databases','A. Silberschatz','Pearson'),
('B002','Computer Networks','J. Kurose','McGraw-Hill'),
('B003','Operating Systems','A. Tanenbaum','Pearson'),
('B004','Algorithms','Cormen','MIT Press');

INSERT INTO Borrowings 
VALUES
(401,1001,'B001','2025-09-01','2025-09-15'),
(402,1002,'B002','2025-09-03','2025-09-17'),
(403,1001,'B003','2025-09-05',NULL),
(404,1003,'B001','2025-09-07','2025-09-21'),
(405,1004,'B004','2025-09-10','2025-09-24');

-- 1. Identify insertion anomalies.
-- You can't add a new member without them borrowing a book. Similarly, you cannot add a new book to the library's catalog until it is borrowed by a member. This is a problem because a library needs to track all members and all books, not just those involved in a current borrowing transaction.

-- 2. Identify update anomalies.
-- If a member's address changes, you have to update it in every row where that member appears. For example, if Kiran Shah's address changes, it must be updated in both rows with MemberID 1001. This is inefficient and risks data inconsistency.

-- -- 3. Identify deletion anomalies.
-- Deleting the last row for a specific member can cause the loss of all their information. For instance, if the only borrowing record for MemberID 1004 is deleted, information about Ravi Patel (name, address) is lost.

-- 4. Why does this table fail 1NF?
-- The table, as described, actually does satisfy 1NF. All values in the table are atomic (indivisible). Each cell contains a single value, and there are no repeating groups or columns.

-- 5. Rewrite schema in 1NF.
-- Since the table already meets 1NF, no rewriting is necessary. The normalization process will continue to 2NF.

-- 6. State primary key.
-- The primary key for this unnormalized table is BorrowID, as it uniquely identifies each borrowing transaction.

-- 7. Write FDs.
-- The functional dependencies are:
-- {BorrowID} -> {MemberID, BookID, BorrowDate, ReturnDate} (A borrowing transaction is uniquely identified by its ID)
-- {MemberID} -> {MemberName, MemberAddress}
-- {BookID} -> {BookTitle, Author, Publisher}.

-- 8. Remove partial dependencies (2NF).
-- The table fails 2NF because non-prime attributes are partially dependent on a part of a composite key, though BorrowID is the only key. However, if we were to use a composite key like {MemberID, BookID, BorrowDate}, then MemberName, MemberAddress, BookTitle, Author, and Publisher would be partially dependent on MemberID and BookID respectively. To fix this, we split the schema into separate tables: Members, Books, and Borrowings.

-- 9. Write SQL for 2NF schema.
CREATE TABLE Members (
    MemberID INT PRIMARY KEY,
    MemberName VARCHAR(100),
    MemberAddress VARCHAR(200));

CREATE TABLE Books (
    BookID VARCHAR(20) PRIMARY KEY,
    BookTitle VARCHAR(200),
    Author VARCHAR(100),
    Publisher VARCHAR(100));

CREATE TABLE Borrowings (
    BorrowID INT PRIMARY KEY,
    MemberID INT,
    BookID VARCHAR(20),
    BorrowDate DATE,
    ReturnDate DATE,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID));
    
-- 10. Identify transitive dependencies.
-- The 2NF schema does not contain any transitive dependencies. MemberName and MemberAddress are directly dependent on MemberID. BookTitle, Author, and Publisher are directly dependent on BookID. There are no non-key attributes that depend on other non-key attributes.

-- 11. Convert to 3NF.
-- Since no transitive dependencies exist, the schema is already in 3NF. No further conversion is needed.

-- 12. Write SQL for 3NF schema.
-- The SQL for the 3NF schema is the same as the one for the 2NF schema, as they are identical.

-- 13. Does schema meet BCNF?
-- Yes, the 3NF schema also meets BCNF (Boyce-Codd Normal Form) because for every functional dependency, the determinant is a superkey. There are no non-trivial functional dependencies where a non-superkey determines a prime or non-prime attribute. Therefore, it satisfies the strict BCNF rules.

-- 14. Query: List all books borrowed by a member.
SELECT b.BookID,b.BookTitle,br.BorrowDate,br.ReturnDate
FROM Borrowings br JOIN Books b ON br.BookID=b.BookID
WHERE br.MemberID=1001;

-- 15. Query: Find members who borrowed more than 3 books.
SELECT m.MemberID,m.MemberName,COUNT(*) AS BorrowCount
FROM Members m JOIN Borrowings br ON m.MemberID=br.MemberID
GROUP BY m.MemberID,m.MemberName
HAVING COUNT(*)>3;

-- 16. Query: Find authors whose books are borrowed most.
SELECT b.Author,COUNT(*) AS BorrowedCount
FROM Books b JOIN Borrowings br ON b.BookID=br.BookID
GROUP BY b.Author
ORDER BY BorrowedCount DESC;

-- 17. Query: Count books borrowed per month.
SELECT DATE_FORMAT(BorrowDate, '%Y-%m') AS Month, COUNT(*) AS TotalBorrows
FROM Borrowings
GROUP BY Month;

-- 18. Query: List overdue books.
SELECT br.BorrowID,m.MemberName,b.BookTitle, br.BorrowDate
FROM Borrowings br
JOIN Members m ON br.MemberID=m.MemberID
JOIN Books b ON br.BookID=b.BookID
WHERE br.ReturnDate IS NULL AND DATEDIFF(CURDATE(), br.BorrowDate) > 14;

-- 19. Query: Find publishers whose books are borrowed most.
SELECT b.Publisher, COUNT(*) AS BorrowedCount
FROM Books b
JOIN Borrowings br ON b.BookID = br.BookID
GROUP BY b.Publisher
ORDER BY BorrowedCount DESC
LIMIT 1;

-- 20. Compare redundancy pre/post normalization.
-- Normalization drastically reduces data redundancy. In the unnormalized LibraryBorrowing table, details about a member (name, address) and a book (title, author, publisher) are repeated for every borrowing transaction. For instance, the details for BookID 'B001' are repeated twice. After normalization, each piece of data is stored only once in its own dedicated table. Member information is in the Members table, book information is in the Books table, and the Borrowings table links them using foreign keys. This design ensures data consistency and makes the database more efficient and easier to manage by eliminating redundant data storage.