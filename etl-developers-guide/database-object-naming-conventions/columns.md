# Columns

All names should plainly and easily describe the information held in that column. There should be no abbreviations. 

Columns in staging tables need to conform to the naming conventions of the source system. As a matter of fact, the column names should be identical to the source system.

Columns in the reporting database should be named in a manner so that they are easily readable by users which usually just means putting a space in a column name.

Boolean columns should be named in such a way as though they were asking a question that starts with the word Is. For example:

1. IsProcessed
2. IsActive
3. IsRetired

A notable exception to this rule is the Processed column in stage tables. A lot of stuff runs on Processed and I am far to lazy to go through everything and change it for now.

If someone wants to set up a pool to guess how long before my OCD kicks in and I just fix it anyway, be my guest.

