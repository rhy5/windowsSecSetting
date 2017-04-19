<#
    功能:自动设置windows 2008 基本安全权限
    作者:二师兄
    时间:2017年3月24日
    email: lovecoding@ntoskrnl.cn

 #>


<# 设置磁盘根目录 #>
$localDrives = [Environment]::GetLogicalDrives()
foreach($curDrive in $localDrives)
{
    <# 设置根目录 administrators system 完全控制 #>
    Write-Host 正在设置$curDrive 根目录权限 -ForegroundColor Yellow
    ./SetACL.exe  -on $curDrive -ot file -actn ace -ace "n:system;p:full;i:so,sc" -ace "n:administrators;p:full;i:so,sc" | Out-Null
    ./SetACL.exe  -on $curDrive -ot file -actn trustee -trst "n1:everyone;ta:remtrst;w:dacl,sacl" | Out-Null <# 删除everyone 权限#>
    if($LASTEXITCODE -eq 0)
    {Write-Host "$curDrive 根目录权限设置成功" -ForegroundColor Green}
    else
    { Write-Host  "$curDrive 权限设置失败 请检查确认" -ForegroundColor red} 

    <# 删除users creator owner组权限#>
    ./SetACL.exe  -on $curDrive -ot file -actn trustee -trst "n1:Users;ta:remtrst;w:dacl,sacl" | Out-Null
    ./SetACL.exe  -on $curDrive -ot file -actn trustee -trst "n1:creator owner;ta:remtrst;w:dacl,sacl" | Out-Null
    sleep 2
}

<# C:\Inetpub  #>
Write-Host 正在设置C:\Inetpub 权限 -ForegroundColor Yellow
./SetACL.exe  -on "C:\Inetpub" -ot file -actn trustee -trst "n1:users;ta:remtrst;w:dacl,sacl" | Out-Null <# 删除users 权限#>
sleep 1

Write-Host 正在设置C:\Inetpub\temp 权限 -ForegroundColor Yellow
./SetACL.exe  -on "C:\Inetpub\temp" -ot file -actn ace -ace "n:users;p:read,read_ex;i:so,sc" | Out-Null <# 添加users 读取，读取和执行权限#>
sleep 1

Write-Host 正在设置C:/Inetpub/wwwroot 权限 -ForegroundColor Yellow
./SetACL.exe -on "C:/Inetpub/wwwroot" -ot file -actn ace -ace "n:users;p:read,read_ex;i:so,sc" | Out-Null <# 添加users 读取执行权限#>
sleep 1

Write-Host 正在设置C:/Inetpub/wwwroot/aspnet_client 权限 -ForegroundColor Yellow
./SetACL.exe -on "C:/Inetpub/wwwroot/aspnet_client" -ot file -actn ace -ace "n:users;p:read;i:so,sc" | Out-Null <# 添加users 读取权限#>
./SetACL.exe -on "C:/Inetpub/wwwroot/aspnet_client" -ot file -actn trustee -trst "n1:everyone;ta:remtrst;w:dacl,sacl" | Out-Null  <# 删除everyone 读取权限#>
sleep 1

<# c:/users #>
Write-Host 正在设置C:/users 权限 -ForegroundColor Yellow
./SetACL.exe -on "C:/users" -ot file -actn ace -ace "n:users;p:read,read_ex;i:so,sc" | Out-Null <# 添加users 读取执行权限#>
./SetACL.exe -on "C:/users" -ot file -actn trustee -trst "n1:everyone;ta:remtrst;w:dacl,sacl" | Out-Null <# 删除everyone 权限#>
sleep 1
<# 
C:\Program Files
C:\Program Files (x86) 
#>
Write-Host 正在设置C:\Program Files 权限 -ForegroundColor Yellow
./SetACL.exe  -on "C:\Program Files" -ot file -actn setowner -ownr "n:administrators" | Out-Null
./SetACL.exe  -on "C:\Program Files" -ot file -actn trustee -trst "n1:users;ta:remtrst;w:dacl,sacl" | Out-Null <# 删除users 权限#>
./SetACL.exe  -on "C:\Program Files" -ot file -actn trustee -trst "n1:creator owner;ta:remtrst;w:dacl,sacl" | Out-Null <# 删除creator owner 权限#>
./SetACL.exe  -on "C:\Program Files" -ot file -actn trustee -trst "n1:TrustedInstaller;ta:remtrst;w:dacl,sacl" | Out-Null <# 删除TrustedInstaller 权限#>
sleep 1

