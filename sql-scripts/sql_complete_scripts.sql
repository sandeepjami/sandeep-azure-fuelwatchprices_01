USE [DataMart]
GO


---------------------------------Scripts for Creating Contained Users for Database--------------
CREATE USER tpuser
WITH PASSWORD='xxxxx'
GO
EXEC sp_addrolemember N'db_owner', N'tpuser'
GO


---------------------------------Scripts for Creating Schema------------------------------------
/****** Object:  Schema [Dim]    Script Date: 30/08/2022 8:16:22 PM ******/
CREATE SCHEMA [dw]
GO
/****** Object:  Schema [tempstage]    Script Date: 30/08/2022 8:16:22 PM ******/
CREATE SCHEMA [tempstage]
GO
---------------------------------Scripts for Creating SQL Tables--------------------------------
/****** Object:  Table [dw].[Dim_Brand]    Script Date: 30/08/2022 8:16:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dw].[Dim_Brand](
	[BrandID] [int] IDENTITY(1,1) NOT NULL,
	[BrandName] [nvarchar](500) NOT NULL,
	[AddedOn] [datetime2](3) NOT NULL,
 CONSTRAINT [IDX_dw.Dim_Brand_BrandID] PRIMARY KEY CLUSTERED 
(
	[BrandID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dw].[Dim_Site]    Script Date: 30/08/2022 8:16:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dw].[Dim_Site](
	[SiteID] [int] IDENTITY(1,1) NOT NULL,
	[TradingName] [nvarchar](500) NULL,
	[Location] [nvarchar](500) NULL,
	[Address] [nvarchar](max) NULL,
	[Phone] [nvarchar](500) NULL,
	[Latitude] [decimal](12, 9) NULL,
	[Longitude] [decimal](12, 9) NULL,
	[AddedOn] [datetime2](3) NOT NULL,
	[FullAddress]  AS (([Address]+', ')+[Location]) PERSISTED,
 CONSTRAINT [IDX_dw.Dim_Site_SiteID] PRIMARY KEY CLUSTERED 
(
	[SiteID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dw].[Dim_SiteFeatures]    Script Date: 30/08/2022 8:16:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dw].[Dim_SiteFeatures](
	[SiteFeatureID] [int] IDENTITY(1,1) NOT NULL,
	[SiteFeatures] [nvarchar](500) NULL,
	[SiteID] [int] NULL,
	[AddedOn] [datetime] NULL,
 CONSTRAINT [IDX_dw.Dim_SiteFeatures_SiteFeaturesID] PRIMARY KEY CLUSTERED 
(
	[SiteFeatureID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dw].[Fact_FuelPrice]    Script Date: 30/08/2022 8:16:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dw].[Fact_FuelPrice](
	[FuelPriceID] [int] IDENTITY(1,1) NOT NULL,
	[BrandID] [int] NULL,
	[SiteID] [int] NULL,
	[Price] [decimal](19, 4) NULL,
	[DateCreated] [int] NULL,
	[DateModifed] [int] NULL,
 CONSTRAINT [IDX_dw_Fact_FuelPrice_FuelPriceID] PRIMARY KEY CLUSTERED 
(
	[FuelPriceID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [tempstage].[FuelPrices]    Script Date: 30/08/2022 8:16:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [tempstage].[FuelPrices](
	[brand] [nvarchar](500) NULL,
	[date] [date] NULL,
	[price] [decimal](19, 4) NULL,
	[tradingname] [nvarchar](max) NULL,
	[location] [nvarchar](max) NULL,
	[address] [nvarchar](max) NULL,
	[phone] [nvarchar](100) NULL,
	[latitude] [decimal](12, 9) NULL,
	[longitude] [decimal](12, 9) NULL,
	[sitefeatures] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dw].[Dim_Brand] ADD  DEFAULT (getdate()) FOR [AddedOn]
GO
ALTER TABLE [dw].[Dim_Site] ADD  DEFAULT (getdate()) FOR [AddedOn]
GO
ALTER TABLE [dw].[Dim_SiteFeatures] ADD  DEFAULT (getdate()) FOR [AddedOn]
GO
ALTER TABLE [dw].[Dim_SiteFeatures]  WITH CHECK ADD  CONSTRAINT [IDX_dw.Dim_SiteFeatures_SiteID] FOREIGN KEY([SiteID])
REFERENCES [dw].[Dim_Site] ([SiteID])
GO
ALTER TABLE [dw].[Dim_SiteFeatures] CHECK CONSTRAINT [IDX_dw.Dim_SiteFeatures_SiteID]
GO
ALTER TABLE [dw].[Fact_FuelPrice]  WITH CHECK ADD  CONSTRAINT [IDX_dw.Fact_FuelPrice_BrandID] FOREIGN KEY([BrandID])
REFERENCES [dw].[Dim_Brand] ([BrandID])
GO
ALTER TABLE [dw].[Fact_FuelPrice] CHECK CONSTRAINT [IDX_dw.Fact_FuelPrice_BrandID]
GO
ALTER TABLE [dw].[Fact_FuelPrice]  WITH CHECK ADD  CONSTRAINT [IDX_dw.Fact_FuelPrice_SiteID] FOREIGN KEY([SiteID])
REFERENCES [dw].[Dim_Site] ([SiteID])
GO
ALTER TABLE [dw].[Fact_FuelPrice] CHECK CONSTRAINT [IDX_dw.Fact_FuelPrice_SiteID]
GO

/****** Object:  NONCLUSTERED  INDEX     Script Date: 30/08/2022 8:16:22 PM ******/

