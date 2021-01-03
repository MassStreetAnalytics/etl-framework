# Robust Processes

In the late 90s, I was reading an article in the KSU Collegian about a software competition a team from our CS program won. The last line of the article has stuck with me all these years. "And the output was robust."

What does that even mean? I got a 34 on the reading section of the ACT and I could not even pull the meaning from context.

It means that when things went wrong, the software was able to handle it. The author's word choice was atrocious and driven by computer science lingo instead of everyday language. But I didn't learn my lesson so now I am going to use an obscure metaphor to describe the framework.

![The DW ETL Framework is the A-10 of frameworks.](../.gitbook/assets/286052_10100302703671379_5239600_o.jpg)

The framework is designed to take a beating and keep ticking. There is a full suite of error detection and recovery processes. As an example, the SQL Server Agent jobs that run the load are highly modular. There is a standard retry process if a step blows up. If a step blows up, just go back and re-run that step without any kind of modification to code or having a separate recovery process.

This is what it means to be robust.

