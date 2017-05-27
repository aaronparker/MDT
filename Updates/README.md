# Get and Import Update Packages
Get and import updates into an MDT deployment share. Schedule to keep your deployment share up to date.

## Get-LatestUpdate.ps1
Originally forked from {https://gist.github.com/keithga/1ad0abd1f7ba6e2f8aff63d94ab03048](https://gist.github.com/keithga/1ad0abd1f7ba6e2f8aff63d94ab03048).

Queries JSON from Microsoft to determine the latest Windows 10 updates. Returns an object that lists details of the update. Optionally download the update to a local folder.

## Import-LatestUpdate.ps1
Imports updates from a specified folder into an MDT deployment share. Takes output via the pipeline from Get-LatestUpdate.ps1.