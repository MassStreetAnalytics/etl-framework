# Demand Pull

Demand pull processes are trigged by the data warehouse environment. The grand majority of your processes should be demand pull.

Demand pull is when the system reaches out to other systems on a schedule defined by whatever is stet in your specific orchestration tool. The key element being that the data warehouse box has access to the remote system. For example, a database to database pull that is executed via a linked server.+

A process that looks for a file that was placed in a folder is not a demand push process even though it may have been initiated by the orchestration tool. That is actually a supply push process which we will talk about next.







