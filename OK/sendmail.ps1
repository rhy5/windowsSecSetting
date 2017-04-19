<#
    功能:邮件发送脚本
    作者:二师兄
    时间:2017年3月24日
    email: lovecoding@ntoskrnl.cn

 #>

param( 
[string]$type="",
[string]$toAddress = "",
[string]$Subject = "" ,
[string]$body = "" ,
[string]$file = "") 

$ss=ConvertTo-SecureString -String "caoni1314" -AsPlainText -force 
$cre= New-Object System.Management.Automation.PSCredential("jbama0@163.com",$ss)
Send-MailMessage -From "监控$type  jbama0@163.com" -To "$toAddress"  -Subject "$Subject" -Body "$body" -Attachments "$file" -Priority High -dno onSuccess, onFailure -SmtpServer "smtp.163.com" -Credential $cre -Encoding utf8

