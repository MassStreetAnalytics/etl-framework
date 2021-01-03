# Sample Fact Table

The sample fact table file only introduces one new column to the mix: TransactionID.

```sql
USE YourEDW

DROP TABLE IF EXISTS [dw].[FactYourFactTableName]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ARITHABORT ON
GO

CREATE TABLE [dw].[FactYourFactTableName](
	[RowID] [bigint] IDENTITY(1,1) NOT NULL,
	--dimension keys
	[TransactionID] NVARCHAR(100) NULL,
	--your columns.
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [nvarchar](50) NULL,
	[SourceSystem] [nvarchar](50) NULL,
	[UniqueDims]  AS (CONVERT([varbinary](35),hashbytes('SHA1',concat(
	CONVERT([nvarchar](35),[DimKey1CK],(0)),
	CONVERT([nvarchar](35),[DimKey2CK],(0)),
	CONVERT([nvarchar](35),[TransactionID],(0))
	)),(0))) PERSISTED,
	--unique rows is optional
	[UniqueRows]  AS (CONVERT([varbinary](35),hashbytes('SHA1',concat(
	CONVERT([nvarchar](35),[Column1],(0)),
	CONVERT([nvarchar](35),[Column2],(0))
	)),(0))) PERSISTED,
 CONSTRAINT [PK_prices] PRIMARY KEY CLUSTERED 
(
	[RowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_FactYourFactTableName] UNIQUE NONCLUSTERED 
(
	[UniqueDims] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

--index is optional
DROP INDEX IF EXISTS [NCIDX_FactYourFactTableName_UniqueDims] ON [dw].[FactYourFactTableName]
GO


CREATE NONCLUSTERED INDEX [NCIDX_FactYourFactTableName_UniqueDims] ON [dw].[FactYourFactTableName]
(
	[UniqueDims] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

--index is optional
DROP INDEX IF EXISTS [NCIDX_FactYourFactTableName_UniqueRows] ON [dw].[FactYourFactTableName]
GO


CREATE NONCLUSTERED INDEX [NCIDX_FactYourFactTableName_UniqueRows] ON [dw].[FactYourFactTableName]
(
	[UniqueRows] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
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
      <td style="text-align:left">TransactionID</td>
      <td style="text-align:left">NVARCHAR(100)</td>
      <td style="text-align:left">
        <p>This is your cheat column.
          <br />
        </p>
        <p>Theoretically, the primary key of a fact table is the combination of all
          the dimensions attached to that fact table plus any degenerate dimensions.
          This should be the case the grand majority of the time.</p>
        <p></p>
        <p>However, nature is messy and you will not always be able to pull this
          off. This is where you can leverage your cheat column.</p>
        <p></p>
        <p>The TransactionID column is part of the hash for populating UniqueDims.
          You can drop data into the column without having to significantly change
          the hash code which comes in super handy when things get added to the table.</p>
        <p></p>
        <p>TransactionID does not conform to First Normal Form. You can put more
          than one column of data in there, provided you separate your columns by
          a pipe. And this is where it comes in handy.</p>
        <p></p>
        <p>If you have some edge case where uniqueness isn&apos;t determined by the
          dimensions, then you can keep stuffing data into TransactionID until you
          finally get the uniqueness you are looking for.</p>
      </td>
    </tr>
    <tr>
      <td style="text-align:left">CreatedBy</td>
      <td style="text-align:left">nvarchar(50)</td>
      <td style="text-align:left">
        <p>Who created the record.
          <br />
          <br />Any kind of record creation process should include the code:</p>
        <p></p>
        <p>CreatedBy = SYSTEM_USER</p>
      </td>
    </tr>
    <tr>
      <td style="text-align:left">CreatedOn</td>
      <td style="text-align:left">datetime</td>
      <td style="text-align:left">
        <p>When the record was created.
          <br />
        </p>
        <p>Any kind of record creation process should include the code:</p>
        <p></p>
        <p>CreatedOn= CURRENT_TIMESTAMP</p>
      </td>
    </tr>
    <tr>
      <td style="text-align:left">UpdatedBy</td>
      <td style="text-align:left">nvarchar(50)</td>
      <td style="text-align:left">
        <p>Who updated the record.
          <br />
        </p>
        <p>If there are any update statements ran against the table, this column
          should be populated as part of that process. This is especially important
          when engineers have to make manual adjustments to data. Your SQL UPDATE
          statement should include:
          <br />
        </p>
        <p>UpdatedBy = SYSTEM_USER</p>
      </td>
    </tr>
    <tr>
      <td style="text-align:left">UpdatedOn</td>
      <td style="text-align:left">datetime</td>
      <td style="text-align:left">
        <p>When the record was updated.
          <br />
          <br />If there are any update statements ran against the table, this column
          should be populated as part of that process. This is especially important
          when engineers have to make manual adjustments to data. Your SQL UPDATE
          statement should include:
          <br />
        </p>
        <p>UpdatedOn = CURRENT_TIMESTAMP</p>
      </td>
    </tr>
    <tr>
      <td style="text-align:left">SourceSystem</td>
      <td style="text-align:left">nvarchar(100)</td>
      <td style="text-align:left">The source system where the data came from. This value is populated from
        a column of the same name in the staging table.</td>
    </tr>
    <tr>
      <td style="text-align:left">UniqueRows</td>
      <td style="text-align:left">varbinary(35)</td>
      <td style="text-align:left">A computed column containing whatever extra non dimension column you need
        to make a row unique. This value is passed back to the staging table for
        comparison later on. It is used to determine if the stage table record
        made it to the fact table ok.</td>
    </tr>
    <tr>
      <td style="text-align:left">UniqueDims</td>
      <td style="text-align:left">varbinary(35)</td>
      <td style="text-align:left">A computed column containing a hash of all keys from dimensions and whatever
        you tossed in TransactionID. This value is passed back to the staging table
        for comparison later on. It is used to determine if the stage table record
        made it to the fact table ok.</td>
    </tr>
  </tbody>
</table>

