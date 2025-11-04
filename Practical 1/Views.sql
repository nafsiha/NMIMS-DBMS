CREATE VIEW AccountsOfTransactions AS
	SELECT * FROM AccountDetails WHERE AccountDetails IN (
    SELECT DISTINCT(AccountDetails) FROM TransactionDetails);
    
SELECT * FROM AccountsOfTransactions;

INSERT INTO TransactionDetails (AccountDetails, TransactionType, TransactionAmount)
VALUES
(2, 'Credit', 1000);

SELECT * FROM AccountsOfTransactions;

UPDATE AccountsOfTransactions
SET Name = 'Ram Prasad'
WHERE AccountDetails = 1;

CREATE VIEW BalanceBank AS 
	SELECT SUM(CurrentBalance) FROM AccountDetails;
    
SELECT * FROM BalanceBank;

UPDATE BalanceBank 
SET Name = 'Ram' WHERE 
AccountDetails = 1;

CREATE VIEW BankStatement AS
    SELECT * FROM Transactiondetails
    WHERE AccountID=1;

SELECT * FROM BankStatement;

ALTER TABLE AccountDetails 
Add AccountStatus VARCHAR(8) DEFAULT('Active');

SELECT * FROM AccountDetails;

alter table AccountDetails rename column AccountDetails to AccountID;
