# Sample Stage Table

To make life easy, all audit columns in stage tables have default values. The only thing you need to change is the default value for SourceSystem.

```sql
USE ODS

DROP TABLE IF EXISTS YourSchemaName.YourStageTableNameData
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE TABLE YourSchemaName.YourStageTableNameData(
[ETLKey] [uniqueidentifier] NOT NULL,
[UniqueDims] [varbinary](35) NULL,
[UniqueRows] [varbinary](16) NULL,
[SourceSystem] [nvarchar](255) NULL,
[Cleansed] [bit] NULL,
[ErrorRecord] [bit] NULL,
[ErrorReason] [nvarchar](255) NULL,
[Processed] [bit] NULL,
[RunDate] [datetime] NULL,
 CONSTRAINT [PK_YourStageTableNameData] PRIMARY KEY CLUSTERED 
(
       [ETLKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [YourSchemaName].[YourStageTableNameData] ADD  CONSTRAINT [DF_YourStageTableNameData_ETLKey]  DEFAULT (newid()) FOR [ETLKey]
GO

ALTER TABLE [YourSchemaName].[YourStageTableNameData] ADD  CONSTRAINT [DF_YourStageTableNameData_SourceSystem]  DEFAULT (N'DatabaseName') FOR [SourceSystem]
GO

ALTER TABLE [YourSchemaName].[YourStageTableNameData] ADD  CONSTRAINT [DF_YourStageTableNameData_Cleansed]  DEFAULT ((0)) FOR [Cleansed]
GO

ALTER TABLE [YourSchemaName].[YourStageTableNameData] ADD  CONSTRAINT [DF_YourStageTableNameData_ErrorRecord]  DEFAULT ((0)) FOR [ErrorRecord]
GO

ALTER TABLE [YourSchemaName].[YourStageTableNameData] ADD  CONSTRAINT [DF_YourStageTableNameData_Processed]  DEFAULT ((0)) FOR [Processed]
GO

ALTER TABLE [YourSchemaName].[YourStageTableNameData] ADD  CONSTRAINT [DF_YourStageTableNameData_RunDate]  DEFAULT (getdate()) FOR [RunDate]
GO




```

<table>
  <thead>
    <tr>
      <th style="text-align:left">Column Name</th>
      <th style="text-align:left">Data Type</th>
      <th style="text-align:left">Function</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="text-align:left">ETLKey</td>
      <td style="text-align:left">uniqueidentifier</td>
      <td style="text-align:left">The primary key of staging tables uses a GUID as a key as opposed to an
        auto incrementing number. Using a GUID ensures uniqueness across all stage
        tables and comes in very handy when tracking the provenance of records.
        There can be no mistake that a certain record came from a certain table.</td>
    </tr>
    <tr>
      <td style="text-align:left">UniqueDims</td>
      <td style="text-align:left">varbinary(35)</td>
      <td style="text-align:left">
        <p>The primary key of a fact table is the unique combination of all the dimensions
          attached to that fact table including any degenerate dimensions.</p>
        <p></p>
        <p>The values of the foreign keys and degenerate dimensions can be hashed
          to provide a single atomic value for efficiently identifying a specific
          row in a fact table. Used in combination with ETLKey, this column is used
          to determine if a record in a stage table made it to the fact table ok.</p>
      </td>
    </tr>
    <tr>
      <td style="text-align:left">UniqueRows</td>
      <td style="text-align:left">varbinary(16)</td>
      <td style="text-align:left">
        <p>There are rare instances that arise, usually as a result of a quirk of
          the source system, where uniqueness can&apos;t be determined by the dimensions
          of the measures and the measures themselves have to be involved in the
          determination of uniqueness.</p>
        <p></p>
        <p>In those cases, UniqueRows holds a hash of those measures that are either
          required to determine uniqueness or used to detect change in a value.</p>
        <p></p>
        <p>When this happens, UniqueDims and UniqueRows is used to determine if a
          record made it to the fact table ok.</p>
      </td>
    </tr>
    <tr>
      <td style="text-align:left">SourceSystem</td>
      <td style="text-align:left">nvarchar(255)</td>
      <td style="text-align:left">The system where the data came from. This value should be short, plain,
        and obvious. An example would be BankOfAmerica.
        <br />
        <br />You want to Pascal case it for when the value winds up in code as is the
        case when you have master data and need to filter on source system.</td>
    </tr>
    <tr>
      <td style="text-align:left">Cleansed</td>
      <td style="text-align:left">bit</td>
      <td style="text-align:left">This is a binary value that indicates whether or not the data set has
        been cleansed.</td>
    </tr>
    <tr>
      <td style="text-align:left">ErrorRecord</td>
      <td style="text-align:left">bit</td>
      <td style="text-align:left">This is a binary value that indicates whether or not this record errored
        out.</td>
    </tr>
    <tr>
      <td style="text-align:left">ErrorReason</td>
      <td style="text-align:left">nvarchar(255)</td>
      <td style="text-align:left">If a record errors, you can use this column to provide diagnostic information.</td>
    </tr>
    <tr>
      <td style="text-align:left">Processed</td>
      <td style="text-align:left">bit</td>
      <td style="text-align:left">This is a binary value that indicates whether or not this record made
        it to the fact table.</td>
    </tr>
    <tr>
      <td style="text-align:left">RunDate</td>
      <td style="text-align:left">datetime</td>
      <td style="text-align:left">The time stamp the record was loaded.</td>
    </tr>
  </tbody>
</table>



