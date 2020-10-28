add the apache deployment

```bash
kubectl apply -f apache-deployment.yaml
```

check it

```bash
kubectl get deployments
kubectl get replicasets
kubectl get pods
```

add the service

```bash
kubectl apply -f apache-service.yaml
```

check it

```bash
kubectl get service
```

add the ingress

```bash
kubectl apply -f apache-ingress.yaml
```

check it

```bash
kubectl get ingress
```

(hmm .. the ingress never shows an IP. Need to debug)