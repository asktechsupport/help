<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->
<a id="readme-top"></a>

# Table of Contents

- [Penetration Testing Dictionary](#penetration-testing-dictionary)
- [Infrastructure Dictionary](#infrastructure-dictionary)
- [Networking Dictionary](#networking-dictionary)
- [Cloud Engineering Dictionary](#cloud-engineering-dictionary)
- [Backlog](#backlog)


# Penetration Testing Dictionary

<p align="left">(<a href="#readme-top">back to top</a>)</p>

## PenTesting | Tools

### Recon Resources | Google Fu
* Google, lmgtfy,
* site:<domain>
* site:tesla.com -www
* filetype:csv

### Recon Resources | email addresses
* hunter.io
* Phonebook.cz
* Clearbit
* email-checker.net
* emailhippo.com

### Recon Resources | hashes
* hashes.org

### Recon Resources | hunting subdomains and website technologies
* sublist3r
* owasp amass
  
* wappalyzer (Firefox)
* burpsuite [https://burp](https://burp) - Kali
* 

### github
[hmaverickadams | breach-parse | github.com](https://github.com/hmaverickadams/breach-parse)

## Nmap
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

## other courses
* OSINT Fundamentals

## 5 stages of ethical hacking - diagram
![image](https://github.com/user-attachments/assets/1d12b895-29e8-475c-bce1-2ce10e282ff1)

## Penetration Testing (Pentesting)

> [!NOTE]
> A simulated cyberattack against a system to identify vulnerabilities.

## Vulnerability
> [!NOTE]
> A weakness in a system that can be exploited by a threat actor.

## Exploit
> [!NOTE]
> A code or software that takes advantage of a vulnerability.

## Payload
> [!NOTE]
> The part of an exploit that performs the intended malicious action.

## Social Engineering
> [!NOTE]
> Manipulating people into divulging confidential information.

## Reconnaissance
> [!NOTE]
> The process of gathering information about a target.

## Footprinting
> [!NOTE]
> Collecting data on a target system or network to map out its structure.

## Enumeration
> [!NOTE]
> Extracting user names, machine names, network resources, and other services.

## Scanning
> [!NOTE]
> Actively probing a target to gather information about its network and systems.

## Brute Force Attack
> [!NOTE]
> Attempting to gain access by trying all possible combinations of credentials.

## Dictionary Attack
> [!NOTE]
> A type of brute force attack that uses a list of common passwords or words.

## Credential Stuffing
> [!NOTE]
> Using leaked username/password pairs from one breach to access other sites.

## Phishing
> [!NOTE]
> A method of tricking individuals into providing sensitive information by pretending to be a trustworthy entity.

## SQL Injection (SQLi)
> [!NOTE]
> An attack that allows execution of malicious SQL statements on a database.

## Cross-Site Scripting (XSS)
> [!NOTE]
> Injecting malicious scripts into web pages viewed by other users.

## Man-in-the-Middle (MitM) Attack
> [!NOTE]
> Intercepting and possibly altering communication between two parties.

## Buffer Overflow
> [!NOTE]
> Overwriting a program's memory, leading to arbitrary code execution.

## Privilege Escalation
> [!NOTE]
> Gaining higher-level permissions on a system.

## Zero-Day
> [!NOTE]
> A vulnerability that is unknown to the software vendor and for which no patch exists.

## Backdoor
> [!NOTE]
> A secret method of bypassing normal authentication to gain access to a system.

## Rootkit
> [!NOTE]
> A set of software tools that enable unauthorized access to a computer, often remaining hidden.

## Malware
> [!NOTE]
> Malicious software designed to disrupt, damage, or gain unauthorized access to a system.

## Trojan Horse
> [!NOTE]
> Malicious software disguised as legitimate software.

## Virus
> [!NOTE]
> A type of malware that replicates by modifying other programs and inserting its code.

## Worm
> [!NOTE]
> A type of malware that replicates itself in order to spread to other computers.

## Ransomware
> [!NOTE]
> Malware that encrypts files on a device, demanding a ransom for decryption.

## Denial of Service (DoS) Attack
> [!NOTE]
> An attack designed to make a system unavailable by overwhelming it with traffic.

## Distributed Denial of Service (DDoS) Attack
> [!NOTE]
> A DoS attack using multiple systems to flood the target.

## Firewall
> [!NOTE]
> A network security device that monitors and filters incoming and outgoing network traffic.

## Intrusion Detection System (IDS)
> [!NOTE]
> A device or software application that monitors network traffic for suspicious activity.

## Intrusion Prevention System (IPS)
> [!NOTE]
> Similar to IDS but actively prevents detected threats.

## Port Scanning
> [!NOTE]
> A technique used to identify open ports and services on a networked device.

## Network Sniffing
> [!NOTE]
> Capturing and analyzing network packets to detect and troubleshoot issues.

## SSL/TLS
> [!NOTE]
> Protocols for encrypting data transmitted over a network.

## VPN (Virtual Private Network)
> [!NOTE]
> A secure connection over a less-secure network, like the internet.

## Shell
> [!NOTE]
> A command-line interface that allows users to interact with the operating system.

## Reverse Shell
> [!NOTE]
> A shell session initiated by the target machine to the attacker’s machine.

## Command and Control (C2)
> [!NOTE]
> Servers that attackers use to communicate with compromised systems.

## Pivoting
> [!NOTE]
> Using a compromised system as a launch point to attack other systems on the same network.

## Steganography
> [!NOTE]
> The practice of hiding data within other non-secret data.

## Obfuscation
> [!NOTE]
> The act of making something unclear or unintelligible to obscure its meaning.

## Sandboxing
> [!NOTE]
> Running programs in isolated environments to prevent them from affecting the main system.

## Red Team
> [!NOTE]
> A group of ethical hackers who simulate attacks to test the security of an organization.

## Blue Team
> [!NOTE]
> The defenders who protect the organization's assets and respond to attacks.

## Purple Team
> [!NOTE]
> A combination of Red and Blue Teams that collaborate to improve overall security.

## Patch Management
> [!NOTE]
> The process of regularly updating software to fix vulnerabilities.

## Open Web Application Security Project (OWASP)
> [!NOTE]
> An organization that provides resources to improve software security.

## OWASP Top Ten
> [!NOTE]
> A list of the most critical security risks to web applications.

## Threat Modeling
> [!NOTE]
> The process of identifying and prioritizing potential threats to a system.

## Attack Surface
> [!NOTE]
> The total sum of the vulnerabilities that can be exploited in a system.

## Risk Assessment
> [!NOTE]
> The process of identifying, analyzing, and evaluating risks.

## Security Posture
> [!NOTE]
> The overall security status of an organization's systems, networks, and information.

## Incident Response
> [!NOTE]
> The approach taken by an organization to handle a security breach or attack.

## Security Operations Center (SOC)
> [!NOTE]
> A centralized unit that deals with security issues at the organizational level.

## Forensics
> [!NOTE]
> The process of collecting, analyzing, and preserving digital evidence.

## Threat Intelligence
> [!NOTE]
> Information that helps organizations understand and mitigate cyber threats.

## Red Teaming
> [!NOTE]
> A more comprehensive testing strategy that involves simulating real-world attacks over an extended period.

## Bug Bounty Program
> [!NOTE]
> A program that rewards individuals for finding and reporting vulnerabilities.

## Penetration Testing Execution Standard (PTES)
> [!NOTE]
> A standard framework for conducting penetration tests.

## Metasploit
> [!NOTE]
> A popular penetration testing framework used to develop and execute exploit code.

## Nmap
> [!NOTE]
> A network scanning tool used to discover hosts and services on a network.

## Burp Suite
> [!NOTE]
> A popular tool for web application security testing.

## Wireshark
> [!NOTE]
> A network protocol analyzer used to capture and analyze network traffic.

## John the Ripper
> [!NOTE]
> A password-cracking tool.

## Aircrack-ng
> [!NOTE]
> A suite of tools for assessing Wi-Fi network security.

## Nikto
> [!NOTE]
> A web server scanner that tests for vulnerabilities.

## Hydra
> [!NOTE]
> A fast and flexible password-cracking tool.

## SQLmap
> [!NOTE]
> An automated tool for detecting and exploiting SQL injection flaws.

## OWASP ZAP (Zed Attack Proxy)
> [!NOTE]
> An open-source web application security scanner.

## Fuzzing
> [!NOTE]
> A testing technique that involves inputting random data to find vulnerabilities.

## Cross-Site Request Forgery (CSRF)
> [!NOTE]
> An attack that tricks a user into performing actions on a web application without their consent.

## Session Hijacking
> [!NOTE]
> An attack that involves taking over a user session to gain unauthorized access.

## Clickjacking
> [!NOTE]
> A technique used to trick users into clicking on something different from what they perceive.

## DNS Spoofing
> [!NOTE]
> An attack where false DNS information is inserted into a DNS resolver's cache.

## ARP Spoofing
> [!NOTE]
> A technique where an attacker sends falsified ARP messages over a local network.

## Eavesdropping
> [!NOTE]
> Secretly listening to private communications.

## Keylogging
> [!NOTE]
> Recording the keystrokes of a user to capture sensitive information.

## Credential Harvesting
> [!NOTE]
> Collecting credentials from users by tricking them into entering them into a fake website or form.

## Spear Phishing
> [!NOTE]
> A targeted phishing attack aimed at a specific individual or organization.

## Watering Hole Attack
> [!NOTE]
> An attack strategy where the attacker infects websites likely to be visited by a specific group of individuals.

## Rogue Access Point
> [!NOTE]
> A wireless access point that has been installed on a network without authorization.

## Botnet
> [!NOTE]
> A network of compromised devices controlled by an attacker.

## Malvertising
> [!NOTE]
> The use of online advertising to spread malware.

## Drive-by Download
> [!NOTE]
> The unintentional download of malicious software to a

 user’s device.

## Honey Pot
> [!NOTE]
> A decoy system set up to attract and detect attackers.

## Honey Net
> [!NOTE]
> A network of honeypots that simulate a network to lure attackers.

## Time-based One-Time Password (TOTP)
> [!NOTE]
> A temporary passcode generated by an algorithm that uses the current time as one of its factors.

## Two-Factor Authentication (2FA)
> [!NOTE]
> A security process that requires two separate forms of identification.

## Full Disk Encryption (FDE)
> [!NOTE]
> Encryption that covers all the data on a disk.

## Advanced Persistent Threat (APT)
> [!NOTE]
> A prolonged and targeted cyberattack in which an intruder gains access to a network and remains undetected.

## Supply Chain Attack
> [!NOTE]
> Attacking an organization by targeting less-secure elements in its supply chain.

## Insider Threat
> [!NOTE]
> A security risk that comes from within the organization, typically from employees or contractors.

## Virtual Machine Escape
> [!NOTE]
> An attack that allows an attacker to escape the confines of a virtual machine and interact with the host operating system.

## Patch Tuesday
> [!NOTE]
> The second Tuesday of each month when Microsoft releases security updates.

## Kill Chain
> [!NOTE]
> A model used to describe the stages of a cyberattack, from reconnaissance to exfiltration.

## Data Exfiltration
> [!NOTE]
> The unauthorized transfer of data from a computer or other device.

## Security Information and Event Management (SIEM)
> [!NOTE]
> A solution that provides real-time analysis of security alerts generated by network hardware and applications.

## Security Orchestration, Automation, and Response (SOAR)
> [!NOTE]
> Tools that automate the response to security incidents.

## Threat Hunting
> [!NOTE]
> The process of proactively searching for cyber threats that are lurking undetected in a network.

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

