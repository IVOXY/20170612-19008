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

write-output "test 1"
write-output $env
write-output "test 2"
get-vm -location $env

# Disconnect from resources
Disconnect-VIServer -confirm:$false
#Disconnect-NsxServer -confirm:$false