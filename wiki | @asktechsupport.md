# Wiki Home

Welcome to the **IT Support and Windows Active Directory Wiki**! This documentation is a comprehensive guide to managing IT systems, troubleshooting common issues, and mastering Active Directory.

## Contents

- [Introduction](#introduction)
- [IT Support Basics](it-support-basics.md)
- [Windows Active Directory Overview](ad-overview.md)
- [Group Policy Management](group-policy.md)
- [Troubleshooting Common Issues](troubleshooting.md)
- [User Management in Active Directory](user-management.md)
- [Security and Permissions](security-and-permissions.md)
- [Backup and Recovery](backup-and-recovery.md)
- [PowerShell for IT Admins](powershell.md)
- [Advanced Topics](advanced-topics.md)
- [FAQ](faq.md)
- [Additional Resources](resources.md)

---

## Introduction

An overview of IT Support and Active Directory fundamentals:

- **Target Audience**: IT Support professionals and system administrators
- **Goals**: Provide actionable insights and best practices

---

## IT Support Basics

General IT Support topics and troubleshooting.

- [Help Desk Ticket Management](it-support-basics.md#help-desk-ticket-management)
- [Hardware Diagnostics](it-support-basics.md#hardware-diagnostics)
- [Network Troubleshooting](it-support-basics.md#network-troubleshooting)

---

## Windows Active Directory Overview

Key concepts and architecture of Active Directory.

- [What is Active Directory?](ad-overview.md#what-is-active-directory)
- [AD DS (Active Directory Domain Services)](ad-overview.md#ad-ds-overview)
- [Domain Controllers](ad-overview.md#domain-controllers)

---

## Group Policy Management

How to configure and manage Group Policies.

- [Introduction to Group Policy](group-policy.md#introduction-to-group-policy)
- [Creating and Linking GPOs](group-policy.md#creating-and-linking-gpos)
- [Common GPO Settings](group-policy.md#common-gpo-settings)

---

## Troubleshooting Common Issues

Guide to resolving frequently encountered problems.

- [Account Lockouts](troubleshooting.md#account-lockouts)
- [DNS and Name Resolution Issues](troubleshooting.md#dns-and-name-resolution)
- [Replication Problems](troubleshooting.md#replication-problems)

---

## User Management in Active Directory

Best practices for managing users and groups.

- [Creating and Managing Users](user-management.md#creating-and-managing-users)
- [Group Management](user-management.md#group-management)
- [User Profiles and Home Directories](user-management.md#user-profiles-and-home-directories)

---

## Security and Permissions

Securing your environment and managing permissions.

- [NTFS Permissions](security-and-permissions.md#ntfs-permissions)
- [Delegation of Control](security-and-permissions.md#delegation-of-control)
- [Auditing and Security Logs](security-and-permissions.md#auditing-and-security-logs)

---

## Backup and Recovery

Preparing for and recovering from disasters.

- [Active Directory Backup](backup-and-recovery.md#ad-backup)
- [Restore Options](backup-and-recovery.md#restore-options)
- [Disaster Recovery Best Practices](backup-and-recovery.md#disaster-recovery)

---

## PowerShell for IT Admins

Automating tasks with PowerShell.

- [Basic Commands](powershell.md#basic-commands)
- [Managing AD with PowerShell](powershell.md#managing-ad-with-powershell)
- [Scripts for Common Admin Tasks](powershell.md#common-admin-scripts)

---

## Advanced Topics

For experienced admins and advanced configurations.

- [Active Directory Federation Services (ADFS)](advanced-topics.md#adfs)
- [Active Directory Certificate Services (ADCS)](advanced-topics.md#adcs)
- [Azure AD Integration](advanced-topics.md#azure-ad-integration)

---

# **Penetration Testing Wiki**

## **1. Introduction to Penetration Testing**
- Overview of Penetration Testing
  - Definition and Goals
  - Types of Penetration Tests (Black Box, White Box, Gray Box)
- Legal and Ethical Considerations
  - Laws and Compliance (e.g., GDPR, HIPAA, PCI-DSS)
  - Rules of Engagement (ROE)
  - Obtaining Permission (Authorization)

---

## **2. The Penetration Testing Lifecycle**
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

## **3. Reconnaissance Tools and Techniques**
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

## **4. Scanning and Enumeration**
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

## **6. Post-Exploitation**
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

## **7. Web Application Security**
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

## **8. Wireless Penetration Testing**
- Wireless Attacks
  - WPA/WPA2 Cracking
  - Evil Twin Attacks
- Wireless Tools
  - Aircrack-ng Suite
  - Wireshark
  - Bettercap

---

## **9. Social Engineering**
- Techniques
  - Phishing
  - Vishing
  - Pretexting
- Tools
  - Gophish
  - SET (Social Engineering Toolkit)

---

## **10. Reporting and Documentation**
- Reporting Structure
  - Executive Summary
  - Technical Details
  - Proof of Concepts
- Risk Ratings
  - CVSS (Common Vulnerability Scoring System)
- Mitigation Strategies
  - Best Practices for Hardening

---

## **11. Tools Cheat Sheet**
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

## **12. Learning Resources**
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

## **13. Appendices**
- Glossary of Terms
- Common Commands
- Useful Links and Resources

---

This skeleton covers the essential topics and includes tools and techniques relevant to penetration testing. You can expand each section with detailed content, commands, examples, and links to resources.

# FAQ

Answers to commonly asked questions.

- [What happens if a DC goes offline?](faq.md#dc-offline)
- [How to fix Group Policy not applying?](faq.md#group-policy-fix)

---

# Additional Resources

Links to further reading and tools.

- [Microsoft Documentation](resources.md#microsoft-documentation)
- [PowerShell Modules](resources.md#powershell-modules)
- [Useful Tools for IT Admins](resources.md#useful-tools)

---
