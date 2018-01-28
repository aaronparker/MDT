# Get-AppxPackageFromStart.ps1
Returns the AppX package that correlates to the application display name on the Start menu. Returns the AppX package object that correlates to the application display name on the Start menu. Returns null if the name specified is not found or the shortcut points to a non-AppX app.

## PARAMETER
Name - specify a shortcut display name to return the AppX package for.
  
## EXAMPLE
PS C:\> Get-AppxPackageFromStart -Name "Twitter"

Returns the AppX package for the shortcut 'Twitter'.
