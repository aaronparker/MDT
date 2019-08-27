# Remove sample files if they exist
$Paths = "$env:PUBLIC\Music\Sample Music", "$env:PUBLIC\Pictures\Sample Pictures", "$env:PUBLIC\Videos\Sample Videos", "$env:PUBLIC\Recorded TV\Sample Media"
ForEach ( $Path in $Paths ) {
    # Write-Host "$Path exists."
    If ( Test-Path $Path ) { Remove-Item $Path -Recurse -Force }
}

# Remove the C:\Logs folder
$Path = "$env:SystemDrive\Logs"
If ( Test-Path $Path ) { Remove-Item $Path -Recurse -Force }
