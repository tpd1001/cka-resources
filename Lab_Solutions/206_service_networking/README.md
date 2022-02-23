# Service Networking

tbc

```bash
k get no -o wide|awk '{print $6}'
ip a | grep <first_few_octets>

k get po -A -o wide
kubectl logs <weave-pod-name> weave -n kube-system|grep ipalloc-range

k get svc -A
grep cluster-ip-range /etc/kubernetes/manifests/kube-apiserver.yaml

kubectl get pods -n kube-system|grep kube-proxy

kubectl logs <kube-proxy-pod-name> -n kube-system|grep Proxier

kubectl get po <kube-proxy-pod-name> -n kube-system|grep kind
```
