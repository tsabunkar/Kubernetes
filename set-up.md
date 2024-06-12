# Setup Kubernetes

- Kubernetes set-up in permise : Minikube, Kubeadm
- Set-up in Cloud environment: GCP, AWS, Google
- Play with k8 (https://labs.play-with-k8s.com/) <== Playground for K8, Similiar playground as we have for docker(https://labs.play-with-docker.com/)

---

# 3 Ways of Setup

- In-Premise: [Minikube](./set-up/in-permise.md)

---

# Blindly follow Steps to install kubernetes (kubectl & minikube) using Home Brew

- Refer
  - [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/)
  - [minikube](https://minikube.sigs.k8s.io/docs/start/?arch=%2Fmacos%2Fx86-64%2Fstable%2Fhomebrew)
- brew install kubectl
- kubectl version --client
- brew install minikube
- minikube start
- kubectl get po -A
- minikube kubectl -- get po -A
- minikube dashboard

### Deploy a hello world application

- kubectl create deployment kubernetes-bootcamp --image=gcr.io/google-samples/kubernetes-bootcamp:v1
- kubectl get deployments
- View the app
  - curl http://localhost:8001/version
  - curl http://localhost:8001/api/v1/namespaces/default/pods/$POD_NAME:8080/proxy/
-
