-- =============================================
-- Author: Bob Wakefield
-- Create date: 13Oct17
-- Description: clean price data
-- =============================================

USE [ODS]
GO

/****** Object:  StoredProcedure [dbo].[sp_CleanEODPrices]    Script Date: 9/15/2016 12:05:55 AM ******/
DROP PROCEDURE [dbo].[sp_CleanEODPrices]
GO

/****** Object:  StoredProcedure [dbo].[sp_CleanEODPrices]    Script Date: 9/15/2016 12:05:55 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_CleanEODPrices] 
AS
BEGIN

BEGIN TRANSACTION


--Convert the rest of the dates into YYYYMMDD format
UPDATE [eod].[EODPrices]
SET [Date] = udf_CleanDate([Date])

--Remove CR from volume data
UPDATE [eod].[EODPrices]
SET Volume = replace(Volume, char(13), '')


UPDATE [eod].[EODPrices]
SET Cleansed = 1





COMMIT TRANSACTION

END



GO


