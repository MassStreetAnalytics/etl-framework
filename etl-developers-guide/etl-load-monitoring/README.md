# Feedback And Control Systems

Every ETL process I build has the ability to monitor itself. Aside from the basics of reporting errors, there is a process that monitors the daily delta of the records in the tables. In order to make this happen, I use some basic time series analysis and I borrow a few things from the electrical engineering subject of feedback and control systems.

What I wound up with is a system that knows when tables have not been loaded, or if their load is outside what would be considered normal. 

All the system does is report. It is agnostic to the nature and magnitude of events because there might be good reasons for anomalies. It relies on human interpretation of the data and takes no action on its own.

You may think that is of no value. Let me tell you, when the CFO has a habit of breathing down your neck to get out the daily canned reporting even when its 5 seconds behind schedule, its nice to be able to just fix issues before the CFO even knows about it. Forewarned is forearmed.







