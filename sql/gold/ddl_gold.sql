/*
===============================================================================
 Project: Bike Share Analytics - Gold Layer Views
 Author : Mostafa Khaled Farag
 Date   : 2025-08-27
 Purpose: Defines the Gold schema analytical layer using views.
          - Fact View: Exposes cleaned, query-ready fact data.
          - Dimension Views: Provides lookup dimensions.
          - Analytical Views: Provides aggregated business insights.
 Notes:
          - This is the Gold layer in the ETL pipeline: Bronze -> Silver -> Gold.
          - Handles missing dates by reconstructing them from year, season, and weekday.
===============================================================================
*/

/*-----------------------------------------------------------------------------
 Fact View
-----------------------------------------------------------------------------*/
-- The fact view exposes cleaned, ready-to-query ride data.
CREATE OR ALTER VIEW gold.fact_rides AS
WITH base_data AS (
    SELECT *,
        -- Fix missing dteday values using yr and season
        COALESCE(dteday, DATEFROMPARTS(
            CASE yr WHEN 0 THEN 2021 WHEN 1 THEN 2022 END,
            CASE season
                WHEN 1 THEN 3   -- Spring
                WHEN 2 THEN 6   -- Summer
                WHEN 3 THEN 9   -- Fall
                WHEN 4 THEN 12  -- Winter
                ELSE 1          -- Default month
            END,
        1)) AS fixed_dteday
    FROM silver.bike_share
)
SELECT
    b.fixed_dteday AS dteday,
    b.season,
    b.yr,
    b.weekday,
    b.hr,
    b.rider_type,
    b.riders,
    b.price,
    b.cogs,
    b.revenue,
    b.profit
FROM base_data b
LEFT JOIN gold.dim_rider_type d
    ON b.rider_type = d.rider_type;
GO


/*-----------------------------------------------------------------------------
 Dimension Views
-----------------------------------------------------------------------------*/
-- Date dimension: provides calendar, season, month, weekday info for analytics
CREATE OR ALTER VIEW gold.dim_date AS
WITH base_data AS (
    SELECT *,
        COALESCE(dteday, DATEFROMPARTS(
            CASE yr WHEN 0 THEN 2021 WHEN 1 THEN 2022 END,
            CASE season
                WHEN 1 THEN 3
                WHEN 2 THEN 6
                WHEN 3 THEN 9
                WHEN 4 THEN 12
                ELSE 1
            END,
        1)) AS fixed_dteday
    FROM silver.bike_share
)
SELECT DISTINCT
    fixed_dteday AS dteday,
    CAST(yr AS INT) + 2021 AS calendar_year,
    season,
    CASE season 
        WHEN 1 THEN 'Winter'
        WHEN 2 THEN 'Spring'
        WHEN 3 THEN 'Summer'
        WHEN 4 THEN 'Fall'
    END AS season_name,
    DATENAME(MONTH, fixed_dteday) AS month_name,
    MONTH(fixed_dteday) AS month_number,
    DATEPART(QUARTER, fixed_dteday) AS quarter,
    weekday AS weekday_number,
    DATENAME(WEEKDAY, fixed_dteday) AS weekday_name,
    CASE WHEN weekday IN (0,6) THEN 1 ELSE 0 END AS is_weekend,
    DATEPART(WEEK, fixed_dteday) AS week_of_year
FROM base_data;
GO

-- Rider type dimension with numeric ID and description
CREATE OR ALTER VIEW gold.dim_rider_type AS
SELECT DISTINCT
    CASE rider_type
        WHEN 'registered' THEN 1
        WHEN 'casual' THEN 0
        ELSE NULL
    END AS rider_type_id,           -- Numeric ID for joins
    rider_type,                     -- Original rider_type string
    CASE rider_type
        WHEN 'casual' THEN 'Occasional rider'
        WHEN 'registered' THEN 'Subscribed / Regular rider'
        ELSE 'Unknown'
    END AS rider_description        -- Human-readable description
FROM silver.bike_share;
GO


/*-----------------------------------------------------------------------------
 Analytical Views
-----------------------------------------------------------------------------*/
-- Daily performance summary: total riders, revenue, and profit per day
CREATE OR ALTER VIEW gold.vw_daily_summary AS
WITH base_data AS (
    SELECT *,
        COALESCE(dteday, DATEFROMPARTS(
            CASE yr WHEN 0 THEN 2021 WHEN 1 THEN 2022 END,
            CASE season
                WHEN 1 THEN 3
                WHEN 2 THEN 6
                WHEN 3 THEN 9
                WHEN 4 THEN 12
                ELSE 1
            END,
        1)) AS fixed_dteday
    FROM silver.bike_share
)
SELECT 
    fixed_dteday AS dteday,
    SUM(riders)  AS total_riders,
    SUM(revenue) AS total_revenue,
    SUM(profit)  AS total_profit
FROM base_data
GROUP BY fixed_dteday;
GO

-- Rider type performance summary: aggregates by rider type
CREATE OR ALTER VIEW gold.vw_rider_type_summary AS
SELECT 
    rider_type,
    SUM(riders)  AS total_riders,
    SUM(revenue) AS total_revenue,
    SUM(profit)  AS total_profit
FROM silver.bike_share
GROUP BY rider_type;
GO
