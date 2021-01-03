# Record Count

Whenever you are working with a new dataset, the first thing you want to do is to get a record count. The record count will help you determine if you have what you need in terms of software and hardware to process the data. 

As a general rule of thumb for SQL Server:

| Record Count | Recommendation |
| :--- | :--- |
| x &lt; 10MM | Good to go. |
| x &gt; 10MM | You may want to add Apache Spark to the historical load. |

This tab has four columns.

| Column Name | Definition |
| :--- | :--- |
| Scenario | This column has predefined drop down values and explains the where the data is coming from. |
| Processing Paradigm | This column has predefined drop down values and explains how the data is processed. |
| Frequency  | This is a free form column and explains how frequently the data is processed. |
| Record Count | How many records you will pull back on the historical load. |

The values for the Scenario column are defined as:

| Drop Down Value | Definition |
| :--- | :--- |
| From Database | This process is pulling data from another database. |
| From File | This process imports a flat file. |
| From Kafka Producer | The process pulls data from a Kafka Producer. |
| From Spark Streaming | This is a real time stream process that sources data directly from Apache Spark. |

The values for Processing Paradigm are defined as:

| Drop Down Value | Definition |
| :--- | :--- |
| Batch | Data is processed on a schedule and the data available is all the data that has piled up since the last run. Everything is processed at once. |
| Stream | Data is processed continually in a real time process. |
| Micro batch | Data is processed on an interval more frequent than batch but is not a real time process. With the advances in technology, micro batching is becoming rare. However, it is a good intermediate solution when your organization looks to start moving towards real time data. Processing data more frequently throughout the day even on intervals as long as 5 minutes can represent a drastic improvement in reporting efficiency. |

