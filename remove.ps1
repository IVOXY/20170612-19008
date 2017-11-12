<#

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

# Variable declarations
$paramconf = "./config.json"
param([string[]]$env)

try {
    $conf = get-content -raw -path $paramconf |convertfrom-json
}
catch {throw "invalid config"}




