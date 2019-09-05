
# Mount ISO
$Iso = "C:\Temp\en_windows_10_features_on_demand_part_1_version_1903_x64_dvd_1076e85a.iso"
Mount-DiskImage -ImagePath $Iso
$Drive = (Get-DiskImage -ImagePath $Iso | Get-Volume).DriveLetter

# Folder
$PackageSource = "C:\Temp\FoD1903"
New-Item -Path $PackageSource -ItemType Directory -Force
New-Item -Path "$PackageSource\metadata" -ItemType Directory -Force

# Copy packages
$Languages = @("en-AU", "en-GB")
ForEach ($lang in $Languages) {
    Get-ChildItem -Path "$Drive\" -Filter "Microsoft-Windows-LanguageFeatures*$lang*" | `
        ForEach-Object { Copy-Item -Path $_.FullName -Destination $PackageSource -Force -ErrorAction SilentlyContinue -Verbose }
}

# Copy metadata
Copy-Item -Path "$Drive\FoDMetadata_Client.cab" -Destination $PackageSource -Force -ErrorAction SilentlyContinue -Verbose 
ForEach ($lang in $Languages) {
    Get-ChildItem -Path "$Drive\metadata" -Filter "*$lang*" | `
        ForEach-Object { Copy-Item -Path $_.FullName -Destination "$PackageSource\metadata" -Force -ErrorAction SilentlyContinue -Verbose }
}
$OtherMetadata = @("DesktopTargetCompDB_en-us.xml.cab", "DesktopTargetCompDB_Neutral.xml.cab")
ForEach ($file in $OtherMetadata) {
    Copy-Item -Path "$Drive\metadata\$file" -Destination "$PackageSource\metadata" -Force -ErrorAction SilentlyContinue -Verbose
}

# Install
ForEach ($lang in $Languages) {
    $Capabilities = Get-WindowsCapability -Online | Where-Object { $_.Name -like "Language*$lang*" }
    ForEach ($Capability in $Capabilities) {
        Add-WindowsCapability -Online -Name $Capability.Name -Source $PackageSource -LimitAccess
    }
}
