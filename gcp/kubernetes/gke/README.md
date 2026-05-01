# infra-gcp-gke

Private GKE cluster with Workload Identity, CMEK etcd encryption, Shielded nodes, Binary Authorization, and VPC-native networking.

## Provisioning Steps

```bash
cat > terraform.tfvars <<EOF
project_id             = "my-gcp-project"
environment            = "prod"
region                 = "us-central1"
network_self_link      = "projects/my-gcp-project/global/networks/infra-gcp-vpc-prod"
subnetwork_self_link   = "projects/my-gcp-project/regions/us-central1/subnetworks/infra-gcp-subnet-private-prod"
master_ipv4_cidr_block = "172.16.0.0/28"
kms_key_self_link      = "projects/my-gcp-project/locations/us-central1/keyRings/gke-ring/cryptoKeys/gke-key"
EOF

terraform init
terraform plan -out=tfplan
terraform apply tfplan

# Get credentials
gcloud container clusters get-credentials infra-gcp-gke-prod \
  --region us-central1 --project my-gcp-project
```

## Common Failure Points

| Symptom | Root Cause | Fix |
|---|---|---|
| `Permission denied` creating cluster | Missing `container.clusters.create` | Grant `roles/container.admin` to Terraform SA |
| Binary Authorization blocks images | Policy not configured with allowed images | Add attestor/policy or set to `PERMISSIVE` for initial rollout |
| Nodes not registering | Firewall blocks master → node communication | Allow port 10250 from master CIDR to nodes |
| CMEK error on cluster create | KMS key policy missing GKE SA | Add `roles/cloudkms.cryptoKeyEncrypterDecrypter` to GKE SA |

## Troubleshooting YAMLs

```bash
kubectl apply -f ../../../troubleshooting/kubernetes/cni-imagepull-oomkill.yaml
kubectl apply -f ../../../troubleshooting/kubernetes/rbac-validation.yaml
kubectl apply -f ../../../troubleshooting/compute/cpu-memory-stress.yaml
```
