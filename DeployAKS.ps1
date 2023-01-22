$subscriptionName='LefeWareSolutions-POC'
$location="eastus2"
$resourceGroupName="lws-poc-eus-pnp-rg"
$keyVaultName="lws-poc-eus-pnp-keyvault"
$clusterName="lws-poc-eus-pnp-aks"


# Set Current Subscription Context
az login
az account set --subscription ead6231b-67c2-496c-a2e5-d2ee7fb3491a

#Create Resource Group
az group create --name $resourceGroupName --location $location

#Create Keyvault with Addons - Web Application Routing
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

#Deploy hello world apps
kubectl apply -f aks-helloworld-one.yaml --namespace ingress-basic
kubectl apply -f aks-helloworld-two.yaml --namespace ingress-basic

#Deploy Ingress
kubectl apply -f hello-world-ingress.yaml --namespace ingress-basic


kubectl get ingress -o wide --all-namespaces



#Add SecureApplication-protected label to all relevant namespaces
kubectl label namespace $(kubectl get namespaces | awk '{print$1}' | grep -v -e NAME -e kube-public -e kube-system -e istio-system -e portshift) SecureApplication-protected=full --overwrites