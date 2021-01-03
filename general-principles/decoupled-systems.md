# Decoupled Systems

The formal term for decoupled systems is separation of concerns. To rip off a truck commercial, software should do one thing and do it well. 

People new to loading data warehouses have a habit of creating one monolithic process especially if they are using SSIS. This is a poor approach for several reasons.

* If one thing breaks, the whole thing breaks.
* If you have to fix one thing, you have to redeploy the entire thing.
* Finding the broken thing in the first place can be a challenge.
* Having more than one person work on the load can be a challenge even with modern source control.

The list goes on but you get the point. Instead of creating monolithic processes, the framework breaks things down based on a Unix philosophy of many small programs working together.

Each process is isolated and executes separately from other processes. Each process is executed by a single stored procedure. That stored procedure does one thing and one thing only. It also does not depend on another process executing properly. If a previous step does not run, then the proc will still run just nothing happens if there is nothing to process. This is important in the case where a previous step does not run, and yet there is still data to process. You will find this handy during error recovery procedures.

Decoupled systems is one of the highest value aspects of the framework. It solves the problems created by monolithic processes. It reduces  maintenance and speeds up error recovery to say nothing of speeding up development time for new processes including greenfield ones.

