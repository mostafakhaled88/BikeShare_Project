/*
===============================================================================
Script Name : BikeShareDB.sql
Purpose     : Create a database for Bike Share analysis
Author      : Mostafa Khaled Farag
===============================================================================
*/

-- Drop database if it already exists (optional, for clean setup)
IF DB_ID('BikeShareDB') IS NOT NULL
    DROP DATABASE BikeShareDB;
GO

-- Create a fresh database
CREATE DATABASE BikeShareDB;
GO

-- Switch context to the new database
USE BikeShareDB;
GO

