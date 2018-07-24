# Mercury API


## FileRetriever()


This object is responsible for downloading data files from a remote source and saving it on your local machine.

### Functions

    download_file(url, target)
        This function actually downloads the file(s)

        url - The url for the data file to be downloaded.

        target - The location to download the file. Use relative paths.
            Default - 'FileDepot/In'
    

***
## FileConverter()


  This Object takes all files from the landing folder, converts them to a .csv if necessary, and moves them into the processing folder for later use.

> Currently supported file extentions:
> * .csv  

### Functions

    convert_files(source, target)
        This function interates over all files in folder and creates an object appropriate to the file extention that will convert the file if necessary and move it to a processing folder.

        source - Where the files to be converted are. Uses relative paths.
            Default - 'FileDepot/In'

        target - The location of the processing folder. Uses relative paths.
            Default - 'InterfaceAndExtractFiles'

***
## File Processor()

This object takes files from a processing folder, moves them to a staging table using pandas and mssql, adds or updates a timestamp, and moves the file to an archive folder.

### Functions

    move_file(file, source, target, timestamp_file(optional))
        Moves the files from the processing folder, adds a timestamp, and places it into the archive folder

        file - file to be moved.

        source - Where the file is located. Uses relative path.

        target - Where the file will be moved to. Uses relative path.

        timestamp_file - Use if you want to use your own timestamp or file name when moving to the archive folder
</br>

    add_timestamp(file, stamp(optional))
        Adds a timestamp to a filename.

        file - File to add timestamp to.

        stamp - Use if you want to use your own timestamp or ending
</br>

    stage_data(file, source, schema(optional))
        Stages data into SQL Server DB

        file - File to be staged to DB

        source - Where the file is located

        schema - Help organize data in DB
            Default - 'qdl'
</br>

    process_files(source, target)
        Iterates over a folder, stages data, and archives folder

        source - Folder to iterate over
            Default - 'InterfaceAndExtractFiles'

        target - Folder to archive data
            Default - 'Archive'



## How to use

All objects can be accessed from the ETL file. To import an Object use the following:  
>`from ETL import 'ETL Process you wish to use'`

## Config file

This project uses a .yaml file to hold config settings for the database connection and the email notifications.

### Database

dns: Since this is a mssql application you should have a dns setup to connect with your database. Enter your dns here.

### Email



