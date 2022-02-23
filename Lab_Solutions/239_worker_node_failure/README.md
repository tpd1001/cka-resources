# Application Failure

Q1 Solution

```bash
k get no
k describe no node01  # NotReady
ssh node01 "service kubelet status"|grep Active:  # dead
ssh node01 "service kubelet start"
```

Q2 Solution

```bash
k get no
k describe no node01  # NotReady
ssh node01 "top -bn1"
ssh node01 "df -h"|grep -v '/var/lib/docker'
ssh node01 "service kubelet status"|grep Active:  # activating
ssh node01 "journalctl -u kubelet"|grep unable    # cert
# journalctl -u kubelet -f
ssh node01 "grep -r WRONG /var/lib/kubelet/"
ssh node01 "sed -i 's/WRONG.*/ca.crt/' /var/lib/kubelet/config.yaml"
```

Q3 Solution

```bash
k get no
k describe no node01  # NotReady
ssh node01 "top -bn1"
ssh node01 "df -h"|grep -v '/var/lib/docker'
ssh node01 "service kubelet status"|grep Active:  # activating
ssh node01 "journalctl -u kubelet"|grep unable    # cert
# journalctl -u kubelet -f
ssh node01 "grep -r WRONG /var/lib/kubelet/"
ssh node01 "sed -i 's/WRONG.*/ca.crt/' /var/lib/kubelet/config.yaml"
```
