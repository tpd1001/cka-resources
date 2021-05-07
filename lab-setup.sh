source <(kubectl completion bash|sed '/ *complete .*kubectl$/{;h;s/kubectl$/k/p;g;}')
k() { kubectl $@; }
v() { vim -c ":set shiftwidth=2 tabstop=2 softtabstop=-1 expandtab" ${1?} && kubectl apply -f $1; }
