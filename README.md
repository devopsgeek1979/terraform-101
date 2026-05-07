# Terraform 101: Multi-Cloud Production Templates

Production-grade Terraform and Kubernetes troubleshooting templates for **AWS**, **Azure**, **GCP**, and **VMware vSphere/TKGS**.

## Why this repo

This repository is built as a practical blueprint for platform teams who need:

- Consistent multi-cloud infrastructure patterns
- Reusable Terraform module structure
- Security-first defaults (private networking, encryption, least privilege)
- Real troubleshooting manifests for day-2 operations

## What’s included

### Terraform templates

Each component follows a consistent module shape:

- `main.tf`
- `variables.tf`
- `outputs.tf`
- `providers.tf`
- `backend.tf`

### Cloud coverage matrix

| Domain | AWS | Azure | GCP | VMware |
| --- | --- | --- | --- | --- |
| Networking | VPC | VNet | VPC | Port Groups |
| Compute | EC2 | VM | GCE | vSphere VM |
| Kubernetes | EKS | AKS | GKE | TKGS |
| State management | S3 backend | Blob backend | GCS backend | SAN-backed local backend |

### Troubleshooting YAMLs

Operational manifests under `troubleshooting/` for:

- Network latency/connectivity diagnostics
- DNS debugging
- Storage I/O benchmarking
- CNI/ImagePull/OOMKill scenarios
- RBAC/permission validation
- VMware/TKGS-specific diagnostics

## Repository structure

```text
aws/
azure/
gcp/
vsphere/
troubleshooting/
```

## Quick start

### 1) Clone

```bash
git clone https://github.com/devopsgeek1979/terraform-101.git
cd terraform-101
```

### 2) Pick a module

```bash
cd aws/networking/vpc
```

### 3) Configure backend + variables

Update `backend.tf` and provide `terraform.tfvars` (or environment variables).

### 4) Deploy

```bash
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

## VMware SAN state management

For vSphere modules, SAN-local state/versioning assets live in:

- `vsphere/state-management/backend.tf`
- `vsphere/state-management/backend.hcl.example`
- `vsphere/state-management/snapshot_state.sh`
- `vsphere/state-management/restore_state.sh`

Example:

```bash
cd vsphere/networking/port-groups
cp ../../state-management/backend.hcl.example ../../state-management/backend.hcl
terraform init -backend-config=../../state-management/backend.hcl
```

## Troubleshooting examples

```bash
kubectl apply -f troubleshooting/networking/cross-cloud-latency.yaml
kubectl apply -f troubleshooting/vmware/tkgs-connectivity-dns.yaml
kubectl apply -f troubleshooting/vmware/tkgs-storage-io.yaml
kubectl apply -f troubleshooting/vmware/tkgs-rbac-validation.yaml
```

## Engineering standards used

- Modular Terraform architecture per component
- Cloud parity by domain and naming consistency (`infra-{cloud}-{resource}`)
- Encryption-at-rest and private networking defaults
- Least-privilege identity/access posture
- Docs and troubleshooting assets colocated with templates

## Contributing

1. Create a feature branch.
2. Keep module structure and naming conventions consistent.
3. Validate Terraform syntax and run targeted checks.
4. Open a pull request with clear scope and change rationale.

## Disclaimer

These templates are production-oriented starting points and should be adapted to your organization’s compliance, networking, IAM, and operational requirements.
