#---------------------------------------------------------------------------
# Control MDT deployment
#---------------------------------------------------------------------------

# Set variables (change these to arguments later)
$MDTBootISO = "[ILIO DataStore] ISOs/MDT/KelwayLiteTouchPE_x86.iso"
$TargetVM_OSName = "W7X86T1"
$TaskSequenceID = "W2K8R2S-RDS"
$MachineObjectOU = "OU=XenApp 6.5,OU=Desktop Virtualization,DC=UCS-POC,DC=CO,DC=UK"
$TargetVM_Name = "Win7-x86-VDA-Template"
$VMTemplate = "ILIO_Win7_x86_Template"
$VIServer = "10.130.36.222"
$DeploymentShare = "E:\Deployment"
# $DeploymentShare = "C:\Common\MDTShare"
$CustomSettingsINI = "$DeploymentShare\Control\CustomSettings.ini"

# Connect to VMware vCenter
Add-PSSnapin 'vmware.VimAutomation.core' -ErrorAction SilentlyContinue
# If ((Get-Module 'vmware.VimAutomation.core') -eq $null) { throw "Module did not load" }
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope Session -Confirm:$False
$MyCredentials = Get-Credential
Connect-VIServer -Server $VIServer -Credential $MyCredentials -Verbose

# Remove any existing VM
$VM = Get-VM | Where-Object { $_.Name -eq $TargetVM_Name }
If ( $VM -ne $Null ) {
    If ( $VM.PowerState -eq "PoweredOn" ) { Stop-VM -VM $VM -Confirm:$False }
    Do {
        $VM = Get-VM | Where-Object { $_.name -eq $TargetVM_Name }
        Switch ($VM.PowerState) {
                {$_ -eq "PoweredOff"}{$Seconds = 0; break}
                {$_ -eq "PoweredOn"}{$Seconds = 10; break}
        }
        Start-Sleep $Seconds
    } Until ( $VM.PowerState -eq "PoweredOff" )
    Remove-VM -VM $VM -DeletePermanently -Confirm:$False -Verbose
}

# Create a VM from a template
New-VM -VMHost "k-poc-stealth02.ucs-poc.co.uk" -Template $VMTemplate -Name $TargetVM_Name -Datastore "ILIO_FAST" -Notes "MDT template VM" -Verbose

# Get the target VM
$TargetVM = Get-VM $TargetVM_Name -Verbose

# Get the target VM's UUID
$TargetVMUUID = $TargetVM | Get-vSphereVMUUID

# Connect to the MDT share
Add-PSSnapin 'Microsoft.BDD.PSSNAPIN' -ErrorAction SilentlyContinue
# If ((Get-Module 'Microsoft.BDD.PSSNAPIN') -eq $null) { throw "Module did not load" }
If (!(Test-Path MDT:)) { New-PSDrive -Name MDT -Root $DeploymentShare -PSProvider MDTPROVIDER }

# Write settings for the target VM to MDT CustomSettings.ini
# open INI file, create or edit section, assign task sequence, configure deployment wizard
Copy-Item $CustomSettingsINI "$DeploymentShare\Control\CustomSettings-Backup.ini" -Force
$CustomSettingsContent = [ordered]@{}
$CustomSettingsContent = Get-IniContent $CustomSettingsINI

# Check INI for existing content and remove
If ($CustomSettingsContent.Contains($TargetVMUUID)) {
    If ($CustomSettingsContent.Item($TargetVMUUID).Contains("OSDComputerName")) {
        If ($CustomSettingsContent.Item($TargetVMUUID).Item("OSDComputerName") -eq $TargetVM_OSName) {
            $CustomSettingsContent.Remove($TargetVMUUID)
        }
    }
}

