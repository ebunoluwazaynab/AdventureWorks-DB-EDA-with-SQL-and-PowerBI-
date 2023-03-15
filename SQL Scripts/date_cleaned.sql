
/*** Date Table Cleaned ***/

USE AdventureWorksDW2019;

SELECT DateKey, 
       FullDateAlternateKey AS [Date], 
	   EnglishDayNameOfWeek AS [Day], 
       EnglishMonthName AS [Month], 
	   CalendarYear AS [Year]
FROM DimDate;
