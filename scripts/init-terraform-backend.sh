#!/bin/bash

# ENV Path
ENV_PATH="../.env"

# Load variables from the .env file
if [ -f "$ENV_PATH" ]; then
  echo "Loading environment variables from $ENV_PATH"
  export $(grep -v '^#' "$ENV_PATH" | xargs)
else
  echo ".env file not found at $ENV_PATH"
  exit 1
fi

# Assign variables from loaded env
RESOURCE_GROUP=$TF_BACKEND_RESOURCE_GROUP
STORAGE_ACCOUNT=$TF_BACKEND_STORAGE_ACCOUNT
CONTAINER_NAME=$TF_BACKEND_CONTAINER_NAME
LOCATION=$TF_BACKEND_LOCATION

echo "Creating resource group..."
az group create --name $RESOURCE_GROUP --location $LOCATION

echo "Creating storage account..."
az storage account create \
  --name $STORAGE_ACCOUNT \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION \
  --sku Standard_LRS \
  --encryption-services blob

echo "Getting storage account key..."
ACCOUNT_KEY=$(az storage account keys list \
  --resource-group $RESOURCE_GROUP \
  --account-name $STORAGE_ACCOUNT \
  --query "[0].value" -o tsv)

echo "Creating blob container..."
az storage container create \
  --name $CONTAINER_NAME \
  --account-name $STORAGE_ACCOUNT \
  --account-key "$ACCOUNT_KEY"

echo "Terraform backend is ready."
