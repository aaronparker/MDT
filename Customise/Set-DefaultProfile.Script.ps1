<#
    .SYNOPSIS
        Script configures the Default User Profile in a Windows 10 image
 
    .DESCRIPTION
        Script configures the Default User Profile in a Windows 10 image.
        Should also be suitable for Windows Server 2016 RDSH deployments.
        Edits the profile of the current user and the default profile.
 
    .LINK
        http://stealthpuppy.com
#>

#region Functions
Function Set-RegistryValue {
    <#
        .SYNOPSIS
            Creates a registry value in a target key. Creates the target key if it does not exist.
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $True)]
        [System.String] $Key,

        [Parameter(Mandatory = $True)]
        [System.String] $Value,

        [Parameter(Mandatory = $True)]
        $Data,

        [Parameter(Mandatory = $False)]
        [ValidateSet('Binary', 'ExpandString', 'String', 'Dword', 'MultiString', 'QWord')]
        [System.String] $Type = "String"
    )

    try {
        If (Test-Path -Path $Key -ErrorAction SilentlyContinue) {
            Write-Verbose "Path exists: $Key"
        }
        Else {
            Write-Verbose -Message "Does not exist: $Key."

            $folders = $Key -split "\\"
            $parent = $folders[0]
            Write-Verbose -Message "Parent is: $parent."

            ForEach ($folder in ($folders | Where-Object { $_ -notlike "*:" })) {
                New-Item -Path $parent -Value $folder -ErrorAction SilentlyContinue | Out-Null
                $parent = "$parent\$folder"
                If (Test-Path -Path $parent -ErrorAction SilentlyContinue) {
                    Write-Verbose -Message "Created $parent."
                }
            }
            Test-Path -Path $Key -ErrorAction SilentlyContinue
        }
    }
    catch {
        Write-Error "Failed to create key $Key."
        Break
    }
    finally {
        Write-Verbose -Message "Setting $Value in $Key."
        New-ItemProperty -Path $Key -Value $Value -Data $Data -PropertyType $Type -ErrorAction SilentlyContinue | Out-Null
    }

    $val = Get-Item -Path $Key
    If ($val.Property -contains $Value) {
        Write-Verbose "Write value success: $Value"
        Write-Output $True
    }
    Else {
        Write-Verbose "Write value failed."
        Write-Output $False
    }
}

