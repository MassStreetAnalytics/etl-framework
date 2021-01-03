# Stored Procedures

Some people start their stored procedures with sp_._ That's a no no. SQL Server looks for "sp\_" __when looking for certain objects. To avoid name collisions, begin your stored procedures with "usp\_".

Stored procedures are named according to their function in the pipeline.

| Process Step | Naming Convention | Naming Model | Example |
| :--- | :--- | :--- | :--- |
| Pull Data | Name should start with the word pull and match the staging table the proc dumps to. | usp\_Pull\[DescriptionOfData\] | usp\_PullCustomerData |
| Clean Data | Name should start with the word clean and match the staging table the proc dumps to. | usp\_Clean\[DescriptionOfData\] | usp\_CleanCustomerData |
| Process MDM | Name should start with the word process and MDM and the dimension name it works on. | usp\_ProcessMDM\[DimensionName\] | usp\_ProcessMDMDimCustomer |
| Process Dimensions | Name should start with the word process and the dimension name it works on. | usp\_Process\[DimensionName\] | usp\_ProcessDimCustomer |
| Process Facts | Name should start with  the word process and match the table name it works on. | usp\_Process\[FactTableName\] | usp\_ProcessFactCustomer |
| Finalize And Audit | Name should be descriptive. | usp\_\[DescribeProcess\] | usp\_MarkRecordsAsProcessed |
| Populate Reporting Tables | Name should start with the word load and end with the word table and should have the table name that it loads. | usp\_Load\[TableName\]Table | usp\_LoadCustomerReportTable |
| Monitoring | Name should describe the process.  | usp\_\[DescribeProcess\] | usp\_DisplayTablesNotLoading |





