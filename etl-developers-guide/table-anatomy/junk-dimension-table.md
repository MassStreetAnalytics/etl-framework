# Sample Junk Dimension Table

Junk dimensions are collections of low cardinality values. The table represents all possible combinations of those values or, at least, all possible combinations of those values that have been imported so far.

The junk dimension template is almost identical to the dimension table template with one key difference. There is an additional column called RowHash which is a computed column that consist of a hash of all the the non-key, non-audit columns.

```sql
USE YourEDW
 
DROP TABLE IF EXISTS [dw].[DimYourDimensionName]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE TABLE [dw].[DimYourDimensionName](
[YourDimensionNameCK] [bigint] IDENTITY(1,1) NOT NULL,
--your columns.
[CreatedBy] [nvarchar](50) NULL,
[CreatedOn] [datetime] NULL,
[UpdatedBy] [nvarchar](50) NULL,
[UpdatedOn] [datetime] NULL,
[SourceSystem] [nvarchar](100) NULL,
[SourceSystemKey] [nvarchar](100) NULL,
[EffectiveFrom] [datetime] NULL,
[EffectiveTo] [datetime] NULL,
[IsMostRecentRecord] [bit] NULL,
[RowHash]  AS (CONVERT([binary](16),hashbytes('MD5',concat(
CONVERT([nvarchar](35),Column1,0),
CONVERT([nvarchar](35),Column2,0),
CONVERT([nvarchar](35),Column3,0),
CONVERT([nvarchar](35),Column4,0),
CONVERT([nvarchar](35),Column5,0),
CONVERT([nvarchar](35),Column6,0))),0)) PERSISTED,
 CONSTRAINT [PK_YourDimensionName] PRIMARY KEY CLUSTERED 
(
[YourDimensionNameCK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END

--index is optional
DROP INDEX IF EXISTS [NCIDX_FactYourFactTableName_RowHash] ON [dw].[FactYourFactTableName]
GO


CREATE NONCLUSTERED INDEX [NCIDX_FactYourFactTableName_RowHash] ON [dw].[FactYourFactTableName]
(
	[RowHash] ASC
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
      <td style="text-align:left">SourceSystemKey</td>
      <td style="text-align:left">nvarchar(100)</td>
      <td style="text-align:left">The primary key of the record from the source system.
        <br />
        <br />Strictly speaking, this does not have to be the primary key of a source
        table. It does not even have to be an atomic value. It can be concatenated
        value. The important thing is that the value uniquely identify the row,
        and that row can be tracked back to a record in the source system.</td>
    </tr>
    <tr>
      <td style="text-align:left">EffectiveFrom</td>
      <td style="text-align:left">datetime</td>
      <td style="text-align:left">
        <p>If the processing of the dimension requires that history be kept, this
          column indicates when the row began to represent the most recent version
          of the data.</p>
        <p></p>
        <p>This column usually shares a value with CreatedOn and does not suffer
          from the challenges found when trying to update the value of EffectiveTo.</p>
      </td>
    </tr>
    <tr>
      <td style="text-align:left">EffectiveTo</td>
      <td style="text-align:left">datetime</td>
      <td style="text-align:left">
        <p>If the processing of the dimension requires that history be kept, this
          column indicates when the row ceased to represent the most recent version
          of the data.</p>
        <p></p>
        <p>If IsMostRecentRecord = 1, then the value of EffectiveTo is the highest
          date in the date dimension. If IsMostRecentRecord = 0, then the value of
          this column is set to the day it stopped being true. This has some challenges
          in the case where you have an intraday change. It happens.
          <br />
          <br />You will need to use your creativity to solve your particular use case.
          My solution was to begin retiring records by decrementing a minute amount
          of time. That is the reason the data type is datatime and not just date.
          I will illustrate this in the section on loading a Type II SCD.</p>
      </td>
    </tr>
    <tr>
      <td style="text-align:left">IsMostRecentRecord</td>
      <td style="text-align:left">bit</td>
      <td style="text-align:left">If the processing of the dimension requires that history be kept, this
        column indicates whether or not that row represents the most up to date
        version of that data.</td>
    </tr>
    <tr>
      <td style="text-align:left">RowHash</td>
      <td style="text-align:left">binary(16)</td>
      <td style="text-align:left">A computed value of those columns used to compute the uniqueness of a
        row. This value is used to determine INSERT or UPDATE operations on the
        table.</td>
    </tr>
  </tbody>
</table>

