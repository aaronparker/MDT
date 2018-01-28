Function Remove-DefaultAppxApps {
    <#
        .SYNOPSIS
            Removes a specified list of AppX packages from the current system.
 
        .DESCRIPTION
            Removes a specified list of AppX packages from the current user account and the local system
            to prevent new installs of in-built apps when new users log onto the system. Return True or 
            False to flag whether the system requires a reboot as a result of removing the packages.

        .PARAMETER Apps
            Specify an array of AppX packages.
  
        .EXAMPLE
            PS C:\> Remove-DefaultApps.ps1
            
            Remove the AppX packages listed by default in the function.
 
         .EXAMPLE
            PS C:\> Remove-DefaultApps.ps1 -Apps "Microsoft.3DBuilder_8wekyb3d8bbwe", "Microsoft.XboxApp_8wekyb3d8bbwe",
            
            Remove a specific set of AppX packages a specified in the -Apps argument.
 
        .NOTES
 	        NAME: Remove-DefaultApps.ps1
	        VERSION: 1.0
	        AUTHOR: Aaron Parker
	        LASTEDIT: March 16, 2016
 
        .LINK
            http://stealthpuppy.com
    #>
    [CmdletBinding(SupportsShouldProcess = $True, ConfirmImpact = "High", DefaultParameterSetName = "Apps")]
    PARAM (
        [Parameter(Mandatory=$false, Position=0, HelpMessage="Specify an AppX package or packages to remove.")]
        [array]$Apps = ( "Microsoft.3DBuilder_8wekyb3d8bbwe", `
                        "Microsoft.ConnectivityStore_8wekyb3d8bbwe", `
                        "Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe", `
                        "Microsoft.MicrosoftSolitaireCollection_8wekyb3d8bbwe", `
                        "Microsoft.SkypeApp_kzf8qxf38zg5c", `
                        "Microsoft.WindowsPhone_8wekyb3d8bbwe", `
                        "Microsoft.XboxApp_8wekyb3d8bbwe", `
                        "Microsoft.OneConnect_8wekyb3d8bbwe", 
                        "king.com.CandyCrushSodaSaga_kgqvnymyfvs32",
                        "Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe",
                        "Microsoft.OneConnect_8wekyb3d8bbwe",
                        "Microsoft.Windows.SecureAssessmentBrowser_cw5n1h2txyewy" )
    )

    BEGIN {
        
        # The flag to be returned by the function
        [bool]$Result = $False
    }
    
    PROCESS {

        If ($PSCmdlet.ShouldProcess("Removing AppX packages $Apps")) {

            # Walk through each package in the array
            ForEach ( $App in $Apps ) {
                
                # Get the AppX package object by passing the string to the left of the underscore
                # to Get-AppxPackage and passing the resulting package object to Remove-AppxPackage
                Get-AppxPackage -AllUsers -Name (($App -split "_")[0]) | Remove-AppxPackage -Verbose

                # Remove the provisioned package as well, completely from the system
                $Package = Get-AppxProvisionedPackage -Online | Where-Object DisplayName -eq (($App -split "_")[0])
                If ( $Package ) {
                    $Action = Remove-AppxProvisionedPackage -Online -PackageName $Package.PackageName -Verbose
                    If ( $Action.RestartNeeded -eq $True ) { $Result = $True } 
                }
            }
        }
    }
    
    END {
        
        Return $Result
    }
}

<#  Apps list from 1511. WARNING - removing some of these apps may cause instability. 
"3D Builder","Microsoft.3DBuilder_8wekyb3d8bbwe"
"Money","Microsoft.BingFinance_8wekyb3d8bbwe"
"News","Microsoft.BingNews_8wekyb3d8bbwe"
"Sport","Microsoft.BingSports_8wekyb3d8bbwe"
"Weather","Microsoft.BingWeather_8wekyb3d8bbwe"
"Phone","Microsoft.CommsPhone_8wekyb3d8bbwe"
"Microsoft WiFi","Microsoft.ConnectivityStore_8wekyb3d8bbwe"
"Get Started","Microsoft.Getstarted_8wekyb3d8bbwe"
"Skype video","Microsoft.Messaging_8wekyb3d8bbwe"
"Messaging","Microsoft.Messaging_8wekyb3d8bbwe"
"Get Office","Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe"
"Microsoft Solitaire Collection","Microsoft.MicrosoftSolitaireCollection_8wekyb3d8bbwe"
"OneNote","Microsoft.Office.OneNote_8wekyb3d8bbwe"
"Sway","Microsoft.Office.Sway_8wekyb3d8bbwe"
"People","Microsoft.People_8wekyb3d8bbwe"
"Get Skype","Microsoft.SkypeApp_kzf8qxf38zg5c"
"Photos","Microsoft.Windows.Photos_8wekyb3d8bbwe"
"Alarms & Clock","Microsoft.WindowsAlarms_8wekyb3d8bbwe"
"Calculator","Microsoft.WindowsCalculator_8wekyb3d8bbwe"
"Camera","Microsoft.WindowsCamera_8wekyb3d8bbwe"
"Calendar","microsoft.windowscommunicationsapps_8wekyb3d8bbwe"
"Mail","microsoft.windowscommunicationsapps_8wekyb3d8bbwe"
"Maps","Microsoft.WindowsMaps_8wekyb3d8bbwe"
"Phone Companion","Microsoft.WindowsPhone_8wekyb3d8bbwe"
"Voice Recorder","Microsoft.WindowsSoundRecorder_8wekyb3d8bbwe"
"Store","Microsoft.WindowsStore_8wekyb3d8bbwe"
"Xbox","Microsoft.XboxApp_8wekyb3d8bbwe"
"Groove Music","Microsoft.ZuneMusic_8wekyb3d8bbwe"
"Films & TV","Microsoft.ZuneVideo_8wekyb3d8bbwe"
"Cortana","Microsoft.Windows.Cortana_cw5n1h2txyewy"
"Microsoft Edge","Microsoft.MicrosoftEdge_8wekyb3d8bbwe"
"Insider Hub","Microsoft.Windows.FeatureOnDemand.InsiderHub_cw5n1h2txyewy"
"Windows Feedback","Microsoft.WindowsFeedback_cw5n1h2txyewy"
"Contact Support","Windows.ContactSupport_cw5n1h2txyewy"
"Twitter","9E2F88E3.Twitter_wgeqdkkx372wm"
"Candy Crush Soda Saga","king.com.CandyCrushSodaSaga_kgqvnymyfvs32"
"Test Taker", Microsoft.Windows.SecureAssessmentBrowser_cw5n1h2txyewy
"Paid WiFi and Mobile", Microsoft.OneConnect_8wekyb3d8bbwe
"Connect", Microsoft.PPIProjection_cw5n1h2txyewy
"Sticky Notes", Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe
#>