Function Set-DefaultProfile {
    Param ([String] $KeyPath = "Microsoft.PowerShell.Core\Registry::HKEY_CURRENT_USER")

    # Set NET USE drive commands to be non-persistent
    Set-RegistryValue -Key "$KeyPath\Software\Microsoft\Windows NT\CurrentVersion\Network\Persistent Connections" -Value "SaveConnections" -Data "No"

    # Windows Explorer
    Set-RegistryValue -Key "$KeyPath\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Value "SeparateProcess" -Data 1 -Type 'Dword'

    # Personalization Settings
    # Remove transparency and colour to Navy Blue
    Set-RegistryValue -Key "$KeyPath\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Value "EnableBlurBehind" -Data 0 -Type 'Dword'
    Set-RegistryValue -Key "$KeyPath\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Value "EnableTransparency" -Data 0 -Type 'Dword'
    Set-RegistryValue -Key "$KeyPath\Software\Microsoft\Windows\DWM" -Value "ColorPrevalence" -Data 1
    Set-RegistryValue -Key "$KeyPath\Software\Microsoft\Windows\DWM" -Value "AccentColor" -Data 4289815296 -Type 'Dword'
    Set-RegistryValue -Key "$KeyPath\Software\Microsoft\Windows\DWM" -Value "ColorizationAfterglow" -Data 3288359857 -Type 'Dword'
    Set-RegistryValue -Key "$KeyPath\Software\Microsoft\Windows\DWM" -Value "ColorizationColor" -Data 3288359857 -Type 'Dword'
    Set-RegistryValue -Key "$KeyPath\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent" -Value "AccentColor" -Data 4289992518 -Type 'Dword'
    Set-RegistryValue -Key "$KeyPath\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent" -Value "AccentPalette" `
        -Data 86CAFF005FB2F2001E91EA000063B10000427500002D4F000020380000CC6A00 -Type 'Binary'

    # Taskbar Settings
    Set-RegistryValue -Key "$KeyPath\Software\Microsoft\TabletTip\1.7" -Value "TipbandDesiredVisibility" -Data 0 -Type 'Dword'
    Set-RegistryValue -Key "$KeyPath\Software\Microsoft\Windows\CurrentVersion\PenWorkspace" -Value "PenWorkspaceButtonDesiredVisibility" -Data 0 -Type 'Dword'
    Set-RegistryValue -Key "$KeyPath\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Value "TaskbarGlomLevel" -Data 1 -Type 'Dword'
    Set-RegistryValue -Key "$KeyPath\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Value "MMTaskbarGlomLevel" -Data 1 -Type 'Dword'

    # Start menu settings
    Set-RegistryValue -Key "$KeyPath\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Value "SystemPaneSuggestionsEnabled" -Data 0 -Type 'Dword'

    # Disable advertising
    Set-RegistryValue -Key "$KeyPath\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Value "Enabled" -Data 0 -Type 'Dword'

    # Internet Explorer - local Intranet zone defaults for Azure AD SSO
    Set-RegistryValue -Key "$KeyPath\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\microsoftazuread-sso.com\autologon" `
        -Value "http" -Data 1 -Type 'Dword'
    Set-RegistryValue -Key "$KeyPath\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\nsatc.net\aadg.windows.net" `
        -Value "http" -Data 1 -Type 'Dword'

    # Internet Explorer - local Trusted Sites zone defaults for Office 365
    Set-RegistryValue -Key "$KeyPath\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\microsoftonline.com" `
        -Value "http" -Data 2 -Type 'Dword'
    Set-RegistryValue -Key "$KeyPath\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\sharepoint.com" `
        -Value "http" -Data 2 -Type 'Dword'
    Set-RegistryValue -Key "$KeyPath\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\outlook.com" `
        -Value "http" -Data 2 -Type 'Dword'
    Set-RegistryValue -Key "$KeyPath\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\lync.com" `
        -Value "http" -Data 2 -Type 'Dword'
    Set-RegistryValue -Key "$KeyPath\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\office365.com" `
        -Value "http" -Data 2 -Type 'Dword'
    Set-RegistryValue -Key "$KeyPath\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\office.com" `
        -Value "http" -Data 2 -Type 'Dword'

    # Windows Media Player
    Set-RegistryValue -Key "$KeyPath\Software\Microsoft\MediaPlayer\Setup\UserOptions" -Value "DesktopShortcut" -Data "No"
    Set-RegistryValue -Key "$KeyPath\Software\Microsoft\MediaPlayer\Setup\UserOptions" -Value "QuickLaunchShortcut" -Data 0 -Type 'Dword'
    Set-RegistryValue -Key "$KeyPath\Software\Microsoft\MediaPlayer\Preferences" -Value "AcceptedPrivacyStatement" -Data 1 -Type 'Dword'
    Set-RegistryValue -Key "$KeyPath\Software\Microsoft\MediaPlayer\Preferences" -Value "FirstRun" -Data 0 -Type 'Dword'
    Set-RegistryValue -Key "$KeyPath\Software\Microsoft\MediaPlayer\Preferences" -Value "DisableMRU" -Data 1 -Type 'Dword'
    Set-RegistryValue -Key "$KeyPath\Software\Microsoft\MediaPlayer\Preferences" -Value "AutoCopyCD" -Data 0 -Type 'Dword'
}
#endregion

# Set default in the current profile for use with CopyProfile in unattend.xml
Set-DefaultProfile -KeyPath "Microsoft.PowerShell.Core\Registry::HKEY_CURRENT_USER"

# Set defaults in the default profile
# Load the default profile hive
$LoadPath = "HKLM\Default"
REG LOAD $LoadPath "$env:SystemDrive\Users\Default\NTUSER.DAT"

# Set defaut profile
Set-DefaultProfile -KeyPath "Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\Default"

# Unload the default profile hive
Start-Sleep -Seconds 30
REG UNLOAD $LoadPath
[gc]::collect()

# Configure the default Start menu
If (!(Test-Path("$env:SystemDrive\Users\Default\AppData\Local\Microsoft\Windows"))) { New-Item -Value "$env:SystemDrive\Users\Default\AppData\Local\Microsoft\Windows" -ItemType Directory }
Import-StartLayout -LayoutPath .\StartMenuLayout.xml -MountPath "$($env:SystemDrive)\"
