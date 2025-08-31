/*
===============================================================================
DDL Script: Bronze Layer Tables – Bike Share Project
===============================================================================
Purpose:
    - Define all bronze schema tables for raw data ingestion
    - Tables correspond directly to CSV files
===============================================================================
*/

USE BikeShareDB;
GO

-- ==========================================
-- Bronze Schema: Bike Share 2021 Rides
-- ==========================================
IF OBJECT_ID('bronze.bike_share_yr_0','U') IS NULL
BEGIN
    CREATE TABLE bronze.bike_share_yr_0 (
        dteday      DATE NULL,
        season      INT NULL,
        yr          INT NULL,
        mnth        INT NULL,
        hr          INT NULL,
        holiday     BIT NULL,
        weekday     INT NULL,
        workingday  BIT NULL,
        weathersit  INT NULL,
        temp        FLOAT NULL,
        atemp       FLOAT NULL,
        hum         FLOAT NULL,
        windspeed   FLOAT NULL,
        rider_type  VARCHAR(20) NULL,
        riders      INT NULL,
        load_ts     DATETIME DEFAULT GETDATE()
    );
END;
GO

-- ==========================================
-- Bronze Schema: Bike Share 2022 Rides
-- ==========================================
IF OBJECT_ID('bronze.bike_share_yr_1','U') IS NULL
BEGIN
    CREATE TABLE bronze.bike_share_yr_1 (
        dteday      DATE NULL,
        season      INT NULL,
        yr          INT NULL,
        mnth        INT NULL,
        hr          INT NULL,
        holiday     BIT NULL,
        weekday     INT NULL,
        workingday  BIT NULL,
        weathersit  INT NULL,
        temp        FLOAT NULL,
        atemp       FLOAT NULL,
        hum         FLOAT NULL,
        windspeed   FLOAT NULL,
        rider_type  VARCHAR(20) NULL,
        riders      INT NULL,
        load_ts     DATETIME DEFAULT GETDATE()
    );
END;
GO

-- ==========================================
-- Bronze Schema: Cost Table
-- ==========================================
IF OBJECT_ID('bronze.cost_table','U') IS NULL
BEGIN
    CREATE TABLE bronze.cost_table (
        yr      INT NULL,           -- Year code: 0=2021, 1=2022
        price   DECIMAL(6,2) NULL, -- Ride price
        cogs    DECIMAL(6,2) NULL, -- Cost of goods sold
        load_ts DATETIME DEFAULT GETDATE()
    );
END;
GO

-- ==========================================
-- Optional: Load Audit Table
-- ==========================================
IF OBJECT_ID('bronze.load_audit','U') IS NULL
BEGIN
    CREATE TABLE bronze.load_audit (
        table_name NVARCHAR(128),
        load_time  DATETIME,
        rows_loaded INT
    );
END;
GO

-- ==========================================
--- Error Logging Table
-- ==========================================
IF OBJECT_ID('bronze.load_errors','U') IS NULL
BEGIN
    CREATE TABLE bronze.load_errors (
        error_time DATETIME,
        procedure_name NVARCHAR(128),
        error_message NVARCHAR(MAX),
        error_number INT,
        error_state INT
    );
END;
GO
