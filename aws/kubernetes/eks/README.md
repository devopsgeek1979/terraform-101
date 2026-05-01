# infra-aws-eks

Production EKS cluster: private endpoint only, encrypted secrets (KMS), managed node groups with IMDSv2 and encrypted EBS, CloudWatch logging.

## Provisioning Steps

```bash
cat > terraform.tfvars <<EOF
project            = "my-project"
environment        = "prod"
vpc_id             = "vpc-xxxxxxxx"
private_subnet_ids = ["subnet-aaa","subnet-bbb","subnet-ccc"]
kubernetes_version = "1.29"
kms_key_arn        = "arn:aws:kms:us-east-1:ACCOUNT_ID:key/KEY_ID"
node_instance_types = ["m6i.xlarge"]
node_desired_size  = 3
node_min_size      = 2
node_max_size      = 6
EOF

terraform init
terraform plan -out=tfplan
terraform apply tfplan

# Update kubeconfig
aws eks update-kubeconfig --region us-east-1 --name infra-aws-eks-prod
```

## Common Failure Points

| Symptom | Root Cause | Fix |
|---|---|---|
| Nodes not joining cluster | Node IAM role missing AmazonEKSWorkerNodePolicy | Check `aws_iam_role_policy_attachment` resources |
| `exec plugin: invalid apiVersion` | aws CLI / kubeconfig mismatch | Update AWS CLI and run `update-kubeconfig` again |
| Secrets not encrypted | KMS key policy missing `eks.amazonaws.com` | Add EKS service principal to KMS key policy |
| Private endpoint unreachable | No VPC endpoint or bastion | Create `eks.amazonaws.com` VPC interface endpoint |

## Troubleshooting YAMLs

```bash
# CNI failures
kubectl apply -f ../../../troubleshooting/kubernetes/cni-imagepull-oomkill.yaml

# OOMKill alerts
kubectl apply -f ../../../troubleshooting/kubernetes/cni-imagepull-oomkill.yaml

# RBAC validation
kubectl apply -f ../../../troubleshooting/kubernetes/rbac-validation.yaml
kubectl logs -n troubleshooting job/rbac-audit
```
