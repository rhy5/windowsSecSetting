<#
    ����:�޸�/�ָ�3389�˿ڲ��Զ���ӷ���ǽ����
    ����:��ʦ��
    ʱ��:2017��3��24��
    email: lovecoding@ntoskrnl.cn

 #>


Write-Host 
Write-Host 1���Զ���Զ������˿� -ForegroundColor 10 
Write-Host 2���ָ�ϵͳĬ�ϵ�Զ������˿� -ForegroundColor 11 
Write-Host 
Write-Host 
Write-Host "���������б�ѡ��һ��ѡ��...[1-2]" -ForegroundColor Yellow
$opt=Read-Host 
Switch ($opt) 
    { 
        1 { 
            Write-Host 
            Write-Host �޸�Զ�����棨Remote Desktop����Ĭ�϶˿�... -ForegroundColor Red 
            Write-Host 
            Write-Host ����������ʾ����Ҫָ���Ķ˿ںţ���ο��˿ڷ�Χ����һ��ָ���Ķ˿ںţ���Χ��1024~65535�� -ForegroundColor Yellow
            Write-Host �ýű��޸�ע���HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp���¡�PortNumber���ļ�ֵ��   -ForegroundColor Yellow
            Write-Host 
            # ����ָ���Ķ˿ںŲ��޸�RDPĬ�϶˿� 
            Write-Host "����������Ҫָ���Ķ˿ںţ���Χ��1024~65535��" -NoNewline -ForegroundColor Yellow 
            $PortNumber=Read-Host  
            $original=Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name 'portnumber' 
            Write-Host ��ǰRDPĬ�϶˿�Ϊ$original.PortNumber  -ForegroundColor Yellow 
            $result=Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name 'portnumber' -Value $PortNumber 
            $newPort = Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name 'portnumber'
            Write-Host  �Ѿ���� RDP �˿ڵ��޸�,��ǰRDP �˿�Ϊ:$newPort.PortNumber�� -ForegroundColor Green 
            #����Զ��������� 
            Write-Host �������� Remote Desktop Services ... -ForegroundColor Yellow 
            Restart-Service termservice -Force 
            #�����Զ���˿�ͨ������ǽ 
            $newPort = Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name 'portnumber'
            Write-Host ��ӷ���ǽ���ԣ��������� RDP �˿�  $newPort.PortNumber ��վ�� -ForegroundColor Green 
            netsh advfirewall firewall add rule name=Զ���ն� dir=in action=allow protocol=TCP localport=$PortNumber | Out-Null
            Write-Host 
            Write-Host ��� RDP �˿��޸ģ� -ForegroundColor green
            } 
        2 { 
            Write-Host 
            Write-Host ���ڻָ�ϵͳĬ�϶˿�... 
            Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name 'portnumber' -Value 3389 
            Write-Host �������� Remote Desktop Services... 
            Restart-Service termservice -Force 
            Write-Host ����ɾ������ǽ����... 
            Remove-NetFirewallRule -DisplayName "Զ���ն�" 
            write-host ��ɻָ��� 
           } 
     }
