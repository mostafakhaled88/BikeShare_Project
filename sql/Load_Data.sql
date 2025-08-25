-- =============================================
-- Page 2: Load CSV into Staging & Insert into Final Tables
-- Description:
--   Loads Year 0, Year 1, and Cost CSVs into staging,
--   converts data to proper types, inserts into final tables,
--   prints row counts, tracks start/end time and duration.
-- =============================================

IF OBJECT_ID('dbo.Load_BikeShare_Data', 'P') IS NOT NULL
    DROP PROCEDURE dbo.Load_BikeShare_Data;
GO

CREATE PROCEDURE dbo.Load_BikeShare_Data
AS
BEGIN
    SET NOCOUNT ON;

    -- -------------------------------------
    -- 1. Track start time
    -- -------------------------------------
    DECLARE @StartTime DATETIME = GETDATE();
    PRINT 'Load started at: ' + CONVERT(NVARCHAR, @StartTime, 120);

    -- -------------------------------------
    -- 2. Cleanup / auto-create staging tables
    -- -------------------------------------
    PRINT 'Preparing staging tables...';

    -- Year 0
    IF OBJECT_ID('staging.bike_share_yr_0', 'U') IS NOT NULL
        TRUNCATE TABLE staging.bike_share_yr_0;

    -- Year 1
    IF OBJECT_ID('staging.bike_share_yr_1', 'U') IS NOT NULL
        TRUNCATE TABLE staging.bike_share_yr_1;

    -- Cost table
    IF OBJECT_ID('staging.bike_cost', 'U') IS NULL
    BEGIN
        CREATE TABLE staging.bike_cost (
            yr    NVARCHAR(10),
            price NVARCHAR(20),
            COGS  NVARCHAR(20)
        );
    END
    ELSE
    BEGIN
        TRUNCATE TABLE staging.bike_cost;
    END

    -- =============================================
    -- 3. Load Year 0 CSV into staging & insert final
    -- =============================================
    PRINT 'Loading Year 0 CSV into staging...';

    BULK INSERT staging.bike_share_yr_0
    FROM 'C:\bike\Dataset\YT_bike_share-main\bike_share_yr_0.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        CODEPAGE = '65001',
        TABLOCK
    );

    DECLARE @Rows_yr0 INT = (SELECT COUNT(*) FROM staging.bike_share_yr_0);
    PRINT 'Rows uploaded to staging.bike_share_yr_0: ' + CONVERT(NVARCHAR, @Rows_yr0);

    INSERT INTO dbo.bike_share_yr_0 (
        dteday, season, yr, mnth, hr, holiday, weekday, workingday, 
        weathersit, temp, atemp, hum, windspeed, rider_type, riders
    )
    SELECT
        TRY_CAST(dteday AS DATE),
        TRY_CAST(season AS INT),
        TRY_CAST(yr AS INT),
        TRY_CAST(mnth AS INT),
        TRY_CAST(hr AS INT),
        TRY_CAST(holiday AS INT),
        TRY_CAST(weekday AS INT),
        TRY_CAST(workingday AS INT),
        TRY_CAST(weathersit AS INT),
        TRY_CAST(temp AS FLOAT),
        TRY_CAST(atemp AS FLOAT),
        TRY_CAST(hum AS FLOAT),
        TRY_CAST(windspeed AS FLOAT),
        rider_type,
        TRY_CAST(riders AS INT)
    FROM staging.bike_share_yr_0;

    -- =============================================
    -- 4. Load Year 1 CSV into staging & insert final
    -- =============================================
    PRINT 'Loading Year 1 CSV into staging...';

    BULK INSERT staging.bike_share_yr_1
    FROM 'C:\bike\Dataset\YT_bike_share-main\bike_share_yr_1.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        CODEPAGE = '65001',
        TABLOCK
    );

    DECLARE @Rows_yr1 INT = (SELECT COUNT(*) FROM staging.bike_share_yr_1);
    PRINT 'Rows uploaded to staging.bike_share_yr_1: ' + CONVERT(NVARCHAR, @Rows_yr1);

    INSERT INTO dbo.bike_share_yr_1 (
        dteday, season, yr, mnth, hr, holiday, weekday, workingday, 
        weathersit, temp, atemp, hum, windspeed, rider_type, riders
    )
    SELECT
        TRY_CAST(dteday AS DATE),
        TRY_CAST(season AS INT),
        TRY_CAST(yr AS INT),
        TRY_CAST(mnth AS INT),
        TRY_CAST(hr AS INT),
        TRY_CAST(holiday AS INT),
        TRY_CAST(weekday AS INT),
        TRY_CAST(workingday AS INT),
        TRY_CAST(weathersit AS INT),
        TRY_CAST(temp AS FLOAT),
        TRY_CAST(atemp AS FLOAT),
        TRY_CAST(hum AS FLOAT),
        TRY_CAST(windspeed AS FLOAT),
        rider_type,
        TRY_CAST(riders AS INT)
    FROM staging.bike_share_yr_1;

    -- =============================================
    -- 5. Load Bike Share Cost CSV into staging & insert final
    -- =============================================
    PRINT 'Loading Bike Share Cost CSV into staging...';

    BULK INSERT staging.bike_cost
    FROM 'C:\bike\Dataset\YT_bike_share-main\cost_table.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        CODEPAGE = '65001',
        TABLOCK
    );

    DECLARE @Rows_cost INT = (SELECT COUNT(*) FROM staging.bike_cost);
    PRINT 'Rows uploaded to staging.bike_cost: ' + CONVERT(NVARCHAR, @Rows_cost);

    INSERT INTO dbo.bike_share_cost (yr, price, COGS)
    SELECT
        TRY_CAST(yr AS INT),
        TRY_CAST(price AS FLOAT),
        TRY_CAST(COGS AS FLOAT)
    FROM staging.bike_cost;

    -- -------------------------------------
    -- 6. Track end time & duration
    -- -------------------------------------
    DECLARE @EndTime DATETIME = GETDATE();
    DECLARE @DurationSeconds INT = DATEDIFF(SECOND, @StartTime, @EndTime);

    PRINT 'Load finished at: ' + CONVERT(NVARCHAR, @EndTime, 120);
    PRINT 'Total execution time (seconds): ' + CONVERT(NVARCHAR, @DurationSeconds);

END
GO
