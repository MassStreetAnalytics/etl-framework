# Primary Keys

Below are the rules for naming primary keys.

| Object Type | Naming Convention | Naming Model | Example |
| :--- | :--- | :--- | :--- |
| Dimension Table | The primary keys of dimension tables are named after the name of the dimension without the Dim modifier and adding a CK for contrived key at the end. | \[DimensionNameWithOutDim\]CK | CustomerCK |
| Fact Table | Fact table primary keys should not be a concatenated key. It should be an atomic autoincremented number so individual rows are easily identified. All primary keys on fact tables are named the same. | Row | RowID |
| Master Data Table | MDM table primary keys should share the name of the table and end in EK for enterprise key. | \[TableName\]EK | CustomerEK |
| Staging Table | All staging tables have identically named primary keys. | ETLKey | ETLKey |



