Delimiter $$
CREATE TRIGGER BalanceUpdater
AFTER INSERT ON TransactionDetails
FOR EACH ROW
BEGIN
    DECLARE VTransactionID INT;
    DECLARE VTransactionType varchar(10);
    DECLARE VAccountID INT;
    DECLARE VTransactionAMT INT;
    select MAX(TransactionID) INTO VTransactionID from TransactionDetails;
    select AccountID, TransactionType, TransactionAmount 
    INTO VAccountID, VTransactionType, VTransactionAMT
    from TransactionDetails
    WHERE TransactionID = VTransactionID;
    IF VTransactionType = 'Credit' THEN
		UPDATE AccountDetails 
        SET CurrentBalance = CurrentBalance + VTransactionAMT
        WHERE AccountID = VAccountID;
	ELSEIF VTransactionType = 'Debit' THEN
		UPDATE AccountDetails
        SET CurrentBalance = CurrentBalance - VTransactionAMT
        WHERE AccountID = VAccountID;
	END IF;
END $$

select * from AccountDetails;

CREATE INDEX AccIndex 
on AccountDetails(AccountID);

CREATE INDEX AccIDIndex 
USING HASH
on AccountDetails(AccountID);

Drop INDEX AccIDIndex 
on AccountDetails;

CREATE TRIGGER CASCADINGDELETE
BEFORE DELETE on AccountDetails
FOR EACH ROW
BEGIN
	DELETE FROM TransactionDetails
    WHERE AccountID = TransactionID
END

DELIMITER;

DELETE FROM AccountDetails
WHERE AccountID = 1;
