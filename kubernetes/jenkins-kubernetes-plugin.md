# HowTo for the jenkins kubernetes plugin

This doesn't run the jenkins-master on kubernetes but it provisions jenkins-agents for it

## Get the kubernetes service going

on the primary machine:

```
sudo swapoff -a
sudo kubeadm reset
sudo kubeadm init
<follow the steps to copy the admin.conf>
## pod network
kubectl apply -f https://docs.projectcalico.org/v3.14/manifests/calico.yaml
## dashboard
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml
## make dashboard accessible
kubectl proxy --address='0.0.0.0' --accept-hosts='.*'
```

Join the kuberenetes agents as described in the `kubeadm init` output. Make sure
swap is off and the config file is in `$HOME/.kube/config` with correct permissions.

### Create dashboard user

Do a `kubectl apply -f ..` of the following file

```
piVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
```

and again for
```
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
```

Log into the dashboard with the admin credentials that can be obtained from
```
kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secrets | grep admin-user | awk '{print $1}')
```

### Create jenkins namespace and user

One more `kubectl apply -f ..` for

```
apiVersion: v1
kind: ServiceAccount
metadata:
  name: jenkins
  namespace: jenkins
---
kind: Role
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: jenkins
  namespace: jenkins
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["create","delete","get","list","patch","update","watch"]
- apiGroups: [""]
  resources: ["pods/exec"]
  verbs: ["create","delete","get","list","patch","update","watch"]
- apiGroups: [""]
  resources: ["pods/log"]
  verbs: ["get","list","watch"]
- apiGroups: [""]
  resources: ["secrets"]
  verbs: ["get"]
- apiGroups: [""]
  resources: ["services"]
  verbs: ["create","delete","get","update"]
- apiGroups: ["apps"]
  resources: ["deployments"]
  verbs: ["create","delete","get","update"]  
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: RoleBinding
metadata:
  name: jenkins
  namespace: jenkins
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: jenkins
subjects:
- kind: ServiceAccount
  name: jenkins
```

## Jenkins

### start a Jenkins master

```
docker run -p 8080:8080 -p 50000:50000 jenkins/jenkins:lts
```
go through the setup steps via the webinterface and install the `kubernetes` plugin afterwads and execute the
jenkins restart.

### configure kubernetes plugin

Points to check:
 - in the security setting the TCP inbound port matches the setting for the docker (i.e. port 50000)
 - one TCP inbound protocol is selected
 - create a Jenkins credential of the type `secret Text` and add the jenkins user token to it `kubectl -n jenkins describe secret $(kubectl -n jenkins get secrets | grep jenkins- | awk '{print $1}')`

Go to `<jenkins-url>/configureCloud` and add a new `Kubernetes` entry.
In my case I made the following settings:

 - Name: `kubernetes`
 - Kubernetes URL: `https://bashir:6443` (my kubernetes master)
 - Disable https certificate check: `true`
 - Credentials: `jenkins-kube` (the text-secret from above)
 - Jenkins URL:` http://sisko:8080` (my jenkins master)

Try a the `Test Connection` Button. You should something like `Connected to Kubernetes 1.18`

Further to `Pod Templates` -> `Add Pod Template`:

 - Name: `jenkins-agent`
 - Namespace: `jenkins` (we created that above)
 - Labels: `jenkins-agent`

`Add Container`:

 - Name: `jenkins-agent`
 - Docker image: `jenkins/inbound-agent`
 - Command to run: clear that entry, should be empty
 - Arguments to pass to the command: `-url http://sisko:8080 ${computer.jnlpmac} ${computer.name}`
 - Host Network: `true`

`Save`

You should now be able to create jobs that can run on the label `jenkins-agent`.