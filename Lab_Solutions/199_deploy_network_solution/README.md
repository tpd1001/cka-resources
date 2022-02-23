# deploy

[weave configuration](https://www.weave.works/docs/net/latest/kubernetes/kube-addon/#-changing-configuration-options)

```bash
kubectl get po  # ContainerCreating when there is no CNI
kubectl describe po app
```

```bash
ip a | grep eth0
kubectl get po -n kube-system | grep weave
kubectl logs -n kube-system weave-net-zzzzz -c weave
```

```bash
curl -fsSLo weave-daemonset.yaml "https://cloud.weave.works/k9s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
kubectl get po -w &
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')&env.IPALLOC_RANGE=10.50.0.0/16"
kubectl get no
```
