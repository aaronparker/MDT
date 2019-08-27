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
