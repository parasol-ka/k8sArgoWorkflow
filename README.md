# Simple CI/CD school project: GitHub Actions → Docker Hub → Argo CD → Kubernetes

This repo uses a minimal GitOps workflow:

1) **GitHub Actions** builds a Docker image on every push  
2) The image is **pushed to Docker Hub** with a unique tag (**the commit SHA**)  
3) The workflow updates the Kubernetes manifest to reference that new image tag  
4) **Argo CD** detects the manifest change in Git and deploys automatically to your local Kubernetes cluster


---

## 1) Docker Hub

- Create a Docker Hub repository (example: `docker.io/<your-user>/flask-app`)
- Create a Docker Hub **Access Token**

---

## 2) GitHub Secrets

In GitHub: **Settings → Secrets and variables → Actions**

Add:
- `DOCKERHUB_USERNAME`
- `DOCKERHUB_TOKEN`

---

## 3) Kubernetes / Argo CD (one-time setup)

### Install Argo CD
```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

### Create the target namespace for the app
```bash
kubectl create namespace flask-app
```

### Open Argo CD UI
```bash
kubectl -n argocd port-forward svc/argocd-server 8080:443
```
Open `https://localhost:8080`

Get the admin password (PowerShell):
```powershell
$pw_b64 = kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}"
[Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($pw_b64))
```

### Create an Argo CD Application (GUI)
In Argo CD:
- **New App**
- **Repo URL**: your GitHub repo
- **Revision**: `main`
- **Path**: `k8s`
- **Destination namespace**: `flask-app`
- **Sync policy**: **Automated** 

---

## 4) GitHub Actions workflow 

On every push to `main`:
- builds the Docker image
- pushes it to Docker Hub as:  
  `docker.io/<your-user>/flask-app:<commit-sha>`
- updates the manifest in `k8s/` to use that new SHA tag
- commits and pushes the manifest update back to `main`

Argo CD sees the new commit and deploys it.

---

## Using it

1) Make a change to the app (even just a color/text change)
2) Commit and push to `main`
3) Watch GitHub Actions run
4) After a short delay, Argo CD deploys automatically

If you exposed the app as NodePort `30080`, you can access it at:
- `http://localhost:30080`

---

## Note about delays

On a local cluster, Argo CD usually checks Git every few minutes.  
You can also press **Refresh** in the Argo CD UI to make it check immediately.
