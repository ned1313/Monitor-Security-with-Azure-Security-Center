# We are going to create an Azure SQL instance and Azure Container registry

#Log into Azure
Add-AzAccount

#Select the correct subscription
Get-AzSubscription -SubscriptionName "SUB_NAME" | Select-AzSubscription

#Set some basic variables
$prefix = "asc"
$Location = "eastus"
$id = Get-Random -Minimum 1000 -Maximum 9999

#Now let's create the Azure SQL DB
$sqldbRGName = "$prefix-sql-$id"

#Create the necessary resource groups
$sqldbRG = New-AzResourceGroup -Name $sqldbRGName -Location $Location

#Define parameter values for the ARM template
$sqldbParameters = @{
    serverName = $sqldbRGName
    administratorLogin = "sqladmin"
    administratorLoginPassword = 'n6Uz^)N.d!j+uE'
}

$sqldbDeploymentParameters = @{
    Name = "sqldbDeploy"
    ResourceGroupName = $sqldbRG.ResourceGroupName
    TemplateFile = "https://github.com/Azure/azure-quickstart-templates/blob/master/101-sql-database/azuredeploy.json"
    TemplateParameterObject = $sqldbParameters
    Mode = "Incremental"
}

New-AzResourceGroupDeployment @sqldbDeploymentParameters

#Now let's create the Azure Container Registry
$acrRGName = "$prefix-acr-$id"

#Create the necessary resource groups
$acrRG = New-AzResourceGroup -Name $acrRGName -Location $Location

#Define parameter values for the ARM template
$arcParameters = @{
    acrName = $acrRGName
    acrAdminUserEnabled = true
}

$arcDeploymentParameters = @{
    Name = "arcDeploy"
    ResourceGroupName = $acrRG.ResourceGroupName
    TemplateFile = "https://github.com/Azure/azure-quickstart-templates/blob/master/101-container-registry/azuredeploy.json"
    TemplateParameterObject = $arcParameters
    Mode = "Incremental"
}

New-AzResourceGroupDeployment @arcDeploymentParameters

# Log into ACR with docker
docker login "${acrName}.azurecr.io"

# Pull insecure docker container
docker pull vulnerables/web-dvwa:latest

# Push insecure docker container
docker tag vulnerables/web-dvwa "${acrName}.azurecr.io/testing/web-dvwa"
docker push "${acrName}.azurecr.io/testing/web-dvwa"