CREATE NONCLUSTERED  INDEX [IDX_dw.Fact_FuelPrice_BrandID]
ON [dw].[Fact_FuelPrice]([BrandID] ASC)
GO

CREATE NONCLUSTERED  INDEX [IDX_dw.Fact_FuelPrice_SiteID]
ON [dw].[Fact_FuelPrice]([SiteID] ASC)
GO

CREATE NONCLUSTERED  INDEX [IDX_dw.Dim_SiteFeatures_SiteID]
ON [dw].[Dim_SiteFeatures]([SiteID] ASC)
GO

------------------Date DIM Table----------------------------------------------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE	[dw].[Dim_Date]
	(	[DateKey] INT primary key, 
		[Date] DATETIME,
		[FullDate] CHAR(10),-- Date in MM-dd-yyyy format
		[DayOfMonth] VARCHAR(2), -- Field will hold day number of Month
		[DayName] VARCHAR(9), -- Contains name of the day, Sunday, Monday 
		[DayOfWeek] CHAR(1),-- First Day Sunday=1 and Saturday=7
		[DayOfWeekInMonth] VARCHAR(2), --1st Monday or 2nd Monday in Month
		[DayOfWeekInYear] VARCHAR(2),
		[DayOfQuarter] VARCHAR(3),
		[DayOfYear] VARCHAR(3),
		[WeekOfMonth] VARCHAR(1),-- Week Number of Month 
		[WeekOfQuarter] VARCHAR(2), --Week Number of the Quarter
		[WeekOfYear] VARCHAR(2),--Week Number of the Year
		[Month] VARCHAR(2), --Number of the Month 1 to 12
		[MonthName] VARCHAR(9),--January, February etc
		[MonthOfQuarter] VARCHAR(2),-- Month Number belongs to Quarter
		[Quarter] CHAR(1),
		[QuarterName] VARCHAR(9),--First,Second..
		[Year] CHAR(4),-- Year value of Date stored in Row
		[YearName] CHAR(7), --CY 2012,CY 2013
		[MonthYear] CHAR(10), --Jan-2013,Feb-2013
		[MMYYYY] CHAR(6),
		[FirstDayOfMonth] DATE,
		[LastDayOfMonth] DATE,
		[FirstDayOfQuarter] DATE,
		[LastDayOfQuarter] DATE,
		[FirstDayOfYear] DATE,
		[LastDayOfYear] DATE
	)
