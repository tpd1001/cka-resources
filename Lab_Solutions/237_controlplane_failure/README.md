# Application Failure

Q1 Solution

```bash
k get no
kubectl config set-context --current --namespace=kube-system
k get deploy,svc,po
k describe po kube-scheduler-controlplane
vim /etc/kubernetes/manifests/kube-scheduler.yaml  # correct kube-schedulerrrr
```

Q2+3 Solution

```bash
kubectl scale -n default deploy app --replicas=2
# or
k edit -n default deploy app

k describe po kube-controller-manager-controlplane
k logs kube-controller-manager-controlplane --previous
vim /etc/kubernetes/manifests/kube-controller-manager.yaml  # correct conf file
# takes a while to fix itself
k get po -A
```

Q4 Solution

```bash
k get no
vim /etc/kubernetes/manifests/kube-controller-manager.yaml  # correct volumemount
```
