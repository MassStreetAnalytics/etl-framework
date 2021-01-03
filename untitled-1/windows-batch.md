# Windows Batch

This is the script you use in SQL Server Agent jobs to execute Python from SQL Server Agent.

```text
python c:\temp\YourPythonScript.py

SET EXITCODE = %ERRORLEVEL% 
IF %EXITCODE% EQ 0 ( 
   REM Process completed successfully. 
   EXIT 0
)
IF %EXITCODE% EQ 1 (
   REM Process error.
   EXIT 1
)
IF %EXITCODE% EQ 2 ( 
   REM Custom error message.
   EXIT 2 
)
```

