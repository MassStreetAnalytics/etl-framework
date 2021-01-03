# Having An Engineering Mindset

Flinging data around an organization is a problem that should be given the same due consideration as any other engineering challenge. Just because our building materials are 1s and 0s and nobody dies when stuff fails, does not mean you can develop processes any less rigorous than a civil engineer. 

You are building pipes through which data flows at 2/3rds the speed of light. Just like the physical world, those pipes have properties like pressure and volume. This means that we can put sensors on our system to measure these properties and to automatically alert us to a problem. 

Think of it in terms of monitoring a pressurized heavy-water reactor. You want to manually monitor systems and get ahead of problems, but there are so many parameters that it is humanly impossible to keep an eye on everything. So you stick a sensor on a pipe hooked to a loud alarm. This allows you to monitor overall health of the system instead of going crazy trying to keep an eye on every subsystem. 

Currently only a passive monitoring system is implemented. There are no automated negative feedback control mechanisms in place. An example of a negative feedback control mechanism might be noticing an excessive amount of records from prior days going unprocessed in staging tables and disabling the Agent Job responsible for pulling that data.

Having no automated negative feedback control systems in place is a serious limitation of the current version of the framework. To continue to use the reactor metaphor, this leaves your system open to risk of meltdown. The probability of experiencing a catastrophic system failure varies by organization but is highly positively correlated to the amount of attention upper management is paying to your data warehouse project.

For now, if you experience a meltdown, and the CFO wants to know where the data is, I highly recommended you just deny that there is graphite on the ground.

