/*
====================================================================================
Stored Procedure: silver.load_bike_share
Purpose:          ETL process to load the Silver Layer table [silver.bike_share]
                  with cleansed data and calculated metrics (Revenue & Profit).

Process:
    1. Combine yearly bike share data from Bronze layer (yr_0 + yr_1).
    2. Join with Bronze cost table for pricing and COGS (Cost of Goods Sold).
    3. Calculate derived metrics:
        - revenue = riders * price
        - profit  = revenue - (riders * cogs)
    4. Load into Silver layer for reporting and further transformations.

Author:           Mostafa Khaled Farag
Date:             2025-08-26
====================================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_bike_share 
AS
BEGIN
    BEGIN TRY
        -- Logging start of load
        PRINT '==============================';
        PRINT 'Loading Silver Layer: bike_share with Revenue & Profit';
        PRINT '==============================';

        -- Step 1: Clear out Silver table before re-load (idempotent load)
        TRUNCATE TABLE silver.bike_share;

        -- Step 2: Union Bronze yearly data
        ;WITH cte AS (
            SELECT * FROM bronze.bike_share_yr_0
            UNION ALL
            SELECT * FROM bronze.bike_share_yr_1
        )
        -- Step 3: Insert transformed data into Silver
        INSERT INTO silver.bike_share (
            dteday, season, yr, weekday, hr, rider_type, riders, price, cogs, revenue, profit
        )
        SELECT 
            TRY_CAST(a.dteday AS DATE) AS dteday,    -- Ensure valid date conversion
            a.season,
            a.yr,
            a.weekday,
            a.hr,
            a.rider_type,
            a.riders,
            b.price,
            b.cogs,
            a.riders * b.price AS revenue,           -- Derived revenue
            (a.riders * b.price) - (a.riders * b.cogs) AS profit -- Derived profit
        FROM cte a
        LEFT JOIN bronze.cost_table b
            ON a.yr = b.yr;

        -- Logging success
        PRINT '==============================';
        PRINT 'Silver.bike_share loaded successfully';
        PRINT '==============================';

    END TRY
    BEGIN CATCH
        -- Logging failure + error message
        PRINT '==============================';
        PRINT 'Error Loading Silver.bike_share';
        PRINT ERROR_MESSAGE();
        PRINT '==============================';
    END CATCH
END;
GO

-- ==================================================================================
-- Notes:
-- - TRY_CAST is used for safe date conversion (invalid dates become NULL).
-- - TRUNCATE ensures full reload; suitable for batch ETL pipelines.
-- - UNION ALL is used instead of UNION for performance (no deduplication needed).
-- - Profit calculation fixed to subtract *total COGS* (riders * cogs).
-- - Future enhancement: parameterize year or source to make incremental loads.
-- ==================================================================================
