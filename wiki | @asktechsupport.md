# Wiki Home

## Windows Active Directory Overview

Key concepts and architecture of Active Directory.

- [What is Active Directory?](ad-overview#what-is-active-directory)
- [AD DS (Active Directory Domain Services)](ad-overview#ad-ds-overview)
- [Domain Controllers](ad-overview#domain-controllers)

---

## Group Policy Management

How to configure and manage Group Policies.

- [Introduction to Group Policy](group-policy#introduction-to-group-policy)
- [Creating and Linking GPOs](group-policy#creating-and-linking-gpos)
- [Common GPO Settings](group-policy#common-gpo-settings)

---

## Troubleshooting Common Issues

Guide to resolving frequently encountered problems.

- [Account Lockouts](troubleshooting#account-lockouts)
- [DNS and Name Resolution Issues](troubleshooting#dns-and-name-resolution)
- [Replication Problems](troubleshooting#replication-problems)

---

## User Management in Active Directory

Best practices for managing users and groups.

- [Creating and Managing Users](user-management#creating-and-managing-users)
- [Group Management](user-management#group-management)
- [User Profiles and Home Directories](user-management#user-profiles-and-home-directories)

---

## Security and Permissions

Securing your environment and managing permissions.

- [NTFS Permissions](security-and-permissions#ntfs-permissions)
- [Delegation of Control](security-and-permissions#delegation-of-control)
- [Auditing and Security Logs](security-and-permissions#auditing-and-security-logs)

---

## Backup and Recovery

Preparing for and recovering from disasters.

- [Active Directory Backup](backup-and-recovery#ad-backup)
- [Restore Options](backup-and-recovery#restore-options)
- [Disaster Recovery Best Practices](backup-and-recovery#disaster-recovery)

---

## PowerShell for IT Admins

Automating tasks with PowerShell.

- [Basic Commands](powershell#basic-commands)
- [Managing AD with PowerShell](powershell#managing-ad-with-powershell)
- [Scripts for Common Admin Tasks](powershell#common-admin-scripts)

---

## Advanced Topics

For experienced admins and advanced configurations.

- [Active Directory Federation Services (ADFS)](advanced-topics#adfs)
- [Active Directory Certificate Services (ADCS)](advanced-topics#adcs)
- [Azure AD Integration](advanced-topics#azure-ad-integration)

---

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

## **Tools Cheat Sheet**
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

---

## **Learning Resources**
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

---

# FAQ

Answers to commonly asked questions.

- [What happens if a DC goes offline?](faq#dc-offline)
- [How to fix Group Policy not applying?](faq#group-policy-fix)

---

# Additional Resources

Links to further reading and tools.

- [Microsoft Documentation](resources#microsoft-documentation)
- [PowerShell Modules](resources#powershell-modules)
- [Useful Tools for IT Admins](resources#useful-tools)

---
