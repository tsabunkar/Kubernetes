# Setup Kubernetes

- Kubernetes set-up in permise : Minikube, Kubeadm
- Set-up in Cloud environment: GCP, AWS, Google

---

# Minikube

- Master Node consist of :- kube-apiserver, etcd, node-controller, replicas-controller
- Worker Node consist of :- kubelet, container-runtime
- [.assets/mini-kube-1.png]
- Minikube bundles all the various master and worker node components into single a image, providing us pre-configured single kubernetes cluster <-- This bunlde as avaliable as .iso image [.assets/mini-kube-2.png]
- Prequiste for Minikube set-up -> Hypervisor like VMWare or VirtualBox or in linux- Kernel Virtual Machine (KVM)
- Steps to install Minikube: [REF- https://kubernetes.io/docs/tasks/tools/install-minikube/]
  - Check Virtualization is enabled in local machine -
    - In VirtualBox if you see 64bit of OS then Virtualization is enabled (or)
    - grep -E --color 'vmx|svm' /proc/cpuinfo (You should see cmx output)
  - Install Kubectl [REF- https://kubernetes.io/docs/tasks/tools/install-kubectl/]
    - \$ cd /home/tejas/tejas/other-apps
    - \$ mkdir k8
    - \$ curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
    - \$ ll
    - \$ chmod +x ./kubectl
    - \$ ll
    - \$ sudo mv ./kubectl /usr/local/bin/kubectl (moving to -> /usr/local/bin)
    - \$ kubectl version --client
    - Enabling shell autocompletion :
      - \$ type \_init_completion (To check if bash completion exist in machine)
      - \$ apt-get install bash-completion
      - \$ echo 'source <(kubectl completion bash)' >>~/.bashrc
      - \$ sudo -i (login as root)
      - \$ kubectl completion bash >/etc/bash_completion.d/kubectl
  - Install a Hypervisor
    - (I already installed VirtualBox)
  - Install Minikube via direct download
    - \$ cd /home/tejas/tejas/other-apps/k8
    - \$ curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
      && chmod +x minikube
    - \$ sudo mkdir -p /usr/local/bin/ (-p, --parents ==> no error if existing)
    - \$ sudo install minikube /usr/local/bin/
    - \$ cd /usr/local/bin/
    - \$ ll
  - Confirm Installation
    - SYTNTAX: minikube start --driver=<driver_name>
    - \$ minikube start --driver=virtualbox (Since we are using VirtualBox, so see compelete list of drivers avaliable -> https://kubernetes.io/docs/setup/learning-environment/minikube/#specifying-the-vm-driver)
    - \$ minikube status
    - \$ minikube stop (To Stop Minikube)
    - (If you get Error -> machine does not exist) --then--> \$ minikube delete (delete minikube)
  - Let us Run First pod [REF- https://kubernetes.io/docs/setup/learning-environment/minikube/#quickstart]
    - \$ minikube status
    - \$ kubectl create deployment hello-minikube --image=k8s.gcr.io/echoserver:1.10
    - \$ kubectl get pod
    - \$ kubectl expose deployment hello-minikube --type=NodePort --port=8080
    - \$ kubectl get pod
    - \$ minikube service hello-minikube --url (Visit in browser)
    - \$ kubectl delete services hello-minikube (Delete this service)
    - \$ kubectl delete deployment hello-minikube
    - \$ minikube stop

---
