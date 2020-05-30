# Incident Response Plan

Taken from [NYDFS](https://www.dfs.ny.gov/docs/legal/regulations/adoptions/dfsrf500txt.pdf)
(a) As part of its cybersecurity program, each Covered Entity shall establish a written incident response plan
designed to promptly respond to, and recover from, any Cybersecurity Event materially affecting the
confidentiality, integrity or availability of the Covered Entity’s Information Systems or the continuing
functionality of any aspect of the Covered Entity’s business or operations.
(b) Such incident response plan shall address the following areas:
(1) the internal processes for responding to a Cybersecurity Event;
9 


(2) the goals of the incident response plan;
(3) the definition of clear roles, responsibilities and levels of decision-making authority;
(4) external and internal communications and information sharing;
(5) identification of requirements for the remediation of any identified weaknesses in Information Systems
and associated controls;
(6) documentation and reporting regarding Cybersecurity Events and related incident response activities;
and
(7) the evaluation and revision as necessary of the incident response plan following a Cybersecurity Event.


DEPT.  |  Name. |  Phone Number / E-Mail  | Title/Location
HELPDESK			
INCIDENT RESPONSE COORDINATOR
CYBER ORGANIZATION CONTACT			
CYBER INSURANCE CONTACT			
CYBER LEGAL CONTACT			
PERSON RESPONSIBLE FOR ORGANIZATIONS TECHNICAL SECURITY			
PERSON RESPONSIBLE FOR ORGANIZATIONS NETWORK, SERVERS and ENDPOINTS			
FBI CONTACT.   See this link for more information.			
POLICE CYBER CONTACT			
CYBER FORENSICS CONTACT			
CXO CONTACT			
MANAGEMENT CONTACT	


## Helpdesk
What type of incident is this? Example: virus, worm, intrusion, abuse, damage.
Is the equipment affected business critical?
What data or property is threatened and how critical is it?
What is the impact on the business should the attack succeed? Minimal, serious, or critical?
Name of system being targeted, along with operating system, IP address, and location.  Essentially any information about the origin of the attack.
Is the incident real or perceived?
Is the incident still in progress?
Can the incident be quickly contained?
Will the response alert the attacker and do we care?
The name of the caller.
Time of the call.
Contact information about the caller.
What equipment or persons were involved?
How the incident was detected.
When the event was first noticed that supported the idea that the incident occurred.


If the issue IS or COULD BE real (versus perceived) and the business impact is serious or critical then HELPDESK will call the INCIDENT RESPONSE COORDINATOR.

INCIDENT RESPONSE COORDINATOR Contacts the following people to respond to issue. This is the INCIDENT RESPONSE TEAM:
PERSON RESPONSIBLE FOR ORGANIZATIONS TECHNICAL SECURITY
PERSON RESPONSIBLE FOR ORGANIZATIONS NETWORK, SERVERS and ENDPOINTS
 

## INCIDENT RESPONSE TEAM
> What they Do

gathers and reviews server logs
gather and review firewall logs
gathers and reviews intrusion detection logs
gather and review SIEM logs
gather and review endpoint logs
gather and review email logs (if Phishing was involved)
gather and review secure web gateway logs
begins to interview witnesses and the incident victim to determine how the incident was caused.
 

INCIDENT RESPONSE TEAM

determines the nature of the attack (this might be different than the initial assessment suggests).
Determine the attack point of origin.
Determine the intent of the attack. Was the attack specifically directed at your organization to acquire specific information, or was it random?
Identify the systems that have been compromised.
Identify the files that have been accessed and determine the sensitivity of those files.
Determine whether unauthorized hardware has been attached to the network or whether there are any signs of unauthorized access through the compromise of physical security controls.
Examine key groups (domain administrators, administrators, and so on) for unauthorized entries.
Search for security assessment or exploitation software. Cracking utilities are often found on compromised systems during evidence gathering.
Look for unauthorized processes or applications currently running or set to run using the startup folders or registry entries.
Search for gaps in, or the absence of, system logs.
Review intrusion detection system logs for signs of intrusion, which systems might have been affected, methods of attack, time and length of attack, and the overall extent of potential damage.
Examine other log files for unusual connections; security audit failures; unusual security audit successes; failed logon attempts; attempts to log on to default accounts; activity during nonworking hours; file, directory, and share permission changes; and elevated or changed user permissions.
Compare systems to previously conducted file/system integrity checks. This enables you to identify additions, deletions, modifications, and permission and control modifications to the file system and registry. You can save a lot of time when responding to incidents if you identify exactly what has been compromised and what areas need to be recovered.
Search for sensitive data, such as credit card numbers and employee or customer data, that might have been moved or hidden for future retrieval or modifications. You might also have to check systems for non-business data, illegal copies of software, and e-mail or other records that might assist in an investigation. If there is a possibility of violating privacy or other laws by searching on a system for investigative purposes, you should contact your legal department before you proceed.
Match the performance of suspected systems against their baseline performance levels. This of course presupposes that baselines have been created and properly updated.
 

## INCIDENT RESPONSE TEAM - CATEGORIES

Categories of issues and move them into the highest applicable level of one of the following categories:
**Category one** – A threat to the network
**Category two** – A threat to sensitive data
**Category three** – A threat to computer systems
**Category four** – A disruption of services

If Category one or two then INCIDENT RESPONSE COORDINATOR Contacts CXO CONTACT and MANAGEMENT CONTACT and adds them to the INCIDENT RESPONSE TEAM
 

If Category three or four then INCIDENT RESPONSE COORDINATOR Contacts MANAGEMENT CONTACT and adds the to the INCIDENT RESPONSE TEAM
 

If Category one or two then INCIDENT RESPONSE COORDINATOR Contacts Forensics, Legal and Insurance contacts (note that it is the judgement call of the INCIDENT RESPONSE TEAM if a Category three or four would require Legal and Insurance to be contacted):
CYBER ORGANIZATION CONTACT
CYBER INSURANCE CONTACT
CYBER FORENSICS CONTACT
 

If Category one or two, once Legal and Insurance have provided guidance the INCIDENT RESPONSE TEAM should contact the FBI CONTACT and POLICE CONTACT.
 

### INCIDENT RESPONSE TEAM
They do Evidence Preservation—make copies of logs, email, and other communication. Keep lists of witnesses. Keep evidence as long as necessary to complete prosecution and beyond in case of an appeal.
 

If Category one or two, once FBI and POLICE have been contacted and provide guidance
Segregateall hardware devices suspected of being compromised (if possible) from other business critical devices.
Quarantineinstead of deleting.
RestrictInternet traffic to only business critical servers and ports
Disableremote access capability and wireless access points
Follow direction of CYBER FORENSICE CONTACT, CYBER INSURANCE CONTACT and CYBER ORGANIZATION CONTACT
Create and Execute Communication Plan
Note:   Try to avoid letting attackers know that you are aware of their activities. This can be difficult, because some essential responses might alert attackers.

Compare the cost of taking the compromised and related systems offline against the risk of continuing operations. In the vast majority of cases, you should immediately take the system off the network. However, you might have service agreements in place that require keeping systems available even with the possibility of further damage occurring. Under these circumstances, you can choose to keep a system online with limited connectivity in order to gather additional evidence during an ongoing attack.

In some cases, the damage and scope of an incident might be so extensive that you might have to take action that invokes the penalty clauses specified in your service level agreements. In any case, it is very important that the actions that you will take in the event of an incident are discussed in advance and outlined in this response plan so that immediate action can be taken when an attack occurs.

 

If Category three / four, team members will restore the affected system(s) to the uninfected state. They may do any or more of the following:
Re-install the affected system(s) from scratch and restore data from backups if necessary. Preserve evidence before doing this.
Make users change passwords if necessary
Ensure the systems are fully patched
Create and Execute Communication Plan
 

## INCIDENT RESPONSE TEAM
Assess damage and cost—assess the damage to the organization and estimate both the damage cost and the cost of the containment efforts.
Costs due to the loss of competitive edge from the release of proprietary or sensitive information
Legal costs
Labor costs to analyze the breaches, reinstall software, and recover data
Costs relating to system downtime (for example, lost employee productivity, lost sales, replacement of hardware, software, and other property)
Costs relating to repairing and possibly updating damaged or ineffective physical security measures (locks, walls, cages, and so on)
Other consequential damages such as loss of reputation or customer trust
 

INCIDENT RESPONSE TEAM recommends (documents) changes to prevent the occurrence from happening again. Upon management approval, the changes will be implemented.
 

INCIDENT RESPONSE TEAM 
reviews response and update policies—plan and take preventative steps so the intrusion can’t happen again.
Consider whether an additional policy could have prevented the intrusion.
Consider whether a procedure or policy was not followed which allowed the intrusion, and then consider what could be changed to ensure that the procedure or policy is followed in the future.
Was the incident response appropriate? How could it be improved?
Was every appropriate party informed in a timely manner?
Were the incident-response procedures detailed and did they cover the entire situation? How can they be improved?
Have changes been made to prevent a re-infection? Have all systems been patched, systems locked down, passwords changed, anti-virus updated, email policies set, etc.?
Have changes been made to prevent a new and similar infection?
Should any security policies be updated?
What lessons have been learned from this experience?
Was the incident handled in a timely manner