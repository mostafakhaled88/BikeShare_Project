/*
===============================================================================
Stored Procedure: Load Bronze Layer (Bike Share & Cost Data)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from three CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from CSV files to bronze tables.

Parameters:
    None. 
    This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze_bike;
===============================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze_bike AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;

    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '=======================================';
        PRINT 'Loading Bronze Layer (Bike Share & Cost Data)';
        PRINT '=======================================';

        ---------------------------
        -- Load bike_share_yr_0
        ---------------------------
        SET @start_time = GETDATE();
        PRINT 'Truncating Table: bronze.bike_share_yr_0';
        TRUNCATE TABLE bronze.bike_share_yr_0;
        PRINT 'Inserting Data into: bronze.bike_share_yr_0';
        BULK INSERT bronze.bike_share_yr_0
        FROM 'C:\SQLData\bike_share_yr_0.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT 'Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '---------------------------';

        ---------------------------
        -- Load bike_share_yr_1
        ---------------------------
        SET @start_time = GETDATE();
        PRINT 'Truncating Table: bronze.bike_share_yr_1';
        TRUNCATE TABLE bronze.bike_share_yr_1;
        PRINT 'Inserting Data into: bronze.bike_share_yr_1';
        BULK INSERT bronze.bike_share_yr_1
        FROM 'C:\SQLData\bike_share_yr_1.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT 'Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '---------------------------';

        ---------------------------
        -- Load cost_table
        ---------------------------
        SET @start_time = GETDATE();
        PRINT 'Truncating Table: bronze.cost_table';
        TRUNCATE TABLE bronze.cost_table;
        PRINT 'Inserting Data into: bronze.cost_table';
        BULK INSERT bronze.cost_table
        FROM 'C:\SQLData\cost_table.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT 'Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '---------------------------';

        SET @batch_end_time = GETDATE();
        PRINT '====================================';
        PRINT 'Loading Bronze Layer is Completed';
        PRINT 'Total Load Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
        PRINT '====================================';

    END TRY
    BEGIN CATCH
        PRINT '====================================';
        PRINT 'ERROR OCCURRED DURING LOADING BRONZE LAYER';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '====================================';
    END CATCH
END;
