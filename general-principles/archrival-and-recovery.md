# Archrival And Recovery

In the scenario where the source of data is a database, pull processes are designed to check what you have vs. what exist in the source system. This allows for recovery of data by simply blowing away what you do not want in EDW and rerunning the pull process.

In the scenario where the source of data is a file, the framework provides a process to archive that file. During error recovery, the process of retrieving that file and loading the data warehouse is not as smooth as I would like. This is a scenario where an extra process is required because retrieving data from archived files is more complex than just yanking history back from a source system.

Even yanking data back from a source system may not be an option as many transactional systems do not even house historical data.

The part of the framework is not as built out as I would like because I have been spoiled in the past few years dealing with data solely sourced from databases.

