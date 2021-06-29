#!/bin/bash

#Setup a virtual machine and a resource group:
az group create --name terraform-rg
az vm create --name terraform-vm --resource-group terraform-rg --size Standard_B2s --image UbuntuLTS --admin-user joshuabrowne --ssh-key-values=~/.ssh/id_rsa.pub

sudo apt update

# Install the azure CLI:
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
az login

#Install Terraform:
sudo apt update && sudo apt upgrade -y
sudo apt install -y unzip wget

wget https://releases.hashicorp.com/terraform/1.0.1/terraform_1.0.1_linux_amd64.zip

unzip terraform_*_linux_*.zip

sudo mv terraform /usr/local/bin

rm terraform_*_linux_*.zip

# Verify installation:
terraform --version

#create key:
ssh-keygen

#Go to the azure portal and create a managed identity
#Once created select go to resource and select role assignments from the left.
#Select subscription and contributor from the two drop down menus available.

#Initialise terraform
terraform init

#Export Variables based off your managed identity:

export ARM_USE_MSI=true
export ARM_SUBSCRIPTION_ID=159f2485-xxxx-xxxx-xxxx-xxxxxxxxxxxx
export ARM_TENANT_ID=72f988bf-xxxx-xxxx-xxxx-xxxxxxxxxxxx
export ARM_CLIENT_ID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx

export TF_VAR_client_id=#long id inside json view including subscriptions onward

# Terraform plan command:
terraform plan -out out.plan
#The above saves the plan to an out.plan file

# Terraform apply:
terraform apply out.plan

# Extras:
# This is how you connect to kubernetes: / install the kubectl
sudo az aks install-cli

#This is how you download credentials to be used by the kubernetes cli:
az aks get-credentials --resource-group <resource_group_name> --name <cluster_name>
#For this specific set of files:
az aks get-credentials --resource-group azure-k8stest --name group-project-k8s
# Verify your connection to the cluster using:
kubectl get nodes

#If you get an error at any point about importing a resource into the state run the folloing commands:
az group show --name <resource_group_name>
#Then copy the id that comes up
#Then run. #First <azure_resource_group> then your label you've set could be "main" and finally the id you got above
terraform import <Terraform Resource Name>.<Resource Label> <Azure Resource ID>
