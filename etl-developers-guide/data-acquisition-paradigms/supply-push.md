# Supply Push

Supply push processes are initiated by processes external to the data warehouse. The general scenario here is data is usually dropped by a 3rd party into a folder that sits on an edge server. That folder is then scanned by data warehouse processes and moved into the InterfacesAndExtracts folder.

Supply push processes should be rare and only done when there are no other options. A good example are bank feeds like bank reconciliation files. Those are published are published by the bank and the data warehouse does not have the ability to pull the data from the source system.

The data warehouse may be used by another systems supply push process by publishing data for other systems to consume without directly accessing the database. However, more and more I'm seeing this actually turning into demand pull processes as organizations open their data through REST APIs.

