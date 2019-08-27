#Requires -RunAsAdministrator
<#
    .SYNOPSIS
    Configuration changes to a default install of Windows during provisioning.
  
    .NOTES
    NAME: Invoke-Scripts.ps1
    AUTHOR: Aaron Parker, Insentra
 
    .LINK
    http://www.insentragroup.com
#>
[CmdletBinding()]
Param ()

# Log file
$stampDate = Get-Date
$scriptName = ([System.IO.Path]::GetFileNameWithoutExtension($(Split-Path $script:MyInvocation.MyCommand.Path -Leaf)))
$logFile = "$env:SystemRoot\Logs\$scriptName-" + $stampDate.ToFileTimeUtc() + ".log"
Start-Transcript -Path $logFile

# Gather the configuration scripts and run each one
$Scripts = @( Get-ChildItem -Path (Join-Path -Path $PWD -ChildPath "*.Script.ps1") -ErrorAction SilentlyContinue)
ForEach ($script in $Scripts) {
    Try {
        . $script.FullName
    }
    Catch {
        Write-Warning -Message "Failed to run script: $($script.fullname)."
        Throw $_.Exception.Message
    }
}

# End log
Stop-Transcript
