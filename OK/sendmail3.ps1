param( 
[string]$type="",
[string]$toAddress = "",
[string]$Subject = "" ,
[string]$body = "" ,
[string]$file = "") 

$ss=ConvertTo-SecureString -String "caoni1314" -AsPlainText -force 
$cre= New-Object System.Management.Automation.PSCredential("jbama0@163.com",$ss)
Send-MailMessage -From "监控$type  jbama0@163.com" -To "$toAddress"  -Subject "$Subject" -Body "$body" -Attachments "$file" -Priority High -dno onSuccess, onFailure -SmtpServer "smtp.163.com" -Credential $cre

