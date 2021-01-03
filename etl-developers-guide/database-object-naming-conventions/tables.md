# Tables

I have a vague memory from undergrad about a rule that said table names should be pluralized in transactional systems. In a data warehouse, that does not really make sense. Dimensions usually hold records describing singular objects like a person place or thing. 

There is a weaker argument to extend this convention to fact tables, however, I do it anyway to satisfy my OCD.

| Table Type | Naming Convention | Naming Model | Example |
| :--- | :--- | :--- | :--- |
| Common Model Tables | Common model tables should be nearly identical to the warehouse tables they mimic but stripped of all indexes, keys, and most constraints with the exception of the index on the column used to match records.  | Dim\[BaseDimensionTableName\] | DimCustomer |
| Conventional Staging Tables | Table names should describe what the data is and end in the word "Data". Additionally, tables should be assigned to a schema that identifies the source system of the data. | \[DescriptiveName\]Data | CustomerData |
| Dimension Tables | All dimension tables should start with the word "Dim". | Dim\[YourDimensionName\] | DimCustomer |
| Fact Tables | All fact tables should start with the word "Fact". | Fact\[YourFactTableName\] | FactCustomerDetail |
| Junk Dimension Tables | All junk dimension names should end in the word "Information" in addition to inheriting the convention for naming standard dimensions. | Dim\[YourDimensionName\]Information | DimCustomerInformation |
| MDM Tables | MDM tables should be named after the data they are storing and end in MasterData. | \[Dimension\]MasterData | CustomerMasterData |
| Reporting Tables | Reporting tables should be obviously named with spaces between words. | no model | Customer Activity Report |
| Staging Tables Designed For Historical Loads | Tables that are specially modified to load large amounts of historical data should share the name of the stage table that manages the normal batch process with the addition of the word "Historical" at the end. | \[DescriptiveName\]DataHistorical | CustomerDataHistorical |







