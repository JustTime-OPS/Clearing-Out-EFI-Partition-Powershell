# Define admin credentials directly in the script
$username = "Your Admin UserID" # Replace with your target admin account
$password = ConvertTo-SecureString "Admin Password" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential($username, $password)

# Run the command under the specified credentials
Start-Process powershell.exe -Credential $cred -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `
    Mount-Volume -VolumeId (Get-Partition -DiskNumber 0 -PartitionNumber 1).AccessPaths[0] -DriveLetter S; `
    Remove-Item -Path 'S:\EFI\(Put in what the model is IE: HP or DELL)' -Recurse -Force -ErrorAction SilentlyContinue; `
    Remove-PartitionAccessPath -DiskNumber 0 -PartitionNumber 1 -AccessPath 'S:\'"