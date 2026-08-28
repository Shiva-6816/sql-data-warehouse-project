-- ============================================================
-- Data Warehouse Database & Schema Setup
-- Creates the main DataWareHouse database and the Bronze, Silver,
-- and Gold schemas used in the data warehouse architecture.
-- ============================================================

-- Switch to the master database before creating the data warehouse.
-- This ensures the CREATE DATABASE statement is executed from the system database.
USE master;

-- Create the main database for the data warehouse project.
-- All Bronze, Silver, and Gold layer objects will be stored inside this database.
CREATE DATABASE DataWareHouse;


-- Switch to the newly created data warehouse database.
-- The following schema creation statements will run inside DataWareHouse.
USE DataWareHouse;

-- Create the Bronze schema for raw/source data.
-- This layer stores data with minimal transformation.
CREATE SCHEMA Bronze;
GO

-- Create the Silver schema for cleaned and transformed data.
-- This layer contains validated and standardized data.
CREATE SCHEMA Silver;
GO

-- Create the Gold schema for business-ready data.
-- This layer contains final dimensions, facts, and reporting data.
CREATE SCHEMA Gold;
GO
