Module for general file processing

file_processing: handles general file proceessing
orm: manages connection to DB and all the call to the DB
config: holds the info for the DB and email connections


TODOS
1. Generalize process for file conversion
2. Detect timestamp if reprocessing
3. Decide on naming convention
4. Add timestamp to filename
5. Write functions to move data into staging tables using the orm
6. General error handling including emailing