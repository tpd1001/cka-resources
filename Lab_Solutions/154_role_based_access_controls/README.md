# rbac

Qs 1-8

```bash
ps -ef|grep apiserver|grep authorization-mode
kubectl -n kube-system describe pod kube-apiserver-controlplane|grep authorization-mode

k get roles --no-headers -A|wc -l

k -n kube-system describe roles.rbac.authorization.k8s.io kube-proxy
k config set-context --current --namespace=kube-system
kubectl describe roles kube-proxy
# check resource names
k describe rolebinding kube-proxy
k -n default --as dev-user get po
```

Q9

```bash
mkdir z;cd z
k get role kube-proxy -o yaml > developer.yaml
k get rolebinding kube-proxy -o yaml > dev-user-binding.yaml
vim *.yaml
kubectl apply -f .
```

Q10

```bash
k config set-context --current --namespace=blue
k get rolebinding -o yaml > dev-user-binding.yaml
kubectl get role -o yaml  > developer.yaml
k edit role developer  # fix ResourceNames
k --as dev-user describe po dark-blue-app
```

Q11

```bash
cat<<EOF >/dev/null
- apiGroups:
  - apps
  resources:
  - deployments
  verbs:
  - create
EOF
k edit role developer  # append the above
k --as dev-user create deploy foo --image=nginx
```
