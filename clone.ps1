<#

.SYNOPSIS
This script will clone a static lab environment from a master

.DESCRIPTION
this script accepts 1 parameters: the enviorment to be refreshed. Envionments will be specfied by a folder. I haven't added
folder error checking, so you can test you input with the get-vm -location commandlet.

Config file location is hard wired.

.EXAMPLE
.\clone.ps1 -env ENV2 

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


$vms = get-vm -location $conf.cloneenv

foreach ($vm in $vms) {
    $prefix,$oldenv,$newvm = $vm -split '-'
    New-VM -Name "$prefix-$env-$newvm" -VM (get-vm $vm) -Location "$env"  -Datastore $conf.vcenter.datastore -ResourcePool Resources -LinkedClone -ReferenceSnapshot $conf.clonesnap
    $oldnetadapter = get-vm -Name $vm | get-networkadapter
    $oldnetworkname = $oldnetadapter.NetworkName -match '.+BECU-(?<ENV>.+)-(?<SEG>.+)$'
    $seg = $Matches.seg
    get-vm "$prefix-$env-$newvm" |get-networkadapter |Set-NetworkAdapter -Portgroup (get-vdportgroup -name "*$env*$seg") -confirm:$false
    get-vm -name "$prefix-$env-$newvm" | start-vm
}


#write-host $env

# Disconnect from resources
#Temporarily disabled for basic testing
#Disconnect-VIServer -confirm:$false
#Disconnect-NsxServer -confirm:$false



