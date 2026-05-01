# infra-azure-aks

Private AKS cluster with Azure CNI, Calico network policy, AAD RBAC, Key Vault CSI, OMS agent, and system/user node pool separation.

## Provisioning Steps

```bash
cat > terraform.tfvars <<EOF
project                    = "my-project"
environment                = "prod"
location                   = "eastus"
subnet_id                  = "/subscriptions/.../subnets/aks-subnet"
kubernetes_version         = "1.29"
log_analytics_workspace_id = "/subscriptions/.../workspaces/my-workspace"
EOF

terraform init
terraform plan -out=tfplan
terraform apply tfplan

# Get credentials
az aks get-credentials --resource-group infra-azure-rg-aks-prod \
  --name infra-azure-aks-prod --admin
```

## Common Failure Points

| Symptom | Root Cause | Fix |
|---|---|---|
| `OutboundType userDefinedRouting requires route table` | UDR outbound needs pre-existing route table | Attach a route table with 0.0.0.0/0 → NVA/FW on the subnet |
| Node pool stuck in `Creating` | Subnet too small | Use /22 or larger for node subnet |
| AAD RBAC `Forbidden` | Missing Azure RBAC role | Assign `Azure Kubernetes Service RBAC Cluster Admin` |
| OMS agent not sending data | Log Analytics workspace unreachable | Ensure private endpoint or firewall allows `*.ods.opinsights.azure.com` |

## Troubleshooting YAMLs

```bash
kubectl apply -f ../../../troubleshooting/kubernetes/cni-imagepull-oomkill.yaml
kubectl apply -f ../../../troubleshooting/kubernetes/rbac-validation.yaml
kubectl apply -f ../../../troubleshooting/networking/dns-debug.yaml
```
