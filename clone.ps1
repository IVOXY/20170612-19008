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
$paramconf = "C:\webcommander\powershell\20170612-19008\config.json"


# Import config data in JSON format
try {
    $conf = get-content -raw -path $paramconf |convertfrom-json
}
catch {throw "invalid config"}


# Connect to required resources
connect-viserver -server $conf.vcenter.ip -user $conf.vcenter.user -Password $conf.vcenter.password
#Connect-NsxServer -server $conf.nsx.ip -user $conf.nsx.user -Password $conf.nsx.password


$vms = get-vm -location $conf.cloneenv

foreach ($vm in $vms) {
    $prefix,$oldenv,$newvm = $vm -split '-'
    New-VM -Name "$prefix-$env-$newvm" -VM (get-vm $vm) -Location "$env"  -Datastore $conf.vcenter.datastore -ResourcePool Resources -LinkedClone -ReferenceSnapshot $conf.clonesnap
    $oldnetadapter = get-vm -Name $vm | get-networkadapter
    $oldnetworkname = $oldnetadapter.NetworkName -match '.+BECU-(?<ENV>.+)-(?<SEG>.+)$'
    $seg = $Matches.seg
    get-vm "$prefix-$env-$newvm" |get-networkadapter |Set-NetworkAdapter -Portgroup (get-vdportgroup -name "*$env*$seg") -confirm:$false
    $mac = ((get-vm "$vm" |get-networkadapter).MacAddress)
   



    ## script function:  set the MAC address of a VM's NIC
    ## Author: vNugglets.com
 
    ## the name of the VM whose NIC's MAC address to change
    $strTargetVMName = "$prefix-$env-$newvm"
    ## the MAC address to use
    $strNewMACAddr = "$mac"
 
 write-host $strTargetVMName
 write-host $strNewMACAddr


    ## get the .NET view object of the VM
    $viewTargetVM = Get-View -ViewType VirtualMachine -Property Name,Config.Hardware.Device -Filter @{"Name" = "^${strTargetVMName}$"}
    ## get the NIC device (further operations assume that this VM has only one NIC)
    $deviceNIC = $viewTargetVM.Config.Hardware.Device | Where-Object {$_ -is [VMware.Vim.VirtualEthernetCard]}
    ## set the MAC address to the specified value
    $deviceNIC.MacAddress = $strNewMACAddr
    ## set the MAC address type to manual
    $deviceNIC.addressType = "Manual"
 
    ## create the new VMConfigSpec
    $specNewVMConfig = New-Object VMware.Vim.VirtualMachineConfigSpec -Property @{
       ## setup the deviceChange object
       deviceChange = New-Object VMware.Vim.VirtualDeviceConfigSpec -Property @{
           ## the kind of operation, from the given enumeration
           operation = "edit"
           ## the device to change, with the desired settings
           device = $deviceNIC
       } ## end New-Object
    } ## end New-Object
 
    ## reconfigure the "clone" VM
    $viewTargetVM.ReconfigVM($specNewVMConfig)


    #end imported code

    #get-vm "$prefix-$env-$newvm" |get-networkadapter |Set-NetworkAdapter -MacAddress 00:50:56:9d:cb:8e
    get-vm -name "$prefix-$env-$newvm" | start-vm



}


#write-host $env

# Disconnect from resources
Disconnect-VIServer -confirm:$false
#Disconnect-NsxServer -confirm:$false



