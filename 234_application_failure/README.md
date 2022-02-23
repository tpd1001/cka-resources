# Application Failure

Q1 Solution

```bash
k get ns
kubectl config set-context --current --namespace=alpha
k get deploy,svc,po
k get svc web-service -o yaml|less
k describe $(kubectl get po -l name=webapp-mysql -o name)
k logs $(kubectl get po -l name=webapp-mysql -o name)
k describe svc mysql
k get svc mysql -o yaml > mysql.yaml
k get svc mysql -o yaml > mysql-service.yaml
vim mysql-service.yaml
# change name to "mysql-service"
k delete svc mysql
k apply -f mysql-service.yaml
```

Q2 Solution

```bash
k get ns
kubectl config set-context --current --namespace=beta
k get deploy,svc,po
k get svc web-service -o yaml|less
k describe $(kubectl get po -l name=webapp-mysql -o name)
k logs $(kubectl get po -l name=webapp-mysql -o name)
k describe svc mysql
k edit svc mysql-service  # change port 8080 => 3306
```

Q3 Solution

```bash
k get ns
kubectl config set-context --current --namespace=gamma
k get deploy,svc,po
k get svc web-service -o yaml|less
k describe $(kubectl get po -l name=webapp-mysql -o name)
k logs $(kubectl get po -l name=webapp-mysql -o name)
k describe
k describe svc mysql|grep -i selector
k describe po mysql |grep -i label
k edit svc mysql-service  # change port 8080 => 3306
```

Q4 Solution

```bash
k get ns
kubectl config set-context --current --namespace=delta
k get deploy,svc,po
k get svc web-service -o yaml|less
k describe $(kubectl get po -l name=webapp-mysql -o name)|grep DB_
k logs $(kubectl get po -l name=webapp-mysql -o name)
k describe svc mysql|grep -i selector
k describe po mysql |grep -i label
k edit svc mysql-service  # change username to root
```

Q5 Solution

```bash
k get ns
kubectl config set-context --current --namespace=epsilon
k get deploy,svc,po
k get svc web-service -o yaml|less
k describe $(kubectl get po -l name=webapp-mysql -o name)
k logs $(kubectl get po -l name=webapp-mysql -o name)
k get po mysql -o yaml > db.yaml
vim db.yaml  # correct MYSQL_ROOT_PASSWORD to paswrd
k delete po mysql
k apply -f db.yaml
k describe svc mysql|grep -i selector
k describe po mysql |grep -i label
k describe svc mysql-service|grep -i port
k describe po mysql |grep -i port
k get $(kubectl get po -l name=webapp-mysql -o name) -o yaml > deploy.yaml
k describe $(kubectl get po -l name=webapp-mysql -o name)|grep DB_
k edit deploy webapp-mysql  # correct DB_User to root
```

Q6 Solution

```bash
k get ns
kubectl config set-context --current --namespace=zeta
k get deploy,svc,po
# page does not load, suggests service fault
k get svc web-service -o yaml > web-service.yaml
k edit svc web-service  # set nodePort to 30081
# now access denied, suggests user/pass issue
k edit deploy webapp-mysql  # correct DB_User to root
k get po mysql -o yaml > db.yaml
vim db.yaml  # correct MYSQL_ROOT_PASSWORD to paswrd
k delete po mysql
k apply -f db.yaml
```

 k get ns
eval "$(curl https://raw.githubusercontent.com/tpd1001/cka-resources/main/lab-setup.sh)"
curl -O https://raw.githubusercontent.com/tpd1001/cka-resources/main/lab-setup.sh
 cat lab-setup.sh
source <(kubectl completion bash|sed '/ *complete .*kubectl$/{;h;s/kubectl$/k/p;g;}')
 type k
 k get ns
 cat .kube/config
kubectl config set-context --current --namespace=alpha
 k get po
 k get svc
 k get deploy
k get deployments.apps webapp-mysql -o yaml > d
 k get svc mysql -o yaml mysql.svc
k get svc mysql -o yaml > mysql.svc
k get svc web-service  -o yaml > web.svc
k get svc web-service  -o yaml > web.svc
 ls
 export HISTCONTROL=ignoreboth
k get po
k get po webapp-mysql-75dfdf859f-s47s8 -o yaml|less
k describe svc web-service
k describe po webapp-mysql-75dfdf859f-s47s8
k logs webapp-mysql-75dfdf859f-s47s8
k logs webapp-mysql-75dfdf859f-s47s8 -f
k logs webapp-mysql-75dfdf859f-s47s8 -f --previous
k get svc
k describe svc web-service
k describe po webapp-mysql-75dfdf859f-s47s8
k describe svc mysql
cp mysql.svc m
v m
kubectl get po -l name=webapp-mysql -o name
k describe $(kubectl get po -l name=webapp-mysql -o name)
k logs $(kubectl get po -l name=webapp-mysql -o name)
kubectl config set-context --current --namespace=beta
k describe $(kubectl get po -l name=webapp-mysql -o name)
k get svc web-service  -o yaml > web.svc
k get svc mysql-service  -o yaml > mysql-service.yaml
k get deployments.apps webapp-mysql -o yaml > deployment.yaml
k get deploy,svc,po
k get po mysql -o yaml > mysql.yaml
cp mysql.yaml db
k logs $(kubectl get po -l name=webapp-mysql -o name)
k logs $(kubectl get po -l name=webapp-mysql -o name) -f
k describe svc mysql-service
k get deploy webapp-mysql -o yaml > dep
k get $(kubectl get po -l name=webapp-mysql -o name) -o yaml > p
k describe svc web-service
k describe svc mysql-service
k edit svc mysql-service
k get ns
kubectl config set-context --current --namespace=gamma
k get deploy,svc,po
k describe $(kubectl get po -l name=webapp-mysql -o name)
k describe svc web-service
k describe $(kubectl get po -l name=webapp-mysql -o name)
k logs $(kubectl get po -l name=webapp-mysql -o name) -f
k describe svc mysql-service
k get po mysql -o yaml|less
k get svc mysql-service  -o yaml > mysql-service.yaml
k edit svc mysql-service
k describe svc mysql|grep -i selector
k describe po mysql |grep -i label
k get ns
kubectl config set-context --current --namespace=delta
k get deploy,svc,po
k get $(kubectl get po -l name=webapp-mysql -o name) -o yaml > p
k logs $(kubectl get po -l name=webapp-mysql -o name) -f
k desribe $(kubectl get po -l name=webapp-mysql -o name)
k describe $(kubectl get po -l name=webapp-mysql -o name)
k edit deploy webapp-mysql
k get deploy,svc,po
kubectl config set-context --current --namespace=epsilon
k get deploy,svc,po
history|cut -c8-
