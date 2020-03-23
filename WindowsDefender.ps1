$MpConfig = Get-MpPreference
$SetMpParams = @{ }
ForEach ($property in $MpConfig.CimInstanceProperties) {
    If ($Null -ne $property.Value) {
        $SetMpParams.Add($property.Name, $property.Value)
    }
}
$SetMpParams.Remove('ComputerID')
$SetMpParams.Remove('PSComputerName')


$Target = Get-ChildItem -Path "$env:ProgramData\Microsoft\Windows Defender\Platform" | `
    Sort-Object -Property LastWriteTime -Descending | Select-Object -First 1
Set-Location -Path $Target.FullName
Start-Process -FilePath ".\MpCmdRun.exe" -ArgumentList "-RemoveDefinitions -DynamicSignatures" -Wait
Start-Process -FilePath ".\MpCmdRun.exe" -ArgumentList "-SignatureUpdate" -Wait


mdatp --config realTimeProtectionEnabled false
mdatp --config cloudEnabled false
mdatp --config cloudDiagnosticEnabled false
mdatp --config cloudAutomaticSampleSubmission false
mdatp --threat --type-handling potentially_unwanted_application off
