# networking weave

```bash
k get no     # 2 nodes
k get po -A  # weave-net
k get po -A -o wide  # check node column
ip link ; ssh node01 ip link
k get po -n kube-system weave-net-7ztkt -o yaml | grep -A1 IPALLOC
ip addr show weave
```

```bash
k run foo --image=busybox --command sleep 1000 --client=dryrun -o yaml
k run foo --image=nginx --client=dryrun -o yaml

nodeName: node03

k exec -ti foo -- sh
```
