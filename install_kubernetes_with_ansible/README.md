# Install Kubernetes Cluster with Ansible on Ubuntu

## Usage

Source Article: [install-kubernetes-cluster-with-ansible](https://www.linuxsysadmins.com/install-kubernetes-cluster-with-ansible/)

In case, if the installation fails at any stage, run the below command on all three nodes and re-run the playbook.

```bash
sudo kubeadm reset --ignore-preflight-errors=all
```

## Useful Links

[VMX Allowlisting](https://www.vagrantup.com/docs/providers/vmware/boxes#vmx-allowlisting)