$subscriptionId='ead6231b-67c2-496c-a2e5-d2ee7fb3491a'
$location="eastus2"
$resourceGroupName="lws-poc-eus-pnp-rg"
$clusterName="lws-poc-eus-pnp-aks"


# Set Current Subscription Context
az login
az account set --subscription $subscriptionId

#Create Resource Group
az group create --name $resourceGroupName --location $location

#Create Keyvault with Addons
az aks create -g $resourceGroupName `
  -n $clusterName `
  -l $location `
  --generate-ssh-keys `
  --enable-secret-rotationkubec
az aks get-credentials --resource-group $resourceGroupName --name $clusterName

#Deploy Ingress Controller
$NAMESPACE="ingress-basic"
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm install ingress-nginx ingress-nginx/ingress-nginx `
  --create-namespace `
  --namespace $NAMESPACE 



  
