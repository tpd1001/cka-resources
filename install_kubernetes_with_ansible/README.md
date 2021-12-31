# Install Kubernetes Cluster with Ansible on Ubuntu

[install-kubernetes-cluster-with-ansible](https://www.linuxsysadmins.com/install-kubernetes-cluster-with-ansible/)

In case, if the installation fails at any stage, run the below command on all three nodes and re-run the playbook.

```bash
sudo kubeadm reset --ignore-preflight-errors=all
```
