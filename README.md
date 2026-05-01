<div align="center">

# 🌩️ terraform-101

### Production-Grade Multi-Cloud Infrastructure Templates

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.6-7B42BC?logo=terraform)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-Supported-FF9900?logo=amazonaws)](https://aws.amazon.com/)
[![Azure](https://img.shields.io/badge/Azure-Supported-0078D4?logo=microsoftazure)](https://azure.microsoft.com/)
[![GCP](https://img.shields.io/badge/GCP-Supported-4285F4?logo=googlecloud)](https://cloud.google.com/)
[![VMware](https://img.shields.io/badge/VMware%20vSphere-Supported-607078?logo=vmware)](https://www.vmware.com/)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

**100+ battle-tested Terraform modules and Kubernetes troubleshooting YAMLs — AWS · Azure · GCP · VMware vSphere**

[Modules](#-modules) · [Troubleshooting YAMLs](#-troubleshooting-yamls) · [Getting Started](#-getting-started) · [Standards](#-engineering-standards) · [Contributing](#-contributing)

</div>

---

## 🗺️ Repository Map

```
terraform-101/
├── aws/                        # Amazon Web Services modules
│   ├── networking/vpc/         # VPC, subnets, NAT, Flow Logs
│   ├── compute/ec2/            # EC2 + IMDSv2 + encrypted EBS
│   └── kubernetes/eks/         # Private EKS + managed node groups
│
├── azure/                      # Microsoft Azure modules
│   ├── networking/vnet/        # VNet, NSG, Network Watcher
│   ├── compute/vm/             # Linux VM + managed disks
│   └── kubernetes/aks/         # Private AKS + AAD RBAC + OMS
│
├── gcp/                        # Google Cloud Platform modules
│   ├── networking/vpc/         # VPC, Cloud NAT, VPC Flow Logs
│   ├── compute/gce/            # GCE + Shielded VM + OS Login
│   └── kubernetes/gke/         # Private GKE + Workload Identity + Binary Auth
│
├── vsphere/                    # VMware vSphere modules
│   ├── networking/port-groups/ # DVS Port Groups (mgmt / workload / storage)
│   ├── compute/vm/             # VM clone from template
│   ├── kubernetes/tkgs/        # Tanzu Kubernetes Grid Supervisor
│   └── state-management/       # SAN-backed state + versioning scripts
│
└── troubleshooting/            # Kubernetes & VMware diagnostic YAMLs
    ├── networking/             # MTR latency, DNS debug
    ├── compute/                # CPU/Memory stress, Storage I/O
    ├── kubernetes/             # CNI, ImagePullBackOff, OOMKill, RBAC
    └── vmware/                 # TKGS connectivity, Storage I/O, RBAC
```

---

## 📦 Modules

Every module ships with a consistent 5-file structure:

| File | Purpose |
|---|---|
| `main.tf` | Core resource definitions |
| `variables.tf` | All inputs with descriptions and validation |
| `outputs.tf` | Useful outputs for downstream modules |
| `providers.tf` | Provider version locks |
| `backend.tf` | Remote state placeholder (S3 / Blob / GCS / SAN) |

### Networking

| Module | Cloud | Highlights |
|---|---|---|
| `aws/networking/vpc` | AWS | Multi-AZ, NAT HA, VPC Flow Logs → CW, deny-all default SG |
| `azure/networking/vnet` | Azure | NSG deny-all baseline, Network Watcher, Service Endpoints |
| `gcp/networking/vpc` | GCP | Global routing, Private Google Access, Cloud NAT, VPC Flow Logs |
| `vsphere/networking/port-groups` | VMware | DVS Port Groups: management / workload / storage VLANs |

### Compute

| Module | Cloud | Highlights |
|---|---|---|
| `aws/compute/ec2` | AWS | Launch Template, IMDSv2, KMS-encrypted EBS, SSM-only IAM |
| `azure/compute/vm` | Azure | SystemAssigned identity, Premium LRS, no public IP |
| `gcp/compute/gce` | GCP | Shielded VM, OS Login, CMEK disk, no external IP |
| `vsphere/compute/vm` | VMware | EFI firmware, thin/thick disk, clone + customize |

### Kubernetes

| Module | Cloud | Highlights |
|---|---|---|
| `aws/kubernetes/eks` | AWS | Private endpoint, KMS secret encryption, managed node groups |
| `azure/kubernetes/aks` | Azure | Private cluster, AAD RBAC, Key Vault CSI, Calico policy |
| `gcp/kubernetes/gke` | GCP | Private nodes, Workload Identity, CMEK etcd, Binary Auth |
| `vsphere/kubernetes/tkgs` | VMware | Supervisor Namespace, TKGs Cluster stub |

---

## 🛠️ Troubleshooting YAMLs

Drop-in Kubernetes/VMware diagnostic pods, jobs, and PrometheusRules — no permanent cluster changes.

### Networking
| YAML | Diagnoses |
|---|---|
| `troubleshooting/networking/cross-cloud-latency.yaml` | MTR latency, iperf3 throughput, tcpdump DaemonSet across clouds |
| `troubleshooting/networking/dns-debug.yaml` | dnsutils pod, CoreDNS debug logging patch |

### Compute
| YAML | Diagnoses |
|---|---|
| `troubleshooting/compute/cpu-memory-stress.yaml` | stress-ng CPU/Memory Jobs, PrometheusRules for OOM/Throttle/DiskPressure |
| `troubleshooting/compute/storage-io-benchmark.yaml` | fio Job + PVC: seq/random read-write IOPS benchmarks |

### Kubernetes
| YAML | Diagnoses |
|---|---|
| `troubleshooting/kubernetes/cni-imagepull-oomkill.yaml` | CNI DaemonSet, skopeo image-pull check, OOMKill/CrashLoop/ImagePullBackOff alerts |
| `troubleshooting/kubernetes/rbac-validation.yaml` | `kubectl auth can-i` audit job, ClusterRole for read-only auditor |

### VMware / TKGS
| YAML | Diagnoses |
|---|---|
| `troubleshooting/vmware/tkgs-connectivity-dns.yaml` | Netshoot pod — DNS, MTR, TCP port checks on TKGs |
| `troubleshooting/vmware/tkgs-storage-io.yaml` | fio Job on vSphere StorageClass PVC |
| `troubleshooting/vmware/tkgs-rbac-validation.yaml` | RBAC audit for TKGs workload namespaces |

---

## 🚀 Getting Started

### Prerequisites

| Tool | Version |
|---|---|
| Terraform | `>= 1.6.0` |
| AWS CLI | `>= 2.x` |
| Azure CLI | `>= 2.x` |
| gcloud CLI | `>= 450.x` |
| kubectl | `>= 1.28` |
| vSphere Terraform Provider | `~> 2.7` |

### Provision a module

```bash
# 1 — clone
git clone https://github.com/devopsgeek1979/terraform-101.git
cd terraform-101

# 2 — pick a module, e.g. AWS VPC
cd aws/networking/vpc

# 3 — fill in your state bucket
cp backend.tf backend.tf.bak
vi backend.tf        # set bucket / dynamodb_table

# 4 — create tfvars
cat > terraform.tfvars <<EOF
project     = "my-project"
environment = "prod"
vpc_cidr    = "10.0.0.0/16"
EOF

# 5 — apply
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

### Run a troubleshooting YAML

```bash
kubectl apply -f troubleshooting/networking/cross-cloud-latency.yaml
kubectl logs -n troubleshooting pod/netshoot-latency -f
kubectl delete -f troubleshooting/networking/cross-cloud-latency.yaml
```

---

## 🔐 Engineering Standards

All modules are built to these non-negotiable defaults:

| Control | Implementation |
|---|---|
| **Encryption at rest** | KMS (AWS) · CMK Managed Disk (Azure) · CMEK (GCP) · Datastore encryption (vSphere) |
| **Private networking** | No public IPs; private subnets / private endpoints everywhere |
| **Least-privilege IAM** | Scoped roles per service; no wildcard `*` actions in production policies |
| **IMDSv2** | `http_tokens = required` on all EC2 / EKS node launch templates |
| **Audit logging** | VPC Flow Logs · Network Watcher · GCP Flow Logs · vSphere events |
| **Provider pinning** | All providers locked with `~>` version constraints |
| **State security** | Remote state encrypted; SAN-backed versioned state for VMware |
| **Naming convention** | `infra-{cloud}-{resource-name}-{environment}` on every resource and tag |

---

## 🗂️ VMware State Management (SAN)

State for vSphere modules is stored on a mounted SAN volume — no cloud dependency.

```bash
# Initialise with SAN backend
cd vsphere/networking/port-groups
terraform init -backend-config=../../state-management/backend.hcl

# Snapshot before every apply
bash ../../state-management/snapshot_state.sh \
  /mnt/san/terraform-state/vsphere/networking/port-groups/prod/terraform.tfstate

# Restore a version
bash ../../state-management/restore_state.sh \
  /mnt/san/terraform-state/.versions/terraform.tfstate.20260430T120000Z \
  /mnt/san/terraform-state/vsphere/networking/port-groups/prod/terraform.tfstate
```

See [`vsphere/state-management/README.md`](vsphere/state-management/README.md) for the full versioning workflow.

---

## 🤝 Contributing

1. Fork the repo and create a feature branch: `git checkout -b feat/your-module`
2. Follow the 5-file module structure and naming convention.
3. Add a `README.md` with provisioning steps and common failure points.
4. Open a PR — describe what cloud, what resource, and what security controls were added.

---

## 📄 License

[MIT](LICENSE) — free to use, modify, and distribute.

---

<div align="center">

Built with ❤️ for engineers who take infrastructure seriously.

⭐ **Star this repo** if it saves you time!

</div>
