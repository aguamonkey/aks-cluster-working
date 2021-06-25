sudo apt update

# Install the azure CLI:
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Login to azure:
az login

# Will display a number of ids:

# tenant id = ""
# id = ""

# The tenantId will be used later
# So will the id. This will later become our ARM_SUBSCRIPTION_ID when we export it.

# Get a service principle by passing in the id given above to this line of code:
# We're assigining it the role of Contributor (This could be changed at a later date)
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<subscription_id>"

# The above line of code will display:

#  "appId": "",
#  "displayName": "",
#  "name": "",
#  "password": "",
#  "tenant": ""

# The name, password and tenantid will be used later on. 
# You must store your password as it won't be accessible again.

# This is the command where you pass through the three mentioned above:
az login --service-principal -u <service_principal_name> -p "<service_principal_password>" --tenant "<service_principal_tenant>"

# Install terraform:
sudo apt update && sudo apt upgrade -y
sudo apt install -y unzip wget

wget https://releases.hashicorp.com/terraform/1.0.1/terraform_1.0.1_linux_amd64.zip

unzip terraform_*_linux_*.zip

sudo mv terraform /usr/local/bin

rm terraform_*_linux_*.zip

# Verify installation:
terraform --version


# After creating all of the files you then have to create a storage account.
# Make a note of the storage account name as well as the first keys value
# within the access keys. 

# The result of the above will be passed in here:
# Create a container in your azure storage account:
az storage container create -n tfstate --account-name <YourAzureStorageAccountName> --account-key <YourAzureStorageAccountKey>

# If correct will come up with created: true

# Then create the kluster using your storage account name and key:
terraform init -backend-config="storage_account_name=<YourAzureStorageAccountName>" -backend-config="container_name=tfstate" -backend-config="access_key=<YourStorageAccountAccessKey>" -backend-config="key=codelab.microsoft.tfstate"

# Assuming all is well export your service principal app id and password:
export TF_VAR_client_id=<service-principal-appid>
export TF_VAR_client_secret=<service-principal-password>

# In order to avoid an error telling you that your service principle is not allowed
# access to your cluster you need to set the following:

# Client ID is the app ID
export ARM_CLIENT_ID=""

# CLient secret is the password
export ARM_CLIENT_SECRET=""

# the subscription id is the id you get when running the command: az account list
export ARM_SUBSCRIPTION_ID=""

# Tenant ID id the tenant
export ARM_TENANT_ID=""

#Also have to make sure you run ssh-keygen at some point for the variables in the cluster
ssh-keygen

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

# Verify your connection to the cluster using:
kubectl get nodes


