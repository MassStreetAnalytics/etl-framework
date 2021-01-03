# Loading Historical Data

Loading historical data is built into the framework. However, here is where you need to be aware of limitations of the framework.

Normally, historical loads take place by deleting everything in the fact table. Since the framework checks for what is there vs what isn't there, if the table is empty, the entire history of the fact table will get pulled from the source system if it is available.

However, this only works if the amount of historical data is something less than double digit millions. Once you cross the line into more than 10MM records, you may have to get creative on your warehouse load.

10MM records is arbitrary and based on my personal experience. It's really a function of the hardware that you are running on. 10MM is not remotely close to "big data" but it is enough to choke your box.

If your load does not perform using the framework, you will have to go off the beaten path. I provide some help here in terms of some PySpark scripts. However, due to the fact that loading large amounts of historical data is very use case specific, there is no way we can generalize an approach at this time.

As a suggestion, try to design your load so loading the fact tables can be done with a BULK INSERT process.

