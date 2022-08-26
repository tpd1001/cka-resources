# Lightning Lab

Q1

```bash
kubectl get no
kubectl taint node controlplane node-role.kubernetes.io/master:NoSchedule-
apt update
apt-cache madison kubeadm
apt-get update && \
apt-get install -y --allow-change-held-packages kubeadm=1.20.0-00
kubectl get po -o wide
kubectl cordon controlplane
kubectl drain controlplane --ignore-daemonsets
kubeadm upgrade plan v1.20.0
kubeadm config images pull  # tbc
kubeadm upgrade apply v1.20.0
apt-get install -y --allow-change-held-packages kubelet=1.20.0-00 kubectl=1.20.0-00
systemctl daemon-reload
systemctl restart kubelet
kubectl get no
kubectl uncordon controlplane
kubectl cordon node01
kubectl drain node01 --ignore-daemonsets
ssh node02
apt update
apt-cache madison kubeadm
apt-get update && \
apt-get install -y --allow-change-held-packages kubeadm=1.20.0-00
kubeadm upgrade node
exit  # back to controlplane
ssh node02
apt-get install -y --allow-change-held-packages kubelet=1.20.0-00 kubectl=1.20.0-00
systemctl daemon-reload
systemctl restart kubelet
exit  # back to controlplane
kubectl get no
kubectl uncordon node01
```

Q2

```bash
kubectl config set-context --current --namespace admin2406
kubectl get deploy  --sort-by='.metadata.name' -o custom-columns='DEPLOYMENT:.metadata.name,CONTAINER_IMAGE:.spec.template.spec.containers[*].image,READY_REPLICAS:.status.readyReplicas,NAMESPACE:.metadata.namespace' > /opt/admin2406_data
```

Q3

```bash
export KUBECONFIG=/root/CKA/admin.kubeconfig 
vim $KUBECONFIG  # correct port to 6443
kubectl get no
unset KUBECONFIG
#OR#
sed -i '/server:/s/:[0-9]*$/:6443/' /root/CKA/admin.kubeconfig
```

Q4

```bash
kubectl config set-context --current --namespace default
kubectl create deploy nginx-deploy --image=nginx:1.16
kubectl get po -w &
   14  kubectl set image deploy/nginx-deploy nginx=1.17  # wrong image version
   15  k rollout undo --helo
   16  k rollout undo --help
   17  k rollout undo deployment/nginx-deploy
kubectl set image deploy/nginx-deploy nginx=nginx:1.17
```

Q5

```bash
kubectl config set-context --current --namespace alpha
kubectl get pv
kubectl get pvc
kubectl describe deploy alpha-mysql
kubectl get pvc alpha-claim -o yaml > pvc.orig
kubectl get pvc alpha-claim -o yaml > pvc
vim pvc  # alpha-claim-pvc, ReadWriteOnce, 1 Gi, slow
kubectl delete pvc alpha-claim
kubectl apply -f pvc
kubectl get pvc  # should be Bound
kubectl edit deploy alpha-mysql  # change pvc: mysql-alpha-pvc => alpha-claim
kubectl get po   # should be Running
```

Q6

ETD

```bash
export ETCDCTL_API=3
cat /etc/kubernetes/manifests/etcd.yaml | \
 sed -n 's/trusted-ca/cacert/;/=\//s/-file//p'
etcdctl snapshot save /opt/etcd-backup.db

```

Q7

pods & secrets

```bash
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: secret-1401
  name: secret-1401
spec:
  containers:
  - image: nginx
    name: secret-1401
    command:
    - "sleep"
    - "4800"
    volumeMounts:
    - mountPath: /etc/secret-volume
      name: secret-volume
      readOnly: true
  volumes:
  - name: secret-volume
    secret:
      secretName: dotfile-secret
# vim:sw=2:ts=2:sts=-1:et
#x vim:set sw=2:ts=2:sts=-1:et
#y vim set:ts=2:sw=2:sts:-1:et
#z vim:set shiftwidth=2 tabstop=2 softtabstop=-1 expandtab
```
