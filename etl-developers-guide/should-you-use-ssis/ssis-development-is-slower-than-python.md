# Python Development Is Faster Than SSIS

I was speaking with a consultant from a third-party firm a client of mine had hired to lend some extra hands to our data warehouse build out project. These guys did not report to me, so we had to have daily meetings to make sure we deconflicted our various areas of responsibility.

During one of these meetings, the consultant said something that made my left eyebrow start to challenge well established altitude records. I was telling him about how I had taken SSIS out of the client’s data warehouse ETL processes and I did not want any more SSIS packages developed.

I was telling him how developing ETL with pure T-SQL orchestrated by SQL Server Agent was superior to SSIS. I am not sure how exactly we got there, but at one point, and with NO sarcasm whatsoever, he says this:

“We use SSIS because we want our junior people to develop the packages because it’s easier for them than writing SQL. That’s how consulting works.”

Jigga what?

First of all, no. I bring my A-team to client engagements and my A-team brings their A-game. There is no JV in business analytics.

Secondly, I reject the premise of the statement. Developing ETL with T-SQL and Python is actually easier than developing SSIS packages. This is not even about developer seniority. I can take a kid with nothing but a high school diploma and no IT experience off the street and have him developing high performing ETL for medium data use cases in a week.

In order to work with databases, you have to know SQL. T-SQL is just an extension of ANSI SQL so the jump from one to the other is not that large. SSIS is this extra thing you have to learn on top of your existing SQL skills. Additionally, SSIS can be rather complex and it takes a while to learn how to create even decently performing packages. Why? Why do that extra work that does not even really gain you any performance benefit?

You could run the argument that Python has a steep learning curve and is harder to learn than SSIS. In reality, Python should have a light footprint in your ETL processes, and you can learn everything you need to know about how to do ETL with Python in a few hours. By that I do not mean an initial set of information to get you started and you get better over time. I mean EVERYTHING you would ever need to know about moving data around on disk outside of SQL Server with Python can be learned in a few hours. Compare that to SSIS which can take months to get good at and years to master enough to be able to tackle any scenario thrown at you.

When you open up an SSIS package, it has to go through all these validation steps before you can start working on your process. If the package does not validate, you have to burn precious minutes or hours trying to figure out why your package will not validate. Sure, you can turn package validation off, but that is not the best of ideas. Why do packages stop validating when you have not even made changes to them? Who knows? What I do know is that T-SQL and Python do not suffer from this problem.

While we are at it, I would mention that you have to develop SSIS packages with a specific integrated development environment \(IDE\). Getting this IDE can be something of a pain because Microsoft likes to play a shell game where you are never quite certain what exactly you need to build SSIS packages. Is it SSDT? Is it Visual Studio? Is it a plug in to Visual Studio? What is Visual Studio Shell? Is that full VS? What exactly is VS Shell \(Integrated\) and why is it now four different downloads in two different places just to build SSIS packages??! 

SERIOUSLY?!

You can develop Python and T-SQL using any IDE you want that will support development in those languages. If you are really cool, you do not even need an IDE. Since both T-SQL and Python are scripting languages that do not need to be compiled, you can develop code with a text editor. If you have a data source name set up, you can execute SQL with Python and all you need is a text editor and the command line.

SQL Server Management Studio \(SSMS\) is a nice tool, but you can use any ODBC compliant editor to connect to SQL server. Last I checked, SQuirreL SQL Client is a good example of this.

Ironically, the seeming ease of use of SSIS encourages junior ETL engineers to build things using anti-patterns. In other words, they create things that are horrific to maintain and there is nothing stopping them especially if there is no senior person around to guide them and/or there is no published style guide for them to follow.

On the other hand, both T-SQL and Python have hard wired rules about how you are supposed to do things. You do not need a senior engineer or style guide \(even though one for T-SQL would be helpful\). The style guide is built into the languages.

T-SQL is a little bit more open, but Python has hard core rules about how it is supposed to look and be developed. If you do not follow those rules, the interpreter will generate a syntax error. You can set a kid down at a machine and be reasonably certain that they are not going to develop a bunch of unreadable junk in Python. Less certain with T-SQL but it really does not matter. Either of those languages are much cleaner and easier to develop processes with than SSIS because of the hard and fast rules built into their respective interpreters.

Python and T-SQL is bumper cars. Letting a junior person write your warehouse ETL with SSIS is like handing the keys to your Porsche to a teenager. Yeah, they are going to go real fast for a bit. But they are going to wind up wrapping it around a pole. By that I mean, they are going to develop brittle, hard to maintain processes. With a little bit of training, that will not happen with Python or T-SQL.

Just to hammer this point home, if I want to loop over some files and perform some file functions, the process for doing that in SSIS is unbelievably complex. Literally unbelievably. You have to use two different tasks. Setting up the Foreach Loop Container takes forever and requires the creation of some variables. Then you have to set up the File System Task. That requires the creation of some more variables, so you have enough flexibility to build file paths and move the files from here to there. You have to be careful about move versus copy because their input parameters are not consistent. Do you need to give it a file name or just a file path? Which requires which? Good lord.

The equivalent process in Python is three lines of code. That is it. Maybe seven lines if you want to get fancy. In either case, it takes all of 20 seconds to set that up and test. In SSIS, just pulling over the task and container, and opening up the configuration on the File System Task will take more than 20 seconds.

So, no. SSIS is not easier to develop than T-SQL or Python. It is actually harder. The point and click interface is a total fake out and executives fall for it all the time much to their detriment.

