# AWS Exam POC - Harness + ArgoCD Deployment

## 🚀 Quick Start

### 1. Local Test
```bash
cd poc-deployment
docker build -t aws-exam-poc .
docker run -p 8080:80 -e APP_SECRET=supersecret123!@# aws-exam-poc
# Visit http://localhost:8080
```

### 2. Push to Docker Hub
```bash
docker tag aws-exam-poc yourusername/aws-exam-poc:latest
docker push yourusername/aws-exam-poc:latest
```

### 3. Harness Setup
**Secrets (Project > Secrets):**
- `poc-app-secret` (Text): `supersecret123!@#`
- `docker-registry-creds` (Docker Connector)

**Pipeline:**
```
Approval → 
Build (Dockerfile) → 
Deploy to ArgoCD (Helm chart)
```

### 4. ArgoCD Setup
```bash
# Update values.yaml image.repository = yourusername/aws-exam-poc
helm install aws-exam-poc ./helm/aws-exam-poc -n argocd --create-namespace -f values.yaml
# or ArgoCD App: git repo + path: poc-deployment/helm/aws-exam-poc
```

### 5. Verify Secrets
```bash
kubectl get secrets -n argocd poc-app-secret -o yaml
kubectl exec deploy/aws-exam-poc-argocd -- env | grep APP_SECRET
```

## 📋 Files Created
- **Static Webpage**: `poc-deployment/*.html|css|js` (Vanilla HTML/JS/CSS)
- **Docker**: Optimized NGINX multi-stage 
- **Helm Chart**: Full-featured with secrets injection
- **Secrets**: Harness ref → K8s Secret → Pod env var APP_SECRET

POC demonstrates end-to-end: Local → Docker Hub → Harness Pipeline → ArgoCD → K8s with secrets mgmt.

**Secret Flow**: Harness Secret → External Secret → K8s Secret `poc-app-secret` → Deployment env `APP_SECRET` → JS reads `process.env.APP_SECRET` → UI masked display/hash
