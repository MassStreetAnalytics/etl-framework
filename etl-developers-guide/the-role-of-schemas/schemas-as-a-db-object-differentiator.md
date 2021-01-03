# Schemas As A DB Object Differentiator

This is a subtle application of schemas. It will frequently be the case that you create different classes of objects that are named the same. The two standard uses cases for this are:

1. Indexed views of EDW base tables.
2. Views of stage tables created in support of BULK INSERT operations.

Since every physical table in EWD and ODS are assigned to a schema, you can leave views in the dbo schema. That way you can easily identify what that objects is, SQL Server can differentiate between the table and the view, and you can use the same name for two different objects in your code without a name collision error.

I am not a fan of using schemas to group your database objects. ODS is an exception. 

Unlike the other databases, ODS does not have a unified use. There are a lot of moving parts in ODS so it makes sense to keep related parts together. Additionally, schemas help to identify the function of a moving part.

NO table in ODS should use the dbo schema. Every table needs a schema that CLEARLY identifies the function of that table. If it is a staging table, the schema needs to identify the source system of the data.

