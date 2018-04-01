<#
    .SYNOPSIS
    Runs each of the batch files in sub-folders to install the Visual C++ Redistributables
  
    .NOTES
    NAME: Install-VisualC.ps1
    VERSION: 1.0
    AUTHOR: Aaron Parker
    LASTEDIT: April 28, 2017
 
    .LINK
    http://stealthpuppy.com
#>

ForEach ($dir in (Get-ChildItem -Directory) {
    Push-Location -Path $dir.FullName
    Start-Process -FilePath $env:SystemRoot\system32\cmd.exe -ArgumentList "/c Install-VisualCRedist.CMD" -Wait -NoNewWindow -WindowStyle Minimized
    Pop-Location
}