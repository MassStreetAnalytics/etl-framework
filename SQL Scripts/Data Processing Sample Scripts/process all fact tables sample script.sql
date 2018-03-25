USE [ODS]
GO

/****** Object:  StoredProcedure [dbo].[sp_ProcessFactTables]    Script Date: 10/17/2017 7:11:09 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[sp_ProcessFactTables]
GO

/****** Object:  StoredProcedure [dbo].[sp_ProcessFactTables]    Script Date: 10/17/2017 7:11:09 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_ProcessFactTables]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_ProcessFactTables] AS' 
END
GO


ALTER PROCEDURE [dbo].[sp_ProcessFactTables]
AS
BEGIN



BEGIN TRY
EXEC sp_ProcessFactAssetPrices
END TRY
BEGIN CATCH
PRINT 'Error sp_ProcessFactAssetPrices: '+CAST(ERROR_NUMBER()AS varchar(6))+' '+ERROR_MESSAGE()
END CATCH


BEGIN TRY
EXEC sp_ProcessFactExchangeCloseData
END TRY
BEGIN CATCH
PRINT 'Error sp_ProcessFactExchangeCloseData: '+CAST(ERROR_NUMBER()AS varchar(6))+' '+ERROR_MESSAGE()
END CATCH



END

GO


