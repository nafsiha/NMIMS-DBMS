CREATE DATABASE BesantBank;
Use BesantBank;

CREATE TABLE AccountDetails(
AccountDetails INT Primary Key,
Name varchar(10) NOT NULL,
Age TINYINT CHECK(Age >= 18),
Accounttype VARCHAR(20),
CurrentBalance INT
);

INSERT INTO AccountDetails 
VALUES
(1, 'Ram', 21, 'Saving', 2000);

CREATE TABLE TransactionDetails(
TransactionID INT PRIMARY KEY AUTO_INCREMENT,
AccountDetails INT,
TransactionType VARCHAR(10) CHECK(TransactionType = 'Credit' OR TransactionType = 'Debit'),
TransactionAmount INT,
TransactionTime DATETIME DEFAULT(NOW()),
FOREIGN KEY (AccountDetails) REFERENCES AccountDetails(AccountDetails)
);

SELECT * FROM TransactionDetails;

INSERT INTO AccountDetails VALUES
(2, 'Sana', 30, 'Saving', 8000);


INSERT INTO TransactionDetails (AccountDetails, TransactionType, TransactionAmount) 
VALUES
(1, 'Credit', 100),
(2, 'Debit', 200);
