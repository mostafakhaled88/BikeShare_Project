/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'BikeShareDB' after checking if it already exists. 
    If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas 
    within the database: 'bronze', 'silver', and 'gold'.

WARNING:
    Running this script will drop the entire 'BikeShareDB' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/

USE master;
GO

-- Drop the 'BikeShareDB' database if it exists
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'BikeShareDB')
BEGIN
    ALTER DATABASE BikeShareDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE BikeShareDB;
END;
GO

-- Create the 'BikeShareDB' database
CREATE DATABASE BikeShareDB;
GO

-- Switch context to the new database
USE BikeShareDB;
GO

-- Create Schemas (if not already existing)
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'bronze')
    EXEC('CREATE SCHEMA bronze');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'silver')
    EXEC('CREATE SCHEMA silver');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'gold')
    EXEC('CREATE SCHEMA gold');
GO
