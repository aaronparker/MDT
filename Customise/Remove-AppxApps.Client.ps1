<#
        .SYNOPSIS
            Removes a specified list of AppX packages from the current system.
 
        .DESCRIPTION
            Removes a specified list of AppX packages from the current user account and the local system
            to prevent new installs of in-built apps when new users log onto the system. Return True or 
            False to flag whether the system requires a reboot as a result of removing the packages.

            If the script is run elevated, it will remove provisioned packages from the system. Otherwise only packages for the current user account will be removed.

        .PARAMETER Operation
            Specify the AppX removal operation - either Blacklist or Whitelist. 

        .PARAMETER Blacklist
            Specify an array of AppX packages to 'blacklist' or remove from the current Windows instance,
            all other apps will remain installed. The script will use the blacklist by default.
  
        .PARAMETER Whitelist
            Specify an array of AppX packages to 'whitelist' or keep in the current Windows instance.
            All apps except this list will be removed from the current Windows instance.

        .EXAMPLE
            PS C:\> .\Remove-AppxApps.ps1 -Operation Blacklist
            
            Remove the default list of Blacklisted AppX packages stored in the function.
 
        .EXAMPLE
            PS C:\> .\Remove-AppxApps.ps1 -Operation Whitelist
            
            Remove the default list of Whitelisted AppX packages stored in the function.

         .EXAMPLE
            PS C:\> .\Remove-AppxApps.ps1 -Operation Blacklist -Blacklist "Microsoft.3DBuilder_8wekyb3d8bbwe", "Microsoft.XboxApp_8wekyb3d8bbwe"
            
            Remove a specific set of AppX packages a specified in the -Blacklist argument.
 
         .EXAMPLE
            PS C:\> .\Remove-AppxApps.ps1 -Operation Whitelist -Whitelist "Microsoft.BingNews_8wekyb3d8bbwe", "Microsoft.BingWeather_8wekyb3d8bbwe"
            
            Remove AppX packages from the system except those specified in the -Whitelist argument.

        .NOTES
 	        NAME: Remove-AppxApps.ps1
	        VERSION: 3.0
	        AUTHOR: Aaron Parker
	        TWITTER: @stealthpuppy
 
        .LINK
            http://stealthpuppy.com
