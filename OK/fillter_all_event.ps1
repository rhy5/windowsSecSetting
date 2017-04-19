# calculate start time (one hour before now)
$Start = (Get-Date) - (New-Timespan -Hours 24)
$Computername = $env:COMPUTERNAME
$filename = $Start.Year.ToString()+$Start.Month.ToString()+$Start.Day.ToString()
$curScriptPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition).ToString()
$logPath =$curScriptPath+"/"+"$ComputerName-$filename.csv"

# Getting all event logs
Get-EventLog -AsString -ComputerName $Computername |
  ForEach-Object {
    # write status info
    #Write-Progress -Activity "Checking Eventlogs on \\$ComputerName" -Status $_
 
    # get event entries and add the name of the log this came from
    Get-EventLog -LogName $_ -EntryType Error,Warning,SuccessAudit,FailureAudit -After $Start -ComputerName $ComputerName -ErrorAction SilentlyContinue |
      Add-Member NoteProperty EventLog $_ -PassThru
 
  } |
  # sort descending
  Sort-Object -Property TimeGenerated -Descending |
  # select the properties for the report
  Select-Object EventLog, TimeGenerated, EntryType, Source, message | Format-List |
  Out-File -FilePath $logPath -Encoding UTF8  

  cd $curScriptPath
  .\sendmail.ps1 -type "system_log" -toaddress "444959314@qq.com" -subject "$Computername 系统所有日志" -body "请查看附件" -file $logPath

  exit