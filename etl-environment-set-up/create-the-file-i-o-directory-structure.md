# Create The File I/O Directory Structure

When you have to process import files or output files back to users or third parties, there is a directory structure for you to do that. You will need to replicate this structure by creating the root directories. You can name the root directory to whatever makes sense for your organization.

Files are handled in two separate areas. Files that are inputs or outputs of the data warehouse are placed on a server where third parties can access them. This server should be an edge server or something that is exposed to the internet. It should NOT be on the data warehouse box.

Actual file processing takes place on the warehouse box. Files are moved back and forth from the file exchange to the data warehouse box.

ETL process names should not be cryptic. They should be as descriptive as possible. When you create a new project in SSDT your project name should match the name of the directory.

Inside of each process directory you create should be an In and Out folder. The In folder should be where you import files from other processes. The Out folder is the result of any processing done in ETL processes where the output is a flat file. You can create whatever file structure necessary to facilitate your process inside of the In/Out folders as long as the base structure exist. In the warehouse processing directory, in addition to In and Out folders in the ETL process folder is also an Archive folder.

The format of the folder structure for processing files is as follows.

**Internal Customer And Third Party Landing Pad Directory**

\[Drive letter\]:\FileExchange\\[Business Unit\] \| \[Third Party\]\\[ETL Process Name\]\\[In \| Out\]

A sample directory structure can be found in: 

etl-framework\Sample Directory Structures\Warehouse File IO

**Warehouse Processing Directory**

\[Drive letter\]:\InterfaceAndExtractFiles\\[Business Unit\] \| \[Third Party\]\\[ETL Process Name\]\\[In \| Out \| Archive\]

A sample directory structure can be found in: 

etl-framework\Sample Directory Structures\File Processing And Storage

