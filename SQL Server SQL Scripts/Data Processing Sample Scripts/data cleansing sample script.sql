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

--Set empty dates to the empty field code
--This HAS to be done before you check for
--bad dates.
UPDATE [eod].[EODPrices]
SET [Date] = '99991231'
WHERE [Date] IS NULL


--Set error dates to the error field code
UPDATE [eod].[EODPrices]
SET [Date] = '99991231'
WHERE ISDATE([Date]) = 0


--Convert the rest of the dates into YYYYMMDD format
UPDATE [eod].[EODPrices]
SET [Date] = CONVERT(VARCHAR(10),CAST([Date] AS DATE),112)

--Remove CR from volume data
UPDATE [eod].[EODPrices]
SET Volume = replace(Volume, char(13), '')




COMMIT TRANSACTION

END



GO


