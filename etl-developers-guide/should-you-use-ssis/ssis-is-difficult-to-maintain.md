# SSIS Is Difficult To Maintain

When I design ETL processes, I think about high performance fighter aircraft. Sound weird? What do F-16s and ETL processes have in common? Maintenance requirements.

If you get a close look at many modern fighter aircraft, you will notice that the skin of the aircraft is covered in what are clearly panels. You can tell a panel by the outline of the screws you have to undo to remove the panel. These panels are maintenance access hatches. They allow easy access to aircraft systems.

On some older aircraft, in order to maintain some systems, you have to remove other systems that are in the way. In particular, I am thinking of the T-38 where you have to remove the engines to perform certain maintenance functions. The engine does not need fixed, but you have to take it out anyway because the broken system is buried in the fuselage and not near a maintenance access hatch.

I build my ETL processes with a lot of maintenance hatches. When things break, I do not want to have to remove the engine to change a hydraulic line. I just want to pop open a hatch, swap out the bad part, put the hatch back, and start generating sorties.

SSIS is a hot mess. A lot of the things I have talked about are difficult to impossible to implement with SSIS. Trying to maintain existing processes is a nightmare.

When something breaks in SSIS, you have to open up the package in the IDE which can be a nightmare all its own. Tracking down the error in the system logs, makes you feel like Nicolas Cage’s character in National Treasure, and that is assuming you get good error information at all.

SSIS has a system of event handlers. These are actions that take place when certain events occur. The interface for managing event handlers is not well implemented. Trying to find an event handler, well, let us just say that I have solved a Rubik’s Cube faster.

Like I mentioned above, SSIS allows junior engineers to create anti-patterns. A better way to put that is, SSIS allows junior engineers to create unnecessarily labyrinthine packages. They will have task all over the place like some digital Gordian Knot. It will make the wires on your home entertainment center look like a paragon of organization. They will have packages calling other packages. They will use SSIS as an orchestration tool which just unnecessarily adds another layer of orchestration. They will write a huge monolithic package that does everything instead of breaking things down into atomic task that are identical independently executing processes.

You can and should build your SSIS packages to call stored procedures. However, if a stored procedure is busted, you cannot just push the fix. Sometimes, alterations to stored procs require that you add columns to the output query \(the last select statement in a proc\). Any change to the columns of the output query result in new metadata. SSIS reads the metadata from stored procs. If the metadata that it is reading, does not match what it expects, SSIS will error out.

In order to fix it, you have to open up SSIS, go to the data flow tab, open up either the source or the destination task and refresh the metadata. Then you have to redeploy the package. And I ask you. Why? Why do all that when you can just fix the proc, go through change control, change your connection in SSMS, hit F5, and call it a day?

I have already talked about code deployment, but that topic also overlaps with maintenance issues. Getting SSIS packages promoted through your various environments is just harder than it needs to be.

Even if you have a senior SSIS engineer writing packages and that person knows all the tips, tricks, and tactics for writing relatively high performing packages, it still will not matter. SSIS just does not lend itself well to the concept of having many maintenance hatches that allow quick access to subsystems.

Do I sound a little nutty? That is because I have PTSD from dealing with poorly developed SSIS packages. You would not believe what I have dealt with over the years.

I cannot stress enough. Clean, high performing warehouse ETL. No SSIS. Use T-SQL and Python.

