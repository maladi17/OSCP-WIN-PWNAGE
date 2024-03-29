echo this is a ps-pe script made by "Magen Gide0n" >> reportps.txt
echo used the following scripts: >>reportps.txt
echo absolomb's security guide >> reportps.txt
echo payloadAllTheThings >>reportps.txt
echo . >> reportps.txt

echo [Is there anything interesting in environment variables?] >>reportps.txt
Get-ChildItem Env: | ft Key,Value >>reportps.txt

echo [any other drivers] >>reportps.txt
Get-PSDrive | where {$_.Provider -like "Microsoft.PowerShell.Core\FileSystem"}| ft Name,Root >>reportps.txt

echo [who am i?] >>reportps.txt
$env:UserName >>reportps.txt

echo [what users are there?] >>reportps.txt
Get-LocalUser | ft Name,Enabled,LastLogon>>reportps.txt
Get-ChildItem C:\Users -Force | select Name>>reportps.txt

echo [what groups?] >>reportps.txt
Get-LocalGroup | ft Name >>reportps.txt

echo [who are on administrators?] >>reportps.txt
Get-LocalGroupMember Administrators | ft Name, PrincipalSource >>reportps.txt

echo [auto logon registry] >>reportps.txt
Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\WinLogon' | select "Default*" >>reportps.txt

echo [credentials manager?] >>reportps.txt
Get-ChildItem -Hidden C:\Users\username\AppData\Local\Microsoft\Credentials\>>reportps.txt
Get-ChildItem -Hidden C:\Users\username\AppData\Roaming\Microsoft\Credentials\>>reportps.txt

echo [what softwares are there?] >>reportps.txt
Get-ChildItem 'C:\Program Files', 'C:\Program Files (x86)' | ft Parent,Name,LastWriteTime >>reportps.txt
Get-ChildItem -path Registry::HKEY_LOCAL_MACHINE\SOFTWARE | ft Name>>reportps.txt

echo [Modify Permissions for Everyone or Users on Program Folders?] >>reportps.txt
Get-ChildItem 'C:\Program Files\*','C:\Program Files (x86)\*' | % { try { Get-Acl $_ -EA SilentlyContinue | Where {($_.Access|select -ExpandProperty IdentityReference) -match 'Everyone'} } catch {}} >>reportps.txt
Get-ChildItem 'C:\Program Files\*','C:\Program Files (x86)\*' | % { try { Get-Acl $_ -EA SilentlyContinue | Where {($_.Access|select -ExpandProperty IdentityReference) -match 'BUILTIN\Users'} } catch {}} >>reportps.txt

echo [processes] >>reportps.txt
Get-Process | where {$_.ProcessName -notlike "svchost*"} | ft ProcessName, Id>>reportps.txt
Get-Service >>reportps.txt

echo [This one liner returns the process owner without admin rights, if something is blank under owner it’s probably running as SYSTEM, NETWORK SERVICE, or LOCAL SERVICE.]>>reportps.txt
Get-WmiObject -Query "Select * from Win32_Process" | where {$_.Name -notlike "svchost*"} | Select Name, Handle, @{Label="Owner";Expression={$_.GetOwner().User}} | ft -AutoSize >>reportps.txt

echo [Are there any unquoted service paths?] >>reportps.txt
gwmi -class Win32_Service -Property Name, DisplayName, PathName, StartMode | Where {$_.StartMode -eq "Auto" -and $_.PathName -notlike "C:\Windows*" -and $_.PathName -notlike '"*'} | select PathName,DisplayName,Name >>reportps.txt

echo [What scheduled tasks are there? Anything custom implemented?] >>reportps.txt
Get-ScheduledTask | where {$_.TaskPath -notlike "\Microsoft*"} | ft TaskName,TaskPath,State>>reportps.txt

echo [startupers] >>reportps.txt
Get-CimInstance Win32_StartupCommand | select Name, command, Location, User | fl>>reportps.txt
Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run'>>reportps.txt
Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunOnce'>>reportps.txt
Get-ItemProperty -Path 'Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run'>>reportps.txt
Get-ItemProperty -Path 'Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunOnce'>>reportps.txt
Get-ChildItem "C:\Users\All Users\Start Menu\Programs\Startup">>reportps.txt
Get-ChildItem "C:\Users\$env:USERNAME\Start Menu\Programs\Startup">>reportps.txt

echo [ipconfigs] >>reportps.txt
Get-NetIPConfiguration | ft InterfaceAlias,InterfaceDescription,IPv4Address >>reportps.txt
Get-DnsClientServerAddress -AddressFamily IPv4 | ft >>reportps.txt

echo [routes] >>reportps.txt
Get-NetRoute -AddressFamily IPv4 | ft DestinationPrefix,NextHop,RouteMetric,ifIndex>>reportps.txt

echo [arp] >>reportps.txt
Get-NetNeighbor -AddressFamily IPv4 | ft ifIndex,IPAddress,LinkLayerAddress,State >>reportps.txt

echo [snmp] >>reportps.txt
Get-ChildItem -path HKLM:\SYSTEM\CurrentControlSet\Services\SNMP -Recurse >>reportps.txt


echo [Are there sysprep or unattend files available that weren’t cleaned up?] >>reportps.txt
Get-Childitem –Path C:\ -Include *unattend*,*sysprep* -File -Recurse -ErrorAction SilentlyContinue | where {($_.Name -like "*.xml" -or $_.Name -like "*.txt" -or $_.Name -like "*.ini")} >>reportps.txt


echo [If the server is an IIS webserver, what’s in inetpub? Any hidden directories? web.config files?] >>reportps.txt
Get-Childitem –Path C:\inetpub\ -Include web.config -File -Recurse -ErrorAction SilentlyContinue >>reportps.txt

echo [web-config-files] >>reportps.txt
Get-Childitem –Path C:\ -Include php.ini,httpd.conf,httpd-xampp.conf,my.ini,my.cnf -File -Recurse -ErrorAction SilentlyContinue >>reportps.txt

echo [apache web logs] >>reportps.txt
Get-Childitem –Path C:\ -Include access.log,error.log -File -Recurse -ErrorAction SilentlyContinue >>reportps.txt

echo [interesting files] >>reportps.txt
Get-Childitem –Path C:\Users\ -Include *password*,*vnc*,*.config -File -Recurse -ErrorAction SilentlyContinue >>reportps.txt

echo [firewalls blocked ports] >>reportps.txt
$f=New-object -comObject HNetCfg.FwPolicy2;$f.rules |  where {$_.action -eq "0"} | select name,applicationname,localports >> reportps.txt


