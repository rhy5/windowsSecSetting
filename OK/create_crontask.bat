@echo off
set NAME=log_monitor
set TIME=08:01:00
set DAY=MON,TUE,WED,THU,FRI,SAT,SUN
set COMMAND1=powershell.exe -file %~dp0fillter_all_event.ps1

%SystemDrive%
cd %windir%\tasks\
if exist %NAME%.job del %NAME%.job

schtasks /create /tn %NAME% /tr "%COMMAND1%" /sc weekly /d %DAY% /st %TIME% /ru system


set NAME=bcweb
set COMMAND2=powershell.exe -file %~dp0BcWeb.ps1

%SystemDrive%
cd %windir%\tasks\
set MINUTES=5
if exist %NAME%.job del %NAME%.job

schtasks /create /tn %NAME% /tr "%COMMAND2%" /sc minute /mo %MINUTES% /ru system



set NAME=mssqllog
set COMMAND3=powershell.exe -file %~dp0mssql_exec_log_query.ps1

%SystemDrive%
cd %windir%\tasks\
if exist %NAME%.job del %NAME%.job

schtasks /create /tn %NAME% /tr "%COMMAND3%" /sc minute /mo %MINUTES% /ru system

pause