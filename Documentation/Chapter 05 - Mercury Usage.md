# Welcome to the documentation for Mercury.

Mercury is a light weight, extensible application to move files around a network in support of data warehouse ETL. Mercury works within the ETL Framework and is an alternative to using SSIS or some other complex point and click ETL tool to accomplish the same task. 

There are three main parts of the application:

* The File Retriever
* The File Converter
* The File Processor

## How to use
Mercury uses the following Python packages that need to be pip installed before use:
* yaml
* os
* smtplib
* EmailMessage
* urllib
* Email
* Pandas
* sqlalchemy

All objects can be accessed from the ETL file. To import an Object use the following:  
>`from ETL import 'ETL Process you wish to use'`

## Config file

This project uses a .yaml file to hold config settings for the database connection and the email notifications.

### Database

dns: Since this is a mssql application you should have a dns setup to connect with your database. Enter your dns here.

### Email



