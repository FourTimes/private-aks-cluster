#!/bin/bash

client_id=${client_id}
client_secret=${client_secret}
subscription_id=${subscription_id}
tenant_id=${tenant_id}
resource_group_name=${resource_group_name}
cluster_name=${cluster_name}
sudo apt update
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
az login --service-principal -u $client_id -p $client_secret --tenant $tenant_id
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
kubectl version
az account set --subscription $subscription_id
az aks get-credentials --resource-group $resource_group_name --name $cluster_name
kubectl get all
