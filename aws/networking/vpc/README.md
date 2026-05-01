# infra-aws-vpc

Production-grade AWS VPC module with multi-AZ subnets, NAT Gateways, VPC Flow Logs, and hardened security group defaults.

## Provisioning Steps

```bash
# 1. Update backend.tf with your S3 bucket and DynamoDB table
# 2. Set required variables
cat > terraform.tfvars <<EOF
project     = "my-project"
environment = "prod"
vpc_cidr    = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
private_subnet_cidrs = ["10.0.11.0/24","10.0.12.0/24","10.0.13.0/24"]
availability_zones   = ["us-east-1a","us-east-1b","us-east-1c"]
kms_key_arn = "arn:aws:kms:us-east-1:ACCOUNT_ID:key/KEY_ID"
EOF

# 3. Initialize and apply
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

## Common Failure Points

| Symptom | Root Cause | Fix |
|---|---|---|
| `Error: Error creating NAT Gateway` | EIP limit reached | Request EIP quota increase in AWS console |
| `InvalidVpcID.NotFound` | Module applied before VPC is ready | Re-run `terraform apply` — eventual consistency |
| Flow logs not appearing in CloudWatch | IAM role missing `logs:PutLogEvents` | Verify `aws_iam_role_policy.flow_logs` was created |
| Private subnet has no internet access | NAT Gateway in wrong subnet | Ensure NAT is in **public** subnet |

## Troubleshooting YAML

Use `../../troubleshooting/networking/cross-cloud-latency.yaml` to test VPN/peering latency:

```bash
kubectl apply -f ../../troubleshooting/networking/cross-cloud-latency.yaml
kubectl logs -n troubleshooting pod/netshoot-latency -f
```

Use `../../troubleshooting/networking/dns-debug.yaml` for DNS resolution issues:

```bash
kubectl apply -f ../../troubleshooting/networking/dns-debug.yaml
kubectl exec -n troubleshooting dnsutils -- nslookup kubernetes.default
```
