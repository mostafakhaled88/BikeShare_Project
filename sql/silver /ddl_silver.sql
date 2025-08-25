/*
====================================================================================
Script:    Create Silver Layer Table - bike_share
Purpose:   Defines the 'silver.bike_share' table in the Data Warehouse.
           This table contains cleansed and enriched data from the Bronze layer,
           including calculated revenue and profit columns.
           
Schema:    silver
Table:     bike_share

Author:    Mostafa Khaled Farag
Date:      2025-08-26
====================================================================================
*/

-- If the table already exists, drop it to allow recreation (idempotent design)
IF OBJECT_ID('silver.bike_share', 'U') IS NOT NULL
    DROP TABLE silver.bike_share;
GO

-- Create the Silver Layer table
CREATE TABLE silver.bike_share (
    dteday     DATE,             -- Date of rental
    season     INT,              -- Season indicator (1=winter, 2=spring, 3=summer, 4=fall)
    yr         INT,              -- Year (e.g., 0=2011, 1=2012 in raw dataset)
    weekday    INT,              -- Day of week (0=Sunday, 6=Saturday)
    hr         INT,              -- Hour of day (0–23)
    rider_type VARCHAR(50),      -- Type of rider (e.g., 'casual', 'registered')
    riders     INT,              -- Number of riders in that hour
    price      DECIMAL(10,2),    -- Price per ride
    cogs       DECIMAL(10,2),    -- Cost of goods sold (per ride basis)
    revenue    DECIMAL(18,2),    -- Total revenue = riders * price
    profit     DECIMAL(18,2)     -- Total profit = revenue - (riders * cogs)
);

-- ==================================================================================
-- Notes:
-- - The Silver layer contains cleansed, structured data derived from the Bronze layer.
-- - Revenue and Profit are derived fields to support business intelligence analysis.
-- - Keep transformations simple in Silver. Complex aggregations belong in the Gold layer.
-- ==================================================================================
