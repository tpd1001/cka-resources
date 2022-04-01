# Secrets

Qs 1-4

```bash
k get secret
k describe secret default-token-<id>
k get secret default-token-<id>\
 -o json|jq '.data[]'|wc -l
k describe secret default-token-<id>|grep Type
```

Qs 6-7

```bash
k create secret generic db-secret \
 --from-literal=DB_Host=sql01 \
 --from-literal=DB_User=root \
 --from-literal=DB_Password=password123
k get po webapp-pod -o yaml \
 | sed '/- image:/a\    envFrom:\n    - secretRef:\n      name: db-secret' > pod.yaml
k delete po webapp-pod && k apply -f pod.yaml
```
