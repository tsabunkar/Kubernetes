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

# Kubeadm (Kube Admin Tool)

- With minikube you can only set-up -> Single Node Kubernetes Cluster but with Kubeadm tool we can set-up multiple node Cluster with -> Master and worker on separate machine
- Configuring Steps: [.assets/kubeadm-steps.png]
  1. Create muliple VM's (or System/Servers)
  2. Designate One VM(or server) as Master node and other VM's as Worker Node
  3. Install container run time(i.e- Docker) on all the host/nodes
  4. Install Kubeadm tool in all the Nodes (kubeadm -> Bootstrap K8)
  5. Initialize Master Server (all the required components are installed in Master Node)
  6. Inorder to communicate b/w all master, worker(s) nodes -> Spun-up the POD Network (or Cluster Network)
  7. Join Worker nodes with -> Master node

## Configuring Steps - Prequistes [Step-1,2]

- Create/Setup multiple VM (Configuring VM -> Before you begin)

  - Installing Kubeadm in local machine [REF- https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/]
    - Download iso image of linux distro which will act as -> One Master Node and Two Worker Nodes
    - debain-10 (Master Node) and centos-8, fed-server (Worker Nodes)
    - Make sure these VM instance have atleast -> 2 GB of RAM, 2 CPUs and Bridge Network
    - Login into VM
      - Check ssh service is running:
        - \$ ifconfig (inside servers- to know ip's)
        - debian-10 (Master Node): 192.168.0.107
        - centos-8 (Worker Node-1): 192.168.0.105 (It will be changing check ifconfig)
        - fed-server (Master Node-2): 192.168.0.106
        - \$ systemctl status ssh\* (debain) or service ssh status
      - From Host Machine- Use Putty to login with ipv4 address
        - \$ ssh -l root 192.168.0.107
        - \$ ssh -l root 192.168.0.105
        - \$ ssh -l root 192.168.0.108
        - (ERROR - WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!) [sol-> ssh-keygen -R "server hostname or ip" ==> \$ ssh-keygen -R 192.168.0.105 (Run in Host Machine)]
        - Check Hostname:
          - Master Node (Debian)
            - \$ cat /etc/hostname (o/p- debian)
            - \$ cat /etc/hosts (o/p - 2nd line debian)
            - (Change the hostname by editing these above files-> as desired) [Similarly do it for- fedora and centos servers which are worker nodes]
          - Master Node hostname -> debian
          - Worker Node-1 hostname -> dexter
          - Worker Node-2 hostname -> fedora.server
        - \$ shutdown (Shutdown all servers)
        - (
          If you launch the VMs now - There Ip Address will be changed bcoz- Bydefault ipAddress for these VM are dynamic i.e- Wifi-Router allocate dynamic or random ipAddr b/e a given range everytime this VM bootsup (Kubernetes communication wont work with Dynamic Ip Address) --> To solve this problem we need to assign static ip address [quite Risky], Alternate Solution-> Create Host Only Network, by disableing dynamic ipaddr (This network will act as medium for our nodes to interact b/w each other)
          )
          - File > Host Network Manager
          - (Select) Enable vboxnet0 Network
          - Select debain-10 > Settings > Network
            - Adapter 2
            - (select) Enable Network Adapter
            - Attached to: Host-only Adapter
          - (Repeat above step for centos and fedora)
        - Start All Nodes/VMs
        - \$ ifconfig (in terminal of all vms)
        - To Assgin Ip Address to Network Interface/Adapater =>
          - Sytnax: ifconfig <netwrok_adapter> <ip_addr>
          - \$ ifconfig enp0s8 192.168.99.10 (This ip can be random b/w 192.168.99.1/24 <== How do I know range, Check in- Host Network Manager) [NOTE: This is temporary way to assign IpAddr]
          - (Repeat above steps all vms)
          - Master Node = debian => 192.168.99.10
          - Worker Node-1 = centos => 192.168.99.11
          - Worker Node-2 = fedora => 192.168.99.12
          - (To assign Permanetly this IpAddress on every boot-up)
            - nano /etc/network/interfaces (Debian based)
              - Add line : [.assets/networks-debian.sh]
            - nano /etc/sysconfig/network-scripts/ifcfg-enp0s3 (Redhat based)
              - Add line : [.assets/networks-redhat.sh]
              - Ref-
                - https://www.serverlab.ca/tutorials/linux/administration-linux/how-to-configure-centos-7-network-settings/
                - https://www.cyberciti.biz/faq/howto-setting-rhel7-centos-7-static-ip-configuration/
                - https://linuxconfig.org/rhel-8-configure-static-ip-address
          - systemctl restart network (Restart Network Settings)
          - Reboot all vm's
          - Dsiable SWAP area
            - \$ swapoff -a
            - nano /etc/fstab (Debian & Redhat based)
              - (Comment line- which is about swap as extension)

---

## Configuring Steps - Install Docker & kubeadm, kubelet and kubectl Tools

3.  [Step-3] Installing Container Runtime -> Docker (If container runtime as docker is not found then kubernetes will consider - Container Runtime Interface)

- Installing runtime (To run containers in Pods, Kubernetes) (Ref- https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#installing-runtime)
  - Install Docker in All VM's Containers
  - ( Debain based) [Ref- https://docs.docker.com/engine/install/debian/]
    - \$ sudo apt-get update
    - \$ sudo apt-get install \
      apt-transport-https \
      ca-certificates \
      curl \
      gnupg-agent \
      software-properties-common
    - \$ curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
    - \$ sudo add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/debian \
      \$(lsb_release -cs) \
      stable"
    - \$ sudo apt-get update
    - (
      After adding above Repo to your PPA, If you do apt-get update -> Get Error will updating then
      - \$ nano /etc/apt/sources.list ( Comment line wrt to docker in file )
      - \$ sudo add-apt-repository \
         "deb [arch=amd64] https://download.docker.com/linux/debian \
         jessie \
         stable"
      - To know different version of docker go inside repo -> https://download.docker.com/linux/debian ==> you can find - buster, jessie, stretch
      - Ref - https://stackoverflow.com/questions/41133455/docker-repository-does-not-have-a-release-file-on-running-apt-get-update-on-ubun
        )
    - NOTE: (Don't install latest Docker Engine rather supported docker version engine ==> https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.9.md#external-dependencies )
    - (We need to install specific version of Docker Engine - 17.03.x)
    - \$ apt-cache madison docker-ce (You must able to see the list of docker version )
    - sudo apt-get install docker-ce=<VERSION_STRING> docker-ce-cli=<VERSION_STRING> containerd.io
    - \$ sudo apt-get install docker-ce=17.03.3~ce-0~debian-jessie
    - \$ docker version
    - \$ docker image ls
  - (Install in Centos-8)
    - (Ref- https://docs.docker.com/engine/install/centos/)
    - \$ sudo yum install -y yum-utils
    - \$ sudo yum-config-manager \
      --add-repo \
      https://download.docker.com/linux/centos/docker-ce.repo
    - (To install specific docker version)
      - \$ yum list docker-ce --showduplicates | sort -r (To See all list of docker version)
      - sudo yum install docker-ce-<VERSION_STRING> docker-ce-cli-<VERSION_STRING> containerd.io
      - \$ sudo yum install docker-ce-17.03.3.ce-1.el7
      - (
        If error occurs
        - \$ yum install -y https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm (Install CentOs-7 container.io essentials) [https://vexpose.blog/2020/04/02/installation-of-docker-fails-on-centos-8-with-error-package-containerd-io-1-2-10-3-2-el7-x86-64-is-excluded/]
        - \$ yum install docker-ce-selinux (or) yum install docker-ce
          )
      - \$ docker version
      - \$ docker image ls
      - (
        Remove docker from centos
        - \$ sudo yum remove docker \
           docker-common \
           container-selinux \
           docker-selinux \
           docker-engine
          )
  - (Install in Fedora-32)
    - \$ sudo dnf -y install dnf-plugins-core
    - \$ sudo dnf -y install dnf-plugins-core
    - $ sudo tee /etc/yum.repos.d/docker-ce.repo<<EOF
      [docker-ce-stable]
      name=Docker CE Stable - \$basearch
      baseurl=https://download.docker.com/linux/fedora/31/\$basearch/stable
      enabled=1
      gpgcheck=1
      gpgkey=https://download.docker.com/linux/fedora/gpg
      EOF
    - (Let me install not specific version of docker i.e- 17.0.3)
      - \$ sudo yum install docker-ce docker-ce-cli containerd.io
    - \$ docker version
    - \$ docker image ls

4. [Step-4] Installing kubeadm, kubelet and kubectl (Ref- https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#installing-kubeadm-kubelet-and-kubectl)

- (For Debain)
  - \$ sudo apt-get update && sudo apt-get install -y apt-transport-https curl
  - \$ curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
  - \$ cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
    deb https://apt.kubernetes.io/ kubernetes-xenial main
    EOF
  - \$ sudo apt-get update
  - \$ sudo apt-get install -y kubelet kubeadm kubectl
  - \$ sudo apt-mark hold kubelet kubeadm kubectl
- (For CentOs & Fedora)
  - $ cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
    [kubernetes]
    name=Kubernetes
    baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
    enabled=1
    gpgcheck=1
    repo_gpgcheck=1
    gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
    exclude=kubelet kubeadm kubectl
    EOF
  - \$ sudo setenforce 0
  - $ sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
  - \$ sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
  - \$ sudo systemctl enable --now kubelet

---

5. [Step-5] Intialize Cluster (Ref- https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#objectives)

- (Master Node) -> (All below commands to run in Debian/Master)
  - kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=<static_ip_addr>
  - \$ kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=192.168.99.10 [Static IpAddr for Master Node -> 192.168.99.10]
  - (Run the commands shown in console)
  - $ mkdir -p $HOME/.kube
  - $ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  - $ sudo chown $(id -u):$(id -g) $HOME/.kube/config
  - (Copy this below command for worker nodes to connect with master)
    - kubeadm join 192.168.99.10:6443 --token ftbf8q.giu7pwvel44gqy9s \
      --discovery-token-ca-cert-hash sha256:57b378be50a35f1d8a95ad400aa77438965470bf9013fbf008a70b438b4975f1

6. [Step-6] Installing a Pod network add-on and Setup Master node (All below commands to run in Debian/Master)

   - Installing Pod Network (Ref: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#pod-network)
     - (select) Calico
     - \$ kubectl apply -f https://docs.projectcalico.org/v3.14/manifests/calico.yaml
     - NOTE: (If Calico Pod network don't work then use -> Weave Net) [i.e- In Step.7 you still see Status as Not Ready]
     - $ kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
   - Verify Network
     - \$ kubectl get pods --all-namespaces
     - \$ kubectl get nodes (Check if the worker nodes are listed)

7. [Step-7] Join Worker nodes with -> Master node

- (To Connect all Worker Nodes to Master Node) [https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#join-nodes]
  - (Paste the kubeadm join command with token copied earlier in All WORKER NODES not in Master Node)
  - (Worker Nodes)
    - \$ kubeadm join 192.168.99.10:6443 --token ftbf8q.giu7pwvel44gqy9s \
      --discovery-token-ca-cert-hash sha256:57b378be50a35f1d8a95ad400aa77438965470bf9013fbf008a70b438b4975f1
- \$ kubectl get nodes (Check if the worker nodes are listed) <-- (Run in Master Node)
- (Make sure all nodes are in STATUS -> Ready state)
- (Master Node)
  - (Verify by running a pod in master)
    - \$ kubectl run nginx --image=nginx
    - \$ kubectl get pods
    - \$ kubectl delete deployment/nginx

---

Error : Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?

- Run docker service : \$ systemctl start docker

---

Error: network connection (To make sure 2nd network interface -> static ip address are assigned to VM's)

- \$ ifconfig
- \$ ifup enp0s8 192.168.99.12
- \$ ping www.google.com
- \$ systemctl status network\* (Check network daemon is running fine)
- \$ systemctl status network-online.target
- \$ systemctl restart network-online.target
- \$ ifup enp0s8 192.168.99.12
- (For Redhat)

  - \$ systemctl start NetworkManager
  - \$ systemctl enable NetworkManager
  - \$ nano /etc/sysconfig/network-scripts/ifcfg-enp0s3 (Before editing create .org) ==> [./networks-redhat.sh]

- (or)

- Tried all approach to make the ipAddr static in Redhat, but not working so-
  - \$ yum install network-scripts
  - \$ ifconfig enp0s8 192.168.99.11
  - \$ ifup enp0s8 192.168.99.11

---

Error - Worker Nodes are in STATUS -> NotReady state

- First, STEPS to exisiting delete Pod existing POD network - Calico
  - \$ kubeadm reset (Reset kubeadm itself)
  - \$ kubectl get pods --all-namespaces (to verifiy)
  - Steps to re-initalize kubeadm in master node
    - \$ kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=192.168.99.10
    - \$ mkdir -p \$HOME/.kube
    - $ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    - $ sudo chown $(id -u):$(id -g) $HOME/.kube/config
    - [Run this command in Worker Nodes] -> \$ kubeadm join 192.168.99.10:6443 --token 8lbhei.jn6pvxj0bisciryj \
      --discovery-token-ca-cert-hash sha256:59f0fa0c2080713fc31c8fee3d609b2bcea6a54778acb7ad82eadceba1d1aefa
    - \$ kubectl get pods --all-namespaces
    - \$ kubectl get nodes
    - \$ kubeadm token list (To know the token of Master node)
- (If Calico Pod network don't work then use -> Weave Net) [Run in Master Mode]
  - $ kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
  - (If want to reset wave pod network then) -> weave reset
- (Now add join the worker node with master node via new token)
  - \$ kubeadm reset
  - \$ systemctl stop kubelet
  - $ docker stop -f $(docker ps -aq)
  - $ docker rm -f $(docker ps -aq)
  - $ docker rmi -f $(docker images -q)
  - \$ rm -f /etc/kubernetes/kubelet.conf (This file -> kubelet.conf has details of client token)
  - \$ rm -rf ~/.kube
  - \$ systemctl start kubelet
  - \$ systemctl start docker
  - \$ docker image ls -a (Check no images or container present in worker node)
  - \$ docker container ls -a
  - \$ kubeadm join 192.168.99.10:6443 --token 8lbhei.jn6pvxj0bisciryj \
     --discovery-token-ca-cert-hash sha256:59f0fa0c2080713fc31c8fee3d609b2bcea6a54778acb7ad82eadceba1d1aefa

* Ref:

- https://stackoverflow.com/questions/53040663/kubectl-get-nodes-shows-notready
- https://stackoverflow.com/questions/56493883/how-to-join-worker-node-in-existing-cluster
- https://computingforgeeks.com/join-new-kubernetes-worker-node-to-existing-cluster/
- https://www.serverlab.ca/tutorials/containers/kubernetes/how-to-add-workers-to-kubernetes-clusters/

---

- Cleaning Worker Node
  - \$ kubeadm reset
  - \$ systemctl stop kubelet
  - \$ systemctl stop docker
  - \$ rm -rf /var/lib/cni/
  - \$ rm -rf /var/lib/kubelet/\*
  - \$ rm -rf /etc/cni/
  - \$ rm -f /etc/kubernetes/kubelet.conf
  - \$ rm -rf ~/.kube
  - \$ systemctl start docker
  - \$ systemctl enable docker
  - \$ yum remove kubeadm kubectl kubelet kubernetes-cni kube\*
  - \$ yum autoremove
- Reinstall Kube-related tools back in Worker Node [Step-4]
  - \$ sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
  - \$ sudo systemctl enable --now kubelet

---

# Using Play with k8 environment

- https://labs.play-with-k8s.com/
- Steps
  1.  Initializes cluster master node:
  - $ kubeadm init --apiserver-advertise-address $(hostname -i) --pod-network-cidr 10.5.0.0/16
  2.  Initialize cluster networking:
  - \$ kubectl apply -f https://raw.githubusercontent.com/cloudnativelabs/kube-router/master/daemonset/kubeadm-kuberouter.yaml
  3. (Optional) Create an nginx deployment:
  - \$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/website/master/content/en/examples/application/nginx-app.yaml

---

# Setps to Setup Worker Node in Ubunut Server - Assume Third (3rd) Worker Node

- VirtualBox > Right Click on Ubunut Instance > Settings
- Adapter-1
  - Attached to: Bridge Adapter
  - Name: wlp3sO
  - Promiscuous Mode: Allow All
  - Ok
- Adapter-2
  - Attached to: Host-only Adapter
  - Name: vboxnet0
  - Ok
- System > Processor > 2
- Login into ubuntu VM (Rick VM)
- \$ ifconfig (note down the ipAddr to login from Host Machine SSH)
- \$ systemctl status ssh\* (Check if SSH daemon is running)
- \$ ssh -l rick 192.168.0.111
- \$ cat /etc/hostname (Change hostname)
- \$ cat /etc/hosts
- \$ ifconfig (Check if you can see the host-only network adapter)
- \$ ifconfig enp0s8 192.168.99.13
- \$ nano /etc/network/interfaces (edit file as -> [.assets/networks-debian.sh])
