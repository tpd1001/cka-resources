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
k describe -n kube-system kube-proxy-stthp
k describe -n kube-system po kube-proxy-stthp
k logs -n kube-system po kube-proxy-stthp
k logs -n kube-system pod/kube-proxy-stthp
cd /var/lib/kube-proxy/
k get -n kube-system po kube-proxy-stthp -o yaml
```
