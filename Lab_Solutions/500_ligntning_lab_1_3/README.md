# Lightning Lab

Q1

```bash
tbc
```

Q2

```bash
kubectl config set-context --current --namespace admin2406
kubectl get deploy  --sort-by='.metadata.name' -o custom-columns='DEPLOYMENT:.metadata.name,CONTAINER_IMAGE:.spec.template.spec.containers[*].image,READY_REPLICAS:.status.readyReplicas,NAMESPACE:.metadata.namespace' > /opt/admin2406_data
```

Q3

```bash
export KUBECONFIG=/root/CKA/admin.kubeconfig 
vim $KUBECONFIG  # correct port to 6443
kubectl get no
```

Q4

```bash
kubectl create deploy nginx-deploy --image=nginx:1.16
kubectl get po -w &
   14  kubectl set image deploy/nginx-deploy nginx=1.17
   15  k rollout undo --helo
   16  k rollout undo --help
   17  k rollout undo deployment/nginx-deploy
kubectl set image deploy/nginx-deploy nginx=nginx:1.17
```

Q5

```bash
k get pv
k get pvc
k describe deploy ...
k get pvc alpha-claim > pvc.orig
k get pvc alpha-claim > pvc
vim pvc  # alpha-claim-pvc, ReadWriteOnce, 1 Gi, slow
k delete pvc alpha-claim
k apply -f pvc
k get pvc  # should be Bound
k get po   # should be Running


root@controlplane:~#  k get pvc
NAME          STATUS   VOLUME     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
alpha-claim   Bound    alpha-pv   1Gi        RWO            slow           11s

   23  echo Q5
   24  kubectl config set-context --current --namespace alpha-mysql
   25  kubectl config set-context --current --namespace alpha
   26  k get po
   27  k get pvc
   28  k get pvc alpha-claim -o yaml > pvc.orig
   29  k get pvc alpha-claim -o yaml > pvc
   30  vim pvc
   31  k delete pvc alpha-claim
   32  k apply -f pvc
   33  k get po
   34  k get deployments.apps alpha-mysql > dep.orig
   35  k get deployments.apps alpha-mysql > dep
   36  k edit deployments.apps alpha-mysql
   37  vim pvc
   38  k apply -f pvc
   39  k get pvc
   40  k delete pvc alpha-claim && vim pvc && k apply -f pvc
   41  k apply -f pvc
   42  k get pvc
   43  k delete po alpha-mysql-6cc9f6bb7c-tvm7z
   44  k get pvc
   45  vi pvc
   46  k apply -f pvc
   47  k get pvc
   48  k get storageclasses.storage.k8s.io -A
   49  k get pvc
   50  vim pvc && k apply -f pvc
   51  k get pvc
   52  alias k=kubectl
   53  k get pvc
   54  diff pvc.orig pvc
   55  vim pvc && k apply -f pvc
   56  k delete pvc mysql-alpha-pvc
   57  vim pvc && k apply -f pvc
   58  diff pvc.orig pvc
   59  vim pvc && k apply -f pvc
   60  k get pv
   61  history
```

Q6

```bash
tbc
```

Q7

```bash
tbc
```
