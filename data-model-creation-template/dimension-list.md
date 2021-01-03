# Dimension List

Ok now we're getting into some spreadsheet magic. This tab feeds other tabs and it's important that it is filled out correctly.

On all auto populated columns, simply drag down until you have values equal to the values in column A.

| Column Name | Usage |
| :--- | :--- |
| Physical Dimension Name | This is a list of all the physical dimensions used in the model. This is important because physical dimensions like DimDate that function as role play dimensions will show up more than once in this list. |
| Physical Dimension Key Column | This is an auto populated column. |
| Logical Dimension name | This is the logical name for dimensions and will be the same as column A unless it is a role play dimension. |
| Logical Dimension Key Column | This is an auto populated column. |
| Unique Row Identifier | This holds the column that this dimension uses to identify unique rows when it gets loaded. If it's a junk dimension, it will be RowHash. Most other dimensions will be SourceSystemKey except for the occasional edge case. |
| Row Identifier Data Type | This is an auto populated column. |
| Dimension Number | This is an auto populated column. |

