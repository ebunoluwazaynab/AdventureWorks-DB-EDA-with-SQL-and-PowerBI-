
/*** Products Table Cleaned ***/

USE AdventureWorksDW2019;

SELECT ProductKey, 
       P.ProductSubcategoryKey, 
	   EnglishProductName AS [ProductName], 
       Category, 
	   Subcategory, 
	   StandardCost, 
	   Color, 
	   ModelName, 
CASE
    WHEN Status IS NULL THEN 'Outdate' 
	WHEN Status = 'Current' THEN 'Current'
END AS 'Status'
FROM DimProduct P
INNER JOIN (SELECT C.ProductCategoryKey, 
                   ProductSubcategoryKey, 
				   EnglishProductCategoryName AS [Category], 
                   EnglishProductSubcategoryName AS [Subcategory]
FROM DimProductCategory C
INNER JOIN DimProductSubcategory S
ON C.ProductCategoryKey = S.ProductCategoryKey) C
ON P.ProductSubcategoryKey = C.ProductSubcategoryKey;