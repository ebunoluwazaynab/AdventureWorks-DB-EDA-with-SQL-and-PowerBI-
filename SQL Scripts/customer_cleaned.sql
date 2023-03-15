
/***  Table Cleaned ***/

USE AdventureWorksDW2019;

SELECT CustomerKey, 
       GeographyKey, 
	   CONCAT(FirstName, ' ', LastName) AS [CustomerName], 
	   BirthDate, CASE 
                      WHEN MaritalStatus = 'M' THEN 'Married'
	                  WHEN MaritalStatus = 'S' THEN 'Single'
                      END AS MaritalStatus, 
				  CASE 
				      WHEN Gender = 'M' THEN 'Male'
					  WHEN Gender = 'F' THEN 'Female'
END AS Gender 
FROM DimCustomer;
