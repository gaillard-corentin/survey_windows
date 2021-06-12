
Write-Output "this options is available :"
Write-Output "1 : list in a file appli install and version"
Write-Output "2 : list ip and mac addresses on each interface of your network card"
Write-Output "3 : list configuration of your wi-fi"
Write-Output "4 : list identification informations stock in windows"
Write-Output "5 : list scheduled tasks"
Write-Output "6 : list active process"
Write-Output "7 : list open port"

[string[]] $Option= @()
$Option = Read-Host -Prompt 'Put the option want use here'
$Option = $Option.Split(',').Split(' ')
$json_script =  New-Object psobject

Foreach($element in $Option)
{
    if ($element -eq "1")
    {
        try{
        $list_appli_installer_version = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, InstallDate # | Format-Table –AutoSize (use for direct visualize in powershell)
        Write-Output "`nfind appli install and version ... DONE"
        $json_script | Add-Member -NotePropertyName "list application install, version, date install" -NotePropertyValue $list_appli_installer_version
        }
        catch{
        Write-Output "`nfind appli install and version ... [FAIL]"
        $json_script | Add-Member -NotePropertyName "list application install, version, date install" -NotePropertyValue "[FAIL]"
        }
    }


    #address mac, name of wifi configurate
    if ($element -eq "2")
    {
        try{
        $ipmac = Get-WmiObject win32_networkadapterconfiguration | Select-Object  Caption, @{name='IPAddress';Expression={($_.IPAddress[0])}} , macaddress
        Write-Output "`nfind ip and mac address ... DONE"
        $json_script | Add-Member -NotePropertyName "list ip and mac addresses on each interface of your network card" -NotePropertyValue $ipmac
        }
        catch{
        Write-Output "`nfind ip and mac address ... [FAIL]"
        $json_script | Add-Member -NotePropertyName "list ip and mac addresses on each interface of your network card" -NotePropertyValue "[FAIL]"
        }
    }

    #wifi configurate
    if ($element -eq "3")
    {
        try{
        $wifi_config = netsh wlan show profiles
        Write-Output "`nWifi configurate ... DONE"
        $json_script | Add-Member -NotePropertyName "list configuration of your wi-fi" -NotePropertyValue $wifi_config
        }
        catch{
        Write-Output "`nWifi configurate ... [FAIL]"
        $json_script | Add-Member -NotePropertyName "list configuration of your wi-fi" -NotePropertyValue "[FAIL]"
        }
    }

    #logon cache
    if ($element -eq "4")
    {
        try{
        $logon_cache = cmdkey.exe /list
         Write-Output "`nLogon cache ... DONE"
         $json_script | Add-Member -NotePropertyName "list identification informations stock in windows" -NotePropertyValue $logon_cache
        }
        catch{
         Write-Output "`nLogon cache ... [FAIL]"
         $json_script | Add-Member -NotePropertyName "list identification informations stock in windows" -NotePropertyValue "[FAIL]"
        }
    }

    #scheduled tasks
    if ($element -eq "5")
    {
        try{
        $list_lancer_au_demarage = Get-ScheduledTask | Select-Object TaskName, State, TaskPath
        Write-Output "`nfind scheduled tasks ... DONE"
        $json_script | Add-Member -NotePropertyName "list scheduled tasks" -NotePropertyValue $list_lancer_au_demarage
        }
        catch{
        Write-Output "`nfind scheduled tasks ... [FAIL]"
        $json_script | Add-Member -NotePropertyName "list scheduled tasks" -NotePropertyValue "[FAIL]"
        }
    }

    #active process
    if ($element -eq "6")
    {
        try{
        $process_active = Get-Process | Select-Object Id, ProcessName, MainWindowTitle, CPU
        Write-Output "`nfind process active ... DONE"
        $json_script | Add-Member -NotePropertyName "list active process" -NotePropertyValue $process_active
        }
        catch{
        Write-Output "`nfind process active ... [FAIL]"
        $json_script | Add-Member -NotePropertyName "list active process" -NotePropertyValue "[FAIL]"
        }
    }

    #list open port
    if ($element -eq "7")
    {
        try{
        $list_open_port = Get-NetTCPConnection | Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, State
        Write-Output "`nfind list open port ... DONE"
        $json_script | Add-Member -NotePropertyName "list open port" -NotePropertyValue $list_open_port
        }
        catch{
        Write-Output "`nfind list open port ... [FAIL]"
        $json_script | Add-Member -NotePropertyName "list open port" -NotePropertyValue "[FAIL]"
        }
    }
}

#construct json file
#$json_script =  New-Object psobject

#$json_script | Add-Member -NotePropertyName "list application install, version, date install" -NotePropertyValue $list_appli_installer_version
#$json_script | Add-Member -NotePropertyName "list ip and mac addresses on each interface of your network card" -NotePropertyValue $ipmac
#$json_script | Add-Member -NotePropertyName "list configuration of your wi-fi" -NotePropertyValue $wifi_config
#$json_script | Add-Member -NotePropertyName "list identification informations stock in windows" -NotePropertyValue $logon_cache
#$json_script | Add-Member -NotePropertyName "list scheduled tasks" -NotePropertyValue $list_lancer_au_demarage
#$json_script | Add-Member -NotePropertyName "list active process" -NotePropertyValue $process_active
#$json_script | Add-Member -NotePropertyName "list open port" -NotePropertyValue $list_open_port

#output
$output_name = Read-Host -Prompt 'Put the output path\name you want here (if you put nothing output is on your shell)'

if ($output_name -eq "")
{
    Write-Output $json_script | ConvertTo-Json
}
else
{
    $json_script  | ConvertTo-Json | Out-File $output_name
}

