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

*Continue adding new steps below using the same format as your project progresses.*