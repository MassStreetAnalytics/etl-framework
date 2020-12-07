-- =============================================
-- Author: Bob Wakefield
-- Create date: 7Dec20
-- Description: Creates the load obvservations table.
-- Change Log:
-- 15Oct20 Created doc bloc sample. - BW
-- =============================================

USE [ODS]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[vol].[LoadObservations]') AND type in (N'U'))
ALTER TABLE [vol].[LoadObservations] DROP CONSTRAINT IF EXISTS [FK_LoadObservations_Tables]
GO


DROP TABLE IF EXISTS [vol].[LoadObservations]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[vol].[LoadObservations]') AND type in (N'U'))
BEGIN
CREATE TABLE [vol].[LoadObservations](
	[LoadObservationID] [bigint] IDENTITY(1,1) NOT NULL,
	[TableID] [bigint] NOT NULL,
	[DateOfCurrentObservation] [datetime] NULL,
	[DateOfLastObservation] [datetime] NULL,
	[RowCount] [bigint] NULL,
	[ChangeFromLastObservation] [bigint] NULL,
	[CurrentThreeSDLevel] [numeric](18, 4) NULL,
 CONSTRAINT [PK_LoadObservations] PRIMARY KEY CLUSTERED 
(
	[LoadObservationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[vol].[FK_LoadObservations_Tables]') AND parent_object_id = OBJECT_ID(N'[vol].[LoadObservations]'))
ALTER TABLE [vol].[LoadObservations]  WITH CHECK ADD  CONSTRAINT [FK_LoadObservations_Tables] FOREIGN KEY([TableID])
REFERENCES [vol].[Tables] ([TableID])
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[vol].[FK_LoadObservations_Tables]') AND parent_object_id = OBJECT_ID(N'[vol].[LoadObservations]'))
ALTER TABLE [vol].[LoadObservations] CHECK CONSTRAINT [FK_LoadObservations_Tables]
GO


