<#
    功能:监控MSSQL 查询语句
    作者:二师兄
    时间:2017年3月24日
    email: lovecoding@ntoskrnl.cn

 #>


#配置信息  
$Database   = 'master'  # 配置master库
$Server     = '192.168.92.129'   #数据库IP
$UserName   = 'SA'  #有master库的读取权限的用户
$Password   = 'sa123!@#'  #密码
$beginTime=(Get-Date).AddDays(-1).ToString('yyyy-MM-dd HH:mm') # 配置时间1天前 若要更改时间频率 如5分钟执行一次 则修改为(Get-Date).AddMinutes(-5)
$endTime=(Get-Date).ToString('yyyy-MM-dd HH:mm') #结束时间为当前时间 
$filename = (get-date).Year.ToString()+(get-date).Month.ToString()+(get-date).Day.ToString() +"_mssql_query_log.txt" #文件命名
$monitingWord = "aa" #配置监控字符串 
$curScriptPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition).ToString()
cd $curScriptPath

$SqlQuery                       ="SELECT QS.creation_time, ST.text FROM sys.dm_exec_query_stats QS  CROSS APPLY sys.dm_exec_sql_text(QS.sql_handle) ST WHERE 
                                QS.creation_time BETWEEN '$beginTime' AND '$endTime' AND ST.text  LIKE '%$monitingWord%' and NOT LIKE '%FROM sys.dm_exec_query_stats QS%' ORDER BY QS.creation_time DESC"
 
# Accessing Data Base
$SqlConnection                  = New-Object -TypeName System.Data.SqlClient.SqlConnection
$SqlConnection.ConnectionString = "Data Source=$Server;Initial Catalog=$Database;user id=$UserName;pwd=$Password"
$SqlCmd                         = New-Object System.Data.SqlClient.SqlCommand
$SqlCmd.CommandText             = $SqlQuery
$SqlCmd.Connection              = $SqlConnection
$SqlAdapter                     = New-Object System.Data.SqlClient.SqlDataAdapter
$SqlAdapter.SelectCommand       = $SqlCmd
$set                            = New-Object data.dataset
 
# Filling Dataset
try{
$countRows =0
$countRows=$SqlAdapter.Fill($set) 
}
catch {
Write-Host $countRows
.\sendmail.ps1 -type "mssql" -toaddress "444959314@qq.com" -subject "数据库连接错误" -body "$Server 服务器连接错误 请登陆查看!" -file　"./$filename"
break

}
$set.Tables |Format-list |Out-File -FilePath "$curScriptPath/$filename" -Encoding utf8
# 对监控的返回值进行判断 可以调用发送email 的脚本 并发送通知。
if($countRows -ne 0 )
{
    .\sendmail.ps1 -type "mssql" -toaddress "444959314@qq.com" -subject "$monitingWord 有操作记录" -body "$monitingWord 有数据库操作语句 请登陆服务器 $Server 进行检查" -file "./$filename"
}
else
{
	 .\sendmail.ps1 -type "mssql" -toaddress "444959314@qq.com" -subject "$monitingWord 暂无操作" -body "$Server服务器 $monitingWord 暂无操作 请勿担心" -file　"./$filename"
}