#>
[CmdletBinding(SupportsShouldProcess = $True, DefaultParameterSetName = "Blacklist")]
Param (
    [Parameter(Mandatory = $False, ParameterSetName = "Blacklist", HelpMessage = "Specify whether the operation is a blacklist or whitelist.")]
    [Parameter(Mandatory = $False, ParameterSetName = "Whitelist", HelpMessage = "Specify whether the operation is a blacklist or whitelist.")]
    [ValidateSet('Blacklist', 'Whitelist')]
    [System.String] $Operation = "Blacklist",

    [Parameter(Mandatory = $False, ParameterSetName = "Blacklist", HelpMessage = "Specify an AppX package or packages to remove.")]
    [System.String[]] $Blacklist = ( "Microsoft.3DBuilder_8wekyb3d8bbwe", `
            "Microsoft.BingFinance_8wekyb3d8bbwe", `
            "Microsoft.BingSports_8wekyb3d8bbwe", `
            "Microsoft.BingWeather_8wekyb3d8bbwe", `
            "Microsoft.ConnectivityStore_8wekyb3d8bbwe", `
            "microsoft.windowscommunicationsapps_8wekyb3d8bbwe", `
            "Microsoft.MicrosoftSolitaireCollection_8wekyb3d8bbwe", `
            "Microsoft.SkypeApp_kzf8qxf38zg5c", `
            "Microsoft.WindowsPhone_8wekyb3d8bbwe", `
            "Microsoft.XboxApp_8wekyb3d8bbwe", `
            "Microsoft.ZuneMusic_8wekyb3d8bbwe", `
            "Microsoft.ZuneVideo_8wekyb3d8bbwe", `
            "Microsoft.WindowsMaps_8wekyb3d8bbwe", `
            "Microsoft.OneConnect_8wekyb3d8bbwe", `
            # "Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe", `
        # "Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe", `
        # "Microsoft.Office.OneNote_8wekyb3d8bbwe", `
        "Microsoft.Office.Desktop.Access_8wekyb3d8bbwe", `
            "Microsoft.Office.Desktop.Excel_8wekyb3d8bbwe", `
            "Microsoft.Office.Desktop.Outlook_8wekyb3d8bbwe", `
            "Microsoft.Office.Desktop.PowerPoint_8wekyb3d8bbwe", `
            "Microsoft.Office.Desktop.Publisher_8wekyb3d8bbwe", `
            "Microsoft.Office.Desktop.Word_8wekyb3d8bbwe", `
            "Microsoft.Office.Desktop_8wekyb3d8bbwe", `
            "Microsoft.People_8wekyb3d8bbwe", `
            "Microsoft.Messaging_8wekyb3d8bbwe", `
            "Microsoft.PPIProjection_cw5n1h2txyewy", `
            # "Microsoft.YourPhone_8wekyb3d8bbwe", `
        # "Microsoft.Microsoft3DViewer_8wekyb3d8bbwe", `
        # "Microsoft.MixedReality.Portal_8wekyb3d8bbwe", `
        # "Microsoft.WindowsFeedbackHub_8wekyb3d8bbwe", `
        # "Microsoft.GetHelp_8wekyb3d8bbwe", `
        # "Microsoft.Getstarted_8wekyb3d8bbwe", `
        # "Microsoft.MSPaint_8wekyb3d8bbwe", `
        # "Microsoft.Print3D_8wekyb3d8bbwe", `
        # "Microsoft.ScreenSketch_8wekyb3d8bbwe", `
        # "Microsoft.Windows.Photos_8wekyb3d8bbwe", `
        # "Microsoft.WindowsAlarms_8wekyb3d8bbwe", `
        # "Microsoft.WindowsCalculator_8wekyb3d8bbwe", `
        # "Microsoft.WindowsCamera_8wekyb3d8bbwe", `
        # "Microsoft.WindowsSoundRecorder_8wekyb3d8bbwe", `
        # "Microsoft.XboxGamingOverlay_8wekyb3d8bbwe", `
        "king.com.CandyCrushSodaSaga_kgqvnymyfvs32", `
            "7EE7776C.LinkedInforWindows_w1wdnht996qgy" ),

    [Parameter(Mandatory = $False, ParameterSetName = "Whitelist", HelpMessage = "Specify an AppX package or packages to keep, removing all others.")]
    [System.String[]] $Whitelist = ( "Microsoft.BingWeather_8wekyb3d8bbwe", `
            "Microsoft.Office.OneNote_8wekyb3d8bbwe", `
            "Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe", `
            "Microsoft.Windows.Photos_8wekyb3d8bbwe", `
            "Microsoft.WindowsAlarms_8wekyb3d8bbwe", `
            "Microsoft.WindowsCalculator_8wekyb3d8bbwe", `
            "Microsoft.WindowsCamera_8wekyb3d8bbwe", `
            "Microsoft.WindowsSoundRecorder_8wekyb3d8bbwe", `
            "Microsoft.WindowsStore_8wekyb3d8bbwe", `
            "Microsoft.MicrosoftEdge_8wekyb3d8bbwe", `
            "Microsoft.Windows.Cortana_cw5n1h2txyewy", `
            "Microsoft.Windows.FeatureOnDemand.InsiderHub_cw5n1h2txyewy", `
            "Microsoft.WindowsFeedback_cw5n1h2txyewy", `
            "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe", `
            "Microsoft.GetHelp_8wekyb3d8bbwe", `
            "Microsoft.Getstarted_8wekyb3d8bbwe", `
            "Microsoft.StorePurchaseApp_8wekyb3d8bbwe", `
            "Microsoft.Wallet_8wekyb3d8bbwe", `
            "Microsoft.YourPhone_8wekyb3d8bbwe" )
)

# A set of apps that we'll never try to remove
[System.String[]] $protectList = ( "Microsoft.WindowsStore_8wekyb3d8bbwe", `
        "Microsoft.MicrosoftEdge_8wekyb3d8bbwe", `
        "Microsoft.Windows.Cortana_cw5n1h2txyewy", `
        "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe", `
        "Microsoft.StorePurchaseApp_8wekyb3d8bbwe", `
        "Microsoft.Wallet_8wekyb3d8bbwe" )

# Get elevated status. If elevated we'll remove packages from all users and provisioned packages
[System.Boolean] $Elevated = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
If ($Elevated) { Write-Verbose -Message "$($MyInvocation.MyCommand): Running with elevated privileges. Removing provisioned packages as well." }

Switch ($Operation) {
    "Blacklist" {
        # Filter list if it contains apps from the $protectList
        $appsToRemove = Compare-Object -ReferenceObject $Blacklist -DifferenceObject $protectList -PassThru | Where-Object { $_.SideIndicator -eq "<=" }
    }
    "Whitelist" {
        Write-Warning -Message "$($MyInvocation.MyCommand): Whitelist action may break stuff."
        If ($Elevated) {
            # Get packages from the current system and filter out the whitelisted apps
            $allPackages = @()
            Write-Verbose -Message "$($MyInvocation.MyCommand): Enumerating system apps."
            $provisionedPackages = Get-AppxProvisionedPackage -Online | Select-Object DisplayName
            ForEach ($package in $provisionedPackages) {
                $allPackages += Get-AppxPackage -AllUsers -Name $package.DisplayName | Select-Object PackageFamilyName
            }
            $appsToRemove = Compare-Object -ReferenceObject $allPackages.PackageFamilyName -DifferenceObject $Whitelist -PassThru | Where-Object { $_.SideIndicator -eq "<=" }

            # Ensure the list does not contain a system app
            Write-Verbose -Message "$($MyInvocation.MyCommand): Enumerating all users apps."
            $systemApps = Get-AppxPackage -AllUsers | Where-Object { $_.InstallLocation -like "$env:SystemRoot\SystemApps*" -or $_.IsFramework -eq $True } | Select-Object PackageFamilyName
            $appsToRemove = Compare-Object -ReferenceObject $appsToRemove -DifferenceObject $systemApps.PackageFamilyName -PassThru | Where-Object { $_.SideIndicator -eq "<=" }

            # Ensure the list does not contain an app from the $protectList
            Write-Verbose -Message "$($MyInvocation.MyCommand): Filtering protected apps."
            $appsToRemove = Compare-Object -ReferenceObject $appsToRemove -DifferenceObject $protectList -PassThru | Where-Object { $_.SideIndicator -eq "<=" }
        }
        Else {
            # Ensure the list does not contain an app from the $protectList
            Write-Verbose -Message "$($MyInvocation.MyCommand): Filtering protected apps."
            $installedApps = Get-AppxPackage | Where-Object { $_.InstallLocation -like "$env:SystemRoot\SystemApps*" -or $_.IsFramework -eq $True } | Select-Object PackageFamilyName
            $appsToRemove = Compare-Object -ReferenceObject $installedApps -DifferenceObject $protectList -PassThru | Where-Object { $_.SideIndicator -eq "<=" }
            Write-Verbose -Message "$($MyInvocation.MyCommand): Not running with elevated privileges. Skipping provisioned apps."
        }
    }
}

# Remove the apps; Walk through each package in the array
ForEach ($app in $appsToRemove) {
           
    # Get the AppX package object by passing the string to the left of the underscore
    # to Get-AppxPackage and passing the resulting package object to Remove-AppxPackage
    $Name = ($app -split "_")[0]
    Write-Verbose -Message "$($MyInvocation.MyCommand): Evaluating: [$Name]."
    If ($Elevated) {
        $package = Get-AppxPackage -Name $Name -AllUsers
    }
    Else {
        $package = Get-AppxPackage -Name $Name
    }
    If ($package) {
        If ($PSCmdlet.ShouldProcess($package.PackageFullName, "Remove User app")) {
            try {
                $package | Remove-AppxPackage -ErrorAction SilentlyContinue
            }
            catch [System.Exception] {
                Write-Warning -Message "$($MyInvocation.MyCommand): Failed to remove: [$($package.PackageFullName)]."
                Throw $_.Exception.Message
                Break
            }
            finally {
                $removedPackage = New-Object -TypeName System.Management.Automation.PSObject
                $removedPackage | Add-Member -Type "NoteProperty" -Name 'RemovedPackage' -Value $app
                Write-Output -InputObject $removedPackage
            }
        }
    }

    # Remove the provisioned package as well, completely from the system
    If ($Elevated) {
        $package = Get-AppxProvisionedPackage -Online | Where-Object DisplayName -eq (($app -split "_")[0])
        If ($package) {
            If ($PSCmdlet.ShouldProcess($package.PackageName, "Remove Provisioned app")) {
                try {
                    $action = Remove-AppxProvisionedPackage -Online -PackageName $package.PackageName -ErrorAction SilentlyContinue
                }
                catch [System.Exception] {
                    Write-Warning -Message "$($MyInvocation.MyCommand): Failed to remove: [$($package.PackageName)]."
                    Throw $_.Exception.Message
                    Break
                }
                finally {
                    $removedPackage = New-Object -TypeName System.Management.Automation.PSObject
                    $removedPackage | Add-Member -Type "NoteProperty" -Name 'RemovedProvisionedPackage' -Value $app
                    Write-Output -InputObject $removedPackage
                    If ($action.RestartNeeded -eq $True) { Write-Warning -Message "$($MyInvocation.MyCommand): Reboot required: [$($package.PackageName)]" }
                }
            }
        }
    }
}
