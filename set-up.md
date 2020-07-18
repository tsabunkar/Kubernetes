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

## Configuring Steps

1. Create/Setup multiple VM

   - Installing Kubeadm in local machine [REF- https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/]
     - Download iso image of linux distro which will act as -> One Master Node and Two Worker Nodes
     - debain-10 (Master Node) and centos-8, fed-server (Worker Nodes)
     - Make sure these VM instance have atleast -> 2 GB of RAM, 2 CPUs and Bridge Network
     - Login into VM
       - Check ssh service is running:
         - \$ ifconfig (inside servers- to know ip's)
         - debian-10 (Master Node): 192.168.0.107
         - centos-8 (Worker Node-1): 192.168.0.105
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
           - systemctl restart network (Restart Network Settings)
           - Reboot all vm's
           - Dsiable SWAP area
             - \$ swapoff -a
             - nano /etc/fstab (Debian based)
               - (Comment line- which is about swap as extension)

2. Setup Kubernetes using kubeadm
   2. Designate One VM(or server) as Master node and other VM's as Worker Node
