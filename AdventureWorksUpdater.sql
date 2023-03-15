/****** Object:  StoredProcedure [dbo].[AdventureWorksUpdate 
   Copyright 2018 Just-BI BV, Raid Fikri (raid.fikri@just-bi.nl)

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
   
******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AdventureWorksUpdate1]
AS
	BEGIN
	DECLARE @AddWeeks INT; 
	DECLARE @AddYears INT;
	DECLARE @AddMonths INT;

	-- CREATE A LOG TABLE TO SHOW DIFFERENCE BEFORE AND AFTER THE UPDATE 
	if exists (select * from sysobjects where name='TempCheckTable' and xtype='U')
	DROP TABLE [dbo].[TempCheckTable];

	CREATE TABLE [dbo].[TempCheckTable](
	[TableName] [nvarchar](50) NOT NULL,
	[ColName] [nvarchar](50) NOT NULL,
	[DateBefore] [date] NULL,
	[DateAfter] [date] NULL,
	[ValueBefore] [int] NULL,
	[ValueAfter] [int] NULL
	CONSTRAINT PK_TableColumn PRIMARY KEY NONCLUSTERED ([TableName], [ColName])
	) ON [PRIMARY]

	-- UPDATE THE LOG TABLE WITH THE INITIAL FROM- AND TO- VALUES
	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [DateBefore], [ValueBefore])
		SELECT 'DimDate', 'DateMin' , MIN([FullDateAlternateKey]), MIN([DateKey]) FROM [dbo].[DimDate];
	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [DateBefore], [ValueBefore])
		SELECT 'DimDate', 'DateMax' , MAX([FullDateAlternateKey]), MAX([DateKey]) FROM [dbo].[DimDate];
	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [DateBefore])
		SELECT 'DimCustomer', 'BirthDateMin' , MIN([BirthDate]) FROM [dbo].[DimCustomer];
	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [DateBefore])
		SELECT 'DimCustomer', 'BirthDateMax' , MAX([BirthDate]) FROM [dbo].[DimCustomer];
	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [DateBefore])
		SELECT 'DimCustomer', 'DateFirstPurchaseMin' , MIN([DateFirstPurchase]) FROM [dbo].[DimCustomer];
	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [DateBefore])
		SELECT 'DimCustomer', 'DateFirstPurchaseMax' , MAX([DateFirstPurchase]) FROM [dbo].[DimCustomer];
	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [DateBefore])
		SELECT 'DimEmployee', 'BirthDateMin' , MIN([BirthDate]) FROM [dbo].[DimEmployee];
	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [DateBefore])
		SELECT 'DimEmployee', 'BirthDateMax' , MAX([BirthDate]) FROM [dbo].[DimEmployee];
	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [DateBefore])
		SELECT 'DimEmployee', 'HireDateMin' , MIN([HireDate]) FROM [dbo].[DimEmployee];
	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [DateBefore])
		SELECT 'DimEmployee', 'HireDateMax' , MAX([HireDate]) FROM [dbo].[DimEmployee];
	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [DateBefore])
		SELECT 'DimEmployee', 'StartDateMin' , MIN([StartDate]) FROM [dbo].[DimEmployee];
	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [DateBefore])
		SELECT 'DimEmployee', 'StartDateMax' , MAX([StartDate]) FROM [dbo].[DimEmployee];
	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [DateBefore])
		SELECT 'DimEmployee', 'EndDateMin' , MIN([EndDate]) FROM [dbo].[DimEmployee];
	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [DateBefore])
		SELECT 'DimEmployee', 'EndDateMax' , MAX([EndDate]) FROM [dbo].[DimEmployee];

	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [DateBefore])
		SELECT 'DimProduct', 'StartDateMin' , MIN([StartDate]) FROM [dbo].[DimProduct];
	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [DateBefore])
		SELECT 'DimProduct', 'StartDateMax' , MAX([StartDate]) FROM [dbo].[DimProduct];
	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [DateBefore])
		SELECT 'DimProduct', 'EndDateMin' , MIN([EndDate]) FROM [dbo].[DimProduct];
	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [DateBefore])
		SELECT 'DimProduct', 'EndDateMax' , MAX([EndDate]) FROM [dbo].[DimProduct];

	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [ValueBefore])
		SELECT 'DimReseller', 'YearOpenedMin' , MIN([YearOpened]) FROM [dbo].[DimReseller];
	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [ValueBefore])
		SELECT 'DimReseller', 'YearOpenedMax' , MAX([YearOpened]) FROM [dbo].[DimReseller];
	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [ValueBefore])
		SELECT 'DimReseller', 'FirstOrderYearMin' , MIN([FirstOrderYear]) FROM [dbo].[DimReseller];
	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [ValueBefore])
		SELECT 'DimReseller', 'FirstOrderYearMax' , MAX([FirstOrderYear]) FROM [dbo].[DimReseller];
	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [ValueBefore])
		SELECT 'DimReseller', 'LastOrderYearMin' , MIN([LastOrderYear]) FROM [dbo].[DimReseller];
	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [ValueBefore])
		SELECT 'DimReseller', 'LastOrderYearMax' , MAX([LastOrderYear]) FROM [dbo].[DimReseller];
	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [ValueBefore])
		SELECT 'DimReseller', 'OrderMonthMin' , MIN([OrderMonth]) FROM [dbo].[DimReseller];
	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [ValueBefore])
		SELECT 'DimReseller', 'OrderMonthMax' , MAX([OrderMonth]) FROM [dbo].[DimReseller];

	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [DateBefore], [ValueBefore])
		SELECT 'FactCallCenter', 'DateMin' , MIN([Date]), MIN([DateKey]) FROM [dbo].[FactCallCenter];
	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [DateBefore], [ValueBefore])
		SELECT 'FactCallCenter', 'DateMax' , MAX([Date]), MAX([DateKey]) FROM [dbo].[FactCallCenter];

	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [DateBefore], [ValueBefore])
		SELECT 'FactCurrencyRate', 'DateMin' , MIN([Date]), MIN([DateKey]) FROM [dbo].[FactCurrencyRate];
	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [DateBefore], [ValueBefore])
		SELECT 'FactCurrencyRate', 'DateMax' , MAX([Date]), MAX([DateKey]) FROM [dbo].[FactCurrencyRate];

	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [DateBefore], [ValueBefore])
		SELECT 'FactFinance', 'DateMin' , MIN([Date]), MIN([DateKey]) FROM [dbo].[FactFinance];
	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [DateBefore], [ValueBefore])
		SELECT 'FactFinance', 'DateMax' , MAX([Date]), MAX([DateKey]) FROM [dbo].[FactFinance];

	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [DateBefore], [ValueBefore])
		SELECT 'FactInternetSales', 'OrderDateMin' , MIN([OrderDate]), MIN([OrderDateKey]) FROM [dbo].[FactInternetSales];
	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [DateBefore], [ValueBefore])
		SELECT 'FactInternetSales', 'OrderDateMax' , MAX([OrderDate]), MAX([OrderDateKey]) FROM [dbo].[FactInternetSales];
	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [DateBefore], [ValueBefore])
		SELECT 'FactInternetSales', 'DueDateMin' , MIN([DueDate]), MIN([DueDateKey]) FROM [dbo].[FactInternetSales];
	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [DateBefore], [ValueBefore])
		SELECT 'FactInternetSales', 'DueDateMax' , MAX([DueDate]), MAX([DueDateKey]) FROM [dbo].[FactInternetSales];
	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [DateBefore], [ValueBefore])
		SELECT 'FactInternetSales', 'ShipDateMin' , MIN([ShipDate]), MIN([ShipDateKey]) FROM [dbo].[FactInternetSales];
	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [DateBefore], [ValueBefore])
		SELECT 'FactInternetSales', 'ShipDateMax' , MAX([ShipDate]), MAX([ShipDateKey]) FROM [dbo].[FactInternetSales];

	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [DateBefore], [ValueBefore])
		SELECT 'FactProductInventory', 'MovementDateMin' , MIN([MovementDate]), MIN([DateKey]) FROM [dbo].[FactProductInventory];
	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [DateBefore], [ValueBefore])
		SELECT 'FactProductInventory', 'MovementDateMax' , MAX([MovementDate]), MAX([DateKey]) FROM [dbo].[FactProductInventory];

	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [DateBefore], [ValueBefore])
		SELECT 'FactResellerSales', 'OrderDateMin' , MIN([OrderDate]), MIN([OrderDateKey]) FROM [dbo].[FactResellerSales];
	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [DateBefore], [ValueBefore])
		SELECT 'FactResellerSales', 'OrderDateMax' , MAX([OrderDate]), MAX([OrderDateKey]) FROM [dbo].[FactResellerSales];
	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [DateBefore], [ValueBefore])
		SELECT 'FactResellerSales', 'DueDateMin' , MIN([DueDate]), MIN([DueDateKey]) FROM [dbo].[FactResellerSales];
	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [DateBefore], [ValueBefore])
		SELECT 'FactResellerSales', 'DueDateMax' , MAX([DueDate]), MAX([DueDateKey]) FROM [dbo].[FactResellerSales];
	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [DateBefore], [ValueBefore])
		SELECT 'FactResellerSales', 'ShipDateMin' , MIN([ShipDate]), MIN([ShipDateKey]) FROM [dbo].[FactResellerSales];
	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [DateBefore], [ValueBefore])
		SELECT 'FactResellerSales', 'ShipDateMax' , MAX([ShipDate]), MAX([ShipDateKey]) FROM [dbo].[FactResellerSales];

	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [DateBefore], [ValueBefore])
		SELECT 'FactSalesQuota', 'DateMin' , MIN([Date]), MIN([DateKey]) FROM [dbo].[FactSalesQuota];
	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [DateBefore], [ValueBefore])
		SELECT 'FactSalesQuota', 'DateMax' , MAX([Date]), MAX([DateKey]) FROM [dbo].[FactSalesQuota];

	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [DateBefore], [ValueBefore])
		SELECT 'FactSurveyResponse', 'DateMin' , MIN([Date]), MIN([DateKey]) FROM [dbo].[FactSurveyResponse];
	INSERT INTO [dbo].[TempCheckTable] ([TableName] , [ColName] , [DateBefore], [ValueBefore])
		SELECT 'FactSurveyResponse', 'DateMax' , MAX([Date]), MAX([DateKey]) FROM [dbo].[FactSurveyResponse];

	-- DETERMINE THE NUMBER OF WEEKS TO BE ADDED AND ASSIGN IT TO A VARIABLE
	SELECT @AddWeeks = DATEDIFF(WW, MAX([OrderDate]) ,GETDATE()+10), @AddMonths = DATEDIFF(MM, MAX([OrderDate])+2 ,GETDATE()+10), @AddYears = DATEDIFF(YY, MAX([OrderDate]) ,GETDATE()+10) FROM [dbo].[FactInternetSales];
	-- SELECT MAX([OrderDate]), DATEDIFF(ww, MAX([OrderDate]) ,GETDATE()+10) FROM [dbo].[FactInternetSales]; 

	--if not exists (select * from sysobjects where name='Temp_Date' and xtype='U')
	--	BEGIN
	--	CREATE TABLE [dbo].[Temp_Date]([LastDate] [date] NULL,	[LastDate_Key] [int] NULL,	[WeeksAgo] [int] NULL) ON [PRIMARY]
	--	END


	--TRUNCATE TABLE [dbo].[Temp_Date];

	--INSERT INTO [dbo].[Temp_Date] VALUES(@DateLast, @DateLastKey, @AddWeeks);

	-- SELECT * FROM [dbo].[Temp_Date];

	-- DROP CONSTRAINTS
	ALTER TABLE [dbo].[FactCallCenter] DROP CONSTRAINT [FK_FactCallCenter_DimDate];
	ALTER TABLE [dbo].[FactCurrencyRate] DROP CONSTRAINT [FK_FactCurrencyRate_DimDate];
	ALTER TABLE [dbo].[FactFinance] DROP CONSTRAINT [FK_FactFinance_DimDate];
	ALTER TABLE [dbo].[FactInternetSales] DROP CONSTRAINT [FK_FactInternetSales_DimDate];
	ALTER TABLE [dbo].[FactInternetSales] DROP CONSTRAINT [FK_FactInternetSales_DimDate1];
	ALTER TABLE [dbo].[FactInternetSales] DROP CONSTRAINT [FK_FactInternetSales_DimDate2];
	ALTER TABLE [dbo].[FactProductInventory] DROP CONSTRAINT [FK_FactProductInventory_DimDate];
	ALTER TABLE [dbo].[FactResellerSales] DROP CONSTRAINT [FK_FactResellerSales_DimDate];
	ALTER TABLE [dbo].[FactResellerSales] DROP CONSTRAINT [FK_FactResellerSales_DimDate1];
	ALTER TABLE [dbo].[FactResellerSales] DROP CONSTRAINT [FK_FactResellerSales_DimDate2];
	ALTER TABLE [dbo].[FactSurveyResponse] DROP CONSTRAINT [FK_FactSurveyResponse_DateKey];
	ALTER TABLE [dbo].[FactSalesQuota] DROP CONSTRAINT [FK_FactSalesQuota_DimDate];

	-- Return the name of primary key.
	-- SELECT name FROM sys.key_constraints WHERE type = 'PK' AND OBJECT_NAME(parent_object_id) = N'DimDate';

	-- Delete the primary key constraint ot the DimDate table
	ALTER TABLE [dbo].[DimDate] DROP CONSTRAINT PK_DimDate_DateKey; 


	-- UPDATE THE DIMDATE TABLE
	UPDATE [dbo].[DimDate] SET [FullDateAlternateKey] = DATEADD(ww,@AddWeeks,[FullDateAlternateKey]);
	UPDATE [dbo].[DimDate] SET [DateKey] = YEAR([FullDateAlternateKey]) * 10000 + MONTH([FullDateAlternateKey]) * 100 + DAY([FullDateAlternateKey]);
	UPDATE [dbo].[DimDate] SET [DayNumberOfMonth] = DAY([FullDateAlternateKey]);
	UPDATE [dbo].[DimDate] SET [DayNumberOfYear] = DATEDIFF(day,STR(YEAR([FullDateAlternateKey]),4)+'0101',[FullDateAlternateKey])+1;
	UPDATE [dbo].[DimDate] SET [WeekNumberOfYear] = DATEPART ( ww , [FullDateAlternateKey] );
	UPDATE [dbo].[DimDate] SET [MonthNumberOfYear] = DATEPART ( mm , [FullDateAlternateKey] );
	UPDATE [dbo].[DimDate] SET [CalendarQuarter] = DATEPART ( qq , [FullDateAlternateKey] );
	UPDATE [dbo].[DimDate] SET [CalendarYear] = DATEPART ( yyyy , [FullDateAlternateKey] );
	UPDATE [dbo].[DimDate] SET [CalendarSemester] = CASE WHEN MONTH([FullDateAlternateKey]) <= 6 THEN 1 ELSE 2 END ;
	UPDATE [dbo].[DimDate] SET [FiscalQuarter] = DATEPART ( qq , DATEADD (m, 6, [FullDateAlternateKey]) );
	UPDATE [dbo].[DimDate] SET [FiscalYear] = DATEPART ( yyyy , DATEADD (m, 6, [FullDateAlternateKey]) );
	UPDATE [dbo].[DimDate] SET [FiscalSemester] = CASE WHEN MONTH(DATEADD (m, 6, [FullDateAlternateKey])) <= 6 THEN 1 ELSE 2 END ;
	SET LANGUAGE us_english;
	UPDATE [dbo].[DimDate] SET [EnglishMonthName]= DATENAME(month, [FullDateAlternateKey]);
	SET LANGUAGE Spanish;  
	UPDATE [dbo].[DimDate] SET [SpanishMonthName]= DATENAME(month, [FullDateAlternateKey]);
	SET LANGUAGE French;  
	UPDATE [dbo].[DimDate] SET [FrenchMonthName]= DATENAME(month, [FullDateAlternateKey]);
	SET LANGUAGE us_english;

	-- UPDATE THE OTHER TABLES
	UPDATE [dbo].[FactCallCenter] SET [Date] = DATEADD(ww,@AddWeeks,[Date]);
	UPDATE [dbo].[FactCallCenter] SET [DateKey] = YEAR([Date]) * 10000 + MONTH([Date]) * 100 + DAY([Date]);
	UPDATE [dbo].[FactCurrencyRate] SET [Date] = DATEADD(ww,@AddWeeks,[Date]);
	UPDATE [dbo].[FactCurrencyRate] SET [DateKey] = YEAR([Date]) * 10000 + MONTH([Date]) * 100 + DAY([Date]);
	UPDATE [dbo].[FactFinance] SET [Date] = DATEADD(ww,@AddWeeks,[Date]);
	UPDATE [dbo].[FactFinance] SET [DateKey] = YEAR([Date]) * 10000 + MONTH([Date]) * 100 + DAY([Date]);
	UPDATE [dbo].[FactInternetSales] SET [OrderDate] = DATEADD(ww,@AddWeeks,[OrderDate]);
	UPDATE [dbo].[FactInternetSales] SET [DueDate] = DATEADD(ww,@AddWeeks,[DueDate]);
	UPDATE [dbo].[FactInternetSales] SET [ShipDate] = DATEADD(ww,@AddWeeks,[ShipDate]);
	UPDATE [dbo].[FactInternetSales] SET [OrderDateKey] = YEAR([OrderDate]) * 10000 + MONTH([OrderDate]) * 100 + DAY([OrderDate]);
	UPDATE [dbo].[FactInternetSales] SET [DueDateKey] = YEAR([DueDate]) * 10000 + MONTH([DueDate]) * 100 + DAY([DueDate]);
	UPDATE [dbo].[FactInternetSales] SET [ShipDateKey] = YEAR([ShipDate]) * 10000 + MONTH([ShipDate]) * 100 + DAY([ShipDate]);
	UPDATE [dbo].[FactProductInventory] SET [MovementDate] = DATEADD(ww,@AddWeeks,[MovementDate]);
	UPDATE [dbo].[FactProductInventory] SET [DateKey] = YEAR([MovementDate]) * 10000 + MONTH([MovementDate]) * 100 + DAY([MovementDate]);
	UPDATE [dbo].[FactResellerSales] SET [OrderDate] = DATEADD(ww,@AddWeeks,[OrderDate]);
	UPDATE [dbo].[FactResellerSales] SET [DueDate] = DATEADD(ww,@AddWeeks,[DueDate]);
	UPDATE [dbo].[FactResellerSales] SET [ShipDate] = DATEADD(ww,@AddWeeks,[ShipDate]);
	UPDATE [dbo].[FactResellerSales] SET [OrderDateKey] = YEAR([OrderDate]) * 10000 + MONTH([OrderDate]) * 100 + DAY([OrderDate]);
	UPDATE [dbo].[FactResellerSales] SET [DueDateKey] = YEAR([DueDate]) * 10000 + MONTH([DueDate]) * 100 + DAY([DueDate]);
	UPDATE [dbo].[FactResellerSales] SET [ShipDateKey] = YEAR([ShipDate]) * 10000 + MONTH([ShipDate]) * 100 + DAY([ShipDate]);
	UPDATE [dbo].[FactSalesQuota] SET [Date] = DATEADD(ww,@AddWeeks,[Date]);
	UPDATE [dbo].[FactSalesQuota] SET [DateKey] = YEAR([Date]) * 10000 + MONTH([Date]) * 100 + DAY([Date]);
	UPDATE [dbo].[FactSurveyResponse] SET [Date] = DATEADD(ww,@AddWeeks,[Date]);
	UPDATE [dbo].[FactSurveyResponse] SET [DateKey] = YEAR([Date]) * 10000 + MONTH([Date]) * 100 + DAY([Date]);
	UPDATE [dbo].[DimCustomer] SET [BirthDate] = DATEADD(ww,@AddWeeks,[BirthDate]);
	UPDATE [dbo].[DimCustomer] SET [DateFirstPurchase] = DATEADD(ww,@AddWeeks,[DateFirstPurchase]);
	UPDATE [dbo].[DimEmployee] SET [BirthDate] = DATEADD(ww,@AddWeeks,[BirthDate]);
	UPDATE [dbo].[DimEmployee] SET [HireDate] = DATEADD(ww,@AddWeeks,[HireDate]);
	UPDATE [dbo].[DimEmployee] SET [StartDate] = DATEADD(ww,@AddWeeks,[StartDate]);
	UPDATE [dbo].[DimEmployee] SET [EndDate] = DATEADD(ww,@AddWeeks,[EndDate]);
	UPDATE [dbo].[DimProduct] SET [StartDate] = DATEADD(ww,@AddWeeks,[StartDate]);
	UPDATE [dbo].[DimProduct] SET [EndDate] = DATEADD(ww,@AddWeeks,[EndDate]);
	UPDATE [dbo].[DimReseller] SET [YearOpened] = [YearOpened] + @AddYears;
	UPDATE [dbo].[DimReseller] SET [FirstOrderYear] = [FirstOrderYear] + @AddYears;
	UPDATE [dbo].[DimReseller] SET [LastOrderYear] = [LastOrderYear] + @AddYears;
	UPDATE [dbo].[DimReseller] SET [OrderMonth] = MONTH(DateAdd(mm, @AddMonths, CAST('2010-' + CAST([OrderMonth] AS varchar) + '-1' AS DATETIME)));


	-- ADD PRIMARY KEY FOR DIMDATE
	ALTER TABLE [dbo].[DimDate] ADD CONSTRAINT PK_DimDate_DateKey PRIMARY KEY CLUSTERED ([DateKey]);

	-- ADD FOREIGN KEYS TO DATES IN FACT TABLES
	ALTER TABLE [dbo].[FactCallCenter] WITH NOCHECK ADD CONSTRAINT [FK_FactCallCenter_DimDate] FOREIGN KEY([DateKey]) REFERENCES [dbo].[DimDate] ([DateKey]);
	ALTER TABLE [dbo].[FactCurrencyRate] WITH NOCHECK ADD CONSTRAINT [FK_FactCurrencyRate_DimDate] FOREIGN KEY([DateKey]) REFERENCES [dbo].[DimDate] ([DateKey]);
	ALTER TABLE [dbo].[FactFinance] WITH NOCHECK ADD  CONSTRAINT [FK_FactFinance_DimDate] FOREIGN KEY([DateKey]) REFERENCES [dbo].[DimDate] ([DateKey]);
	ALTER TABLE [dbo].[FactInternetSales] WITH NOCHECK ADD CONSTRAINT [FK_FactInternetSales_DimDate] FOREIGN KEY([OrderDateKey]) REFERENCES [dbo].[DimDate] ([DateKey]);
	ALTER TABLE [dbo].[FactInternetSales] WITH NOCHECK ADD CONSTRAINT [FK_FactInternetSales_DimDate1] FOREIGN KEY([DueDateKey]) REFERENCES [dbo].[DimDate] ([DateKey]);
	ALTER TABLE [dbo].[FactInternetSales] WITH NOCHECK ADD CONSTRAINT [FK_FactInternetSales_DimDate2] FOREIGN KEY([ShipDateKey]) REFERENCES [dbo].[DimDate] ([DateKey]);
	ALTER TABLE [dbo].[FactProductInventory] WITH NOCHECK ADD CONSTRAINT [FK_FactProductInventory_DimDate] FOREIGN KEY([DateKey]) REFERENCES [dbo].[DimDate] ([DateKey]);
	ALTER TABLE [dbo].[FactResellerSales] WITH NOCHECK ADD CONSTRAINT [FK_FactResellerSales_DimDate] FOREIGN KEY([OrderDateKey]) REFERENCES [dbo].[DimDate] ([DateKey]);
	ALTER TABLE [dbo].[FactResellerSales] WITH NOCHECK ADD CONSTRAINT [FK_FactResellerSales_DimDate1] FOREIGN KEY([DueDateKey]) REFERENCES [dbo].[DimDate] ([DateKey]);
	ALTER TABLE [dbo].[FactResellerSales] WITH NOCHECK ADD CONSTRAINT [FK_FactResellerSales_DimDate2] FOREIGN KEY([ShipDateKey]) REFERENCES [dbo].[DimDate] ([DateKey]);
	ALTER TABLE [dbo].[FactSurveyResponse] WITH NOCHECK ADD CONSTRAINT [FK_FactSurveyResponse_DateKey] FOREIGN KEY([DateKey]) REFERENCES [dbo].[DimDate] ([DateKey]);
	ALTER TABLE [dbo].[FactSalesQuota] WITH NOCHECK ADD CONSTRAINT [FK_FactSalesQuota_DimDate] FOREIGN KEY([DateKey]) REFERENCES [dbo].[DimDate] ([DateKey]);

	-- UPDATE THE LOG TABLE WITH THE NEW FROM- AND TO- VALUES
	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[DateAfter] = [SourceTable].[DateMin],
		[ValueAfter] = [SourceTable].[DateKeyMin]
	FROM
		[dbo].[DimDate] INNER JOIN (SELECT MIN([FullDateAlternateKey]) AS DateMin, MIN([DateKey]) AS DateKeyMin FROM [dbo].[DimDate]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'DimDate' AND [dbo].[TempCheckTable].[ColName]  = 'DateMin';

	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[DateAfter] = [SourceTable].[DateMax],
		[ValueAfter] = [SourceTable].[DateKeyMax]
	FROM
		[dbo].[DimDate] INNER JOIN (SELECT MAX([FullDateAlternateKey]) AS DateMax, MAX([DateKey]) AS DateKeyMax FROM [dbo].[DimDate]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'DimDate' AND [dbo].[TempCheckTable].[ColName]  = 'DateMax';


	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[DateAfter] = [SourceTable].[BirthDateMin]
	FROM
		[dbo].[DimCustomer] INNER JOIN (SELECT MIN([BirthDate]) AS BirthDateMin FROM [dbo].[DimCustomer]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'DimCustomer' AND [dbo].[TempCheckTable].[ColName]  = 'BirthDateMin';
	
	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[DateAfter] = [SourceTable].[BirthDateMax]
	FROM
		[dbo].[DimCustomer] INNER JOIN (SELECT MAX([BirthDate]) AS BirthDateMax FROM [dbo].[DimCustomer]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'DimCustomer' AND [dbo].[TempCheckTable].[ColName]  = 'BirthDateMax';
	
	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[DateAfter] = [SourceTable].[DateFirstPurchaseMin]
	FROM
		[dbo].[DimCustomer] INNER JOIN (SELECT MIN([DateFirstPurchase]) AS DateFirstPurchaseMin FROM [dbo].[DimCustomer]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'DimCustomer' AND [dbo].[TempCheckTable].[ColName]  = 'DateFirstPurchaseMin';

	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[DateAfter] = [SourceTable].[DateFirstPurchaseMax]
	FROM
		[dbo].[DimCustomer] INNER JOIN (SELECT MAX([DateFirstPurchase]) AS DateFirstPurchaseMax FROM [dbo].[DimCustomer]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'DimCustomer' AND [dbo].[TempCheckTable].[ColName]  = 'DateFirstPurchaseMax';

	-- =================
	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[DateAfter] = [SourceTable].[BirthDateMin]
	FROM
		[dbo].[DimEmployee] INNER JOIN (SELECT MIN([BirthDate]) AS BirthDateMin FROM [dbo].[DimEmployee]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'DimEmployee' AND [dbo].[TempCheckTable].[ColName]  = 'BirthDateMin';
	
	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[DateAfter] = [SourceTable].[BirthDateMax]
	FROM
		[dbo].[DimEmployee] INNER JOIN (SELECT MAX([BirthDate]) AS BirthDateMax FROM [dbo].[DimEmployee]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'DimEmployee' AND [dbo].[TempCheckTable].[ColName]  = 'BirthDateMax';
	
	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[DateAfter] = [SourceTable].[HireDateMin]
	FROM
		[dbo].[DimEmployee] INNER JOIN (SELECT MIN([HireDate]) AS HireDateMin FROM [dbo].[DimEmployee]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'DimEmployee' AND [dbo].[TempCheckTable].[ColName]  = 'HireDateMin';

	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[DateAfter] = [SourceTable].[HireDateMax]
	FROM
		[dbo].[DimEmployee] INNER JOIN (SELECT MAX([HireDate]) AS HireDateMax FROM [dbo].[DimEmployee]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'DimEmployee' AND [dbo].[TempCheckTable].[ColName]  = 'HireDateMax';

	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[DateAfter] = [SourceTable].[StartDateMin]
	FROM
		[dbo].[DimEmployee] INNER JOIN (SELECT MIN([StartDate]) AS StartDateMin FROM [dbo].[DimEmployee]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'DimEmployee' AND [dbo].[TempCheckTable].[ColName]  = 'StartDateMin';

	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[DateAfter] = [SourceTable].[StartDateMax]
	FROM
		[dbo].[DimEmployee] INNER JOIN (SELECT MAX([StartDate]) AS StartDateMax FROM [dbo].[DimEmployee]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'DimEmployee' AND [dbo].[TempCheckTable].[ColName]  = 'StartDateMax';

	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[DateAfter] = [SourceTable].[EndDateMin]
	FROM
		[dbo].[DimEmployee] INNER JOIN (SELECT MIN([EndDate]) AS EndDateMin FROM [dbo].[DimEmployee]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'DimEmployee' AND [dbo].[TempCheckTable].[ColName]  = 'EndDateMin';

	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[DateAfter] = [SourceTable].[EndDateMax]
	FROM
		[dbo].[DimEmployee] INNER JOIN (SELECT MAX([EndDate]) AS EndDateMax FROM [dbo].[DimEmployee]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'DimEmployee' AND [dbo].[TempCheckTable].[ColName]  = 'EndDateMax';

	-- ==================================
	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[DateAfter] = [SourceTable].[StartDateMin]
	FROM
		[dbo].[DimProduct] INNER JOIN (SELECT MIN([StartDate]) AS StartDateMin FROM [dbo].[DimProduct]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'DimProduct' AND [dbo].[TempCheckTable].[ColName]  = 'StartDateMin';

	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[DateAfter] = [SourceTable].[StartDateMax]
	FROM
		[dbo].[DimProduct] INNER JOIN (SELECT MAX([StartDate]) AS StartDateMax FROM [dbo].[DimProduct]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'DimProduct' AND [dbo].[TempCheckTable].[ColName]  = 'StartDateMax';

	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[DateAfter] = [SourceTable].[EndDateMin]
	FROM
		[dbo].[DimProduct] INNER JOIN (SELECT MIN([EndDate]) AS EndDateMin FROM [dbo].[DimProduct]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'DimProduct' AND [dbo].[TempCheckTable].[ColName]  = 'EndDateMin';

	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[DateAfter] = [SourceTable].[EndDateMax]
	FROM
		[dbo].[DimProduct] INNER JOIN (SELECT MAX([EndDate]) AS EndDateMax FROM [dbo].[DimProduct]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'DimProduct' AND [dbo].[TempCheckTable].[ColName]  = 'EndDateMax';

	-- ==================================
	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[ValueAfter] = [SourceTable].[YearOpenedMin]
	FROM
		[dbo].[DimReseller] INNER JOIN (SELECT MIN([YearOpened]) AS YearOpenedMin FROM [dbo].[DimReseller]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'DimReseller' AND [dbo].[TempCheckTable].[ColName]  = 'YearOpenedMin';

	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[ValueAfter] = [SourceTable].[YearOpenedMax]
	FROM
		[dbo].[DimReseller] INNER JOIN (SELECT MAX([YearOpened]) AS YearOpenedMax FROM [dbo].[DimReseller]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'DimReseller' AND [dbo].[TempCheckTable].[ColName]  = 'YearOpenedMax';
	--ERROR
	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[ValueAfter] = [SourceTable].[FirstOrderYearMin]
	FROM
		[dbo].[DimReseller] INNER JOIN (SELECT MIN([FirstOrderYear]) AS FirstOrderYearMin FROM [dbo].[DimReseller]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'DimReseller' AND [dbo].[TempCheckTable].[ColName]  = 'FirstOrderYearMin';

	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[ValueAfter] = [SourceTable].[FirstOrderYearMax]
	FROM
		[dbo].[DimReseller] INNER JOIN (SELECT MAX([FirstOrderYear]) AS FirstOrderYearMax FROM [dbo].[DimReseller]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'DimReseller' AND [dbo].[TempCheckTable].[ColName]  = 'FirstOrderYearMax';

	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[ValueAfter] = [SourceTable].[LastOrderYearMin]
	FROM
		[dbo].[DimReseller] INNER JOIN (SELECT MIN([LastOrderYear]) AS LastOrderYearMin FROM [dbo].[DimReseller]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'DimReseller' AND [dbo].[TempCheckTable].[ColName]  = 'LastOrderYearMin';

	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[ValueAfter] = [SourceTable].[LastOrderYearMax]
	FROM
		[dbo].[DimReseller] INNER JOIN (SELECT MAX([LastOrderYear]) AS LastOrderYearMax FROM [dbo].[DimReseller]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'DimReseller' AND [dbo].[TempCheckTable].[ColName]  = 'LastOrderYearMax';

	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[ValueAfter] = [SourceTable].[OrderMonthMin]
	FROM
		[dbo].[DimReseller] INNER JOIN (SELECT MIN([OrderMonth]) AS OrderMonthMin FROM [dbo].[DimReseller]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'DimReseller' AND [dbo].[TempCheckTable].[ColName]  = 'OrderMonthMin';

	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[ValueAfter] = [SourceTable].[OrderMonthMax]
	FROM
		[dbo].[DimReseller] INNER JOIN (SELECT MAX([OrderMonth]) AS OrderMonthMax FROM [dbo].[DimReseller]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'DimReseller' AND [dbo].[TempCheckTable].[ColName]  = 'OrderMonthMax';

	--============================================

	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[DateAfter] = [SourceTable].[DateMin],
		[ValueAfter] = [SourceTable].[DateKeyMin]
	FROM
		[dbo].[FactCallCenter] INNER JOIN (SELECT MIN([Date]) AS DateMin, MIN([DateKey]) AS DateKeyMin FROM [dbo].[FactCallCenter]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'FactCallCenter' AND [dbo].[TempCheckTable].[ColName]  = 'DateMin';

	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[DateAfter] = [SourceTable].[DateMax],
		[ValueAfter] = [SourceTable].[DateKeyMax]
	FROM
		[dbo].[FactCallCenter] INNER JOIN (SELECT MAX([Date]) AS DateMax, MAX([DateKey]) AS DateKeyMax FROM [dbo].[FactCallCenter]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'FactCallCenter' AND [dbo].[TempCheckTable].[ColName]  = 'DateMax';

	--============================================

	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[DateAfter] = [SourceTable].[DateMin],
		[ValueAfter] = [SourceTable].[DateKeyMin]
	FROM
		[dbo].[FactCurrencyRate] INNER JOIN (SELECT MIN([Date]) AS DateMin, MIN([DateKey]) AS DateKeyMin FROM [dbo].[FactCurrencyRate]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'FactCurrencyRate' AND [dbo].[TempCheckTable].[ColName]  = 'DateMin';

	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[DateAfter] = [SourceTable].[DateMax],
		[ValueAfter] = [SourceTable].[DateKeyMax]
	FROM
		[dbo].[FactCurrencyRate] INNER JOIN (SELECT MAX([Date]) AS DateMax, MAX([DateKey]) AS DateKeyMax FROM [dbo].[FactCurrencyRate]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'FactCurrencyRate' AND [dbo].[TempCheckTable].[ColName]  = 'DateMax';


	--============================================

	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[DateAfter] = [SourceTable].[DateMin],
		[ValueAfter] = [SourceTable].[DateKeyMin]
	FROM
		[dbo].[FactFinance] INNER JOIN (SELECT MIN([Date]) AS DateMin, MIN([DateKey]) AS DateKeyMin FROM [dbo].[FactFinance]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'FactFinance' AND [dbo].[TempCheckTable].[ColName]  = 'DateMin';

	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[DateAfter] = [SourceTable].[DateMax],
		[ValueAfter] = [SourceTable].[DateKeyMax]
	FROM
		[dbo].[FactFinance] INNER JOIN (SELECT MAX([Date]) AS DateMax, MAX([DateKey]) AS DateKeyMax FROM [dbo].[FactFinance]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'FactFinance' AND [dbo].[TempCheckTable].[ColName]  = 'DateMax';

	--============================================

	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[DateAfter] = [SourceTable].[OrderDateMin],
		[ValueAfter] = [SourceTable].[OrderDateKeyMin]
	FROM
		[dbo].[FactInternetSales] INNER JOIN (SELECT MIN([OrderDate]) AS OrderDateMin, MIN([OrderDateKey]) AS OrderDateKeyMin FROM [dbo].[FactInternetSales]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'FactInternetSales' AND [dbo].[TempCheckTable].[ColName]  = 'OrderDateMin';

	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[DateAfter] = [SourceTable].[OrderDateMax],
		[ValueAfter] = [SourceTable].[OrderDateKeyMax]
	FROM
		[dbo].[FactInternetSales] INNER JOIN (SELECT MAX([OrderDate]) AS OrderDateMax, MAX([OrderDateKey]) AS OrderDateKeyMax FROM [dbo].[FactInternetSales]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'FactInternetSales' AND [dbo].[TempCheckTable].[ColName]  = 'OrderDateMax';

	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[DateAfter] = [SourceTable].[DueDateMin],
		[ValueAfter] = [SourceTable].[DueDateKeyMin]
	FROM
		[dbo].[FactInternetSales] INNER JOIN (SELECT MIN([DueDate]) AS DueDateMin, MIN([DueDateKey]) AS DueDateKeyMin FROM [dbo].[FactInternetSales]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'FactInternetSales' AND [dbo].[TempCheckTable].[ColName]  = 'DueDateMin';

	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[DateAfter] = [SourceTable].[DueDateMax],
		[ValueAfter] = [SourceTable].[DueDateKeyMax]
	FROM
		[dbo].[FactInternetSales] INNER JOIN (SELECT MAX([DueDate]) AS DueDateMax, MAX([DueDateKey]) AS DueDateKeyMax FROM [dbo].[FactInternetSales]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'FactInternetSales' AND [dbo].[TempCheckTable].[ColName]  = 'DueDateMax';


	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[DateAfter] = [SourceTable].[ShipDateMin],
		[ValueAfter] = [SourceTable].[ShipDateKeyMin]
	FROM
		[dbo].[FactInternetSales] INNER JOIN (SELECT MIN([ShipDate]) AS ShipDateMin, MIN([ShipDateKey]) AS ShipDateKeyMin FROM [dbo].[FactInternetSales]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'FactInternetSales' AND [dbo].[TempCheckTable].[ColName]  = 'ShipDateMin';

	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[DateAfter] = [SourceTable].[ShipDateMax],
		[ValueAfter] = [SourceTable].[ShipDateKeyMax]
	FROM
		[dbo].[FactInternetSales] INNER JOIN (SELECT MAX([ShipDate]) AS ShipDateMax, MAX([ShipDateKey]) AS ShipDateKeyMax FROM [dbo].[FactInternetSales]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'FactInternetSales' AND [dbo].[TempCheckTable].[ColName]  = 'ShipDateMax';

	-- =================================================
	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[DateAfter] = [SourceTable].[MovementDateMin],
		[ValueAfter] = [SourceTable].[DateKeyMin]
	FROM
		[dbo].[FactProductInventory] INNER JOIN (SELECT MIN([MovementDate]) AS MovementDateMin, MIN([DateKey]) AS DateKeyMin FROM [dbo].[FactProductInventory]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'FactProductInventory' AND [dbo].[TempCheckTable].[ColName]  = 'MovementDateMin';

	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[DateAfter] = [SourceTable].[MovementDateMax],
		[ValueAfter] = [SourceTable].[DateKeyMax]
	FROM
		[dbo].[FactProductInventory] INNER JOIN (SELECT MAX([MovementDate]) AS MovementDateMax, MAX([DateKey]) AS DateKeyMax FROM [dbo].[FactProductInventory]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'FactProductInventory' AND [dbo].[TempCheckTable].[ColName]  = 'MovementDateMax';

	--============================================

	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[DateAfter] = [SourceTable].[OrderDateMin],
		[ValueAfter] = [SourceTable].[OrderDateKeyMin]
	FROM
		[dbo].[FactResellerSales] INNER JOIN (SELECT MIN([OrderDate]) AS OrderDateMin, MIN([OrderDateKey]) AS OrderDateKeyMin FROM [dbo].[FactResellerSales]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'FactResellerSales' AND [dbo].[TempCheckTable].[ColName]  = 'OrderDateMin';

	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[DateAfter] = [SourceTable].[OrderDateMax],
		[ValueAfter] = [SourceTable].[OrderDateKeyMax]
	FROM
		[dbo].[FactResellerSales] INNER JOIN (SELECT MAX([OrderDate]) AS OrderDateMax, MAX([OrderDateKey]) AS OrderDateKeyMax FROM [dbo].[FactResellerSales]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'FactResellerSales' AND [dbo].[TempCheckTable].[ColName]  = 'OrderDateMax';

	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[DateAfter] = [SourceTable].[DueDateMin],
		[ValueAfter] = [SourceTable].[DueDateKeyMin]
	FROM
		[dbo].[FactResellerSales] INNER JOIN (SELECT MIN([DueDate]) AS DueDateMin, MIN([DueDateKey]) AS DueDateKeyMin FROM [dbo].[FactResellerSales]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'FactResellerSales' AND [dbo].[TempCheckTable].[ColName]  = 'DueDateMin';

	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[DateAfter] = [SourceTable].[DueDateMax],
		[ValueAfter] = [SourceTable].[DueDateKeyMax]
	FROM
		[dbo].[FactResellerSales] INNER JOIN (SELECT MAX([DueDate]) AS DueDateMax, MAX([DueDateKey]) AS DueDateKeyMax FROM [dbo].[FactResellerSales]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'FactResellerSales' AND [dbo].[TempCheckTable].[ColName]  = 'DueDateMax';

	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[DateAfter] = [SourceTable].[ShipDateMin],
		[ValueAfter] = [SourceTable].[ShipDateKeyMin]
	FROM
		[dbo].[FactResellerSales] INNER JOIN (SELECT MIN([ShipDate]) AS ShipDateMin, MIN([ShipDateKey]) AS ShipDateKeyMin FROM [dbo].[FactResellerSales]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'FactResellerSales' AND [dbo].[TempCheckTable].[ColName]  = 'ShipDateMin';

	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[DateAfter] = [SourceTable].[ShipDateMax],
		[ValueAfter] = [SourceTable].[ShipDateKeyMax]
	FROM
		[dbo].[FactResellerSales] INNER JOIN (SELECT MAX([ShipDate]) AS ShipDateMax, MAX([ShipDateKey]) AS ShipDateKeyMax FROM [dbo].[FactResellerSales]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'FactResellerSales' AND [dbo].[TempCheckTable].[ColName]  = 'ShipDateMax';

	--=================================
	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[DateAfter] = [SourceTable].[DateMin],
		[ValueAfter] = [SourceTable].[DateKeyMin]
	FROM
		[dbo].[FactSalesQuota] INNER JOIN (SELECT MIN([Date]) AS DateMin, MIN([DateKey]) AS DateKeyMin FROM [dbo].[FactSalesQuota]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'FactSalesQuota' AND [dbo].[TempCheckTable].[ColName]  = 'DateMin';

	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[DateAfter] = [SourceTable].[DateMax],
		[ValueAfter] = [SourceTable].[DateKeyMax]
	FROM
		[dbo].[FactSalesQuota] INNER JOIN (SELECT MAX([Date]) AS DateMax, MAX([DateKey]) AS DateKeyMax FROM [dbo].[FactSalesQuota]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'FactSalesQuota' AND [dbo].[TempCheckTable].[ColName]  = 'DateMax';

	--=================================
	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[DateAfter] = [SourceTable].[DateMin],
		[ValueAfter] = [SourceTable].[DateKeyMin]
	FROM
		[dbo].[FactSurveyResponse] INNER JOIN (SELECT MIN([Date]) AS DateMin, MIN([DateKey]) AS DateKeyMin FROM [dbo].[FactSurveyResponse]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'FactSurveyResponse' AND [dbo].[TempCheckTable].[ColName]  = 'DateMin';

	UPDATE 
		[dbo].[TempCheckTable]
	SET 
		[DateAfter] = [SourceTable].[DateMax],
		[ValueAfter] = [SourceTable].[DateKeyMax]
	FROM
		[dbo].[FactSurveyResponse] INNER JOIN (SELECT MAX([Date]) AS DateMax, MAX([DateKey]) AS DateKeyMax FROM [dbo].[FactSurveyResponse]) AS [SourceTable] ON 1=1
	WHERE
		[dbo].[TempCheckTable].[TableName] = 'FactSurveyResponse' AND [dbo].[TempCheckTable].[ColName]  = 'DateMax';

-- FINAL CHECK OF THE CHANGES
	SELECT * FROM [dbo].[TempCheckTable];
END
GO