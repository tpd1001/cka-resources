# Certified Kubernetes Administrator Revision Notes

These are my revision notes for my CKA exam. Hope someone finds them useful.

* [include-diagrams-markdown-files](https://github.blog/2022-02-14-include-diagrams-markdown-files-mermaid/)
* [how-dockershim-forthcoming-deprecation-affects-your-kubernetes](https://www.tripwire.com/state-of-security/security-data-protection/cloud/how-dockershim-forthcoming-deprecation-affects-your-kubernetes/)

## setup

```bash
alias k=kubectl
#k() { kubectl $@; }
source <(kubectl completion bash|sed '/ *complete .*kubectl$/{;h;s/kubectl$/k/p;g;}')
v() { vim -c ":set shiftwidth=2 tabstop=2 softtabstop=-1 expandtab" ${1?} && kubectl apply -f $1; }
# replace all "k" with "kubectl" for notes portability
#gsed -i 's/^\([#(]\)*k /\1kubectl /g;s/k get/kubectl get/g;s/k apply/kubectl apply/g;s/k desc/kubectl desc/g' README.md;gif README.md
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

ansible

```bash
 1996  pp test
 1997  ika package_install.yml
 1998  ika package_install.yml
 1999  ggrep -s --exclude-dir logs ansible .
2:main:SBGML06654:~/OD/____Future/Kubernetes/CKA/install_kubernetes_with_ansible$
```

## YAML, Markdown and Mac stuff

<!-- markdownlint-disable MD022 MD031 MD033 -->
<details><summary>Expand...</summary>

iTerm2 on Mac stuff

* [Captured Output](https://iterm2.com/documentation-captured-output.html)
* [Triggers](https://iterm2.com/documentation-triggers.html)
* [Shell Integration](https://iterm2.com/documentation-shell-integration.html)

## YAML

* [YAML cheat sheet](https://lzone.de/cheat-sheet/YAML)
* [YAML Multiline Strings](https://yaml-multiline.info/)

## markdown

* Markdown [docs](https://code.visualstudio.com/docs/languages/markdown)
* [VS Code as Markdown Note-Taking App](https://helgeklein.com/blog/vs-code-as-markdown-note-taking-app/)
* [Languages Supported by Github Flavored Markdown](https://www.rubycoloredglasses.com/2013/04/languages-supported-by-github-flavored-markdown/)
* [collapsed sections](https://docs.github.com/en/github/writing-on-github/working-with-advanced-formatting/organizing-information-with-collapsed-sections)
* [ultimate markdown cheat sheet](https://towardsdatascience.com/the-ultimate-markdown-cheat-sheet-3d3976b31a0)
* [About READMEs](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-readmes)

### markdownlint

See markdownlint [Configuration](https://github.com/DavidAnson/markdownlint#configuration) and the HTML comments below here in the source file and these [rules](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md): [MD022](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md#md022), [MD031](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md#md031).
Show VS Code preview pane: Cmd-K,V

</details>

## What's New

In the many months I've been studying in my spare time, there have been some new Kubernetes releases.

### 1.22

Alpha feature (may now be GA)

* [Using Kubernetes Ephemeral Containers for Troubleshooting
](https://loft.sh/blog/using-kubernetes-ephemeral-containers-for-troubleshooting/)

### [1.23](https://loft.sh/blog/kubernetes-1.23-release/)

* Ephemeral containers & [PodSecurity](https://kubernetes.io/docs/concepts/security/pod-security-admission/) move from alpha to beta
* dual ipv4/ipv6 stack moves to stable/GA
  * [Kubernetes 1.23 Release - loft.sh](https://loft.sh/blog/kubernetes-1.23-release/)
  * [Kubernetes Version 1.23 Is Out: Everything You Should Know](https://dzone.com/articles/kubernetes-version-123-is-out-everything-you-shoul)

### 1.24

* [Kubernetes 1.24 Release Information - kubernetes.dev](https://www.kubernetes.dev/resources/release/)

### GoLang

Kubernetes is built on Go.

<details><summary>Some interesting background reading...</summary>

* [How To Call Kubernetes API using Go - Types and Common Machinery](https://iximiuz.com/en/posts/kubernetes-api-go-types-and-common-machinery/) - annoyingly, this domain has gone away but I snaffled the HTML from Google's cache.
* more to come perhaps...

</details>

## pods (po)
```bash
kubectl run redis -n finance --image=redis
kubectl run nginx-pod --image=nginx:alpine
kubectl run redis --image=redis:alpine --labels='tier=db,foo=bar'

#kubectl run custom-nginx --image=nginx
#kubectl expose pod custom-nginx --port=8080
kubectl run custom-nginx --image=nginx --port=8080
kubectl run httpd --image=httpd:alpine --port=80 --expose

kubectl run --restart=Never --image=busybox static-busybox --dry-run=client -o yaml --command -- sleep 1000 > /etc/kubernetes/manifests/static-busybox.yaml
```

Commands using [PODS.template](PODS.template) (work in progress)

```bash
kubectl get po -o jsonpath="{.items[*].spec.containers[*].image}"
kubectl get po -o custom-columns-file=PODS.template
vim PODS.template && kubectl get po -o custom-columns-file=PODS.template
watch -n1 kubectl get po -o custom-columns-file=${func_path?}/../CKA/PODS.template
```

While you can specify a containerPort in the pod, it is purely informational as per [Should I configure the ports in the Kubernetes deployment?](https://faun.pub/should-i-configure-the-ports-in-kubernetes-deployment-c6b3817e495)

```yaml
ports:
- name: mysql
  containerPort: 3306  # purely informational
```

### pods for speed, in the exam

Reference (Bookmark this page for exam. It will be very handy):

[conventions](https://kubernetes.io/docs/reference/kubectl/conventions/)

Create an NGINX Pod

```bash
kubectl run nginx --image=nginx
```

Generate POD Manifest YAML file (-o yaml). Don't create it(--dry-run)

```bash
kubectl run nginx --image=nginx --dry-run=client -o yaml
```

Get pods that are in a state of Running or not Running

```bash
kubectl get po ${ns:+-n $ns} -l app=primary-01 -o name --field-selector=status.phase=Running
kubectl get po ${ns:+-n $ns} -l app=primary-01 -o name --field-selector=status.phase!=Running
```

## replicasets (rs)
```text
kubectl create replicaset foo-rs --image=httpd:2.4-alpine --replicas=2
kubectl scale replicaset new-replica-set --replicas=5
kubectl edit replicaset new-replica-set
```

## deployments (deploy)
```bash
kubectl create deployment httpd-frontend --image=httpd:2.4-alpine --replicas=2
kubectl create deployment webapp --image=kodekloud/webapp-color --replicas=3
kubectl create deployment webapp --image=kodekloud/webapp-color --replicas=3 -o yaml --dry-run=client | sed '/strategy:/d;/status:/d' > pink.yaml
kubectl set image deployment nginx nginx=nginx:1.18
kubectl get all
```

### limits

Should always specify requests and limits in a resources section for each container in a pod.

```yaml
spec:
  containers:
  - name: nginx
    image: nginx:latest
    resources:
      limits:
        memory: 200Mi
        cpu: 200m
      requests:
        memory: 128Mi
        cpu: 100m
```

### deploy for speed, in the exam

Create a deployment

```bash
kubectl create deployment --image=nginx nginx
```

Generate Deployment YAML file (-o yaml). Don't create it(--dry-run)

```bash
kubectl create deployment --image=nginx nginx --dry-run=client -o yaml
```

Generate Deployment YAML file (-o yaml). Don't create it(--dry-run) with 4 Replicas (--replicas=4)

In k8s version 1.19+, we can specify the --replicas option to create a deployment with 4 replicas.

```bash
kubectl create deployment --image=nginx nginx --replicas=4 --dry-run=client -o yaml > nginx-deployment.yaml
```

## services (svc)
```bash
kubectl create svc clusterip redis-service --tcp=6379:6379  # worked in practice test but should use expose
kubectl expose pod redis --name=redis-service --port=6379
```

## namespaces (ns)
```bash
kubectl create ns dev-ns
kubectl create deployment redis-deploy -n dev-ns --image=redis --replicas=2
```

## common verbs/ations

### describe
```bash
kubectl describe $(kubectl get po -o name|head -1)
```

### replace
```bash
kubectl replace -f nginx.yaml
```

### delete
```bash
kubectl delete $(kubectl get po -o name)
```

### generate manifest
```bash
kubectl run nginx --image=nginx --dry-run=client -o yaml
```

## scheduling

Manual scheduling, add `nodeName` property in pod spec

```yaml
---
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  nodeName: node01
  containers:
  -  image: nginx
     name: nginx
```

See also

* [Advanced Scheduling in Kubernetes](https://kubernetes.io/blog/2017/03/advanced-scheduling-in-kubernetes/)

## labels and selectors

labels in spec>selector and spec>template must match

```bash
kubectl get po --selector app=foo
kubectl get po --selector env=dev|grep -vc NAME
kubectl get all --selector env=prod|egrep -vc '^$|NAME'
kubectl get all --selector env=prod|grep -c ^[a-z]
kubectl get all --selector env=prod --no-headers|wc -l
kubectl get all --selector env=prod,bu=finance,tier=frontend --no-headers
kubectl get all -l env=prod  # short switch
```

## taints and tolerations

taint-effect is what happens to pods that do not tolerate the taint

* NoSchedule
* PreferNoSchedule
* NoExecute

use `kubectl describe node NODE` to list taints

## affinity

[Schedule a Pod using required node affinity](https://kubernetes.io/docs/tasks/configure-pod-container/assign-pods-nodes-using-node-affinity/)

### permit master to run pods

use a `-` suffix to the effect to remove it

```bash
# remove taint on master to allow it to run pods
kubectl taint nodes controlplane node-role.kubernetes.io/master:NoSchedule-
kubectl taint nodes controlplane node-role.kubernetes.io/control-plane:NoSchedule-
# prevent master from running pods again (defaut)
kubectl taint nodes controlplane node-role.kubernetes.io/master:NoSchedule
kubectl taint nodes controlplane node-role.kubernetes.io/control-plane:NoSchedule
```

### other taints

```bash
kubectl taint nodes node1 key=value:taint-effect
kubectl taint nodes node1 app=blue:NoSchedule
kubectl taint nodes node1 app=blue:NoSchedule-  # to remove

#spec>tolerations>- key: "app" (all in quotes)
kubectl describe node kubemaster | grep Taint

#kubectl get po bee -o yaml | sed '/tolerations:/a\  - key: spray\n    value: mortein\n    effect: NoSchedule\n    operator: Equal'|kubectl apply -f -
kubectl get po bee -o yaml | sed '/tolerations:/a\  - effect: NoSchedule\n    key: spray\n    operator: Equal\n    value: mortein'|kubectl apply -f -
```

## node selectors

* label nodes first
* spec:>nodeSelector:>size:Large

```bash
kubectl label nodes node1 size=Large
```

## node affinity

```yaml
#spec:>template:>spec:>affinity:
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

      # this should let the pod run on a controlplane node
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: node-role.kubernetes.io/master
                operator: Exists

      affinity:
        podAntiAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            - labelSelector:
                matchExpressions:
                  - key: "app"
                    operator: In
                    values:
                    - tomd-nginx
              # will get stuck on deployment restart if: num pods = num nodes
              # though individual pod restarts seem ok
              topologyKey: "kubernetes.io/hostname"
```

## resources

Create pod > yaml and edit/copy the resources lines

```bash
kubectl describe po elephant | grep Reason
kubectl describe po elephant | sed -n '/Last State/{;N;p}'
```

## daemonsets

Same creation process as for deployments only without the replicas

```bash
kubectl get ds -A
kubectl get ds -n kube-system kube-flannel-ds
kubectl describe ds kube-flannel-ds|grep Image
kubectl get ds kube-flannel-ds -o yaml
kubectl create deployment -n kube-system elasticsearch --image=k8s.gcr.io/fluentd-elasticsearch:1.20 -o yaml --dry-run=client | \
 sed 's/Deployment$/DaemonSet/;/replicas:/d;/strategy:/d;/status:/d' > ds.yaml
kubectl create -f ds.yaml
sed 's/Deployment$/DaemonSet/;/replicas:/d;/strategy:/d;/status:/d' deployment.yaml | kubectl apply -f -
```

## static pods

* as an option in kubelet.service (systemd)
* or as a --config switch to a file containing the staticPodPath opt

```bash
# static pods will have the node name appended to the name
kubectl get po -A -o wide

# check the static pod path in the kublet config
sudo grep staticPodPath $(ps -wwwaux | \
 sed -n '/kubelet /s/.*--config=\(.*\) --.*/\1/p' | \
 awk '/^\//{print $1}')

ls .*  # dummy command to close italics

kubectl run static-pod-nginx --image=nginx --dry-run=client -o yaml | \
 egrep -v 'creationTimestamp:|resources:|status:|Policy:' \
 >static-pod-nginx.yaml
```

## statefulsets

Similar to deployments.

Probably not in the CKA exam but still of interest.

* [StatefulSets](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/)

```bash
kubectl create deployment ${name?} --image=nginx:1.23.1-alpine --replicas=2 --dry-run=client -o yaml | \
 sed "s/Deployment$/StatefulSet/;s/strategy:.*/serviceName: $name/;/status:/d" | \
kubectl apply -f -
```

## multiple schedulers

* [advanced-scheduling-in-kubernetes](https://kubernetes.io/blog/2017/03/advanced-scheduling-in-kubernetes/)
* [how-does-the-kubernetes-scheduler-work](https://jvns.ca/blog/2017/07/27/how-does-the-kubernetes-scheduler-work/)
* [how-does-kubernetes-scheduler-work](https://stackoverflow.com/questions/28857993/how-does-kubernetes-scheduler-work/28874577#28874577)

1. use /etc/kubernetes/manifests/kube-scheduler.yaml as a source
2. add --scheduler-name= option
3. change --leader-elect to false
4. change --port to your desired port
5. update port in probes to the same as above

```bash
kubectl create -f my-scheduler.yaml  # not as a static pod
echo -e '    schedulerName: my-scheduler' >> pod.yaml
kubectl create -f pod.yaml
kubectl get events
```

## monitoring

* [kubernetes-metrics-server](https://github.com/kodekloudhub/kubernetes-metrics-server)

```bash
git clone https://github.com/kodekloudhub/kubernetes-metrics-server.git
kubectl create -f kubernetes-metrics-server
kubectl top node
kubectl top pod
```

## application lifecycle

* RollingUpdate - a few pods at a time
* Recreate      - all destroyed in one go and then all recreated

```bash
kubectl set image deployment/myapp nginx=nginx:1.9.1
#                            ^^^^^-The name of the container inside the pod
kubectl edit deployment/myapp
#OR#
kubectl rollout restart deployment/myapp
kubectl annotate deployment/myapp kubernetes.io/change-cause="foo"  # replace deprecated --record
kubectl rollout status deployment/myapp
kubectl rollout history deployment/myapp
kubectl rollout undo deployment/myapp
kubectl get po -o=custom-columns=NAME:.metadata.name,IMAGE:.spec.containers[].image
```

## Dockerfile commands

* kube command == docker entrypoint
* kube args    == docker cmd
* with CMD        command line params get replaced entirely
* with ENTRYPOINT command line params get appended
* ENTRYPOINT => command that runs on startup
* CMD        => default params to command at sartup
* always specity in json format

```text
ENTRYPOINT ["sleep"]
CMD ["5"]
# default command will be "sleep 5"
```

## command & args in kubernetes

```yaml
    command: ["printenv"]
    args: ["HOSTNAME", "KUBERNETES_PORT"]
# or
    command:
    - printenv
    args:
    - HOSTNAME
    - KUBERNETES_PORT
```

## environment variables

docker command to pass in env vars

```bash
docker run --rm -ti -p 8080:8080 -e APP_COLOR=blue kodekloud/webapp-color
```

kubernetes yaml equivalent

```yaml
spec:
  containers:
  - env:
    - name: APP_COLOR
      value: green
```

## configmaps

```bash
kubectl create configmap --from-literal=APP_COLOR=green \
                         --from-literal=APP_MOD=prod
kubectl create configmap --from-file=app_config.properties
```

use the contents of an entire directory:

```bash
kubectl create configmap tomd-test-ssl-certs --from-file=path/to/dir
```

or configure in yaml

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  APP_COLOR: green
  APP_MOD: prod
    image: foo
    envFrom:
      configMapRef:
      name: app-config
```

## secrets (secret)

* [encrypt-data](https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/)
* Read about the [protections](https://kubernetes.io/docs/concepts/configuration/secret/#protections) and [risks](https://kubernetes.io/docs/concepts/configuration/secret/#risks) of using secrets [here](https://kubernetes.io/docs/concepts/configuration/secret/#risks)
* There are other better ways of handling sensitive data like passwords in Kubernetes, such as using tools like Helm Secrets, [HashiCorp Vault](https://www.vaultproject.io/).

```bash
kubectl create secret generic app-secret --from-literal=DB_PASSWD=green \
                                   --from-literal=MYSQL_PASSWD=prod
kubectl create secret generic app-secret --from-file=app_secret.properties
kubectl describe secret app-secret
kubectl get secret app-secret -o yaml
```

create with

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: app-secret
data:
  # encode with: echo -n "password123" | base64
  # decode with: echo -n "encodedstring" | base64 --decode
  DB_PASSWD: green
  MYSQL_PASSWD: prod
```

use as env var with

```yaml
    image: foo
    envFrom:
    - secretRef:
      name: app-config
```

or as a volume with

```yaml
volumes:
  - name: app-secret-volume
    secret:
      secretName: app-secret
#ls /opt/app-secret-volumes
#cat /opt/app-secret-volumes/DB_PASSWD
```

## multi-container pods

```yaml
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
```

## init containers

```bash
kubectl describe pod blue  # check the state field of the initContainer and reason: Completed
```

```yaml
  initContainers:
  - command:
    - sh
    - -c
    - sleep 600
    image: busybox
    name: red-init
```

## cluster upgrades

```bash
# componentstatus (cs) is deprecated in v1.19+
kubectl get cs
```

[kubeadm upgrade](https://v1-20.docs.kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/)

```bash
kubectl drain node01 --ignore-daemonsets
kubectl drain node01 --ignore-daemonsets --delete-emptydir-data
kubectl cordon node01
kubectl uncordon node01
```

### etcd

```bash
etcdctl member list                # list the members in the cluster
etcdctl endpoint status            # list this server's status
etcdctl endpoint status --cluster  # list all server status
etcdctl endpoint health --cluster  # all endpoint health

etcdsrv() { kubectl get -n kube-system pod $(kubectl get -n kube-system po|awk "/apiserver/{print \$1;exit}") -oyaml|sed -n '/etcd-servers/s/.*=//p'; }

# my company only (probably)
systemctl status etcd-member.service
systemctl status etcd-backup.service
journalctl -eu etcd-backup.service
#NUKE#systemctl stop etcd-member.service && rm -rf /var/lib/etcd/*

export ETCDCTL=3
etcdctl
```

### controlplane

```bash
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
```

### workers

```bash
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
```

## backup and restore

### backup

```bash
kubectl get all --all-namespaces -o yaml \
 > all-deploy-services.yaml
ETCDCTL_API=3 etcdctl snapshot save snapshot.db
ETCDCTL_API=3 etcdctl snapshot status snapshot.db

crt=$(kubectl describe -n kube-system po etcd-controlplane|awk -F= '/--cert-file/{print $2}')
ca=$( kubectl describe -n kube-system po etcd-controlplane|awk -F= '/--trusted-ca-file/{print $2}')
key=$(kubectl describe -n kube-system po etcd-controlplane|awk -F= '/--key-file/{print $2}')
ETCDCTL_API=3 etcdctl --cacert=${ca?} --cert=${crt?} --key=${key?} snapshot save /opt/snapshot-pre-boot.db
```

### restore

```bash
service kube-apiserver stop
ETCDCTL_API=3 etcdctl snapshot restore snapshot.db \
 --data-dir /new/data/dir
# !!CARE!! edit data-dir to point to restore location in volumes section
vim /etc/kubernetes/manifests/etcd.yaml
```

### cluster maintenance references

* [backing-up-an-etcd-cluster](https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/#backing-up-an-etcd-cluster)
* [etcd recovery](https://github.com/etcd-io/website/blob/main/content/en/docs/v3.5/op-guide/recovery.md)
* [Disaster Recovery for your Kubernetes Clusters](https://www.youtube.com/watch?v=qRPNuT080Hk)

## security

Nick Perry [kubesec.io](https://twitter.com/nickwperry/status/1442095087844945934)

```bash
kubectl run -oyaml --dry-run=client nginx --image=nginx > nginx.yaml
docker run -i kubesec/kubesec scan - < nginx.yaml
```

### authentication

basic, deprecated

```bash
curl -vk https://master_node_ip:6443/api/v1/pods -u "userid:passwd
curl -vk https://master_node_ip:6443/api/v1/pods --header "Authorization: Bearer ${token?}"
```

view certificates

```bash
kubectl get po kube-apiserver-controlplane -o yaml -n kube-system|grep cert
kubectl get po etcd-controlplane -o yaml -n kube-system|grep cert
openssl x509 -text -noout -in /etc/kubernetes/pki/apiserver.crt
openssl x509 -text -noout -in /etc/kubernetes/pki/etcd/server.crti|grep CN  # etcd
openssl x509 -text -noout -in /etc/kubernetes/pki/apiserver.crt|grep Not    # validity
openssl x509 -text -noout -in /etc/kubernetes/pki/ca.crt|grep Not           # CA validity
for f in $(grep pki /etc/kubernetes/manifests/etcd.yaml|egrep 'key|crt'|awk -F= '{print $2}'); do echo +++ $f;test -f $f && echo y || echo n;done
vim /etc/kubernetes/manifests/etcd.yaml
docker logs $(docker ps|grep -v pause:|awk '/etcd/{print $1}')
grep pki /etc/kubernetes/manifests/kube-apiserver.yaml|grep '\-ca'
```

certificates API

```bash
openssl genrsa -out jane.key 2048
openssl req -new -key jane.key -subj "/CN=jane" -out jane.csr
cat jane.csr | base64
```

csr in yaml

```yaml
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
```

approving csr

```bash
kubectl get csr
kubectl certificate approve jane
kubectl get csr -o yaml
cat jane.b64|base64 --decode

cat akshay.csr|base64|sed 's/^/      /'>>akshay.yaml
sed -i "/request:/s/$/ $(echo $csr|sed 's/ //g')/" a
```

### KubeConfig

```bash
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
kubectl config set-context --current --namespace=alpha
kubectl config -h

kubectl config --kubeconfig=my-kube-config current-context
kubectl config --kubeconfig=my-kube-config use-context research
```

```yaml
contexts:
- name: kubernetes-admin@kubernetes
  context:
    cluster: kubernetes
    namespace: default
    user: kubernetes-admin
```

better to use full path to crt etc. or base64 encode it

### API Groups

```bash
curl -k https://controlplane:6443/ --key $PWD/dev-user.key --cert $PWD/dev-user.crt --cacert /etc/kubernetes/pki/ca.crt
curl -k https://controlplane:6443/apis --key $PWD/dev-user.key --cert $PWD/dev-user.crt --cacert /etc/kubernetes/pki/ca.crt
# =OR=
kubectl proxy  # starts on localhost:8001 and proxy uses creds from kubeconfig file
curl -k https://localhost:8001
```

## Authorisation

```bash
kubectl describe -n kube-system po kube-apiserver-controlplane
```

Authorisation Mechanisms

* Node
  * system:node:node01
* ABAC (Attribute)
  * need to restart kube-apiserver
* RBAC (Role)
* Webhook
  * for outsourcing authorisation
  * e.g. Open Policy Agent
* AlwaysAllow
  * kube-apiserver switch `--authorization-mode=AlwaysAllow` by default
  * comma separatyed list
* AlwaysDeny

### Roles and Role Bindings

These are namespaced and created within a namespace (if not specified, created in default namespace)

Role yaml

```yaml
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
```

RoleBinding yaml

```yaml
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
```

```bash
kubectl create -f developer-role.yaml
kubectl create -f devuser-developer-binding.yaml
```

```bash
kubectl get roles
kubectl get rolebindings
kubectl describe role developer
kubectl describe rolebinding devuser-developer-rolebinding
```

Can I?

```bash
kubectl auth can-i create deployments
kubectl auth can-i delete nodes
kubectl auth can-i create deployments --as dev-user
kubectl auth can-i create pods        --as dev-user
kubectl auth can-i create pods        --as dev-user --namespace test
# can edit in-place
kubectl edit role developer -n blue
```

### Cluster Roles and Role Bindings

These apply to the cluster scoped resources, rather than namespaced resources.

* nodes
* PV
* CSR
* clusterroles
* clusterrolebindings
* namespaces

For a list, run:

```bash
kubectl api-resources --namespaced=true
kubectl api-resources --namespaced=false
```

```bash
kubectl get roles
kubectl get roles -n kube-system -o yaml
kubectl get role -n blue developer -o yaml
```

Cluster Role

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: cluster-administrator
  # NB. no namespace:
rules:
- apiGroups:  # [""] or ["apps","extensions"] for example
  - ""
  resources:  # ["nodes"] or
  # optional
  - nodes
  verbs:      # ["get","list"] or
  - list
  - get
  - create
  - delete
```

Cluster RoleBinding

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: cluster-admin-role-binding
  # NB. no namespace:
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: cluster-administrator
subjects:
- apiGroup: rbac.authorization.k8s.io
  kind: User
  name: cluster-admin
```

```bash
kubectl get rolebinding -n blue dev-user-binding -o yaml
kubectl create -f rb.yaml
```

Can I?

```bash
kubectl auth can-i create pods
kubectl auth can-i create pods --as dev-user
# don't need to delete & recreate - can edit in-place
kubectl edit role developer -n blue
```

### serviceaccounts (sa)

User by machines e.g.

* Prometheus
* Jenkins
  * to deploy applications on a cluster

```bash
kubectl create serviceaccount dashboard-sa
kubectl get sa
kubectl describe sa dashboard-sa | grep ^Token
# token is a secret object. to view it use
kubectl describe secret $(kubectl describe sa dashboard-sa | awk '/^Token/{print $2}')
# token is a bearer token
curl -kv https://x.x.x.x:6443/api \
 --header "Authorization: Bearer ${token?}"
```

mount service account token as a volume into pod
the default sa in each ns is automatically created as a volume mount in all created pods
mounted at `/var/run/secrets/kubernetes.io/serviceaccount` so you can access it

```yaml
# inside template>pod spec, NOT dep spec!
spec:
  serviceAccountName: dashboard-sa
  # must delete & recreate pod (deployment handles this)

  # to prevent automount sa
  automountServiceAccountToken: false
```

### Image Security

```yaml
image: docker.io/nginx/nginx
#                      ^^^^^-- image/repository
#                ^^^^^-------- user/account
#      ^^^^^^^^^-------------- registry
image: gcr.io/kubernetes-e2e-test-images/dnsutils
```

```bash
docker login private-registry.io
docker run   private-registry.io/apps/internal-app
```

creating a registry

```bash
kubectl create secret docker-registry regcred \
 --docker-server=private-registry.io \
 --docker-username=registry-user \
 --docker-password=password123 \
 --docker-email=registry-user@org.com
```

```yaml
spec:
  containers:
  - image: nginx:latest
    name: ignition-nginx
  imagePullSecrets:
  - name: regcred
```

## Security Contexts

security settings & capabilities

```yaml
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
```

## Network Policies

* [webapp-conntest](https://github.com/kodekloudhub/webapp-conntest)
* [docker hub](https://hub.docker.com/r/kodekloud/webapp-conntest)

```bash
docker pull kodekloud/webapp-conntest
```

* Ingress is to the pod
* Egress  is from the pod
* only looking at direction in which the traffic originated
* the response is not in scope

in the from: or to: sections,
 each hyphen prefix is a rule and they are all OR'd together. ie. only need to match one rule
 without a hyphen prefix it is a criteria for a rule and they are all AND'd together. ie. must match ALL criteria

## Storage

### Docker Storage

/var/lib/docker ??? - what is here?

* aufs
* containers
* image
* volumes
  * data_volume   created here by `docker volume create data_volume`
  * datavolume2   auto-created on the fly if !exist

```bash
# -v       is the old volume mount syntax
-v /data/mysql:/var/lib/mysql
# --mount  is the new volume mount syntax
--mount type=bind,source=/data/mysql,target=/var/lib/mysql
```

### Storage Drivers

depends on underlying OS e.g.
aufs, zfs, btrfs, Device Mapper, Overlay, Overlay2

### Persistent Volumes (pv)

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

### Persistent Volume Claims (pvc)
access mode must match the pv

#### pod mounts
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

### Storge Classes (sc)
`kubectl get sc`
#### provisioner
```bash
kubectl describe sc ${x?} | grep '"provisioner":'
kubectl describe sc portworx-io-priority-high |awk -F= '/"provisioner":/{print $2}'|jq '.'
kubectl describe sc portworx-io-priority-high |awk -F= '/^Annotations/{print $2}'|jq '.'
```
##### no dynamic provisioning
```bash
kubectl describe sc ${x?} | grep 'no-provision'
```
##### check pvc events
A pod needs to be created as a consumer or it remains in "pending"
```bash
kubectl describe pvc local-pvc
```
and look for events

The example Storage Class called `local-storage` makes use of `VolumeBindingMode` set to `WaitForFirstConsumer`. This will delay the binding and provisioning of a PersistentVolume until a Pod using the PersistentVolumeClaim is created.

## Additional Storage Topics

Additional topics such as StatefulSets are out of scope for the exam. However, if you wish to learn them, they are covered in the  Certified Kubernetes Application Developer (CKAD) course.

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

```bash
ip -n red addr add 192.168.1.10/24 dev veth-red
```

Another thing to check is FirewallD/IP Table rules. Either add rules to IP Tables to allow traffic from one namespace to another. Or disable IP Tables all together (Only in a learning environment).

#### Docker Networking

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

#### CNI (Container Network Interface)

Docker,rkt,Mesos,k8s (all use CNI and it's called implemented as "bridge")
`bridge` is a plugin for CNI

Other CNI plugin examples:

* bridge, vlan, ipvlan, macvlan, windows
* dhcp, host-local
* weave, flannel, cilium, vmwrensx, calico, infoblox

Docker does NOT implement CNI but rather CNM (container network model) so you can't run `docker run --network=cni-bridge nginx` but you could use:

```bash
docker run --network=none nginx
bridge add ${id?} /var/run/netns/${id?}
```

### Cluster Networking

<details><summary>N.B. CNI and CKA Exam...</summary>
An important tip about deploying Network Addons in a Kubernetes cluster.

In the upcoming labs, we will work with Network Addons. This includes installing a network plugin in the cluster. While we have used weave-net as an example, please bear in mind that you can use any of the plugins which are described here:

[Installing Addons](https://kubernetes.io/docs/concepts/cluster-administration/addons/)

[Cluster Networking](https://kubernetes.io/docs/concepts/cluster-administration/networking/#how-to-implement-the-kubernetes-networking-model)

In the CKA exam, for a question that requires you to deploy a network addon, unless specifically directed, you may use any of the solutions described in the link above.

However, the documentation currently does not contain a direct reference to the exact command to be used to deploy a third party network addon.

The links above redirect to third party/ vendor sites or GitHub repositories which cannot be used in the exam. This has been intentionally done to keep the content in the Kubernetes documentation vendor-neutral.

At this moment in time, there is still one place within the documentation where you can find the exact command to deploy weave network addon:

[Stacked control plane and etcd nodes](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/high-availability/#steps-for-the-first-control-plane-node) (step 2)
</details>

* Must have unique:
  * hostname
  * mac
* Master must have ports open:
  * 6443 (apiserver)
  * 10250 (kubelet)
  * 10251 (scheduler)
  * 10252 (controller-mgr)
* Workers must have ports open:
  * 10250 (kubelet)
  * 30000-32767 (container services)
* Etcd
  * 2379 (etcd server)
  * 2380 (etcd clients)

Useful commands

```bash
ip link
ip link show eth0
ip addr
ip addr add 192.168.15.5/24 dev v-net-0
ip route add 192.168.1.0/24 via 192.168.2.1
cat /proc/sys/net/ipv4/ip_forward
arp
netstat -plnt
```

### Pod Networking

Every pod must

* havd IP
* connectivity to all pods on node
* connectivity to all pods on other nodes

net-script.sh <add|delete>

### CNI in Kubernetes

```bash
vim -c ":set syntax=sh" /etc/systemd/system/multi-user.target.wants/kubelet.service
ps -ef|grep kubelet|grep cni
sudo -p four: vim -c ":set syntax=sh" /var/lib/kubelet/config.yaml
ls /opt/cni/bin/
ls /etc/cni/net.d/
cat /etc/cni/net.d/10-*|jq '.'
```

### CNI weave (WeaveWorks)

an agent/service on each node which communidate with each other
each agent stores topo
creates bridge called "weave" (separate to bridge created by docker etc.)
pod can be attached to multiple bridge networks
weave ensures pod has route to agent
agent then takes care of other pods
peforms encapsulation

can be deployed ad daemons on node os
or as daemonset (ideally)

```bash
kubectl apply -f "...url..."
kubectl get po -n kube-system
kubectl logs weave-net-... -n kube-system
```

### IPAM

The responsibility of the CNI plugin

* host-local
* dhcp

weave uses 10.32.0.0/12 by default
weave assigns a potion (configurable) to each node

### Service Networking

* ClusterIP - only accessible from within the cluster, runs on the cluster
* NodePort - exposes service via a port on each node to it is accessible from outside the cluster

kube-proxy does this:

* monitors API for new services
* gets IP from predefined range
* creates forwarding rules on the cluster (each node?)

kube-proxy can create this ip:port rule in a number of different ways

* userspace
* ipvs
* iptables [default]

```bash
kube-proxy --proxy-mode [userspace|ipvs|iptables] ...
```

ClusterIPs are allocated from 10.0.0.0/24 by default, often 10.96.0.0/12 is used.
N.B. must not overlap with PodNetwork, typically 10.244.0.0/16

```bash
kube-api-server --service-cluster-ip-range CIDR
```

```bash
kubectl get svc  # list ClusterIP
kubectl get svc db-dervice
iptables -L -t nat | grep db-service
sudo grep 'new service' /var/log/kube-proxy.log  # location varies
sudo grep 'new service' /var/log/pods/kube-system_kube-proxy-*/kube-proxy/*.log
kubectl logs -n kube-system kube-proxy-kxg8g|less
# if no logs, check process verbosity
```

## DNS in Kubernetes

Services

* when service created, kube dns record is created, can use service name, within same namespace e.g. web-service
* when in a different namespace, append the namespace as a domain e.g. web-service.apps
* all recoreds of a type e.g. services are grouped together in a subdomain, svc e.g. web-service.apps.svc
* all services & pods are in a root domain, cluster.local by default e.g. web-service.apps.svc.cluster.local

Pods

* Pods dns not created by default but can be enabled
* ip has dots substituted by dashes e.g. 10-244-2-5
* namespace as before, or default
* type is pod e.g. 10-244-2-5.apps.pods.cluster.local

## CoreDNS in Kubernetes

`/etc/coredns/Corefile`

* kubernetes plugin in Corefile is where the TLD for the cluster is set e.g. cluster.local
* `pods insecure` enables creation of DNS records for pods
* Corefile is passed in as a ConfigMap `kubectl get cm -n kube-system coredns -o yaml`

For pods, their resolv.conf is configured with the Service registered by coredns `kubectl get svc -n kube-system kube-dns` which is done by the kubelet

search domains are only possible for services; pods must use fqdns

```bash
  ns=kube-system
kubectl logs ${ns:+-n $ns} $(
  kubectl get po -A -l k8s-app=kube-dns -o name|head -1)
```

```bash
nslookup pod-i-p-addr.namespace.pod.cluster.local
nslookup service-name.namespace.svc.cluster.local
# e.g.
nslookup 10-244-69-111.test.pod.cluster.local
nslookup nginx-service.test.svc.cluster.local
nslookup nginx-service.prod.svc.cluster.local
# from prod
nslookup nginx-service.test
# from within the same test namespace
nslookup nginx-service
```

See [DNS for Services and Pods](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/) for more details.

## Ingress (ing)

* Ingress Controller
  * nginix
  * GCE
  * Contour
  * haproxy
  * traefik
  * istio
* Ingress Resources

* to split by url
  * one rule, two paths
* to split by host
  * two rules, one path

```bash
kubectl describe ingress foo
```

Now, in k8s version 1.20+ we can create an Ingress resource from the imperative way like this:-

```bash
# kubectl create ingress <ingress-name> --rule="host/path=service:port"
kubectl create ingress ingress-test --rule="wear.my-online-store.com/wear*=wear-service:80"
```

Find more information and examples in the below reference link:-

* [kubectl ingress commands](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#-em-ingress-em-)

References:-

* [ingress](https://kubernetes.io/docs/concepts/services-networking/ingress)
* [path-types](https://kubernetes.io/docs/concepts/services-networking/ingress/#path-types)

## to merge with the end of Networking or Troubleshooting

[merge](https://learnk8s.io/kubernetes-network-packets)

### MetalLB

* [usage](https://metallb.universe.tf/usage/)
* [METALLB IN LAYER 2 MODE](https://metallb.universe.tf/concepts/layer2/)
* [Using MetalLB to add the LoadBalancer Service to Kubernetes Environments](https://platform9.com/blog/using-metallb-to-add-the-loadbalancer-service-to-kubernetes-environments/) which supports multiple networks

## Design a Kubernetes Cluster

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

```bash
--initial-cluster-peer="one...,two..."  # list of peers
export ETCDCTL_API=3
etcdctl put name john
etcdctl get name
etcdctl get / --prefix --keys-only
```

### ETCD Commands

Maybe not part of CKA - tbc...

<details><summary>ETCDCTL is the CLI tool used to interact with ETCD.</summary>

ETCDCTL can interact with ETCD Server using 2 API versions - Version 2 and Version 3.  By default its set to use Version 2. Each version has different sets of commands.

For example ETCDCTL version 2 supports the following commands:

```bash
etcdctl backup
etcdctl cluster-health
etcdctl mk
etcdctl mkdir
etcdctl set
```

Whereas the commands are different in version 3

```bash
etcdctl snapshot save
etcdctl endpoint health
etcdctl get
etcdctl put
```

To set the right version of API set the environment variable ETCDCTL_API command

```bash
export ETCDCTL_API=3
```

When API version is not set, it is assumed to be set to version 2. And version 3 commands listed above don't work. When API version is set to version 3, version 2 commands listed above don't work.

Apart from that, you must also specify path to certificate files so that ETCDCTL can authenticate to the ETCD API Server. The certificate files are available in the etcd-master at the following path. We discuss more about certificates in the security section of this course. So don't worry if this looks complex:

```bash
--cacert /etc/kubernetes/pki/etcd/ca.crt
--cert /etc/kubernetes/pki/etcd/server.crt
--key /etc/kubernetes/pki/etcd/server.key
```

So for the commands I showed in the previous video to work you must specify the ETCDCTL API version and path to certificate files. Below is the final form:

```bash
# reformatted from one-liner for readability
kubectl exec etcd-master -n kube-system -- sh -c "
 ETCDCTL_API=3 etcdctl get / --prefix --keys-only --limit=10 \
 --cacert /etc/kubernetes/pki/etcd/ca.crt \
 --cert /etc/kubernetes/pki/etcd/server.crt \
 --key /etc/kubernetes/pki/etcd/server.key
"
```

</details>

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

### Important Update: End to End Section

<details><summary>Expand...</summary>

As per the CKA exam changes (effective September 2020), End to End tests is no longer part of the exam and hence it has been removed from the course.

If you are still interested to learn this, please check out the complete tutorial and demos in our YouTube playlist:

[tutorial and demos](https://www.youtube.com/watch?v=-ovJrIIED88&list=PL2We04F3Y_41jYdadX55fdJplDvgNGENo&index=18)

</details>

## Troubleshooting

* [twitter link](https://twitter.com/manekinekko/status/1434808198532370432)
* [troubleshooting deployments](https://learnk8s.io/troubleshooting-deployments)

### Application Failure

Draw map of entire stack

* DB pod
* DB svc
* Web pod
* Web svc

Check top down client>web>db
Check service first
Check selectors and labels

```bash
kubectl describe svc web-svc  # grep for Selector:
kubectl describe pod web-pod  # check matches in metadata>labels
```

Check pod is running ok

```bash
kubectl get po
kubectl describe po web
kubectl logs web -f
kubectl logs web -f --previous
```

Repeat for DB svc then pod

Further troubleshooting tips in kubernetes doc [Troubleshooting Applications](https://kubernetes.io/docs/tasks/debug-application-cluster/debug-application/)

### Controlplane Failure

Check status of nodes

```bash
kubectl get no
kubectl get po

kubectl get po -n kube-system
# if deployed as services
service kube-apiserver status
service kube-controller-manager status
service kube-scheduler status
service kubelet status
service kube-proxy status

kubectl logs kube-apiserver-master -n kube-system
# if deployed as services
sudo journalctl -u kube-apiserver
```

Further troubleshooting tips in kubernetes doc [Troubleshooting Clusters](https://kubernetes.io/docs/tasks/debug-application-cluster/debug-cluster/)

### Worker Node Failure

Check status of nodes

```bash
kubectl get no  # look for NotReady
kubectl describe no node01
# if status Unknown, comms lost with master, possible node failure
# then check LastHeartbeatTime for when it happened
# if crashed, bring it back up
top    # check for CPU/Mem issues
df -h  # check for disk issues
service kubelet status     # check kubelet status
sudo journalctl -u kubelet  # check kubelet logs
openssl x509 -text -in /var/lib/kubelet/worker-1.crt  # check certs
# check certs are not expired and have been issues by correct CA
# Subject: ... O = system:nodes
```

### Network Failure

tbc

### JSON PATH

<details><summary>Basics</summary>

Always start with a $ to represent the root element (dict with no name).

```json
$[1]            # the 2nd item an a root list/array
$.fruit         # the dict named fruit
$.fruit.colour  # the dict in a dict
```

Results are returned in an array i.e. square brackets

To limit the output, use a criteria

```json
?()     # denotes the check if inside the list
@       # represents each item in the list
@ > 40  # items greter than 40
@ == 40
@ != 40
@ in [40,41,42]
@ nin [40,41,42]
$.car.wheels[?(@.location == "rear-right")].model
```

Wildcards

```json
$.*.price            # price of all cars
$[*].model           # model of all cars in array/list
$.*.wheels[*].model  # model of all wheels of all models
```

```json
# literal
$.prizes[5].laureates[2]
# better but overly verbose
$.prizes[?(@.year == "2014")].laureates[?(@.firstname == "Malala")]
# optimal
$.prizes[*].laureates[?(@.firstname == "Malala")]
```

Lists

```json
$[0:3]    # start:end get first 4 elements, NOT including the 4th
$[0:4]    # get first 4 elements, INCLUDING the 4th
$[0:8:2]  # in increments of 2
$[-1]     # the last item in list. not in ALL implementations
$[-1:0]   # this works to get the last element
$[-1:]    # you can leave out the 0
$[-3:0]   # last three elements
```

</details>

[JSON PATH](https://githib.com/json-path/JsonPath) Documentation

JSON PATH in kubectl

```bash
# develop a JSONPATH query and replace "HERE" between the braces
kubectl get no -o jsonpath='{HERE}'
# example JSON PATH for a pod json
echo '$.status.containerStatuses[?(@.name=="redis-container")].restartCount'
# $ is not mandatory, kubectl adds it
kubectl get no -o jsonpath='
{.items[*].metadata.name}
{.items[*].status.nodeInfo.architecture}
{.items[*].status.capacity.cpu}'
# can use \n and \t etc.
kubectl get no -o jsonpath='{.items[*].metadata.name}{"\n"}{.items[*].status.capacity.cpu}{"\n"}'
# with ranges for pretty output
kubectl get no -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.capacity.cpu}{"\n"}{end}'
# using custom columns
kubectl get no -o custom-columns=NAME:{.metadata.name},CPU:.status.capacity.cpu
# sorting
kubectl get no --sort-by=.status.capacity.cpu

# Mock Exam 3
kubectl get nodes -o jsonpath='{.items[*].status.addresses[?(@.type=="InternalIP")].address}'
```

My Homegrown Examples (before I understood JSON PATH)

```bash
# get the Pod CIDR
kubectl get nodes -o jsonpath='{.items[*].spec.podCIDR}'
# get images for the running pods
kubectl get po -o jsonpath="{.items[*].spec.containers[*].image}"
# get names & images for pods
kubectl get po -o=custom-columns=NAME:.metadata.name,IMAGE:.spec.containers[].image
```

## Monitoring

Not part of CKA but interesting.

* [Kubernetes Health Checks Using Probes](https://thenewstack.io/kubernetes-health-checks-using-probes/)

## Other Resources

Other exam resources that may be of use

* [CKAD-Bookmarks](https://github.com/reetasingh/CKAD-Bookmarks)

Also not part of CKA but these are interesting articles I found on t'Internet:

* [Kubernetes The Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way)
* [Network Service Mash](https://networkservicemesh.io/docs/concepts/architecture/)
* [clusterapi](https://cluster-api.sigs.k8s.io/)
  * [Quick Start](https://cluster-api.sigs.k8s.io/user/quick-start.html)
  * [Cluster API v1alpha3](https://kubernetes.io/blog/2020/04/21/cluster-api-v1alpha3-delivers-new-features-and-an-improved-user-experience/) original blog post
* [kubespray now supports kube-vip](https://github.com/kubernetes-sigs/kubespray/blob/master/docs/kube-vip.md)

These below are generated from a OneTab export with

<details><summary>ot2md()</summary>

```bash
ot2md() {
 # OneTab to Markdown converter
 # converts a range of lines from a OneTab export
 # into a bullet point Markdown format and puts them on the Mac clipboard
 # Usage: ot2md <start_string> <end_string>
 local f=export5
 sed -n "
  /${1?}/,/${2?}/{
   # remove whitespace from pipe separator
   s/ | /|/
   # title fixups
   s/ - Stack Overflow//
   s/ . Opensource.com//
   s/ . Appvia.io//
   s/ . Code-sparks//
   s/ . The New Stack//
   s/ - T&C DOC//
   s/ - General Discussions.*//
   s/ . GitHub//
   s/ . Kubernetes//
   s| . kubernetes/kubernetes||
   s| . flannel-io/flannel||
   s/ . by .* Medium//
   s/ . by .* ITNEXT//
   # special one-time fixups
   s/: .Open/: Open/g
   s/.best practice./\"best practice\"/g
   s/, bare metal load-balancer for Kubernetes//
   s|\. TL/DR . made . plugin to clean up your.||g
   # replace strange unicode delimiter chars with hyphens
   / [IiAa] /!s/ . / - /g
   p
  }
 " $f | \
 awk -F\| '
  {
   # remove trailing spaces from link title or you get markdown lint warnings
   sub(/ $/,"",$2)
   # title fixups
   sub(/kubernetes - /,"",$2)
   printf("* [%s](%s)\n",$2,$1)
  }
 ' | tee >(pbcopy)
}
```

</details>

* [Living with Kubernetes: Cluster Upgrades](https://thenewstack.io/living-with-kubernetes-cluster-upgrades/)
* [GitHub - cncf/curriculum: Open Source Curriculum for CNCF Certification Courses](https://github.com/cncf/curriculum)
* [Linux Foundation Certification Exams: Candidate Handbook](https://docs.linuxfoundation.org/tc-docs/certification/lf-candidate-handbook)
* [Important Instructions: CKA and CKAD](https://docs.linuxfoundation.org/tc-docs/certification/tips-cka-and-ckad)
* [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
* [Tutorial: Deploy Your First Kubernetes Cluster](https://www.appvia.io/blog/tutorial-deploy-kubernetes-cluster)
* [Kubernetes Tutorial - Step by Step Guide to Basic Kubernetes Concepts](https://auth0.com/blog/kubernetes-tutorial-step-by-step-introduction-to-basic-concepts/)
* [MetalLB configuration](https://metallb.universe.tf/configuration/)
* [MetalLB troubleshooting](https://metallb.universe.tf/configuration/troubleshooting/)
* [Load Balancer Services Always Show EXTERNAL-IP Pending](https://discuss.kubernetes.io/t/load-balancer-services-always-show-external-ip-pending/10009/2)
* [Kubernetes and MetalLB: LoadBalancer for On-Prem Deployments](https://starkandwayne.com/blog/k8s-and-metallb-a-loadbalancer-for-on-prem-deployments/)
* [Metallb LoadBalancer is stuck on pending](https://stackoverflow.com/questions/66124430/metallb-loadbalancer-is-stuck-on-pending)
* [external-ip status is pending - Issue #673 - metallb/metallb](https://github.com/metallb/metallb/issues/673)
* [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
* ["pkg/mod/k8s.io/client-go@v0.18.5/tools/cache/reflector.go:125: Failed to list *v1.Service: Unauthorized"](https://stackoverflow.com/questions/66329284/pkg-mod-k8s-io-client-gov0-18-5-tools-cache-reflector-go125-failed-to-list)
* [Troubleshooting - NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx/troubleshooting/)
* [The worst so-called "best practice" for Docker](https://pythonspeed.com/articles/security-updates-in-docker/)
* [Working with kubernetes configmaps, part 2: Watchers](https://itnext.io/working-with-kubernetes-configmaps-part-2-watchers-b6dd0e583d71)
* [Kubernetes at home - Bringing the pilot to dinner](https://darienmt.com/kubernetes/2019/03/31/kubernetes-at-home.html)
* [Dirty Kubeconfig? Clean it up!](https://medium.com/@ashleyschuett/dirty-kubeconfig-clean-it-up-65cc56c372a6)
* [kubeadm init](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-init/)
* [kube-dns ContainerCreating /run/flannel/subnet.env no such file - Issue #36575](https://github.com/kubernetes/kubernetes/issues/36575)
* [pod cidr not assgned - Issue #728](https://github.com/flannel-io/flannel/issues/728)
* [Kube-Flannel cant get CIDR although PodCIDR available on node](https://stackoverflow.com/questions/50833616/kube-flannel-cant-get-cidr-although-podcidr-available-on-node)
* [How do I access a private Docker registry with a self signed certificate using Kubernetes?](https://stackoverflow.com/questions/53545732/howIdoaiaaccess-a-private-docker-registry-with-a-self-signed-certificate-using-k)
* [Test your Kubernetes experiments with an open source web interface](https://opensource.com/article/21/6/chaos-mesh-kubernetes)

And more OneTab exports

* [Implementing Chaos Engineering in K8s: Chaos Mesh Principle Analysis and Control Plane Development](https://en.pingcap.com/blog/implementing-chaos-engineering-in-k8s-chaos-mesh-principle-analysis-and-control-plane-development/)
* [Siloscape: The Dark Side of Kubernetes - Container Journal](https://containerjournal-com.cdn.ampproject.org/v/s/containerjournal.com/features/siloscape-the-dark-side-of-kubernetes/amp/?amp_gsa=1&amp_js_v=a6&usqp=mq331AQIKAGwASCAAgM%3D#amp_tf=From+%251%24s&aoh=16341240802898&csi=0&ampshare=https%3A%2F%2Fcontainerjournal.com%2Feditorial-calendar%2Fbest-of-2021%2Fsiloscape-the-dark-side-of-kubernetes%2F)
* [Single Sign-On SSH With Zero Key Management](https://smallstep.com/sso-ssh/)
* [Easy Monitoring of Container Status - Log](https://boatswain.io/)
* [Kubernetes at home - Bringing the pilot to dinner](https://darienmt.com/kubernetes/2019/03/31/kubernetes-at-home.html)
* [Kubernetes Volumes Guide - Examples for NFS and Persistent Volume Book](https://matthewpalmer.net/kubernetes-app-developer/articles/kubernetes-volumes-example-nfs-persistent-volume.html)
* [Building Docker Images The Proper Way](https://itnext.io/building-docker-images-the-proper-way-3c9807524582)
* [matchbox/deployment.md at master - poseidon/matchbox](https://github.com/poseidon/matchbox/blob/master/docs/deployment.md)
* [Kubernetes Proceeding with Deprecation of Dockershim in Upcoming 1.24 Release](https://www.infoq.com/news/2022/01/kubernetes-dockershim-removal/)
* [Kubernetes Nodes - The Complete Guide](https://komodor.com/learn/kubernetes-nodes-complete-guide/)
* [Kubernetes ConfigMap Configuration and Reload Strategy](https://medium.com/swlh/kubernetes-configmap-confuguration-and-reload-strategy-9f8a286f3a44)
* [Restart pods when configmap updates in Kubernetes?](https://stackoverflow.com/questions/37317003/restart-pods-when-configmap-updates-in-kubernetes)
* [Chart Development Tips and Tricks](https://helm.sh/docs/howto/charts_tips_and_tricks/#automatically-roll-deployments)
* [kustomize/configGeneration.md at 12d1771bb349e1523bc546e314da63c684a7faf2 - kubernetes-sigs/kustomize](https://github.com/kubernetes-sigs/kustomize/blob/12d1771bb349e1523bc546e314da63c684a7faf2/examples/configGeneration.md#L5)
* [Facilitate ConfigMap rollouts - management - Issue #22368](https://github.com/kubernetes/kubernetes/issues/22368)
* [stakater/Reloader: controller to watch changes in ConfigMap and Secrets and do rolling upgrades on Pods with their associated Deployment, StatefulSet, DaemonSet and DeploymentConfig](https://github.com/stakater/Reloader)

### Weaknesses

* kubectl expose
* k run httpd --image=httpd:alpine --port=80 --expose
* manual schedulers
* taints & node affinity
  * affinity operators: In, Exists

### end

Not Kubernetes but I put these here for some reason:

[Another free CA as an alternative to Let's Encrypt (scotthelme.co.uk)](https://news.ycombinator.com/item?id=28244246) - SSL certs, might be useful for Ingress stuff.
