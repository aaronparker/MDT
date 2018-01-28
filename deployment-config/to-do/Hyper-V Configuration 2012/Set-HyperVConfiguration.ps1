## Configures Hyper-V system and network configuration
 
# System variables
$HyperVFolder = "$env:SystemDrive\HyperV"

# Change default machine and vDisk locations
New-Item $HyperVFolder -ItemType Directory -Force -Confirm:$False
Set-VMHost -VirtualHardDiskPath "$HyperVFolder\HardDisks" -VirtualMachinePath "$HyperVFolder\Machines" -Confirm:$False


# Network configuration variables
$SwitchName = "Virtual Machines External"
$SelectedAdapters = @()
$TeamName = "Virtual Machines"
 
# List of MAC addresses for the adapter in each server to be bound to a virtual switch
# HYPERV1=00:1C:42:FF:2A:8A; HV1=00:1C:C4:D8:36:BA; HV2=00:19:BB:C9:63:04;
$MACAddressList = "00-1C-42-ED-16-A9", "00-1C-42-4C-AF-EC", "00-1C-C4-D8-36-BA", "00-19-BB-C9-63-04"

# If the Hyper-V module exists, we're good to go
If (Get-Module -ListAvailable | Where-Object { $_.name -eq "Hyper-V" }) {
 
    # Match MAC addresses to a local adapter
    $Adapters = Get-NetAdapter | Select Name, InterfaceDescription, MacAddress
    For ($n=0; $n -le $MACAddressList.Count -1; $n++) {
        For ($i=0; $i -le $Adapters.Count -1; $i++) {
            If ($MACAddressList[$n] -eq $Adapters[$i].MacAddress) {
                $SelectedAdapters = $SelectedAdapters + $Adapters[$i].Name
            }
        }
    }

    # Create a new network adapter team
    If ($SelectedAdapters.Count -ge 1) {
        New-NetLbfoTeam -Name $TeamName -TeamMembers $SelectedAdapters -TeamingMode SwitchIndependent -LoadBalancingAlgorithm HyperVPort -Verbose -Confirm:$False
        $TeamAdapter = Get-NetAdapter | Where-Object { $_.Name -eq $TeamName }
    }

    # Configure Hyper-V networking with the supplied adapter description
    If (!(Get-VMSwitch | Where-Object { $_.Name -eq $SwitchName } )) {
        If ($TeamAdapter) {
            # Create the Hyper-V network and remove the option 'Allow management operating system to share this network adapter'
            New-VMSwitch -Name $SwitchName -NetAdapterInterfaceDescription $TeamAdapter.InterfaceDescription -AllowManagementOS $False -Verbose
        } Else {
            Write-Error "Unable to match a local adapter from the list of supplied MAC addresses or create the adapter team."
        }
    } Else {
        Write-Error "Virtual switch $SwitchName already exists."
    }
}
Else {
    Write-Error "Unable to find or load the required Hyper-V module."
}