Write-Host 正在设置"C:\Program Files (x86)" 权限 -ForegroundColor Yellow
./SetACL.exe  -on "C:\Program Files (x86)" -ot file -actn setowner -ownr "n:administrators" | Out-Null
./SetACL.exe  -on "C:\Program Files (x86)" -ot file -actn trustee -trst "n1:users;ta:remtrst;w:dacl,sacl" | Out-Null <# 删除users 权限#>
./SetACL.exe  -on "C:\Program Files (x86)" -ot file -actn trustee -trst "n1:creator owner;ta:remtrst;w:dacl,sacl" | Out-Null <# 删除creator owner 权限#>
./SetACL.exe  -on "C:\Program Files (x86)" -ot file -actn trustee -trst "n1:TrustedInstaller;ta:remtrst;w:dacl,sacl" | Out-Null <# 删除TrustedInstaller 权限#>
sleep 1

<# 删除cmd的执行权限#>
Write-Host 正在设置cmd.exe 权限 -ForegroundColor Yellow
./SetACL.exe  -on "C:\windows\system32\cmd.exe" -ot file -actn setowner -ownr "n:administrators" | Out-Null
./SetACL.exe  -on "C:\windows\system32\cmd.exe" -ot file -actn trustee -trst "n1:users;ta:remtrst;w:dacl,sacl" | Out-Null <# 删除users 权限#>
./SetACL.exe  -on "C:\windows\syswow64\cmd.exe" -ot file -actn setowner -ownr "n:administrators" | Out-Null
./SetACL.exe  -on "C:\windows\syswow64\cmd.exe" -ot file -actn trustee -trst "n1:users;ta:remtrst;w:dacl,sacl"| Out-Null <# 删除users 权限#>
sleep 1
<# 删除powershell 的执行权限#>
Write-Host 正在设置PowerShell 权限 -ForegroundColor Yellow
./SetACL.exe  -on "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -ot file -actn setowner -ownr "n:administrators" | Out-Null
sleep 1

<#  
./SetACL.exe  -on "C:\Windows\winsxs" -ot file -actn setowner -ownr "n:administrators" -rec cont_obj  
.\SetACL.exe  -on "C:\Windows\winsxs" -ot file -actn ace -ace "n:users;p:read_ex;i:so,sc;m:deny" -rec cont_obj
    C:\Windows\Media
    C:\Users\Default\AppData\Roaming\Microsoft\Windows\Network Shortcuts 
    C:\Users\Administrator\AppData\Roaming\Microsoft\HTML Help
    C:\Users\Administrator\AppData\Roaming\Microsoft\Crypto\RSA 
    C:\Users\Administrator\AppData\Roaming\Microsoft\Crypto
    C:\Users\Administrator\AppData\Local\Temp 
    C:\Users\Default\AppData\Roaming\Microsoft 
    C:\Users\Administrator\AppData\Local\Temp 
    C:\Users\Default\AppData\Local\Temp
    C:\Users\Administrator\AppData\Roaming  
    C:\Users\Administrator\AppData\Local
    C:\Users\Default\Downloads  
    C:\Users\Default\Documents
    C:\Users\Default\AppData
    C:\Users\Administrator\AppData
    C:\Users\Default\AppData\Roaming\Microsoft\Windows\「开始」菜单 
    C:Users/Default  
    C:\Users\Default\AppData\Roaming
    C:Users/Administrator  
    
    C:\Windows  
    C:\Program Files  
    C:\Program Files (x86)  
    C:\Program Files\Common Files 
    C:\Program Files\Windows NT  
    C:\Program Files (x86)\Windows NT 
    C:\Program Files (x86)\Common Files  
    C:\Program Files (x86)\Windows NT\Accessories 
    C:\Program Files\Windows NT\Accessories  
    C:Program Files\Common Files\Microsoft Shared  
    C:\Program Files (x86)\Common Files\Microsoft Shared
    C:WINDOWS/system32/inetsrv 
    C:WINDOWS/system32/config
    C:\Windows\Temp
    C:Program Files\Internet Explorer\iexplore.exe  
    C:\Program Files (x86)\Internet Explorer\iexplore.exe

  E:Program Files\Microsoft SQL Server   
  E:\Program FilesMicrosoft SQL ServerMSSQL

  主要权限部分：  其他权限部分：  
  Administrators 完全控制      Users 读取和运行   
  该文件夹，子文件夹 及文件    该文件夹，子文件夹及文件   
  <继承于上一级文件夹>         <继承于上一级文件夹>  
  CREATOR OWNER 完全控制   
  只有子文件夹及文件   <不是继承的>  
  SYSTEM 完全控制
  以上路径默认权限即可 如发现异常请按上述权限配置
