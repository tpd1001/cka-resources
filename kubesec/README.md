kubectl run -oyaml --dry-run=client nginx --image=nginx > nginx.yaml
docker run -i kubesec/kubesec scan - < nginx.yaml
