# Indexes

Indexes should be named so it is obvious what table and column the index is on and what kind of index it is.

| Index Type | Naming Model | Example |
| :--- | :--- | :--- |
| Clustered | CIDX\_\[YourTableName\]\_\[ColumnName\] | CIDX\_DimCustomer\_CustomerCK |
| Non-Clustered | NCIDX\_\[YourTableName\]\_\[ColumnName\] | NCIDX\_DimCustomer\_SourceSystemKey |