#>
<###############################禁用服务 请根据需求调整#####################################>
<# 
    服务名:Application Layer Gateway Service
    描述:#为应用程序级协议插件提供支持并启用网络/协议连接。如果 此服务被禁用，任何依赖它的服务将无法启动
    文件:c:\WINDOWS\System32\alg.exe
#>
Write-Host 接下来将禁用/开启 某些服务 -ForegroundColor red
Write-Host 正在停止且禁用 Application Layer Gateway Service服务 -ForegroundColor Yellow
Stop-Service alg 
Set-Service  alg -StartupType Disabled 

<# 
    服务名:Computer Browser
    描述:维护网络上计算机的更新列表，并将列表提供给计 算机指定浏览。如果服务停止，列表不会被更新或维护。如果 服务被禁用，任何直接依赖于此服务的服务将无法启动。
    文件:c:\WINDOWS\System32\svchost.exe -k  netsvcs
#>
Write-Host 正在停止且禁用 Computer Browser 服务 -ForegroundColor Yellow
Stop-Service Browser
Set-Service  Browser -StartupType Disabled 
<# 
    服务名:DNS Client
    描述:维护网络上计算机的更新列表，并将列表提供给计 算机指定浏览。如果服务停止，列表不会被更新或维护。如果 服务被禁用，任何直接依赖于此服务的服务将无法启动。
    文件:c:\WINDOWS\System32\svchost.exe -k NetworkService
#>
Write-Host 正在停止且禁用 DNS Client 服务 -ForegroundColor Yellow
Stop-Service Dnscache
Set-Service  Dnscache -StartupType Disabled 
<# 
    服务名:Internet Connection Sharing (ICS)
    描述:为家庭和小型办公网络提供网络地址转换、寻址、名称解析和 /或入侵保护服务。 
    文件:c:\WINDOWS\System32\svchost.exe -k netsvcs
#>
Write-Host 正在停止且禁用 Internet Connection Sharing "(ICS)" 服务 -ForegroundColor Yellow
Stop-Service SharedAccess
Set-Service  SharedAccess -StartupType Disabled 
<# 
    服务名:IP Helper
    描述:使用 IPv6 转换技术(6to4、ISATAP、端口代理和 Teredo)和  IP-HTTPS 提供隧道连接。如果停止该服务，则计算机将不具 备这些技术提供的增强连接优势。
    文件:c:\WINDOWS\System32\svchost.exe -k NetSvcs
#>
Write-Host 正在停止且禁用 IP Helper 服务 -ForegroundColor Yellow
Stop-Service iphlpsvc
Set-Service  iphlpsvc -StartupType Disabled 
<# 
    服务名:Print Spooler
    描述:管理所有本地和网络打印队列及控制所有打印工作。如果此服 务被停用，本地计算机上的打印将不可用。如果此服务被禁用， 任何依赖于它的服务将无法启用。
    文件:c:\WINDOWS\System32\spoolsv.exe
