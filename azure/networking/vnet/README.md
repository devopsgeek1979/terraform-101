# infra-azure-vnet

Production Azure VNet with public/private subnets, NSG deny-all baseline, and Network Watcher.

## Provisioning Steps

```bash
az login
cat > terraform.tfvars <<EOF
project             = "my-project"
environment         = "prod"
location            = "eastus"
vnet_cidr           = "10.1.0.0/16"
public_subnet_cidr  = "10.1.1.0/24"
private_subnet_cidr = "10.1.11.0/24"
EOF

terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

## Common Failure Points

| Symptom | Root Cause | Fix |
|---|---|---|
| `AuthorizationFailed` | Service principal lacks Contributor | Assign `Contributor` on target subscription |
| NSG blocks all traffic | `DenyAllInbound` rule at priority 4096 | Add explicit allow rules at priority < 4096 |
| Network Watcher already exists | One watcher per region limit | Import existing watcher: `terraform import` |

## Troubleshooting YAML

```bash
kubectl apply -f ../../troubleshooting/networking/cross-cloud-latency.yaml
kubectl apply -f ../../troubleshooting/networking/dns-debug.yaml
```
