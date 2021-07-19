sp_who2

dba_maint.dbo.sp_whoisactive

[dbo].[sp_AllNightLog]

[dba_maint].[dbo].[sp_BlitzAnalysis] @OutputDatabaseName = N'DBA_Maint'

[dbo].[sp_BlitzFirst]
/*Then, run it with these options:
EXEC sp_Blitz @CheckUserDatabaseObjects = 0, @CheckServerInfo = 1;

These two parameters give you a server-level check without looking inside databases (slowly) for things like heaps and triggers.
*/
[dbo].[sp_Blitz]



--Somebody has been messing with your trace files. Check the files are present at C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Log\log.trc




[dbo].[sp_BlitzCache] @databasename = [ankura_dw]

