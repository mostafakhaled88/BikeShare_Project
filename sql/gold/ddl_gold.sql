/*
===============================================================================
 Project: Bike Share Analytics - Gold Layer Views
 Author : [Your Name]
 Date   : [YYYY-MM-DD]
 Purpose: Defines the Gold schema analytical layer using views.
          - Fact View: Exposes cleaned, query-ready fact data.
          - Dimension Views: Provides lookup dimensions.
          - Analytical Views: Provides aggregated business insights.
===============================================================================
*/

/*-----------------------------------------------------------------------------
 Fact View
   - Centralized fact table for reporting.
   - Source: silver.bike_share
-----------------------------------------------------------------------------*/
CREATE OR ALTER VIEW gold.fact_rides AS
SELECT 
    dteday,        -- Ride date
    season,        -- Season code
    yr,            -- Year
    weekday,       -- Day of week
    hr,            -- Hour of day
    rider_type,    -- Casual or Registered
    riders,        -- Number of riders
    price,         -- Price per ride
    cogs,          -- Cost of goods sold
    revenue,       -- Total revenue
    profit         -- Total profit
FROM silver.bike_share;
GO


/*-----------------------------------------------------------------------------
 Dimension Views
   - Normalized dimensions for drill-down analysis
-----------------------------------------------------------------------------*/

-- 📅 Calendar Dimension
CREATE OR ALTER VIEW gold.dim_date AS
SELECT DISTINCT 
    dteday,   -- Calendar date
    yr,       -- Year
    season,   -- Season code
    weekday   -- Weekday code
FROM silver.bike_share;
GO

-- 🚴 Rider Type Dimension
CREATE OR ALTER VIEW gold.dim_rider_type AS
SELECT DISTINCT
    rider_type,   -- Rider category (casual/registered)
    price,        -- Price per ride
    cogs          -- Cost of goods sold
FROM silver.bike_share;
GO


/*-----------------------------------------------------------------------------
 Analytical Views
   - Aggregated KPIs for dashboards & reports
-----------------------------------------------------------------------------*/

-- 📊 Daily Performance Summary
CREATE OR ALTER VIEW gold.vw_daily_summary AS
SELECT 
    dteday,                        -- Calendar date
    SUM(riders)  AS total_riders,  -- Total riders per day
    SUM(revenue) AS total_revenue, -- Total revenue per day
    SUM(profit)  AS total_profit   -- Total profit per day
FROM silver.bike_share
GROUP BY dteday;
GO

-- 👥 Rider Type Performance Summary
CREATE OR ALTER VIEW gold.vw_rider_type_summary AS
SELECT 
    rider_type,                    -- Rider category
    SUM(riders)  AS total_riders,  -- Total riders per category
    SUM(revenue) AS total_revenue, -- Total revenue per category
    SUM(profit)  AS total_profit   -- Total profit per category
FROM silver.bike_share
GROUP BY rider_type;
GO
