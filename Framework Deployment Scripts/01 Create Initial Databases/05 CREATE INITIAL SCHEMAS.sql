-- =============================================
-- Author: Bob Wakefield
-- Create date: 15Oct20
-- Description: Create the universal schemas.
-- Directions for use: Replace [Your Data Warehouse Database Name]
-- with the name specific to your EDW, run this script on all
-- EDW related servers.
-- =============================================

USE [Your Data Warehouse Database Name]

DROP SCHEMA IF EXISTS dw

GO

CREATE SCHEMA dw

GO

USE ODS

DROP SCHEMA IF EXISTS cm

GO

CREATE SCHEMA cm

GO

DROP SCHEMA IF EXISTS rpt

GO

CREATE SCHEMA rpt

GO

DROP SCHEMA IF EXISTS vol

GO

CREATE SCHEMA vol

GO

DROP SCHEMA IF EXISTS mdm

GO

CREATE SCHEMA mdm

GO

DROP SCHEMA IF EXISTS ms

GO

CREATE SCHEMA ms