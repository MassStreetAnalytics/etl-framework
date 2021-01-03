--View information about current users, sessions, and processes
EXEC sp_who2

--see how long it will take for
--a rollback to complete
KILL [SPID] WITH STATUSONLY
--Example
KILL 59 WITH STATUSONLY

--Kill open transactions
DBCC opentran
KILL [SPID]
--Example
KILL 59