#>
Write-Host 正在停止且禁用 Print Spooler 服务 -ForegroundColor Yellow
Stop-Service Spooler
Set-Service  Spooler -StartupType Disabled 
<# 
    服务名:Problem Reports and Solutions Control Panel Support
    描述:此服务为查看、发送和删除“问题报告和解决方案”控制面板 的系统级问题报告提供支持。
    文件:c:\WINDOWS\System32\svchost.exe -k netsvcs
#>
Write-Host 正在停止且禁用 Problem Reports and Solutions Control Panel Support 服务 -ForegroundColor Yellow
Stop-Service wercplsupport
Set-Service  wercplsupport -StartupType Disabled 
<# 
    服务名:Remote Desktop Services UserMode Port Redirector
    描述:允许为 RDP 连接重定向打印机/驱动程序/端口 
    文件:c:\WINDOWS\System32\svchost.exe -k LocalSystemNetworkRestricted 
#>
Write-Host 正在停止且禁用 Remote Desktop Services UserMode Port Redirector 服务 -ForegroundColor Yellow
Stop-Service UmRdpService
Set-Service  UmRdpService -StartupType Disabled 
<# 
    服务名:Remote Procedure Call (RPC) Locator
    描述:在 Windows 2003 和 Windows 的早期版本中，远程过程调用(RPC)定位器服务可管理 RPC 名称服务数据库。在 Windows  Vista 和 Windows 的更新版本中，此服务不提供任何功能，但可用于应用程序兼容性。
    文件:c:\WINDOWS\System32\locator.exe 
#>
Write-Host 正在停止且禁用 Remote Procedure Call "(RPC)" Locator 服务 -ForegroundColor Yellow
Stop-Service RpcLocator 
Set-Service  RpcLocator -StartupType Disabled 
<# 
    服务名:Remote Registry
    描述:使远程用户能修改此计算机上的注册表设置。如果此服务被终 止，只有此计算机上的用户才能修改注册表。如果此服务被禁 用，任何依赖它的服务将无法启动。
    文件:c:\WINDOWS\System32\svchost.exe -k regsvc
#>
Write-Host 正在停止且禁用 Remote Registry 服务 -ForegroundColor Yellow
Stop-Service RemoteRegistry 
Set-Service  RemoteRegistry -StartupType Disabled 
<# 
    服务名:Routing and Remote Access
    描述:在局域网以及广域网环境中为企业提供路由服务。
    文件:c:\WINDOWS\System32\svchost.exe -k netsvcs
#>
Write-Host 正在停止且禁用 Routing and Remote Access 服务 -ForegroundColor Yellow
Stop-Service RemoteAccess
Set-Service  RemoteAccess -StartupType Disabled 
<# 
    服务名:Server
    描述:支持此计算机通过网络的文件、打印、和命名管道共享。如果 服务停止，这些功能不可用。如果服务被禁用，任何直接依赖 于此服务的服务将无法启动。
    文件:c:\WINDOWS\System32\svchost.exe -k netsvcs
#>
Write-Host 正在停止且禁用 Server 服务 -ForegroundColor red
Stop-Service Server -Force
Set-Service  Server -StartupType Disabled 
<# 
    服务名:Shell Hardware Detection
    描述:为自动播放硬件事件提供通知。
    文件:c:\WINDOWS\System32\svchost.exe -k netsvcs
#>
Write-Host 正在停止且禁用 Shell Hardware Detection 服务 -ForegroundColor Yellow
Stop-Service ShellHWDetection
Set-Service  ShellHWDetection -StartupType Disabled 
<# 
    服务名:SSDP Discovery
    描述:当发现了使用 SSDP 协议的网络设备和服务，如 UPnP 设备，同时还报告了运行在本地计算机上使用的 SSDP 设备和服务。 如果停止此服务，基于 SSDP 的设备将不会被发现。如果禁用此服务，任何依赖此服务的服务都无法正常启动。
    文件:c:\WINDOWS\System32\svchost.exe -k  LocalServiceAndNoImpersonation 
