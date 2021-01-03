# Foreign Key Creation

When you create your fact table, you have to attach the dimensions to it physically in the database by creating foreign key relationships. This sheet automatically creates the code that builds those relationships.

When you run the resultant code, be sure to wrap it in begin/commit transaction statements in case anything goes wrong. If it does, the transaction will prevent you from having a partial execution with some of the relationships built while others got hung.

All you need to do is populate the Schema column and the Fact Table Name column and the rest will auto populate. The end result can be found in the column Final Product at the end.



