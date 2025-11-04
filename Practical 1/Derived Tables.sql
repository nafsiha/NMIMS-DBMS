SELECT CurrentBalance from AccountDetails
ORDER BY CurrentBalance DESC 
LIMIT 5;

SELECT Min(CurrentBalance) from AccountDetails 
WHERE CurrentBalance in (
	SELECT CurrentBalance from AccountDetails
	ORDER BY CurrentBalance DESC 
	LIMIT 5
);

SELECT Min(CurrentBalance) from (
	SELECT CurrentBalance from AccountDetails
	ORDER BY CurrentBalance DESC 
	LIMIT 5) AS TopBalance;
    
SELECT Min(CurrentBalance) from (
	SELECT CurrentBalance from AccountDetails
	ORDER BY CurrentBalance DESC 
	LIMIT 2) AS TopBalance;
