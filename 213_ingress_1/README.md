# Ingress 1

Qs 1-8

```bash
k get ns
k get -n app-space deploy,svc,po,cm,ing
k get -n ingress-space deploy,svc,po,cm,ing
k describe -n ingress-space $(k get -n ingress-space po -l name=nginx-ingress -o name)
k describe -n app-space ingress
```

Qs 9-13

```bash
k describe -n app-space ingress|grep '/wear'  # Q9
k describe -n app-space ingress|grep 'video'  # Q10
k describe -n app-space ingress|grep '^Defa'  # Q11
https://30080-port-984be872c5594fcc.labs.kodekloud.com/
https://30080-port-984be872c5594fcc.labs.kodekloud.com/wear   # Q13
https://30080-port-984be872c5594fcc.labs.kodekloud.com/watch  # Q13
```

Q14

```bash
k edit -n app-space ingress  # change /watch to /stream
```

Qs 16-19

```bash
k describe -n app-space deploy webapp-food  # Q17
k edit -n app-space ingress  # search for /backend, 7yyP , change /wear to /eat, change wear-service to food-service
```

Qs 20-

```bash
k get -n critical-space deploy,svc,po,cm,ing  # Q21
k describe -n app-space deploy webapp-food  # Q17
#k edit -n app-space ingress  # search for /backend, 7yyP , change /wear to /eat, change wear-service to food-service
kubectl get svc -n critical-space
vim i && k apply -f i
```

Solution

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-critical
  namespace: critical-space
spec:
  rules:
  - http:
      paths:
      - backend:
          service:
            name: pay-service
            port:
              number: 8282
        path: /pay
        pathType: Prefix
```