GO
/********************************************************************************************/
--Specify Start Date and End date here
--Value of Start Date Must be Less than Your End Date 

DECLARE @StartDate DATETIME = '01/01/2022' --Starting value of Date Range
DECLARE @EndDate DATETIME = '01/01/2024' --End Value of Date Range

--Temporary Variables To Hold the Values During Processing of Each Date of Year
DECLARE
	@DayOfWeekInMonth INT,
	@DayOfWeekInYear INT,
	@DayOfQuarter INT,
	@WeekOfMonth INT,
	@CurrentYear INT,
	@CurrentMonth INT,
	@CurrentQuarter INT

/*Table Data type to store the day of week count for the month and year*/
DECLARE @DayOfWeek TABLE (DOW INT, MonthCount INT, QuarterCount INT, YearCount INT)

INSERT INTO @DayOfWeek VALUES (1, 0, 0, 0)
INSERT INTO @DayOfWeek VALUES (2, 0, 0, 0)
INSERT INTO @DayOfWeek VALUES (3, 0, 0, 0)
INSERT INTO @DayOfWeek VALUES (4, 0, 0, 0)
INSERT INTO @DayOfWeek VALUES (5, 0, 0, 0)
INSERT INTO @DayOfWeek VALUES (6, 0, 0, 0)
INSERT INTO @DayOfWeek VALUES (7, 0, 0, 0)

--Extract and assign various parts of Values from Current Date to Variable

DECLARE @CurrentDate AS DATETIME = @StartDate
SET @CurrentMonth = DATEPART(MM, @CurrentDate)
SET @CurrentYear = DATEPART(YY, @CurrentDate)
SET @CurrentQuarter = DATEPART(QQ, @CurrentDate)

/********************************************************************************************/
--Proceed only if Start Date(Current date ) is less than End date you specified above

WHILE @CurrentDate < @EndDate
BEGIN
 
/*Begin day of week logic*/

         /*Check for Change in Month of the Current date if Month changed then 
          Change variable value*/
	IF @CurrentMonth != DATEPART(MM, @CurrentDate) 
	BEGIN
		UPDATE @DayOfWeek
		SET MonthCount = 0
		SET @CurrentMonth = DATEPART(MM, @CurrentDate)
	END

        /* Check for Change in Quarter of the Current date if Quarter changed then change 
         Variable value*/

	IF @CurrentQuarter != DATEPART(QQ, @CurrentDate)
	BEGIN
		UPDATE @DayOfWeek
		SET QuarterCount = 0
		SET @CurrentQuarter = DATEPART(QQ, @CurrentDate)
	END
       
        /* Check for Change in Year of the Current date if Year changed then change 
         Variable value*/
	

	IF @CurrentYear != DATEPART(YY, @CurrentDate)
	BEGIN
		UPDATE @DayOfWeek
		SET YearCount = 0
		SET @CurrentYear = DATEPART(YY, @CurrentDate)
	END
	
        -- Set values in table data type created above from variables 

	UPDATE @DayOfWeek
	SET 
		MonthCount = MonthCount + 1,
		QuarterCount = QuarterCount + 1,
		YearCount = YearCount + 1
	WHERE DOW = DATEPART(DW, @CurrentDate)

	SELECT
		@DayOfWeekInMonth = MonthCount,
		@DayOfQuarter = QuarterCount,
		@DayOfWeekInYear = YearCount
	FROM @DayOfWeek
	WHERE DOW = DATEPART(DW, @CurrentDate)
	
/*End day of week logic*/