# Create new content for the INI file and write back to the file
$Category1 = [ordered]@{"OSDComputerName"=$TargetVM_OSName;"TaskSequenceID"=$TaskSequenceID;"MachineObjectOU"=$MachineObjectOU;"XenAppRole"="NONE";"WindowsUpdate"="FALSE";"SkipSummary"="YES";"SkipTaskSequence"="YES";"SkipApplications"="YES";"SkipLocaleSelection"="YES";"SkipDomainMembership"="YES";"SkipTimeZone"="YES";"SkipComputerName"="YES"}
$NewINIContent = [ordered]@{$TargetVMUUID=$Category1}
$CustomSettingsContent = $CustomSettingsContent += $NewINIContent
Out-IniFile -InputObject $CustomSettingsContent -FilePath $CustomSettingsINI -Force ASCII
# Out-IniFile -InputObject $NewINIContent -FilePath $CustomSettingsINI -Append ASCII

# Connect the MDT ISO to the target VM
$CDDrives = $TargetVM.CDDrives
Set-CDDrive -CD $CDDrives -StartConnected:$True -Connected:$True -Confirm:$False

# Start the VM
If (!($TargetVM.PowerState -eq "PoweredOn")) { $TargetVM | Start-VM -Verbose }

# Wait for the OS deployment to start before monitoring
# This may require user intervention to boot the VM from the MDT ISO if an OS exists on the vDisk
If ((Test-Path variable:InProgress) -eq $True) { Remove-Variable -Name InProgress }
Do {
    $InProgress = Get-MDTMonitorData -Path MDT: | Where-Object { $_.Name -eq $TargetVM_OSName -and $_.DeploymentStatus -eq 1 }
    If ($InProgress) {
        If ($InProgress.PercentComplete -eq 100) {
            $Seconds = 30
            $TSStarted = $False
            Write-Host "Waiting for task sequence to begin..." -ForegroundColor Green
        } Else {
            $Seconds = 0
            $TSStarted = $True
            Write-Host "Task sequence has begun. Moving to monitoring phase." -ForegroundColor Green
        }
    } Else {
        $Seconds = 30
        $TSStarted = $False
        Write-Host "Waiting for task sequence to begin..." -ForegroundColor Green
    }
    Start-Sleep -Seconds $Seconds
} Until ($TSStarted -eq $True)
 
# Monitor the MDT OS deployment once started
Do {
    $InProgress = Get-MDTMonitorData -Path MDT: | Where-Object { $_.Name -eq $TargetVM_OSName -and $_.DeploymentStatus -eq 1 }
    If ( $InProgress.PercentComplete -lt 100 ) {
        If ( $InProgress.StepName.Length -eq 0 ) { $StatusText = "Waiting for update" } Else { $StatusText = $InProgress.StepName }
        Write-Progress -Activity "Task sequence in progress" -Status $StatusText -PercentComplete $InProgress.PercentComplete
        Switch ($InProgress.PercentComplete) {
            {$_ -lt 25}{$Seconds = 35; break}
            {$_ -lt 50}{$Seconds = 30; break}
            {$_ -lt 75}{$Seconds = 10; break}
            {$_ -lt 100}{$Seconds = 5; break}
        }
        Start-Sleep -Seconds $Seconds
    }
} Until ($InProgress.CurrentStep -eq $InProgress.TotalSteps)
Write-Host "Task sequence complete." -ForegroundColor Green

# Shutdown the target VM
$VM = Get-VM | Where-Object { $_.Name -eq $TargetVM_Name }
If ( $VM -ne $Null ) {
    If ( $VM.PowerState -eq "PoweredOn" ) { Shutdown-VMGuest -VM $VM -Confirm:$False }
    Do {
        $VM = Get-VM | Where-Object { $_.name -eq $TargetVM_Name }
        Switch ($VM.PowerState) {
                {$_ -eq "PoweredOff"}{$Seconds = 0; break}
                {$_ -eq "PoweredOn"}{$Seconds = 10; break}
        }
        Start-Sleep $Seconds
    } Until ( $VM.PowerState -eq "PoweredOff" )
}

# Connect to XenDesktop and create a machine catalog


# Run SSH commands
$SshHost = "192.168.0.100"
Import-Module SSH-Sessions
New-SshSession -ComputerName $SshHost -Username admin -Password Passw0rd
Invoke-SshCommand -Command 'ls' -InvokeOnAll
Remove-SshSession -ComputerName $SshHost
