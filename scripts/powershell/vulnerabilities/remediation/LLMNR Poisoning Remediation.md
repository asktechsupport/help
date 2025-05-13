<h1>Windows Infrastructure Vulnerability Remediation </h1>

<details>
<summary>LLMNR Poisoning Remediation</summary>

> **Tip:** You can either manually link the new GPO, or modify the 3rd line "New-GPLink" to link it to the correct OU

```powershell
# Create a new GPO
New-GPO -Name "Disable LLMNR"

# Configure the GPO to disable LLMNR
Set-GPRegistryValue -Name "Disable LLMNR" -Key "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient" -ValueName "EnableMulticast" -Type DWord -Value 0

# Link GPO to a specific Organizational Unit (OU)
New-GPLink -Name "Disable LLMNR" -Target <e.g.>"OU=<<<Computers>>>,DC=<<<YourDomain>>>,DC=co,DC=uk"
```

</details>
</details>



