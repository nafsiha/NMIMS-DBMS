Use BesantBank;
select * from AccountDetails;

INSERT INTO AccountDetails
VALUES
(3, 'John', 27, 'Saving', 1000),
(4, 'Peter', 25, 'Saving', 1500),
(5, 'Kiran', 27, 'Current', 5200),
(6, 'Priya', 21, 'Saving', 5500),
(7, 'Varun', 28, 'Current', 500),
(8, 'Sonu', 29, 'Saving', 2500),
(9, 'Kumar', 28, 'Saving', 2000),
(10, 'Jathin', 27, 'Current', 5000),
(11, 'Suma', 22, 'Saving', 1500);

INSERT INTO TransactionDetails (AccountDetails, TransactionType, TransactionAmount)
Values
(7, 'Credit', 1000);

SELECT Distinct(AccountDetails) from TransactionDetails;

SELECT * FROM AccountDetails where AccountDetails in (1,7);

select * from AccountDetails 
WHERE AccountDetails IN(
	SELECT Distinct(AccountDetails) FROM TransactionDetails);
