# VMware Terraform State Management (SAN-Backed)

This pattern stores Terraform state on a mounted SAN volume using the Terraform `local` backend.

## Why this approach

- Keeps state fully on-prem on VMware-backed storage.
- Avoids dependency on public cloud object backends.
- Works with strict data residency controls.

## SAN layout

Use module and environment-specific paths:

- `/mnt/san/terraform-state/vsphere/networking/port-groups/dev/terraform.tfstate`
- `/mnt/san/terraform-state/vsphere/compute/vm/prod/terraform.tfstate`
- `/mnt/san/terraform-state/vsphere/kubernetes/tkgs/prod/terraform.tfstate`

## Initialization

```bash
cd /Users/shashi/Downloads/terraform-yamls/vsphere/networking/port-groups
cp ../../state-management/backend.hcl.example ../../state-management/backend.hcl
terraform init -backend-config=../../state-management/backend.hcl
```

## State versioning on SAN

Use the provided scripts:

```bash
# create timestamped snapshot copies
bash ../../state-management/snapshot_state.sh /mnt/san/terraform-state/vsphere/networking/port-groups/prod/terraform.tfstate

# list versions for a state file
ls -1 /mnt/san/terraform-state/.versions/terraform.tfstate.*

# restore one version
bash ../../state-management/restore_state.sh \
  /mnt/san/terraform-state/.versions/terraform.tfstate.20260430T120000Z \
  /mnt/san/terraform-state/vsphere/networking/port-groups/prod/terraform.tfstate
```

## Security controls

- Mount SAN over encrypted transport and restrict host access.
- Set filesystem permissions to Terraform runner users/groups only.
- Use immutable snapshots on the SAN array where available.
- Keep a periodic off-SAN backup for disaster recovery.

## Notes

- `backend.hcl.example` is a template; keep real `backend.hcl` untracked.
- For shared teams, enforce one Terraform runner per workspace or external locking discipline.
