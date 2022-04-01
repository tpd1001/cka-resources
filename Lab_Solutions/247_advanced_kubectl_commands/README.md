# Advanced Kubectl Commands

Qs 1-4

```bash
k get no -o json > /opt/outputs/nodes.json
k get no node01 -o json > /opt/outputs/node01.json
k get no -o jsonpath='{.items[*].metadata.name}' > /opt/outputs/node_names.txt
k get no -o jsonpath='{.items[*].status.nodeInfo.osImage}' > /opt/outputs/nodes_os.txt
```

Qs 5-6

```bash
kubectl config view --kubeconfig=/root/my-kube-config
kubectl config view --kubeconfig=/root/my-kube-config -o jsonpath='{.users[*].name}' > /opt/outputs/users.txt

# NOT_JUST_THE_CAPACITIES_BUT_THE WHOLE JSON
#k get pv -o jsonpath='{.items[*].spec.capacity.storage}' --sort-by=.spec.capacity.storage > /opt/outputs/storage-capacity-sorted.txt
k get pv --sort-by=.spec.capacity.storage > /opt/outputs/storage-capacity-sorted.txt
```

Qs 7-8

```bash
k get pv --sort-by=.spec.capacity.storage -o=custom-columns=NAME:.metadata.name,CAPACITY:.spec.capacity.storage > /opt/outputs/pv-and-capacity-sorted.txt
# my answer
kubectl config view --kubeconfig=my-kube-config -o jsonpath='{.contexts[?(@.context.user=="aws-user")]}'| tee /opt/outputs/aws-context-name
# OR the official answer
kubectl config view --kubeconfig=my-kube-config -o jsonpath="{.contexts[?(@.context.user=='aws-user')].name}" > /opt/outputs/aws-context-name
```
