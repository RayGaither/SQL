declare @prevAdvancedOptions int
declare @prevXpCmdshell int

select @prevAdvancedOptions = cast(value_in_use as int) from sys.configurations where name = 'show advanced options'
select @prevXpCmdshell = cast(value_in_use as int) from sys.configurations where name = 'xp_cmdshell'

if (@prevAdvancedOptions = 0)
begin
    exec sp_configure 'show advanced options', 1
    reconfigure
end

if (@prevXpCmdshell = 0)
begin
    exec sp_configure 'xp_cmdshell', 1
    reconfigure
end

/* do work */

if (@prevXpCmdshell = 0)
begin
    exec sp_configure 'xp_cmdshell', 0
    reconfigure
end

if (@prevAdvancedOptions = 0)
begin
    exec sp_configure 'show advanced options', 0
    reconfigure
end
