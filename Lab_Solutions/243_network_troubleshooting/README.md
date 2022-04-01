# Network Troubleshooting

Q1 Solution

```bash
k get ns
k config set-context --current --namespace=triton
k get po
k describe po mysql
# 
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
```

Q2 Solution

```bash
# still not resolved
alias k=kubectl
k get po -n triton -w
k get po -n triton -w &
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
# kube-proxy is in CrashLoopBackOff
k get -n kube-system ds
ns=kube-system
k config set-context --current --namespace=kube-system
kubectl describe $(kubectl get po -l k8s-app=kube-proxy -o name)
kubectl logs $(kubectl get po -l k8s-app=kube-proxy -o name|tee >(cat >&2))
# open /var/lib/kube-proxy/configuration.conf: no such file or directory
kubectl get $(kubectl get po -l k8s-app=kube-proxy -o name) -o yaml|less
# config is from ConfigMap volume mount
k get cm kube-proxy -o yaml|less
# filename in configmap is called config.conf, not configuration.conf
k edit ds kube-proxy
# this was a tricky one!
```
