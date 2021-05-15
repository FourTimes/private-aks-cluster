Create the private aks cluster
---------- 
    1. terraform 
    2. azure service principals
---------- 
Create the service principal

    #=> ... Go to azure cli
    az ad sp create-for-rbac --name private-aks-cluster-sp
    #=> Copy it (.... .....)

steps and params

    1. update the config.tfvars params 
Resources
---------- 
    1. vnet with two subnets
    2. aks private cluster 
---------- 

Commands
---------- 
    initial => terraform init
    plan    => terraform plan -var-file=config.tfvars
    create  => terraform apply -auto-approve -var-file=config.tfvars
    delete  => terraform destroy -auto-approve -var-file=config.tfvars
---------- 

How to access the priate ak cluster
-----------
    1. create the vm instance on the jump subnet
    2. install the require packages
-----------

Set environment variable
-----------
    client_id           = "xxxxxxxxxxxxxxx"
    client_secret       = "xxxxxxxxxxxxxxx"
    subscription_id     = "xxxxxxxxxxxxxxx"
    tenant_id           = "xxxxxxxxxxxxxxx"
    resource_group_name = "xxxxxx"
    cluster_name        = "xxxxxx"
-----------

shell commands

-----------
    1. Create ubuntu machine
    2. ssh -l username ipaddress
    3. sudo apt update
    4. curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
    5. az login --service-principal -u $client_id -p $client_secret --tenant $tenant_id
    6. curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    7. chmod +x kubectl
    8. sudo mv kubectl /usr/local/bin/
    9. kubectl version
    10 az account set --subscription $subscription_id
    11. az aks get-credentials --resource-group $resource_group_name --name $cluster_name
    12. kubectl get all
-----------
 