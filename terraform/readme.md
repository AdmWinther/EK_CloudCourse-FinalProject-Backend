# Terraform Project Setup Guide

This document outlines the steps taken to set up and configure this Terraform project. Each section describes a key step in the process. Future steps can be added using the same format.

---

## 1. Install Azure CLI

To interact with Azure resources, the Azure CLI was required. Installation was performed using [winget](https://learn.microsoft.com/en-us/windows/package-manager/winget/):

```sh
winget install Microsoft.AzureCLI
```

---

## 2. Azure CLI Login and Subscription Management

After installing the CLI, logging in was necessary:

```sh
az login
```

### Subscription Issue

Initially, I logged in with a different account, which caused a subscription mismatch. To resolve this:

1. Cleared all cached account information:
    ```sh
    az account clear
    ```
2. Logged in again with the correct account:
    ```sh
    az login
    ```

This ensured the correct subscription was selected for the project.

---

## 3. Database Provisioning and Teardown

The database was successfully created and destroyed using Terraform scripts. This validated the infrastructure automation setup and ensured that resources could be managed reliably.

---

## 4. Apache James Container Preparation

To deploy Apache James, the following steps were performed:

1. Pulled the official `apache/james` Docker image:
    ```sh
    docker pull apache/james
    ```
2. Created an Azure Container Registry (ACR) to store custom images. It was done on the UI but it seems like it could also be done using CLI and the following command.
    ```sh
    az acr create --resource-group <resource-group> --name <acr-name> --sku Basic
    ```
    The ACR name is "containerregisteryforcloudcourse" and its login server is: containerregisteryforcloudcourse.azurecr.io

3. under settings of the ACR/Settings/Access Keys, I enabled the Admin user. 

4. Tagged the Apache James image for the ACR:
    ```sh
    docker tag apache/james:jpa-3.8.2 containerregisteryforcloudcourse.azurecr.io/apache-james:3.8.2
    ```
    it was confirmed by running:
    ```sh
    docker images
    ```
    a new image with the tag is present.

5. Pushed the tagged image to the ACR:
    ```sh
    docker push containerregisteryforcloudcourse.azurecr.io/apache-james:3.8.2
    ```

---

So now when I make a container, I can use "containerregisteryforcloudcourse.azurecr.io/apache-james:3.8.2" for the image url.

> **Note:** During the provisioning process, Azure deployments were noticeably slower compared to AWS. While AWS could complete similar tasks in under a minute, Azure often took more than 7 minutes to build resources. This difference in provisioning speed was a significant challenge during setup. for example, buiding a DB-server takes 4 minutes!!! I cannot believe it!

*Continue adding new steps below using the same format as your project progresses.*

6. At this step, I can successfully create the container and destroy it. Now I need to connect the DB to James container.