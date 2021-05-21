# USAGE: eval "$(curl https://raw.githubusercontent.com/tpd1001/cka-resources/main/lab-setup.sh)"
# ALTERNATE USAGE: source /dev/stdin <<< "$(curl https://raw.githubusercontent.com/tpd1001/cka-resources/main/lab-setup.sh)"
source <(kubectl completion bash|sed '/ *complete .*kubectl$/{;h;s/kubectl$/k/p;g;}')
k() { kubectl $@; }
v() { vim -c ":set shiftwidth=2 tabstop=2 softtabstop=-1 expandtab" ${1?} && kubectl apply -f $1; }
