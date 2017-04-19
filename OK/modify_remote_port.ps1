<#
    功能:修改/恢复3389端口并自动添加防火墙规则
    作者:二师兄
    时间:2017年3月24日
    email: lovecoding@ntoskrnl.cn

 #>


Write-Host 
Write-Host 1、自定义远程桌面端口 -ForegroundColor 10 
Write-Host 2、恢复系统默认的远程桌面端口 -ForegroundColor 11 
Write-Host 
Write-Host 
Write-Host "请从上面的列表选择一个选项...[1-2]" -ForegroundColor Yellow
$opt=Read-Host 
Switch ($opt) 
    { 
        1 { 
            Write-Host 
            Write-Host 修改远程桌面（Remote Desktop）的默认端口... -ForegroundColor Red 
            Write-Host 
            Write-Host 下来将会提示输入要指定的端口号，请参考端口范围输入一个指定的端口号（范围：1024~65535） -ForegroundColor Yellow
            Write-Host 该脚本修改注册表“HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp”下“PortNumber”的键值。   -ForegroundColor Yellow
            Write-Host 
            # 输入指定的端口号并修改RDP默认端口 
            Write-Host "现在请输入要指定的端口号（范围：1024~65535）" -NoNewline -ForegroundColor Yellow 
            $PortNumber=Read-Host  
            $original=Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name 'portnumber' 
            Write-Host 当前RDP默认端口为$original.PortNumber  -ForegroundColor Yellow 
            $result=Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name 'portnumber' -Value $PortNumber 
            $newPort = Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name 'portnumber'
            Write-Host  已经完成 RDP 端口的修改,当前RDP 端口为:$newPort.PortNumber！ -ForegroundColor Green 
            #重启远程桌面服务 
            Write-Host 正在重启 Remote Desktop Services ... -ForegroundColor Yellow 
            Restart-Service termservice -Force 
            #允许自定义端口通过防火墙 
            $newPort = Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name 'portnumber'
            Write-Host 添加防火墙策略，允许现有 RDP 端口  $newPort.PortNumber 入站。 -ForegroundColor Green 
            netsh advfirewall firewall add rule name=远程终端 dir=in action=allow protocol=TCP localport=$PortNumber | Out-Null
            Write-Host 
            Write-Host 完成 RDP 端口修改！ -ForegroundColor green
            } 
        2 { 
            Write-Host 
            Write-Host 正在恢复系统默认端口... 
            Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name 'portnumber' -Value 3389 
            Write-Host 正在重启 Remote Desktop Services... 
            Restart-Service termservice -Force 
            Write-Host 正在删除防火墙设置... 
            Remove-NetFirewallRule -DisplayName "远程终端" 
            write-host 完成恢复！ 
           } 
     }
