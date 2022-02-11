# Ingress 1

Qs 1-5

```bash
k get ns
k get -n app-space deploy,svc,po,cm,ing
k create ns ingress-space
k create -n ingress-space cm nginx-configuration
k create -n ingress-space sa ingress-serviceaccount
k get -n ingress-space roles,rolebindings
```

Q6 Solution

```yaml
see ingress-controller.yaml
```

Q7 Solution

```bash
kubectl expose -n ingress-space deployment ingress-controller --type=NodePort --port=80 --name=ingress --dry-run=client -o yaml > ingress.yaml
# then edit for namespace and nodePort
# -OR-
kubectl expose -n ingress-space deployment ingress-controller \
--type=NodePort --port=80 --name=ingress \
--dry-run=client -o yaml | \
sed '
 /creation/{;d;b;};
 /^metadata:/{;h;s/.*/  namespace: ingress-space/;x;p;g;};
 /target/{;h;s/target/node/;s/[0-9][0-9]*/30080/;x;p;g;}
' | kubectl apply -f -
```

Q8 Solution

```yaml
see rules.yaml
```