#>
Write-Host 正在停止且禁用 SSDP Discovery 服务 -ForegroundColor Yellow
Stop-Service SSDPSRV -Force
Set-Service  SSDPSRV -StartupType Disabled 
<# 
    服务名:TCP/IP NetBIOS Helper
    描述:提供 TCP/IP (NetBT) 服务上的 NetBIOS 和网络上客户端的 NetBIOS 名称解析的支持，从而使用户能够共享文件、打印和 登录到网络。如果此服务被停用，这些功能可能不可用。如果此服务被禁用，任何依赖它的服务将无法启动。
    文件:c:\WINDOWS\System32\svchost.exe -k  LocalServiceNetworkRestricted
#>
Write-Host 正在停止且禁用 TCP/IP NetBIOS Helper 服务 -ForegroundColor Yellow
Stop-Service LmHosts
Set-Service  LmHosts -StartupType Disabled 
<# 
    服务名:UPnP Device Host
    描述:允许 UPnP 设备宿主在此计算机上。如果停止此服务，则所有宿主的 UPnP 设备都将停止工作，并且不能添加其他宿主设备。如果禁用此服务，则任何显式依赖于它的服务将都无法启动。
    文件:c:\WINDOWS\System32\svchost.exe -k  LocalServiceAndNoImpersonation
#>
Write-Host 正在停止且禁用 UPnP Device Host 服务 -ForegroundColor Yellow
Stop-Service upnphost
Set-Service  upnphost -StartupType Disabled 
<# 
    服务名:Workstation
    描述:创建和维护到远程服务的客户端网络连接。如果服务停止，这 些连接将不可用。如果服务被禁用，任何直接依赖于此服务的 服务将无法启动。
    文件:c:\WINDOWS\System32\svchost.exe -k NetworkService

    Stop-Service lanmanworkstation -Force
Set-Service  lanmanworkstation -StartupType Disabled 
#>

<# 
    服务名:Windows Management Instrumentation
    描述:提供共同的界面和对象模式以便访问有关操作系统、设备、应用程序和服务的管理信息。如果此服务被终止，多数基于 Windows 的软件将无法正常运行。如果此服务被禁用，任何依赖它的服务将无法启动。
    文件:C:\Windows\system32\svchost.exe -k netsvcs
#>
Write-Host 正在停止且禁用 Windows Management Instrumentation 服务,此服务为大多数webshell利用，非不得已请勿启用。 -ForegroundColor red
Stop-Service Winmgmt -Force
Set-Service  Winmgmt -StartupType Disabled 
<# 
    服务名:Windows Update
    描述:启用检测、下载和安装 Windows 和其他程序的更新。如果此服务被禁用，这台计算机的用户将无法使用 Windows Update 或其自动更新功能， 并且这些程序将无法使用 Windows Update Agent (WUA) API。
    文件:c:\WINDOWS\System32\svchost.exe -k netsvcs
#>
Write-Host 正在开启并自动运行 Windows Update 服务 -ForegroundColor Yellow
Start-service wuauserv
Set-Service  wuauserv -StartupType Automatic
<# 
    服务名:Windows Firewall
    描述:Windows 防火墙通过阻止未授权用户通过 Internet 或网络访问您的计算机来帮助保护计算机。
    文件:c:\WINDOWS\System32\svchost.exe -k LocalServiceNoNetwork
#>
Write-Host 正在开启并自动运行 Windows Firewall 服务 -ForegroundColor Yellow
Start-service TermService
Set-Service  TermService -StartupType Automatic


Write-Host 接下来将卸载危险组件  -ForegroundColor red
sleep 3

<# 
    服务名:Remote Desktop Services
    描述:允许用户以交互方式连接到远程计算机。远程桌面和远程桌面会话主机服务器依赖此服务。若要防止远程使用此计算机，请清除“系统”属性控制面板项目的“远程”选项卡上的复选框。
    文件:C:\Windows\System32\svchost.exe -k termsvcs

