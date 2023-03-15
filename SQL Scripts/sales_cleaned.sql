
/*** Sales Table Cleaned ***/

USE AdventureWorksDW2019;

SELECT ProductKey, 
       OrderDateKey, 
	   CustomerKey, 
	   SalesTerritoryKey, 
	   OrderQuantity, 
	   ProductStandardCost, 
	   SalesAmount, 
	   CAST(OrderDate AS date) AS [OrderDate]
FROM FactInternetSales;
