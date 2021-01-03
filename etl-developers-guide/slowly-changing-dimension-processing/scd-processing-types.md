# SCD Processing Types

Most people will tell you there are three different ways to process a dimension. There are actually seven you just rarely see the other four out in the wild.

Below is a table of SCD processing types and descriptions of how they work.  


| Type | Short Description | Description | Real World Use Case |
| :--- | :--- | :--- | :--- |
| 0 | Do nothing  | No, I'm not kidding. Do absolutely nothing. The data in a Type 0 dimension is functionally immutable. | DimDate |
| 1 | Overwrite | You do not keep history. New values simply overwrite the old. | You don't care what the old values are. |
| 2 | Add a row | You create a new row that represents the current state of the data and deprecate the old row. | This is the most common method to manage a SCD. |
| 3 | Add a column | You add a column to the table that represents an older value. You use this when you only want to keep one step of history. That said, this is a really poor way to manage SCDs. | Keeping track of maiden names using a Type 3 SCD is the optimistic method of keeping track of maiden names. |
| 4 | Add a history table | With this method, you keep the history in a separate table and the main table represents the current state of the data. | This is how SQL Server implements Temporal Tables. |

There are other types, but after 4 they get a bit arcane. Some of them do not conform to the table load methodology taught by this framework so talking about them is beyond the scope of this document.

