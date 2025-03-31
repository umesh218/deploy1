#!/bin/bash

# Get the public IP from Terraform output
PUBLIC_IP=$(terraform output -raw public_ip)

# Store it in GitHub Secrets using GitHub CLI
gh secret set AZURE_VM_IP -b "$PUBLIC_IP"
