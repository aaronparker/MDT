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