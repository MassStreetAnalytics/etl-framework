-- =============================================
-- Author: Bob Wakefield
-- Create date: 20Oct20
-- Description: This builds the table that holds volumetric data for table loads.
-- Directions for use:Simply run the script.
-- =============================================

USE [ODS]
GO

/****** Object:  Table [rpt].[TableLoadReport]    Script Date: 12/7/2017 10:57:51 PM ******/
DROP TABLE IF EXISTS [rpt].[TableLoadReport]
GO

/****** Object:  Table [rpt].[TableLoadReport]    Script Date: 12/7/2017 10:57:51 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rpt].[TableLoadReport]') AND type in (N'U'))
BEGIN
CREATE TABLE [rpt].[TableLoadReport](
[TableLoadReportID] [bigint] IDENTITY(1,1) NOT NULL,
[TableName] [nvarchar](50) NULL,
[DateOfCurrentObservation] [datetime] NULL,
[DateOfLastObservation] [datetime] NULL,
[RowCount] [int] NULL,
[ChangeFromLastObservation] [int] NULL,
[CurrentThreeSDLevel] [numeric](18, 4) NULL,
[AsOf] [date] NULL,
CONSTRAINT [PK_TableLoadReport] PRIMARY KEY CLUSTERED 
(
[TableLoadReportID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO


