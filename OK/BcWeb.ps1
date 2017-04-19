<#
    功能:web目录监控脚本
    作者:二师兄
    时间:2017年3月24日
    email: lovecoding@ntoskrnl.cn

 #>

$curScriptPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition).ToString()
cd $curScriptPath
$webpath="c:\web" #配置需要监控文件变化的目录
$safeweb="c:\web1" #设置部署时的文件夹
$report ="./report.html"
$script="./test2.txt"
$hostname=hostname
if(Test-Path $report)
{
    del $report
}

.\bc\BComp.com  "@$script" $safeweb $webpath $report

.\sendmail.ps1 -type "WebFiles" -toaddress "444959314@qq.com" -subject "$hostname web文件对比报告" -body "请查看附件" -file "$report"