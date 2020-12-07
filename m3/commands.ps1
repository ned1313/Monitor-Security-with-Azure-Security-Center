#Log into Azure
Add-AzAccount

#Select the correct subscription
Get-AzSubscription -SubscriptionName "SUB_NAME" | Select-AzSubscription

#Set some basic variables
$prefix = "asc"
$Location = "eastus"
$id = Get-Random -Minimum 1000 -Maximum 9999

#Now let's create the Windows VM
$winVMRGName = "$prefix-winvm-$id"

#Create the necessary resource groups
$winVMRG = New-AzResourceGroup -Name $winVMRGName -Location $Location

#Define parameter values for the ARM template
$winVMParameters = @{
    adminUsername = "winadmin"
    adminPassword = 'n6Uz^)N.d!j+uE'
    dnsLabelPrefix = "$($prefix)win$id"
}

$winVMDeploymentParameters = @{
    Name = "winVMDeploy"
    ResourceGroupName = $winVMRG.ResourceGroupName
    TemplateFile = ".\azuredeploy.json"
    TemplateParameterObject = $winVMParameters
    Mode = "Incremental"
}

New-AzResourceGroupDeployment @winVMDeploymentParameters