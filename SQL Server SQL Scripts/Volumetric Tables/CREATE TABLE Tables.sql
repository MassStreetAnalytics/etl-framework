USE [ODS]
GO

/****** Object:  Table [vol].[Tables]    Script Date: 11/21/2017 12:34:59 AM ******/
DROP TABLE IF EXISTS [vol].[Tables]
GO

/****** Object:  Table [vol].[Tables]    Script Date: 11/21/2017 12:34:59 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[vol].[Tables]') AND type in (N'U'))
BEGIN
CREATE TABLE [vol].[Tables](
	[TableID] [bigint] IDENTITY(1,1) NOT NULL,
	[TableName] [nvarchar](50) NOT NULL,
	[DateCreated] [datetime] NOT NULL,
 CONSTRAINT [PK_Tables] PRIMARY KEY CLUSTERED 
(
	[TableID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO


