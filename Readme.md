Create the private aks cluster
---------- 
    1. terraform 
    2. azure service principals
---------- 
Create the service principal

    #=> ... Go to azure cli
    az ad sp create-for-rbac --name private-aks-cluster-sp
    #=> Copy it (.... .....)

Assign the variables in config.tfvars

    1. update the config.tfvars params 
Resources
---------- 
    1. vnet with two subnets
    2. aks private cluster 
    3. kubernetes apiserver access server
---------- 

Commands
---------- 
    initial => terraform init
    plan    => terraform plan -var-file=config.tfvars
    create  => terraform apply -auto-approve -var-file=config.tfvars
    delete  => terraform destroy -auto-approve -var-file=config.tfvars
---------- 

How to access the priate aks cluster
----------
    ssh -i key username@ipaddess
    sudo -i
    kubectl get all
----------
