# weave

just more exploring stuff with cni

```bash
k get no  # 2 nodes
k get no -o wide|awk '/controlplane/{print $6}'  # get ip
ip a | grep -B2 $(k get no -o wide|awk '/controlplane/{print $6}')  # get interface
ip a | grep $(k get no -o wide|awk '/controlplane/{print $6}') | awk '{print $NF}'
ip link show $if | grep ether              # get mac
k get no -o wide|awk '/node01/{print $6}'  # get node ip
ssh node01 ip link show $if | grep ether   # get mac
ip link | grep docker
ip link show docker0
ip route show default
netstat -nlpt|grep kube-scheduler          # scheduler port
netstat -npt|grep etcd                     # etcd port
```
