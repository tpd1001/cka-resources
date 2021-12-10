# Title Will Go Here

## setup

```bash
alias k=kubectl
#k() { kubectl $@; }
source <(kubectl completion bash|sed '/ *complete .*kubectl$/{;h;s/kubectl$/k/p;g;}')
v() { vim -c ":set shiftwidth=2 tabstop=2 softtabstop=-1 expandtab" ${1?} && kubectl apply -f $1; }
```

consider these:
* [kubectl aliases](https://github.com/ahmetb/kubectl-aliases)
* [Getting started with K8s](https://edgehog.blog/getting-started-with-k8s-core-concepts-135fb570462e)
* [KubeCost](https://thenewstack.io/kubecost-monitor-kubernetes-costs-with-kubectl/)

vim configuration for yaml

```vim
# configuration for vim for... something... *.md perhaps but maybe *.yaml
# shiftwidth=sw=2
# tabstop=ts=2
# softtabstop=sts=-1
# vim: set shiftwidth=2 tabstop=2 softtabstop=-1 expandtab
```

iTerm2 on Mac stuff

* [Captured Output](https://iterm2.com/documentation-captured-output.html)
* [Triggers](https://iterm2.com/documentation-triggers.html)
* [Shell Integration](https://iterm2.com/documentation-shell-integration.html)

## markdown

* Markdown [docs](https://code.visualstudio.com/docs/languages/markdown)
* [VS Code as Markdown Note-Taking App](https://helgeklein.com/blog/vs-code-as-markdown-note-taking-app/)

### markdownlint

See markdownlint [Configuration](https://github.com/DavidAnson/markdownlint#configuration) and the HTML comments below here in the source file.
<!-- markdownlint-disable MD022 MD031 -->
Show VS Code preview pane: Cmd-K,V

## What's New

### 1.22

Alpha feature

* [Using Kubernetes Ephemeral Containers for Troubleshooting
](https://loft.sh/blog/using-kubernetes-ephemeral-containers-for-troubleshooting/)

## pods (po)
```bash
k run redis -n finance --image=redis
k run nginx-pod --image=nginx:alpine
k run redis --image=redis:alpine --labels='tier=db,foo=bar'

#k run custom-nginx --image=nginx
#k expose pod custom-nginx --port=8080
kubectl run custom-nginx --image=nginx --port=8080
kubectl run httpd --image=httpd:alpine --port=80 --expose

kubectl run --restart=Never --image=busybox static-busybox --dry-run=client -o yaml --command -- sleep 1000 > /etc/kubernetes/manifests/static-busybox.yaml

  905  kubectl get po -o custom-columns-file=PODS.template
  906  k get po -o jsonpath="{.items[*].spec.containers[*].image}"
  907  vim PODS.template && kubectl get po -o custom-columns-file=PODS.template
  908  watch -n1 kubectl get po -o custom-columns-file=${func_path?}/../CKA/PODS.template
```

## replicasets (rs)
```bash
kubectl create replicaset foo-rs --image=httpd:2.4-alpine --replicas=2
kubectl scale replicaset new-replica-set --replicas=5
kubectl edit replicaset new-replica-set
```

## deployments (deploy)
```bash
kubectl create deployment httpd-frontend --image=httpd:2.4-alpine --replicas=2
k create deployment webapp --image=kodekloud/webapp-color --replicas=3
k create deployment webapp --image=kodekloud/webapp-color --replicas=3 -o yaml --dry-run=client | sed '/strategy:/d;/status:/d' > pink.yaml
k set image deployment nginx nginx=nginx:1.18
kubectl get all
```

## services (svc)
```bash
k create svc clusterip redis-service --tcp=6379:6379  # worked in practice test but should use expose
k expose pod redis --name=redis-service --port=6379
```

## namespaces (ns)
```bash
k create ns dev-ns
k create deployment redis-deploy -n dev-ns --image=redis --replicas=2
```

## common verbs/ations

### describe
```bash
k describe $(k get po -o name|head -1)
```

### replace
```bash
k replace -f nginx.yaml
```

### delete
```bash
k delete $(k get po -o name)
```

### generate manifest
```bash
kubectl run nginx --image=nginx --dry-run=client -o yaml
```

# === markdownified to here ===

## labels and selectors

### labels in spec>selector and spec>template must match
```bash
k get po --selector app=foo
k get po --selector env=dev|grep -vc NAME
k get all --selector env=prod|egrep -vc '^$|NAME'
k get all --selector env=prod|grep -c ^[a-z]
k get all --selector env=prod --no-headers|wc -l
k get all --selector env=prod,bu=finance,tier=frontend --no-headers
```

## taints and tolerations
### taint-effect is what happens to pods that do not tolerate the taint
#### NoSchedule
#### PreferNoSchedule
#### NoExecute
# permit master to run pods
k taint nodes controlplane node-role.kubernetes.io/master:NoSchedule-
# prevent master from running pods again (defaut)
k taint nodes controlplane node-role.kubernetes.io/master:NoSchedule

k taint nodes node1 key=value:taint-effect
k taint nodes node1 app=blue:NoSchedule
k taint nodes node1 app=blue:NoSchedule-  # to remove
#spec>tolerations>- key: "app" (all on quotes)
k describe node kubemaster | grep Taint
#k get po bee -o yaml | sed '/tolerations:/a\  - key: spray\n    value: mortein\n    effect: NoSchedule\n    operator: Equal'|k apply -f -
k get po bee -o yaml | sed '/tolerations:/a\  - effect: NoSchedule\n    key: spray\n    operator: Equal\n    value: mortein'|k apply -f -

# node selectors
#label nodes first
#spec:>nodeSelector:>size:Large
k label nodes node1 size=Large

# node affinity
#spec:>nodeAffinity:
      affinity:
        podAntiAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
          - labelSelector:
              matchExpressions:
              - key: app
                operator: In
                values:
                - store

      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: color
                operator: In
                values:
                - blue

      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: node-role.kubernetes.io/master
                operator: Exists

# resources
k describe po elephant | grep Reason
k describe po elephant | sed -n '/Last State/{;N;p}'

# daemonsets
k get ds -A
k get ds -n kube-system kube-flannel-ds
k describe ds kube-flannel-ds|grep Image
k get ds kube-flannel-ds -o yaml
k create deployment -n kube-system elasticsearch --image=k8s.gcr.io/fluentd-elasticsearch:1.20 -o yaml --dry-run=client | sed 's/Deployment$/DaemonSet/;/replicas:/d;/strategy:/d' > d.yaml
k create deployment -n kube-system elasticsearch --image=k8s.gcr.io/fluentd-elasticsearch:1.20 -o yaml --dry-run=client | sed 's/Deployment$/DaemonSet/;/replicas:/d;/strategy:/d;/status:/d' > ds.yaml
kubectl create -f ds.yaml

# static pods
## as an option in kublet.service (systemd)
## or as a --config switch to a file containing the staticPodPath opt
sudo grep staticPodPath $(ps -wwwaux|sed -n '/kubelet /s/.*--config=\(.*\) --.*/\1/p'|awk '/^\//{print $1}')
ls .*  # dummy command to close italics
k run static-pod-nginx --image=nginx --dry-run=client -o yaml|egrep -v 'creationTimestamp:|resources:|status:|Policy:'>static-pod-nginx.yaml

# multiple schedulers
* [advanced-scheduling-in-kubernetes](https://kubernetes.io/blog/2017/03/advanced-scheduling-in-kubernetes/)
* [how-does-the-kubernetes-scheduler-work](https://jvns.ca/blog/2017/07/27/how-does-the-kubernetes-scheduler-work/)
* [how-does-kubernetes-scheduler-work](https://stackoverflow.com/questions/28857993/how-does-kubernetes-scheduler-work/28874577#28874577)
## use /etc/kubernetes/manifests/kube-scheduler.yaml as a source
## add --scheduler-name= option
## change --leader-elect to false
## change --port to your desired port
## update port in probes to the same as above
k create -f my-scheduler.yaml  # not as a static pod
echo -e '    schedulerName: my-scheduler' >> pod.yaml
k create -f pod.yaml
k get events

## monitoring

* [kubernetes-metrics-server](https://github.com/kodekloudhub/kubernetes-metrics-server)

```bash
git clone https://github.com/kodekloudhub/kubernetes-metrics-server.git
k create -f kubernetes-metrics-server
k top node
k top pod
```

# application lifecycle
## RollingUpdate - a few pods at a time
## Recreate      - all destroyed in one go and then all recreated
k set image deployment/myapp nginx=nginx:1.9.1
#                            ^^^^^-The name of the container inside the pod
k edit deployment/myapp
k annotate deployment/myapp kubernetes.io/change-cause="foo"  # replace deprecated --record
k rollout status deployment/myapp
k rollout history deployment/myapp
k rollout undo deployment/myapp
kubectl get po -o=custom-columns=NAME:.metadata.name,IMAGE:.spec.containers[].image

# Dockerfile commands
## kube command == docker entrypoint
## kube args    == docker cmd
## with CMD        command line params get replaced entirely
## with ENTRYPOINT command line params get appended
## ENTRYPOINT => command that runs on startup
## CMD        => default params to command at sartup
## always specity in json format
## ENTRYPOINT ["sleep"]
## CMD ["5"]
## default command will be "sleep 5"

# command & args in kubernetes
    command: ["printenv"]
    args: ["HOSTNAME", "KUBERNETES_PORT"]
# or
    command:
    - printenv
    args:
    - HOSTNAME
    - KUBERNETES_PORT


# environment variables
docker run --rm -ti -p 8080:8080 -e APP_COLOR=blue kodekloud/webapp-color
#spec:
#  containers:
#  - env:
#    - name: APP_COLOR
#      value: green

# configmaps
k create configmap --from-literal=APP_COLOR=green \
                   --from-literal=APP_MOD=prod
k create configmap --from-file=app_config.properties
# use the contents of an entire directory:
k create configmap tomd-test-ssl-certs --from-file=path/to/dir
#apiVersion: v1
#kind: ConfigMap
#metadata:
#  name: app-config
#data:
#  APP_COLOR: green
#  APP_MOD: prod

#    image: foo
#    envFrom:
#      configMapRef:
#      name: app-config

## secrets

* [encrypt-data](https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/)

k create secret generic app-secret --from-literal=DB_PASSWD=green \
                                   --from-literal=MYSQL_PASSWD=prod
k create secret generic app-secret --from-file=app_secret.properties
k describe secret app-secret
k get secret app-secret -o yaml
#apiVersion: v
#kind: Secret
#metadata:
#  name: app-secret
#data:
#  # encode with: echo -n "password123" | base64
#  # decode with: echo -n "encodedstring" | base64 --decode
#  DB_PASSWD: green
#  MYSQL_PASSWD: prod

#    image: foo
#    envFrom:
#      secretRef:
#      name: app-config

#volumes:
#  - name: app-secret-volume
#    secret:
#      secretName: app-secret
ls /opt/app-secret-volumes
cat /opt/app-secret-volumes/DB_PASSWD

# multi-container pods

apiVersion: v1
kind: Pod
metadata:
  labels:
    run: yellow
  name: yellow
spec:
  containers:
  - image: busybox
    name: lemon
  - image: redis
    name: gold

# init containers
kubectl describe pod blue  # check the state field of the initContainer and reason: Completed

  initContainers:
  - command:
    - sh
    - -c
    - sleep 600
    image: busybox
    name: red-init

# cluster upgrades
[kubeadm upgrade](https://v1-20.docs.kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/)
```
k drain node01 --ignore-daemonsets
k cordon node01
k uncordon node01
```

## controlplane
kubeadm version -o short
kubectl drain controlplane --ignore-daemonsets
apt update && apt-cache madison kubeadm
apt-get install -y --allow-change-held-packages kubeadm=1.20.0-00
yum list --showduplicates kubeadm --disableexcludes=kubernetes
yum install -y kubeadm-1.21.x-0 --disableexcludes=kubernetes
kubeadm upgrade plan v1.20.0
kubeadm config images pull
kubeadm upgrade apply -y v1.20.0
apt-get install -y --allow-change-held-packages kubelet=1.20.0-00 kubectl=1.20.0-00
yum install -y kubelet-1.21.x-0 kubectl-1.21.x-0 --disableexcludes=kubernetes
sudo systemctl daemon-reload && sudo systemctl restart kubelet
sudo systemctl daemon-reload
sudo systemctl restart kubelet
kubectl uncordon controlplane
# oneliners (for unjoined node)
sudo yum makecache -y fast && yum list --showduplicates kubeadm --disableexcludes=kubernetes
ver=1.21.2
sudo yum install -y kubeadm-${ver?}-0 --disableexcludes=kubernetes
sudo yum install -y kubelet-${ver?}-0 kubectl-$ver-0 --disableexcludes=kubernetes && sudo systemctl daemon-reload && sudo systemctl restart kubelet

## workers
kubectl drain node01 --ignore-daemonsets --force
apt update && apt-cache madison kubeadm
apt-get install -y --allow-change-held-packages kubeadm=1.20.0-00
kubeadm upgrade node  # this is quick as just a config upgrade
apt-get install -y --allow-change-held-packages kubelet=1.20.0-00 kubectl=1.20.0-00
# where does this bit get done?
# ===
yum list docker-ce --showduplicates
# ===
sudo systemctl daemon-reload && sudo systemctl restart kubelet
kubectl uncordon node01

# backup and restore
kubectl get all --all-namespaces -o yaml > all-deploy-services.yaml
ETCDCTL_API=3 etcdctl snapshot save snapshot.db
ETCDCTL_API=3 etcdctl snapshot status snapshot.db
## restore
service kube-apiserver stop
ETCDCTL_API=3 etcdctl snapshot restore snapshot.db \
--data-dir /new/data/dir

## security

Nick Perry [kubesec.io](https://twitter.com/nickwperry/status/1442095087844945934)
```
kubectl run -oyaml --dry-run=client nginx --image=nginx > nginx.yaml
docker run -i kubesec/kubesec scan - < nginx.yaml
```

# authentication
# basic, depracated
curl -vk https://master_node_ip:6443/api/v1/pods -u "userid:passwd
curl -vk https://master_node_ip:6443/api/v1/pods --header "Authorization: Bearer ${token?}"

# view certificates
k get po kube-apiserver-controlplane -o yaml -n kube-system|grep cert
k get po etcd-controlplane -o yaml -n kube-system|grep cert
openssl x509 -text -noout -in /etc/kubernetes/pki/apiserver.crt
openssl x509 -text -noout -in /etc/kubernetes/pki/etcd/server.crti|grep CN  # etcd
openssl x509 -text -noout -in /etc/kubernetes/pki/apiserver.crt|grep Not    # validity
openssl x509 -text -noout -in /etc/kubernetes/pki/ca.crt|grep Not           # CA validity
for f in $(grep pki /etc/kubernetes/manifests/etcd.yaml|egrep 'key|crt'|awk -F= '{print $2}'); do echo +++ $f;test -f $f && echo y || echo n;done
vim /etc/kubernetes/manifests/etcd.yaml
docker logs $(docker ps|grep -v pause:|awk '/etcd/{print $1}')
grep pki /etc/kubernetes/manifests/kube-apiserver.yaml|grep '\-ca'

# certificates API
openssl genrsa -out jane.key 2048
openssl req -new -key jane.key -subj "/CN=jane" -out jane.csr
cat jane.csr|base64

# v1.19 = v1
apiVersion: certificates.k8s.io/v1beta1
kind: CertificateSigningRequest
metadata:
  name: jane
spec:
  groups:
  - system:authenticated
  usages:
  - digital signature
  - key encipherment
  - server
  signerName: kubernetes.io/kube-apiserver-client
  # cat jane.csr|base64
  request:
      base64text

kubectl get csr
kubectl certificate approve jane
kubectl get csr -o yaml
cat jane.b64|base64 --decode

cat akshay.csr|base64|sed 's/^/      /'>>akshay.yaml
sed -i "/request:/s/$/ $(echo $csr|sed 's/ //g')/" a

# KubeConfig
curl https://kubecluster:6443/api/v1/nodes \
 --key admin.key \
 --cert admin.crt \
 --cacert ca.crt \
curl https://controlplane:6443/api/v1/nodes --key $PWD/dev-user.key --cert $PWD/dev-user.crt --cacert /etc/kubernetes/pki/ca.crt

kubectl get nodes \
 --server controlplane:6443 \
 --client-key admin.key \
 --client-certificate admin.crt \
 --certificate-authority ca.crt

kubectl get nodes \
 --kubeconfig config

kubectl config view
kubectl config view --kubeconfig=my-custom-config
kubectl config use-context prod-user@production
kubectl config -h

k config --kubeconfig=my-kube-config current-context
k config --kubeconfig=my-kube-config use-context research

contexts:
- name: kubernetes-admin@kubernetes
  context:
    cluster: kubernetes
    namespace: default
    user: kubernetes-admin

# better to use full path to crt etc. or base64 encode it

# API Groups
curl -k https://controlplane:6443/ --key $PWD/dev-user.key --cert $PWD/dev-user.crt --cacert /etc/kubernetes/pki/ca.crt
curl -k https://controlplane:6443/apis --key $PWD/dev-user.key --cert $PWD/dev-user.crt --cacert /etc/kubernetes/pki/ca.crt
# =OR=
kubectl proxy  # starts on localhost:8001 and proxy uses creds from kubeconfig file
curl -k https://localhost:6443

# Authorisation
k describe -n kube-system po kube-apiserver-controlplane
## Node
## ?BAC
## Webhook
## AlwaysAllow?
## AlwaysDeny?
## RBAC
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: developer
  # namespace: tbc
rules:
  # blank for core groups, names for anything else
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["list,"get","create","update","delete"]
  #resourceNames: ["red","blue"]  # optional, specific resources e.g. only certain pods

kubectl create -f developer-role.yaml

apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: devuser-developer-binding
  # namespace: tbc
subjects:
- kind: User
  name: dev-user
  verbs: rbac.authorization.k8s.io
roleRef:
  # blank for core groups, names for anything else
- kind: Role
  name: developer
  verbs: rbac.authorization.k8s.io

kubectl create -f devuser-developer-binding.yaml

k get roles
k get rolebindings
k describe role developer
k describe rolebinding devuser-developer-rolebinding

k auth can-i create deployments
k auth can-i delete nodes
k auth can-i create deployments --as dev-user
k auth can-i create pods        --as dev-user
k auth can-i create pods        --as dev-user --namespace test
# can edit in-place
k edit role developer -n blue

# Cluster Roles and Role Bindings
k get roles
k get roles -n kube-system -o yaml
k get role -n blue developer -o yaml

apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: developer
  namespace: blue
rules:
- apiGroups:  # [""] or ["apps","extensions"] for example
  - ""
  resourceNames:
  - blue-app
  resources:  # ["pods"] or
  # optional
  - pods
  verbs:  # ["get","list"] or
  - get
  - watch
  - create
  - delete

k get rolebinding -n blue dev-user-binding -o yaml

apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: dev-user-binding
  namespace: blue
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: developer
subjects:
- apiGroup: rbac.authorization.k8s.io
  kind: User
  name: dev-user

k create -f rb.yaml

k auth can-i create pods
k auth can-i create pods --as dev-user
# don't need to delete & recreate - can edit in-place
kubectl edit role developer -n blue

# t

# Cluster Roles and Role Bindings
kubectl api-resources --namespaced=true
kubectl api-resources --namespaced=false

# Image Security
image: docker.io/nginx/nginx
#                      ^^^^^-- image/repository
#                ^^^^^-------- user/account
#      ^^^^^^^^^-------------- registry
image: gcr.io/kubernetes-e2e-test-images/dnsutils
#
docker login private-registry.io
docker run   private-registry.io/apps/internal-app
#
kubectl create secret docker-registry regcred \
 --docker-server=private-registry.io \
 --docker-username=registry-user \
 --docker-password=password123 \
 --docker-email=registry-user@org.com

spec:
  containers:
  - image: nginx:latest
    name: ignition-nginx
  imagePullSecrets:
  - name: regcred

# Security Contexts
## security settings & capabilities
apiVersion: v1
kind: Pod
metadata:
  name: web-pod
spec:
  securityContext:
    runAsUser: 1000
  containers:
  - name: nginx
    image: nginx:1.20
    command: ["sleep", "3600"]
    # container settings override pod settings
    securityContext:
      # i.e. docker run --user=999 ubuntu sleep 3600
      runAsUser: 999
      # capabilities are only supported at the container level, not the pod level
      # i.e. docker run --cap-add MAC_ADMIN ubuntu
      capabilities:
        add: ["MAC_ADMIN"]

## Network Policies

* [webapp-conntest](https://github.com/kodekloudhub/webapp-conntest)
* [docker hub](https://hub.docker.com/r/kodekloud/webapp-conntest)

```bash
docker pull kodekloud/webapp-conntest
```

### Ingress is to the pod
### Egress  is from the pod
### only looking at direction in which the traffic originated
### the response is not in scope

in the from: or to: sections,
 each hyphen prefix is a rule and they are all OR'd together. ie. only need to match one rule
 without a hyphen prefix it is a criteria for a rule and they are all AND'd together. ie. must match ALL criteria
# Docker Storage
/var/lib/docker
+aufs
+containers
+image
+volumes
 +data_volume   created here by `docker volume create data_volume`
 +datavolume2   auto-created on the flt is !exist

-v       is the old volume mount syntax
 -v /data/mysql:/var/lib/mysql
--mount  is the new volume mount syntax
 --mount type=bind,source=/data/mysql,target=/var/lib/mysql

## Storage Drivers
# depends on underlying OS
aufs,zfs,btrfs,Device Mapper, Overlay, Overlay2

# === markdownified below ===

## Persistent Volumes (pv)

* [kubernetes-volumes-example-nfs-persistent-volume](https://matthewpalmer.net/kubernetes-app-developer/articles/kubernetes-volumes-example-nfs-persistent-volume.html)

NB. volumes, plural!
```yaml
spec:
  containers:
  - image: nginx:alpine
    name: nginx
  # NB. volumes, plural!
  volumes:
    - name: local-pvc
      persistentVolumeClaim:
        claimName: local-pvc
```

```bash
kubectl exec webapp -- cat /log/app.log
```

## Persistent Volume Claims (pvc)
access mode must match the pv

### pod mounts
NB. Mounts, plural!
```yaml
spec:
  containers:
  - image: nginx:alpine
    name: nginx
    # NB. Mounts, plural!
    volumeMounts:
    - name: local-pvc
      mountPath: "/var/www/html"
```

## Storge Classes (sc)
`k get sc`
### provisioner
```bash
k describe sc ${x?} | grep '"provisioner":'
k describe sc portworx-io-priority-high |awk -F= '/"provisioner":/{print $2}'|jq '.'
k describe sc portworx-io-priority-high |awk -F= '/^Annotations/{print $2}'|jq '.'
```
#### no dynamic provisioning
```bash
k describe sc ${x?} | grep 'no-provision'
```
#### check pvc events
A pod needs to be created as a consumer or it remains in "pending"
```bash
k describe pvc local-pvc
```
and look for events

The example Storage Class called `local-storage` makes use of `VolumeBindingMode` set to `WaitForFirstConsumer`. This will delay the binding and provisioning of a PersistentVolume until a Pod using the PersistentVolumeClaim is created.

## Networking

### Prerequisites

#### Linux Networking

* [bash ip completion](https://github.com/GArik/bash-completion)

Switching & Routing

```bash
export dev=eth0
ip link
ip addr add 192.168.1.10/24 dev $dev
vim /etc/network/interfaces  # <= make IPs permanent here
ip route add 192.168.2.0/24 via 192.168.1.1
ip route add default via 192.168.1.1  # or 0.0.0.0
echo 1 > /proc/sys/net/ipv4/ip_forward
```

DNS

```bash
cat /etc/resolv.conf  # nameserver, search
grep ^hosts /etc/nsswitch.conf
```

CoreDNS

* [Source](https://github.com/coredns)
* [Docs](https://github.com/kubernetes/dns/blob/master/docs/specification.md)
* [Plugin](https://coredns.io/plugins/kubernetes/)

#### Network Namespaces

```bash
ip netns add red
ip netns add blue
ip netns exec red ip link  # exec ip command inside a netns
ip -n red link             # or with this

ip netns exec red arp
ip netns exec red route
```

a virtual ethernet pair/cable is often called a pipe

```bash
ip link add veth-red type veth peer name veth-blue   # create pipe
ip link set veth-red  netns red                      # attach pipe to interface
ip link set veth-blue netns blue                     # ...at each end
ip -n red  addr add 192.168.15.1 dev veth-red        # assign IP
ip -n blue addr add 192.168.15.2 dev veth-blue       # ...to each namespace
ip -n red  link set veth-red  up                     # bring up interface
ip -n blue link set veth-blue up                     # ...in each namespace
ip netns exec red  ping 192.168.15.2                 # ping blue IP
ip netns exec red  arp                               # identified its neighbour
ip netns exec blue arp                               # ...in each namespace
arp                                                  # but the host has no visibility
```

virtual switch

* linux bridge
* Open vSwitch

```bash
ip link add
ip link add v-net-0 type bridge                         # create vswitch (bridge)
ip link set dev v-net-0 up                              # bring up the vswitch
ip -n veth-red link-del veth-red                        # del link, other end auto-del
ip link add veth-red  type veth peer name veth-red-br   # create pipe for red
ip link add veth-blue type veth peer name veth-blue-br  # ...and blue
ip link set veth-red  netns red                         # attach pipe to red ns
ip link set veth-blue netns blue                        # ...and blue
ip link set veth-red-br  master v-net-0                 # attach pipe to red ns
ip link set veth-blue-br master v-net-0                 # ...and blue
ip -n red  addr add 192.168.15.1 dev veth-red           # assign IP
ip -n blue addr add 192.168.15.2 dev veth-blue          # ...to each namespace
ip -n red  link set veth-red  up                        # bring up interface
ip -n blue link set veth-blue up                        # ...in each namespace
ip addr add 192.168.15.5/24 dev v-net-0                 # assign IP for host
ip addr add 192.168.15.5/24 dev v-net-0                 # assign IP for host
ping -c3 192.168.15.1                                   # ping from host
ip netns exec blue ping 192.168.1.3                     # destination unreachable
ip netns exec blue \
 ip route add 192.168.1.0/24 via 192.168.15.5           # route to host network
ip netns exec blue ping 192.168.1.3                     # no reply, need NAT
iptables -t nat -A POSTROUTING \
 -s 192.168.15.0/24 -j MASQUERADE                       # add SNAT
ip netns exec blue ping 192.168.1.3                     # now reachable
ip netns exec blue ping 8.8.8.8                         # destination unreachable
ip netns exec blue \
 ip route add default via 192.168.15.5                  # route via host
ip netns exec blue ping 8.8.8.8                         # Internet-a-go-go!
iptables -t nat -A PREROUTING \
 --dport 80 --to-destination 192.168.15.2:80 -j DNAT    # port forward rule to blue ns
```

##### FAQ

While testing the Network Namespaces, if you come across issues where you can't ping one namespace from the other, make sure you set the NETMASK while setting IP Address. ie: 192.168.1.10/24

```
ip -n red addr add 192.168.1.10/24 dev veth-red
```

Another thing to check is FirewallD/IP Table rules. Either add rules to IP Tables to allow traffic from one namespace to another. Or disable IP Tables all together (Only in a learning environment).

#### Docker Networking

tbc

```bash
docker run --network none nginx  # cannot talk to each other or outside world
docker run --network host nginx  # only on local host http://192.168.1.2:80
docker run nginx                 # bridge 172.17.0.0/16 by default
                                 # creates a network namespace
# equivalent to
ip link add docker0 type bridge
ip addr                          # docker0 is an interface to the host so had an IP
docker run nginx:1.21.1          # creates a network namespace
ip netns                         # generated hex ID
docker inspect ${containerid?}   # netns is end of SandboxID
```

```bash
docker network ls  # name is bridge by default
ip link            # but called docker0 by the host
```

#### CNI

tbc

### Cluster Networking

tbc

### CNI in Kubernetes

```bash
vim -c ":set syntax=sh" /etc/systemd/system/multi-user.target.wants/kubelet.service
ps -ef|grep kubelet|grep cni
sudo -p four: vim -c ":set syntax=sh" /var/lib/kubelet/config.yaml
ls /opt/cni/bin/
ls /etc/cni/net.d/
cat /etc/cni/net.d/10-*|jq '.'
```

#### CNI weave

tbc

## Design a Kubernetes Cluster

Maximums

* 5000 nodes
* 150,000 pods
* 300,000 total containers
* 100 pods per node

### Topology

* API Server
  * active-active
  * one node addressed, through LB
* Controller Manager
  * active-standby
  * leader election by getting lock on Kube-controller-manager endpoint
  * lease for 15s, leader renews every 10s (by default)
* etcd
  * stacked topology
    * easier, less resilient/fault tolerant
  * external etcd topology
    * harder
  * api sever has a list of etcd servers
  * since etcd is distributed, can read/write to any instance
  * distribued consensus with RAFT protocol
  * write complete if can be confirmed on majority of cluster nodes (quorum)
  * quorum = N/2+1 (should be an odd number of nodes)

```
--initial-cluster-peer="one...,two..."  # list of peers
export ETCDCTL_API=3
etcdctl put name john
etcdctl get name
etcdctl get / --prefix --keys-only
```

#### Important Update: Kubernetes the Hard Way

Installing Kubernetes the hard way can help you gain a better understanding of putting together the different components manually.

An optional series on this is available at our youtube channel here:
[Install Kubernetes Cluster from Scratch](https://www.youtube.com/watch?v=uUupRagM7m0&list=PL2We04F3Y_41jYdadX55fdJplDvgNGENo)

The GIT Repo for this tutorial can be found here:
[kubernetes-the-hard-way](https://github.com/mmumshad/kubernetes-the-hard-way)

## Install Kubernetes the kubeadm way

* provision nodes
* install container runtime (docker)
* install kubeadm
* initialise master
* configure pod network
* join worker nodes to master node

### Resources

The vagrant file used in the next video is available here: 
[certified-kubernetes-administrator-course](https://github.com/kodekloudhub/certified-kubernetes-administrator-course)

Here's the link to the documentation: [install-kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)

### end
