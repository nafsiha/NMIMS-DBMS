CREATE DEFINER=`root`@`localhost` PROCEDURE `AccountStatusUpdater`()
BEGIN
	UPDATE AccountDetails
    SET AccountStatus = 'Active' WHERE AccountDetails IN(
		SELECT AccountDetails FROM TransactionDetails
        WHERE TIMESTAMPDIFF(MONTH, TransactionTime, NOW())<6);
	UPDATE AccountDetails 
    SET AccountStatus = 'Inactive' WHERE AccountDetails NOT IN(
		SELECT AccountDetails FROM TransactionDetails
        WHERE TIMESTAMPDIFF(MONTH, TransactionTIme, NOW())<6);
END

CREATE DEFINER=`root`@`localhost` PROCEDURE `BankStatement`(Par_AccountID INT)
BEGIN
	SELECT * FROM TransactionDetails
    WHERE AccountDetails = Par_AccountID;
END

CREATE DEFINER=`root`@`localhost` PROCEDURE `MiniStatement`(Par_AccountID INT)
BEGIN
	Declare Var_Name CHAR(20);
    Declare Var_CurrentBalance INT;
    SELECT NOW() AS Today_DateTime;
    IF EXISTS(
		SELECT * FROM AccountDetails
        WHERE AccountDetails = Par_AccountID)
	THEN
		SELECT Par_AccountID AS AccountDetails;
        SELECT Name, CurrentBalance INTO Var_Name, Var_CurrentBalance 
			from AccountDetails 
            WHERE AccountDetails = Par_AccountID;
		SELECT Var_Name AS CustomerName;
        SELECT Var_CurrentBalance AS CurrentBalance;
        SELECT * from TransactionDetails
			WHERE AccountDetails = Par_AccountID 
            AND TIMESTAMPDIFF(MONTH, TransactionTime, NOW()) < 6;
	else
		SELECT 'INVALID ACCOUNT ID' as Message;
	END IF;
END
