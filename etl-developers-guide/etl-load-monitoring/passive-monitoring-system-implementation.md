# Passive Monitoring System Implementation

The passive monitoring system is implemented as a small application within the larger framework. It records the load levels and sends out alerts based on the tolerances you set. 

The passive monitoring system is set it and forget it. As long as you set it up right, you do not have to make code changes when you add new fact tables. The system will automatically begin recording loads on new tables.

Since the system works on historical loads, you have to give the system time to stabilize to normal levels. As part of this process, you need to make sure you remove any historical loads from the tables, otherwise the dataset will be thrown off. Automating the removal of historical loads is an area for improvement.

The specific set up is discussed in [Sample Script Guide](../../untitled-1/) and [Building Out Your Data Warehouse](../../building-out-your-data-warehouse/). 

 The passive monitoring system consist of the following database objects.

| Object Name | Object Type | Function |
| :--- | :--- | :--- |
| vol.Tables | Table | Holds a list of fact tables that the load monitors. |
| vol.LoadObservations | Table | Holds the history of observations for the load. |
| usp\_RecordRowCounts | Stored Proc | Populates the volumetric tables. |
| usp\_TableLoadMonitoring | Stored Proc | Sends out email alerts of anomalous events. |
| usp\_LoadTableLoadReportingTable | Stored Proc | Populates a flat table of the nightly load report. |



