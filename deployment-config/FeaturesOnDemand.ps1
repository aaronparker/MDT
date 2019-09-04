
#Mount ISO
# $FoD_Source = "$env:USERPROFILE\Downloads\1809_FoD_Disk1.iso"
# Mount-DiskImage -ImagePath "$FoD_Source"
# $path = (Get-DiskImage "$FoD_Source" | Get-Volume).DriveLetter


# Folder
$PackageSource = "C:\Temp"
New-Item -Path $PackageSource -ItemType Directory -Force
New-Item -Path "$PackageSource\metadata" -ItemType Directory -Force
$FODPath = "D:"

# Copy packages
$Languages = @("en-AU", "en-GB")
ForEach ($lang in $Languages) {
    Get-ChildItem -Path "$FODPath\" -Filter "Microsoft-Windows-LanguageFeatures*$lang*" | `
        ForEach-Object { Copy-Item -Path $_.FullName -Destination $PackageSource -Force -ErrorAction SilentlyContinue -Verbose }
}

# Copy metadata
Copy-Item -Path "$FODPath\FoDMetadata_Client.cab" -Destination $PackageSource -Force -ErrorAction SilentlyContinue -Verbose 
ForEach ($lang in $Languages) {
    Get-ChildItem -Path "$FODPath\metadata" -Filter "*$lang*" | `
        ForEach-Object { Copy-Item -Path $_.FullName -Destination "$PackageSource\metadata" -Force -ErrorAction SilentlyContinue -Verbose }
}
$OtherMetadata = @("DesktopTargetCompDB_en-us.xml.cab", "DesktopTargetCompDB_Neutral.xml.cab")
ForEach ($file in $OtherMetadata) {
    Copy-Item -Path "$FODPath\metadata\$file" -Destination "$PackageSource\metadata" -Force -ErrorAction SilentlyContinue -Verbose
}

# Install
ForEach ($lang in $Languages) {
    $Capabilities = Get-WindowsCapability -Online | Where-Object { $_.Name -like "Language*$lang*" }
    ForEach ($Capability in $Capabilities) {
        Add-WindowsCapability -Online -Name $Capability.Name -Source $Source -LimitAccess
    }
}
