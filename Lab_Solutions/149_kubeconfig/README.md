# kubeconfig

Qs 1-6

```bash
$HOME/.kube/config
vim $HOME/.kube/config
```

Qs 7-11

```bash
vim my-kube-config
# 4 clusters
# 4 contexts
# dev-user
# aws-user.crt
# test-user@development
```

Qs 12-14

```bash
kubectl config --kubeconfig=/root/my-kube-config current-context
kubectl config --kubeconfig=/root/my-kube-config use-context research
#OR
export KUBECONFIG=/root/my-kube-config
kubectl config use-context research
#NOT#sed -i '/^current-context/s/: .*/: dev-uset@test-cluster-1/' my-kube-config

cp /root/my-kube-config ~/.kube/config

find /etc/kubernetes/pki/users -type f
vim ~/.kube/config
sed -i 's/developer-user.crt/dev-user.crt/' ~/.kube/config
```
