https://code.visualstudio.com/docs/languages/markdown

#alias k=kubectl
k() { kubectl $@; }
source <(kubectl completion bash|sed '/ *complete .*kubectl$/{;h;s/kubectl$/k/p;g;}')
v() { vim -c ":set shiftwidth=2 tabstop=2 softtabstop=-1 expandtab" ${1?} && kubectl apply -f $1; }
# shiftwidth=sw=2
# tabstop=ts=2
# softtabstop=sts=-1
# vim: set shiftwidth=2 tabstop=2 softtabstop=-1 expandtab

# pods
k run redis -n finance --image=redis
k run nginx-pod --image=nginx:alpine
k run redis --image=redis:alpine --labels='tier=db,foo=bar'

#k run custom-nginx --image=nginx
#k expose pod custom-nginx --port=8080
kubectl run custom-nginx --image=nginx --port=8080
kubectl run httpd --image=httpd:alpine --port=80 --expose

kubectl run --restart=Never --image=busybox static-busybox --dry-run=client -o yaml --command -- sleep 1000 > /etc/kubernetes/manifests/static-busybox.yaml

# replicasets (rs)
kubectl create replicaset foo-rs --image=httpd:2.4-alpine --replicas=2
kubectl scale replicaset new-replica-set --replicas=5
kubectl edit replicaset new-replica-set

# deployments
kubectl create deployment httpd-frontend --image=httpd:2.4-alpine --replicas=2
k create deployment webapp --image=kodekloud/webapp-color --replicas=3
k create deployment webapp --image=kodekloud/webapp-color --replicas=3 -o yaml --dry-run=client | sed '/strategy:/d;/status:/d' > pink.yaml
k set image deployment nginx nginx=nginx:1.18
kubectl get all

# services
k create svc clusterip redis-service --tcp=6379:6379  # worked in practice test but should use expose
k expose pod redis --name=redis-service --port=6379

# namespaces
k create ns dev-ns
k create deployment redis-deploy -n dev-ns --image=redis --replicas=2

# describe
k describe $(k get po -o name|head -1)

# replace
k replace -f nginx.yaml

# delete
k delete $(k get po -o name)

# generate manifest
kubectl run nginx --image=nginx --dry-run=client -o yaml

# labels and selectors
## labels in spec>selector and spec>template must match
k get po --selector app=foo
k get po --selector env=dev|grep -vc NAME
k get all --selector env=prod|egrep -vc '^$|NAME'
k get all --selector env=prod|grep -c ^[a-z]
k get all --selector env=prod --no-headers|wc -l
k get all --selector env=prod,bu=finance,tier=frontend --no-headers

# taints and tolerations
## taint-effect is what happens to pods that do not tolerate the taint
### NoSchedule
### PreferNoSchedule
### NoExecute
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
## use /etc/kubernetes/manifests/kube-scheduler.yaml as a source
## add --scheduler-name= option
## change --leader-elect to false
## change --port to your desired port
## update port in probes to the same as above
k create -f my-scheduler.yaml  # not as a static pod
echo -e '    schedulerName: my-scheduler' >> pod.yaml
k create -f pod.yaml
k get events

# monitoring
git clone https://github.com/kodekloudhub/kubernetes-metrics-server.git
k create -f kubernetes-metrics-server
k top node
k top pod

# application lifecycle
## RollingUpdate - a few pods at a time
## Recreate      - all destroyed in one go and then all recreated
k set image deployment/myapp nginx=nginx:1.9.1
#                            ^^^^^-The name of the container inside the pod
k edit deployment/myapp
k rollout status deployment/myapp
k rollout history deployment/myapp
k rollout undo deployment/myapp

# Dockerfile commands
## with CMD        command line params get replaced entirely
## with ENTRYPOINT command line params get appended
## ENTRYPOINT => command that runs on startup
## CMD        => default params to command at sartup
## always specity in json format
## ENTRYPOINT ["sleep"]
## CMD ["5"]
## default command will be "sleep 5"

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

# secrets
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
https://v1-20.docs.kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/
k drain node01 --ignore-daemonsets
k cordon node01
k uncordon node01

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

## workers
kubectl drain node01 --ignore-daemonsets --force
apt update && apt-cache madison kubeadm
apt-get install -y --allow-change-held-packages kubeadm=1.20.0-00
kubeadm upgrade node  # this is quick as just a config upgrade
apt-get install -y --allow-change-held-packages kubelet=1.20.0-00 kubectl=1.20.0-00
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


# security

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