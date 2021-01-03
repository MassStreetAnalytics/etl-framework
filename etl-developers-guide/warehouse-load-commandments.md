# Warehouse Load Commandments



**Thou shalt not put stand-alone codes in the database.** 

Always import code values along with their English explanations if possible.

**Thou shalt not put data into generically named columns like Value1 and Value2.** 

Every single column should have a clear and understandable name such that the meaning of the values in that column are entirely unambiguous even without having to consult the data dictionary.

**Thou shalt not use 1 or 0 to represent Boolean values.** 

Use only “Yes” and “No”.

**Thou shalt not place textual filter data into fact tables.**

**Thou shalt not place dates into fact tables without an appropriate connection to a date dimension.**

The exception here is datetime stamps. When you need high temporal precision, datetime can exist as a degenerate dimension.

**Thou shalt not allow flags and acronyms into the database if possible.** 

Systems are usually filled with all kinds of flags and other acronyms that require expertise to decipher. Usually a front end will decode these flags for a user. These values do not belong in the data warehouse and need to be translated as part of the cleansing process.

