+++
title = "Azure Kubernetes Service (AKS)"
description = "Azure and Kubernetes K8"
linkTitle = "Azure Kubernetes Service"
summary = "Use Habitat with AKS, including setting up Azure Container Registry (ACR) and connecting it to AKS."

[menu.containers]
    title = "Azure Kubernetes Service"
    identifier = "containers/aks Chef Habitat Azure Kubernetes"
    parent = "containers"
    weight = 40
+++

[Azure Kubernetes Service (AKS)](https://azure.microsoft.com/en-us/products/kubernetes-service/)
is a fully managed Kubernetes service running on the Azure platform.

## Azure Container Registry (ACR)

Azure Container Registry is a managed Docker container registry service for storing private Docker container images. It's a fully managed Azure resource and provides local, network-close storage of your container images when deploying to AKS.

To do this, create an Azure Service Principal that has `Owner` rights on your ACR instance. You can do this with the following script, changing the environment variable values to match your environment.

```sh
  !/bin/bash

    R_RESOURCE_GROUP=myACRResourceGroup
    R_NAME=myACRRegistry
BLDR_PRINCIPAL_NAME=myPrincipalName
BLDR_PRINCIPAL_PASSWORD="ThisIsVeryStrongPassword"

    Create Service Principal for Chef Habitat Builder
    R_ID=$(az acr show --name $ACR_NAME --resource-group $ACR_RESOURCE_GROUP --query "id" --output tsv)
     ad sp create-for-rbac --scopes $ACR_ID --role Owner --password "$BLDR_PRINCIPAL_PASSWORD" --name $BLDR_PRINCIPAL_NAME
BLDR_ID=$(az ad sp list --display-name $BLDR_PRINCIPAL_NAME  --query "[].appId" --output tsv)

    ho "Configuration details for Habitat Builder Principal:"
echo "  ID : $BLDR_ID"
echo "  Password : $BLDR_PRINCIPAL_PASSWORD"
```

Note: The unique Service Principal Name (the UUID) should be provided in the Chef Habitat Builder
configuration.

## Connect ACR and AKS

Since ACR is a private Docker registry, AKS must be authorized to pull images from it. To do this, create a role assignment on the Service Principal that's automatically created for AKS, granting it `Reader` access on your ACR instance.

To do this you can use the following script, changing the environment variable values to match your configuration.

```sh
#!/bin/bash

AKS_RESOURCE_GROUP=myAKSResourceGroup
AKS_CLUSTER_NAME=myAKSCluster
ACR_RESOURCE_GROUP=myACRResourceGroup
ACR_NAME=myACRRegistry

# Get the id of the service principal configured for AKS
CLIENT_ID=$(az aks show --resource-group $AKS_RESOURCE_GROUP --name $AKS_CLUSTER_NAME --query "servicePrincipalProfile.clientId" --output tsv)

# Get the ACR Registry Resource ID
ACR_ID=$(az acr show --name $ACR_NAME --resource-group $ACR_RESOURCE_GROUP --query "id" --output tsv)

# Create Role Assignment
az role assignment create --assignee $CLIENT_ID --role Reader --scope $ACR_ID
```

## Related reading

* [Authenticate with Azure Container Registry (ACR) from Azure Kubernetes Service (AKS)](https://docs.microsoft.com/azure/container-registry/container-registry-auth-aks)