/* Populate Your Dimension Table with values*/
	
	INSERT INTO [dw].[Dim_Date]
	SELECT
		
		CONVERT (char(8),@CurrentDate,112) as DateKey,
		@CurrentDate AS Date,
		CONVERT (char(10),@CurrentDate,101) as FullDate,
		DATEPART(DD, @CurrentDate) AS DayOfMonth,
		DATENAME(DW, @CurrentDate) AS DayName,
		DATEPART(DW, @CurrentDate) AS DayOfWeek,
		@DayOfWeekInMonth AS DayOfWeekInMonth,
		@DayOfWeekInYear AS DayOfWeekInYear,
		@DayOfQuarter AS DayOfQuarter,
		DATEPART(DY, @CurrentDate) AS DayOfYear,
		DATEPART(WW, @CurrentDate) + 1 - DATEPART(WW, CONVERT(VARCHAR, 
		DATEPART(MM, @CurrentDate)) + '/1/' + CONVERT(VARCHAR,
		DATEPART(YY, @CurrentDate))) AS WeekOfMonth,
		(DATEDIFF(DD, DATEADD(QQ, DATEDIFF(QQ, 0, @CurrentDate), 0), 
		@CurrentDate) / 7) + 1 AS WeekOfQuarter,
		DATEPART(WW, @CurrentDate) AS WeekOfYear,
		DATEPART(MM, @CurrentDate) AS Month,
		DATENAME(MM, @CurrentDate) AS MonthName,
		CASE
			WHEN DATEPART(MM, @CurrentDate) IN (1, 4, 7, 10) THEN 1
			WHEN DATEPART(MM, @CurrentDate) IN (2, 5, 8, 11) THEN 2
			WHEN DATEPART(MM, @CurrentDate) IN (3, 6, 9, 12) THEN 3
			END AS MonthOfQuarter,
		DATEPART(QQ, @CurrentDate) AS Quarter,
		CASE DATEPART(QQ, @CurrentDate)
			WHEN 1 THEN 'First'
			WHEN 2 THEN 'Second'
			WHEN 3 THEN 'Third'
			WHEN 4 THEN 'Fourth'
			END AS QuarterName,
		DATEPART(YEAR, @CurrentDate) AS Year,
		'CY ' + CONVERT(VARCHAR, DATEPART(YEAR, @CurrentDate)) AS YearName,
		LEFT(DATENAME(MM, @CurrentDate), 3) + '-' + CONVERT(VARCHAR, 
		DATEPART(YY, @CurrentDate)) AS MonthYear,
		RIGHT('0' + CONVERT(VARCHAR, DATEPART(MM, @CurrentDate)),2) + 
		CONVERT(VARCHAR, DATEPART(YY, @CurrentDate)) AS MMYYYY,
		CONVERT(DATETIME, CONVERT(DATE, DATEADD(DD, - (DATEPART(DD, 
		@CurrentDate) - 1), @CurrentDate))) AS FirstDayOfMonth,
		CONVERT(DATETIME, CONVERT(DATE, DATEADD(DD, - (DATEPART(DD,
		(DATEADD(MM, 1, @CurrentDate)))), DATEADD(MM, 1,
		@CurrentDate)))) AS LastDayOfMonth,
		DATEADD(QQ, DATEDIFF(QQ, 0, @CurrentDate), 0) AS FirstDayOfQuarter,
		DATEADD(QQ, DATEDIFF(QQ, -1, @CurrentDate), -1) AS LastDayOfQuarter,
		CONVERT(DATETIME, '01/01/' + CONVERT(VARCHAR, DATEPART(YY, 
		@CurrentDate))) AS FirstDayOfYear,
		CONVERT(DATETIME, '12/31/' + CONVERT(VARCHAR, DATEPART(YY, 
		@CurrentDate))) AS LastDayOfYear

	SET @CurrentDate = DATEADD(DD, 1, @CurrentDate)
