-- =============================================
-- Create Staging & Final Tables
-- Description:
--   Creates staging tables (all NVARCHAR for safe CSV load)
--   and final tables with proper data types for Bike Share Year 0 & Year 1.
--   Includes cost table for pricing and COGS information.
-- =============================================

-- ================================
-- 1. Staging Tables (NVARCHAR)
-- ================================

-- Drop & create staging table for Year 0
IF OBJECT_ID('staging.bike_share_yr_0', 'U') IS NOT NULL
    DROP TABLE staging.bike_share_yr_0;

CREATE TABLE staging.bike_share_yr_0 (
    dteday       NVARCHAR(50),
    season       NVARCHAR(10),
    yr           NVARCHAR(10),
    mnth         NVARCHAR(10),
    hr           NVARCHAR(10),
    holiday      NVARCHAR(10),
    weekday      NVARCHAR(10),
    workingday   NVARCHAR(10),
    weathersit   NVARCHAR(10),
    temp         NVARCHAR(20),
    atemp        NVARCHAR(20),
    hum          NVARCHAR(20),
    windspeed    NVARCHAR(20),
    rider_type   NVARCHAR(20),
    riders       NVARCHAR(20)
);

-- Drop & create staging table for Year 1
IF OBJECT_ID('staging.bike_share_yr_1', 'U') IS NOT NULL
    DROP TABLE staging.bike_share_yr_1;

CREATE TABLE staging.bike_share_yr_1 (
    dteday       NVARCHAR(50),
    season       NVARCHAR(10),
    yr           NVARCHAR(10),
    mnth         NVARCHAR(10),
    hr           NVARCHAR(10),
    holiday      NVARCHAR(10),
    weekday      NVARCHAR(10),
    workingday   NVARCHAR(10),
    weathersit   NVARCHAR(10),
    temp         NVARCHAR(20),
    atemp        NVARCHAR(20),
    hum          NVARCHAR(20),
    windspeed    NVARCHAR(20),
    rider_type   NVARCHAR(20),
    riders       NVARCHAR(20)
);

-- Drop & create staging table for Bike Cost
IF OBJECT_ID('staging.bike_cost', 'U') IS NOT NULL
    DROP TABLE staging.bike_cost;

CREATE TABLE staging.bike_cost (
    yr    NVARCHAR(10),
    price NVARCHAR(20),
    COGS  NVARCHAR(20)
);

-- ================================
-- 2. Final Tables (Proper Types)
-- ================================

-- Drop & create final table for Year 0
IF OBJECT_ID('dbo.bike_share_yr_0', 'U') IS NOT NULL
    DROP TABLE dbo.bike_share_yr_0;

CREATE TABLE dbo.bike_share_yr_0 (
    dteday       DATE,
    season       INT,
    yr           INT,
    mnth         INT,
    hr           INT,
    holiday      INT,
    weekday      INT,
    workingday   INT,
    weathersit   INT,
    temp         FLOAT,
    atemp        FLOAT,
    hum          FLOAT,
    windspeed    FLOAT,
    rider_type   NVARCHAR(20),
    riders       INT
);

-- Drop & create final table for Year 1
IF OBJECT_ID('dbo.bike_share_yr_1', 'U') IS NOT NULL
    DROP TABLE dbo.bike_share_yr_1;

CREATE TABLE dbo.bike_share_yr_1 (
    dteday       DATE,
    season       INT,
    yr           INT,
    mnth         INT,
    hr           INT,
    holiday      INT,
    weekday      INT,
    workingday   INT,
    weathersit   INT,
    temp         FLOAT,
    atemp        FLOAT,
    hum          FLOAT,
    windspeed    FLOAT,
    rider_type   NVARCHAR(20),
    riders       INT
);

-- Drop & create final cost table
IF OBJECT_ID('dbo.bike_share_cost', 'U') IS NOT NULL
    DROP TABLE dbo.bike_share_cost;

CREATE TABLE dbo.bike_share_cost (
    yr    INT,
    price FLOAT,
    COGS  FLOAT
);
