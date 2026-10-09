<h1>Clearing Out EFI Partition Powershell</h1>
I created this for my Organization when we were having difficulties pushing out encryption onto all the machines. And with roughly over 500 machines this script made our IT department lives so much easier.</br>

<h2>What the Script Does: </h2>
What the script does is you will fill out what is in quotes for UserID and Password with your organizations (or your own) admin creads. Then run the script either as an admin or through GPO. It will then mount the EFI partition and search for the brand you put in, in the second half.
After that it will delete that folder freeing up nearly 75MB of space which is just enough for encryption.
Once it creates the space in the EFI partition, the only thing left to do is re-run the enccryption</br></br>

<h3>The Script</h3>

--Define admin credentials directly in the script--</br>
`$username = "Your Admin UserID" # Replace with your target admin account` </br>
`$password = ConvertTo-SecureString "Admin Password" -AsPlainText -Force` </br>
`$cred = New-Object System.Management.Automation.PSCredential($username, $password)` </br>

--Run the command under the specified credentials--</br>
`Start-Process powershell.exe -Credential $cred -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command` </br> 
    `Mount-Volume -VolumeId (Get-Partition -DiskNumber 0 -PartitionNumber 1).AccessPaths[0] -DriveLetter S;` </br>
    `Remove-Item -Path 'S:\EFI\(Put in what the model is IE: HP or DELL)' -Recurse -Force -ErrorAction SilentlyContinue;` </br>
    `Remove-PartitionAccessPath -DiskNumber 0 -PartitionNumber 1 -AccessPath 'S:\'"` </br>
