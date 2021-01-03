# Install Anaconda

We use Python to move data instead of SSIS which is super clunky. You need to install Python and some dev tools if you have not already.

**Step 1**

Download and install Python 3.7. Make sure you install the software in such a manner that the entire machine has access to it, not just your account.

{% embed url="https://www.anaconda.com/distribution/" %}



**Step 2 \(optional\)**

If you don’t have a Python IDE, download and install the community edition of PyCharm.

{% embed url="https://www.jetbrains.com/pycharm/" %}



**Step 3**

After installing python, reboot SQL Server Agent or the whole SQL Server if you can. The reboot is necessary for SQL Server Agent to load new environment variables, including the updated PATH with Python in it.  