Start-service MpsSvc
Set-Service  MpsSvc -StartupType Automatic

#>

<###############################组件安全#####################################>

Write-Host 正在卸载 C:/WINDOWS/System32/wshom.ocx 组件 -ForegroundColor Yellow
regsvr32 /u /s C:/WINDOWS/System32/wshom.ocx  
sleep 1
Write-Host 正在卸载 C:/Windows/SysWOW64/wshom.ocx 组件 -ForegroundColor Yellow
regsvr32 /u /s C:/Windows/SysWOW64/wshom.ocx  
sleep 1
Write-Host 正在卸载 C:/WINDOWS/system32/shell32.dll 组件 -ForegroundColor Yellow
regsvr32 /u /s C:/WINDOWS/system32/shell32.dll 
sleep 1
Write-Host 正在卸载 C:/Windows/SysWOW64/shell32.dll 组件 -ForegroundColor Yellow
regsvr32 /u /s C:/Windows/SysWOW64/shell32.dll
sleep 1
<#regsvr32 /u C:/WINDOWS/SYSTEM32/scrrun.dll 
regsvr32 /u C:/Windows/SysWOW64/scrrun.dll#> 

<###############################.net程序集 安装卸载#####################################>
<#
function Install-Gac([string]$assemblyPath)
{
    $currentPath=Get-Location
    $currentPath
    $fullPath= [System.IO.Path]::GetFullPath($assemblyPath)
	Write-Host "Install assembly", $fullPath
	
	#[System.Reflection.Assembly]::Load("System.EnterpriseServices, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a")
	[System.Reflection.Assembly]::LoadWithPartialName("System.EnterpriseServices") > $null
	
	$publish = new-object System.EnterpriseServices.Internal.Publish
	
	$publish.GacInstall($fullPath)
	Write-Host "Install assembly to Gac Finish"
}

function Uninstall-Gac([string]$assemblyPath)
{
	Write-Host "Uninstall assembly", $assemblyPath
	
	#[System.Reflection.Assembly]::Load("System.EnterpriseServices, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a")
	[System.Reflection.Assembly]::LoadWithPartialName("System.EnterpriseServices") > $null
	
	$publish = new-object System.EnterpriseServices.Internal.Publish
	
	$publish.GacRemove($assemblyPath)
	Write-Host "unstall assembly in Gac Finish"
}
Uninstall-Gac 	DLLPATH

#>
<###############################组策略安全#####################################>
Write-Host 接下来将设置 组策略 -ForegroundColor red
Write-Host 正在导入组策略.. -ForegroundColor yellow
secedit /configure /db gp.sdb /cfg gpall.inf /quiet  # 导入组策略
sleep 2
<###############################防火墙配置 #####################################>
#netsh advfirewall firewall add rule name=远程终端 dir=in action=allow protocol=TCP localport=3389
Write-Host 接下来将设置 防火墙过滤规则  -ForegroundColor red
Write-Host 防火墙设置 添加web后台端口8888 允许 -ForegroundColor green
netsh advfirewall firewall add rule name="back office" dir=in action=allow protocol=TCP localport=8888 | Out-Null
Write-Host 防火墙设置 添加web后台端口5566 允许 -ForegroundColor green
netsh advfirewall firewall add rule name=webAPI dir=in action=allow protocol=TCP localport=5566 | Out-Null
Write-Host 防火墙设置 添加FTP端口21 允许 -ForegroundColor green
netsh advfirewall firewall add rule name=ftp dir=in action=allow protocol=TCP localport=21 | Out-Null
<###############################远程端口修改并添加防火墙策略 #####################################>
Write-Host 接下来将设置远程桌面端口 -ForegroundColor red
sleep 5
.\modify_remote_port.ps1

Write-host 所有任务执行完成，请重启生效 管理员名字为lgadmin 密码为原administrator 密码  -ForegroundColor green

