$subscriptionId='ead6231b-67c2-496c-a2e5-d2ee7fb3491a'
$resourceGroupName="lws-poc-eus-pnp-rg"
$clusterName="lws-poc-eus-pnp-aks"
$acrName="lwseusdmastertemplatesacr"

# Connect to AKS Cluster
az login
az account set --subscription $subscriptionId
az aks get-credentials --resource-group $resourceGroupName --name $clusterName

# Deploy Custom Images to AKS
$imageName="lwseusdmastertemplatesacr.azurecr.io/images/helloworldpanopticaapi"

az acr login --name $acrName
# docker build -t $imageName ../src/HelloWorldPanoptica.Api
docker tag helloworldpanopticaapi:dev $imageName
docker push $imageName


#Scan Images
accessKey="" #TODO: Move to env file before checkin
secretKey="" #TODO: Move to env file before checkin
../Plugins/

securecn_deployment_cli run-vulnerability-scan --access-key $accessKey --secret-key $secretKey --image-name=$imageName:latest

  
#Deploy hello world apps
kubectl apply -f aks-helloworld-one.yaml --namespace ingress-basic
kubectl apply -f aks-helloworld-two.yaml --namespace ingress-basic

#Deploy Ingress
kubectl apply -f hello-world-ingress.yaml --namespace ingress-basic


kubectl get ingress -o wide --all-namespaces



#Add SecureApplication-protected label to all relevant namespaces
kubectl label namespace $(kubectl get namespaces | awk '{print$1}' | grep -v -e NAME -e kube-public -e kube-system -e istio-system -e portshift) SecureApplication-protected=full --overwrites