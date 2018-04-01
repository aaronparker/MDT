# Set root storage location
$root = "\\mcfly\Deployment\Automata\Applications"


# Google Chrome Enterprise
$appFolder = "Google Chrome"
$uri = "http://dl.google.com/edgedl/chrome/install/GoogleChromeStandaloneEnterprise64.msi"
$filename = $uri.Substring($uri.LastIndexOf("/") + 1)
Invoke-WebRequest -Uri $uri -OutFile "$root\$appfolder\$filename"


#Mozilla Firefox
$firefoxJSON = "https://product-details.mozilla.org/1.0/firefox_versions.json"
$firefoxVersions = (Invoke-WebRequest -uri $firefoxJSON).Content | ConvertFrom-Json
$appFolder = "Mozilla Firefox"
$uri = "https://download.mozilla.org/?product=firefox-esr-latest&lang=en-US"
$filename = "Firefox Setup $($firefoxVersions.LATEST_FIREFOX_VERSION).exe"
If (!(Test-Path -Path "$root\$appfolder\$filename")) {
    Get-ChildItem -Path "$root\$appFolder" -Filter *.exe | Remove-Item -Force
    Invoke-WebRequest -Uri $uri -OutFile "$root\$appfolder\$filename"
}


# Microsoft Office
$appFolder = "Microsoft Office 365 ProPlus"
$filename = "setup.exe"
Start-Process -FilePath "$root\$appfolder\$filename" -ArgumentList "/download $root\$appfolder\configurationDesktop.xml" -Wait