END
---------------------------------Scripts for Creating Store Procedures------------------------------------
/****** Object:  StoredProcedure [tempstage].[STP_LoadBrand]    Script Date: 30/08/2022 8:16:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dw].[STP_Dim_Brand]
AS

SET NOCOUNT ON;

MERGE [dw].[Dim_Brand] TARGET
    USING (SELECT DISTINCT([brand]) AS Brand FROM [tempstage].[FuelPrices]) AS  SOURCE
ON (SOURCE.[Brand] = TARGET.[BrandName])


WHEN NOT MATCHED BY TARGET 
    THEN INSERT (BrandName)

	VALUES 
	(SOURCE.Brand);
		
SET NOCOUNT OFF;

GO
/****** Object:  StoredProcedure [tempstage].[STP_LoadFactPrices]    Script Date: 30/08/2022 8:16:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dw].[STP_Fact_FactPrices]
AS

SET NOCOUNT ON;

MERGE [dw].[Fact_FuelPrice] TARGET
    USING (
	SELECT dimbrand.BrandID AS BrandID, dimsite.SiteID AS SiteID, tempprices.price AS Price, cast(format(tempprices.date,'yyyyMMdd') as int) AS DateCreated  FROM [tempstage].[FuelPrices] tempprices
	JOIN [dw].[Dim_Site] dimsite ON tempprices.[tradingname] = dimsite.[TradingName] AND tempprices.[location]= dimsite.[Location] AND tempprices.[address]= dimsite.[address]
	JOIN [dw].[Dim_Brand] dimbrand ON tempprices.[brand] = dimbrand.[BrandName]
	) AS  SOURCE
ON (SOURCE.SiteID =TARGET.[SiteID] AND SOURCE.BrandID =TARGET.[BrandID] AND SOURCE.[DateCreated] =TARGET.[DateCreated]  )

WHEN MATCHED
    THEN UPDATE SET 

	TARGET.[Price]=SOURCE.[Price], TARGET.[DateModifed] = CAST(FORMAT(getdate(),'yyyyMMdd') as int)

WHEN NOT MATCHED BY TARGET 
    THEN INSERT ([BrandID],[SiteID],[Price],[DateCreated])

	VALUES 
	(SOURCE.[BrandID],SOURCE.[SiteID],SOURCE.[Price],SOURCE.[DateCreated]);

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [tempstage].[STP_LoadSite]    Script Date: 30/08/2022 8:16:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dw].[STP_Dim_Site]
AS

SET NOCOUNT ON;

MERGE [dw].[Dim_Site] TARGET
    USING (SELECT DISTINCT tradingname AS TradingName ,location AS Location ,address AS Address,phone AS Phone ,latitude AS Latitude ,longitude AS Longitude   FROM [tempstage].[FuelPrices]) AS  SOURCE
ON (SOURCE.TradingName = Target.TradingName AND SOURCE.Location = Target.Location AND SOURCE.Address = Target.Address   )

WHEN MATCHED
    THEN UPDATE SET 
	TARGET.Phone = SOURCE.Phone, TARGET.Latitude = SOURCE.Latitude, TARGET.Longitude = SOURCE.Longitude

WHEN NOT MATCHED BY TARGET 
    THEN INSERT (TradingName,Location,Address,Phone,Latitude,Longitude)
	VALUES 
	(SOURCE.TradingName,SOURCE.Location,SOURCE.Address,SOURCE.Phone,SOURCE.Latitude,SOURCE.Longitude);
	
SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [tempstage].[STP_SiteFeatures]    Script Date: 30/08/2022 8:16:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dw].[STP_Dim_SiteFeatures]
AS

SET NOCOUNT ON;

MERGE [dw].[Dim_SiteFeatures] TARGET
    USING (SELECT dimsite.SiteID AS SiteID, tempprices.sitefeatures AS SiteFeatures  FROM [tempstage].[FuelPrices] tempprices JOIN [dw].[Dim_Site] dimsite ON tempprices.[tradingname] = dimsite.[TradingName] AND tempprices.[location]= dimsite.[Location] AND tempprices.[address]= dimsite.[address]) AS  SOURCE
ON (SOURCE.SiteID =TARGET.SiteID )

WHEN MATCHED
    THEN UPDATE SET 
	TARGET.SiteFeatures = SOURCE.SiteFeatures

WHEN NOT MATCHED BY TARGET 
    THEN INSERT (SiteFeatures,SiteID)

	VALUES 
	(SOURCE.SiteFeatures,SOURCE.SiteID);

SET NOCOUNT OFF;
GO

