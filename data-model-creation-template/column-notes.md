# Column Notes

This tab is where we start building our data model. Here we start to make observations about our data. We start asking questions like:

1. Is this a string or numeric value?
2. What is it's data type?
3. What kind table would it go in?
4. What is interesting about this column?

For ease of use, many columns are populated from a drop down.

| Column Name | Usage |
| :--- | :--- |
| Column Name | Again this is just a drop in from the Sample Data table. |
| Data Type | There are predefined data types so you don't get lost in all the data types SQL Server offers. If you standardize on a handful of data types, it makes building so much easier. |
| Table Type | There are only two options here. It's either dimension data, or it's fact data. |
| Dimension Subtype | Denotes if the dimension data is a special type of dimension or just a run of the mill dimension. |
| Table Name | A preliminary name for the table the data will reside in. |
| Is Required | Not ever column that you pull over will be necessary in the load. You use this column to flag and filter your rows so you can focus on what needs to be loaded. |
| Notes | Here is here you notate any business logic or special information about the column such as if it's a source system key or a business key of some sort. |



