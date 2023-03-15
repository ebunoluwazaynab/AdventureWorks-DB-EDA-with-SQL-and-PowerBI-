
/*** Geography Table Cleaned ***/

USE AdventureWorksDW2019;

SELECT GeographyKey, 
       City, 
	   EnglishCountryRegionName AS [CountryName], 
	   SalesTerritoryRegion, 
       SalesTerritoryGroup, 
	   PostalCode, 
	   S.SalesTerritoryKey
FROM DimGeography G
INNER JOIN DimSalesTerritory S
ON G.SalesTerritoryKey = S.SalesTerritoryKey;