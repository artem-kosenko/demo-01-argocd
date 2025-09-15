# demo-01-argocd

Ready to run on Mac.

- Kind (Kubernetes in Docker)


## How To

1. START (setup) kubernetes
    ```
    ./scripts/setup-k8s-colima.sh
    ```

2. START (setup) ArgoCD

   ```
   ./scripts/setup-argocd.sh
   ```

3. Deploy ArgoCD bootstrap-app

   ```
   kubectl apply -f bootstrap/bootstrap-app.yaml -n argocd
   ```

3. Access ArgoCD UI
   
   Run in separate console for port forwarding
   ```
   kubectl port-forward svc/argocd-server -n argocd 8080:443
   ```
   https://127.0.0.1:8080

   username in `admin`, password can be found in outputs of `./setup-argocd.sh` script.

4. Access Grafana UI

   Run in separate console for port forwarding
   ```
   kubectl port-forward svc/kube-prometheus-stack-grafana -n monitoring 8081:80
   ```
   https://127.0.0.1:8081

   username: `admin`
   password: `admin`

4. STOP kubernetes
   ```
   ./scripts/stop-k8s-colima.sh
   ```

