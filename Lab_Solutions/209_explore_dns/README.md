# Explore DNS

```bash
k get po -A
k get svc -A
k get svc -n kube-system kube-dns
k get po -n kube-system coredns-74ff55c5b-qck9g -o yaml|less  # / to search for args:
k get cm -n kube-system
k get cm -n kube-system coredns -o yaml|less
k get svc
k exec -it test -- sh
k exec -it test -- curl http://web-service
k exec -it test -- curl http://web-service.payroll
```

q 14

```bash
k get po -A      # mysql is in payroll ns
k get deploy -A  # webapp is in default ns
k edit deploy webapp  # set to mysql.payroll
```

q 15

```bash
k exec -it hr -- nslookup mysql.payroll > /root/CKA/nslookup.out
```
