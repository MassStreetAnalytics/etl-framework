# Data Flow Design

## Elegant Simplicity

Data flows into the data warehouse though ODS and ODS only. ODS is the front door to the system and this should always remain true to ensure ease of system maintenance.

Agent jobs that manage the warehouse load are named in order of execution. This pattern should also never drift far from its initial state. You can insert extra items, but the ordinal relationships need to be set in stone. As an example, fact tables should never process before dimension tables.

All the steps in the warehouse load are loosely coupled meaning you can run all the steps independently with the proviso that that prior step ran at some point. In other words, if one step blows up, you do not have to go back and run the entire process. That said, once you get familiar with the process, the fastest way to fix things usually is to blow away staging, re-pull specific data, and rerun everything.

Data flows into the data warehouse in the following manner. In all cases, you are only processing data flagged as cleaned, unprocessed, and error free.

1. Data is pulled from source systems into a specific staging table in ODS.
2. The data is cleaned.
3. Data from your systems EDW dimensions are pulled into the common model in ODS.
4. Existing dimensional data is compared to incoming dimensional data and actions are taken based upon the rules surrounding a particular dimension and loaded into Production.
5. Dimensional fields used to identify records are flushed back to ODS for matching with facts.
6. Fact records are matched up with their dimensions and loaded into the common model.
7. The common model is flushed to production.

## **Avoiding Overengineering**

In Medium Data™ use cases it is frequently the case that the amount of data that is loaded over night does not require certain performance enhancing techniques. A good example is writing code that drops indexes before loading and puts them back after. 

That is a fairly common technique, but you have to weigh the action of dropping and rebuilding the index against the load time of not performing the operations on the index. If the performance increase against the expected load is incremental, then you are actually increasing IT spend by creating complexity where none need exist. 

