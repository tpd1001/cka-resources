# Test Backup and Restore Methods

Qs 1-5

```bash
alias k=kubectl
k get deploy
kubectl describe pod etcd-controlplane -n kube-system|grep Image:
#OR#kubectl logs etcd-controlplane -n kube-system
kubectl describe pod etcd-controlplane -n kube-system|grep listen-client
crt=$(kubectl describe -n kube-system po etcd-controlplane|awk -F= '/--cert-file/{print $2}');      echo $crt
ca=$( kubectl describe -n kube-system po etcd-controlplane|awk -F= '/--trusted-ca-file/{print $2}');echo $ca
key=$(kubectl describe -n kube-system po etcd-controlplane|awk -F= '/--key-file/{print $2}')
```

Qs 6-9

```bash
ep=$(kubectl describe -n kube-system po etcd-controlplane|awk -F= '/listen-client/{print $2}')
#ETCDCTL_API=3 etcdctl --cacert=${ca?} --cert=${crt?} --key=${key?} snapshot save /opt/snapshot-pre-boot.db
ETCDCTL_API=3 etcdctl ${ep:+--endpoints=${ep%,*}} --cacert=${ca?} --cert=${crt?} --key=${key?} snapshot save /opt/snapshot-pre-boot.db
k get po,svc
dd=$(kubectl describe -n kube-system po etcd-controlplane|awk -F= '/data-dir/{print $2}')
ETCDCTL_API=3 etcdctl snapshot restore /opt/snapshot-pre-boot.db --data-dir=${dd?}2
# !!CARE!! edit `hostPath` to point to restore location in volumes section
#          do NOT edit the `--data-dir` switch
vim /etc/kubernetes/manifests/etcd.yaml
watch "docker ps | grep etcd"
#if_necessary#
kubectl delete pod -n kube-system etcd-controlplane
# wait for 
watch kubetl get po -A
```
