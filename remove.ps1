﻿<#

.SYNOPSIS
This script will remove a static lab environment

.DESCRIPTION
this script accepts 1 parameters: the enviorment to be refreshed. Envionments will be specfied by a folder. I haven't added
folder error checking, so you can test you input with the get-vm -location commandlet.

Config file location is hard wired.

.EXAMPLE
.\Remove.ps1 -env ENV2 

.NOTES
N/A

.LINK
http://github.com/ivoxy

#>

param([string[]]$env)

# Variable declarations
$paramconf = "./config.json"


# Import config data in JSON format
try {
    $conf = get-content -raw -path $paramconf |convertfrom-json
}
catch {throw "invalid config"}


# Connect to required resources
#Temporarily disabled for basic testing 
#connect-viserver -server $conf.vcenter.ip -user $conf.vcenter.user -Password $conf.vcenter.password
#Connect-NsxServer -server $conf.nsx.ip -user $conf.nsx.user -Password $conf.nsx.password


get-vm -location $env | Stop-VM -Confirm:$false 
get-vm -location $env | remove-vm -DeletePermanently:$true -Confirm:$false 



# Disconnect from resources
#Temporarily disabled for basic testing
#Disconnect-VIServer -confirm:$false
#Disconnect-NsxServer -confirm:$false



