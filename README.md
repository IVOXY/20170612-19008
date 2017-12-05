# 20170612-19008

Executing Test Scripts:

Web Method:

Log in to https://script2.lab.local with administrator@lab.local : Clab4911!
There will be a few commands listed: 
 - Clone an Environment: this script accepts a dropdown and creates a new environment
 - Remove an Environment: this script accepts a dropdown and removes a new environment
 - Refresh an Environmen: this script accepts a dropdown and both removes then creates a new environment

Click on one of the scripts above and select an environment from the dropdown, then click the run button.
It is a good idea to log in to the vCenter server to see what is happening.

Command Line Method:

RDP script2.lab.local
Your named account has access to the server, but I think it is easiest to log in with administrator@lab.local (password is Clab4911!).
Once logged in, the powershell IDE should be up on the screen.

Scripts are located here: c:\webcommander\powershell\20170612-19008

They can be executed from a powershell prompt by typing: 
 c:\webcommander\powershell\20170612-19008\clone.ps1 -env env2
 c:\webcommander\powershell\20170612-19008\remove.ps1 -env env2

Script Testing Environment:
For this script environment we are going to configure the following:
There is a shared infrastructure and presentation environment at “BECU-Shared” 10.1.12.0/24
IPs 11-19: ENV1 NAT
IPs 21-29: ENV2 NAT
IPs 101-109: Shared servers
ENV1 will be the master environment, ENV2 is the refresh environment.Each environment will have 3 segments
SEG1: 192.168.1.0/24
SEG2: 192.168.2.0/24
SEG3: 192.168.3.0/24
We will be using CentOS in the environmentThis setup is mostly static with the refresh from master being automated
The same master will be used to seed the VRA environment
