# Clearing Out EFI Partition with PowerShell

I created this script for my organization when we ran into difficulties pushing out endpoint encryption to all of our machines. Managing over 500 endpoints, this script streamlined the process and saved our IT department significant manual effort.

## Why This Was Needed
Following recent hardware security concerns, we needed a reliable way to protect sensitive data on vulnerable hard drives against unauthorized access. We selected **Check Point Harmony Endpoint (BitLocker Management)** as our enterprise encryption standard.

However, during deployment, the encryption rollout frequently failed with an error stating that the **EFI system partition had insufficient free space**. Through testing, I discovered that freeing up roughly **25 MB** of space on the EFI partition allowed the process to complete successfully. 

Upon further investigation, I found that pre-installed manufacturer diagnostic tools and OEM download packages stored directly in the EFI partition were consuming the necessary headroom. Removing these unnecessary files freed up nearly 75 MB—more than enough space for encryption. To scale this across our environment, the cleanup and encryption workflow was packaged for deployment **via GPO**.

## What the Script Does
1. **Authenticates:** Temporarily utilizes specified admin credentials.
2. **Mounts the EFI Partition:** Assigns a temporary drive letter (`S:`) to Disk 0, Partition 1.
3. **Cleans OEM Bloatware:** Automatically targets and deletes manufacturer-specific directories (such as HP or Dell diagnostic/download folders).
4. **Unmounts:** Removes the temporary access path to secure the partition again.

Once the space is freed up, you can immediately re-run your encryption deployment.

## The Script

```powershell
# Define admin credentials directly in the script
$username = "Your Admin UserID" # Replace with your target admin account
$password = ConvertTo-SecureString "Admin Password" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential($username, $password)

# Run the command under the specified credentials
Start-Process powershell.exe -Credential $cred -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `
    Mount-Volume -VolumeId (Get-Partition -DiskNumber 0 -PartitionNumber 1).AccessPaths[0] -DriveLetter S; `
    Remove-Item -Path 'S:\EFI\(Put in what the model is IE: HP or DELL)' -Recurse -Force -ErrorAction SilentlyContinue; `
    Remove-PartitionAccessPath -DiskNumber 0 -PartitionNumber 1 -AccessPath 'S:\'"
