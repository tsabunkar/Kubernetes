# Objectives

- Kubernetes
- Containers - Docker
- Container Orchestration?
- Setup Kubernetes
- k8 Concepts - PODs | ReplicaSets | Deployment | services
- Networking in kubernetes
- Kubernetes Management - Kubectl
- Kubernetes Definition Files - YAML
- Kubernetes on Cloud - AWS/GCP

# Kubernetes or K8s

- k8 -> Build by Google
- Google's Container Orchestration tools
- Open Source
- k8 --> Containers + Orchestration

## Containers

- Why do we need containers ?
  - Remeber about - Matrix from Hell !! (Each OS - Installing different s/w(redis,node) requires different configuration/setup which leads to ==> Compatibility/Dependency, Long setup time, Different dev/val/prod env makes it much complex, works in my system) <== Thus development, building and shipping take more time and not-smooth
- To solve this Matrix from Hell issue --> Birth of Docker
- Docker runs each component (s/w- Nodejs server, redis, mongodb) in its own Container
- Think Containers are separate environment for your component/images
- These Containers has its own libraries & Dependencies
- Thus we can quickly start running this image (without had to worry abt configur) just by running the docker image provided by DevOps team
- Thus Docker --> Containerize Application (Provides each appln/image its own environment)
- What are containers ?
  - Containers are completely isolated Environments
  - Containers has its own Processes, Network, Mounts
  - Think Containers are like- VM except they share same OS-Kernel
- If your base/host OS Kernel is (Ubuntu)Linux then you can run container application of os like- fedora, suse, redhat (linux flavour) BUT YOU CANNOT RUN WINDOWS/MAC Conatiner Application on Linux based OS Kernel
- Docker is not meant to virtualize and run different Operating System (as done by VM) but main purpose of docker is to containerize the application (like- nodejs. redis, etc) and ship & run them
- H/w Infrastructure >> OS Kernel >> DOCKER >> {(lib + dependency) => Application} => Container
- VM : Heaver is Size (iso images in GB) thus use hig disk-space, take lot of RAM uses lot of resources, and Take more time to boot-up
  Containers: lower disk-space, less ram is utilized, fast boot-up
- Most popular containerizing techonlogy - docker
- Public Docker Registry --> Docker Hub (Where you can containerized ur custome application as images)
- Docker Hosts <-- (Think like VM HOST but for docker, Base Machine where docker was installed upon ur OS Kernel)
- When you run the docker image -> `docker run ansible` (This will run the Instance of Ansible application on your docker host)
- Docker images are run as instance is called containers
- Container v/s images
  - Image is a package template (Think image as Class)
  - When you run a particular image --> it create instance of this image/application is called containers (Think Container as Instance of a class)
  - Containers are instance of a image which are isolated, each containers has its own environment,processes,network,mount

## Container Orchestration

- How to run Docker host and all its container in Prod environment, how to scale-up or down different docker host based on traffic, Connect b/w docker Hosts, Managing containers etc --done_by--> Container Orchestration
- Automatically deploying, Managing containers based on traffic, etc is know as Container Orchestration technology
- Kubernetes is Container Orchestration Technology ( Other technologies are - Docker Swarm, MESOS )
- Kubernetes is now avaliable in all Cloud Providers like- GCP, Amazon, Azure
- Advantages
  - Your application is highly avaliable, as h/w failure do not bring your application down- As there are multiple instance running of our application
  - User traffic is load balance b/w various containers - i.e container orchestration can quickly scale-up and down as per traffic
- Thus Kubernetes is Container Orchestration Technology which help to deploy and Manage containers in an clustered environment.

---

# Kubernetes Architecture

- Nodes
  - is machine physical or virtual on which kubernetes is installed
  - A Node is a worker machine(woker node) on which containers(instance) of your application would be launched [Think a Node as Docker Host]
  - Nodes ---Called---> Minions
  - [.assets/nodes.png]
- Cluster
  - A cluster is a set of nodes group together
  - Even if one node fails, our application is accessible from other nodes
  - Multiple nodes also help in sharing load
  - [.assets/cluster.png]
- Master
  - Master is responsible for managing the cluster
  - Other responsibility of Master node is - information of member of cluster stored, monitoring of all worker nodes, if a node fail then need to move the workload from fail node to another worker node
  - Master is another node in which kubernetes installed in it (Configured it as Master Node).
  - Master node is responsible for actual orchestration on worker nodes
  - [.assets/master-slave-nodes.png]
- K8 comes with following components:
  - API Server (Act as frontend for Kubernetes Cluster )
  - etcd service (distributed key value storage)
  - kubelet service (Agent)
  - Container Runtime (use to run container -> docker)
  - Controller (think- brain of k8)
  - Scheduler (distributing the work/containers across the nodes)

---

# Master v/s Worker Nodes

- How can we distribute the kubernetes components among different servers (Consider you have different physical servers running fedora), How can we make one server Master Node and other Server Wokrer Nodes
- Worker Nodes or Minions <---where--- containers are hosted
  - In order to run docker containers we require - Container Runtime Engine (ex- Docker, Rkt, CRI-O)
  - Worker nodes has - kubelet agent
- Master Node has -> kube-apiserver (which make this server as Master node)
  - Master component has etcd, controller, scheduler
- [.assets/master-worker-nodes.png]

---

# Kubectl

- Kubernetes CLI - kube control tool (kubectl)
- Used to deploy and Manage application on kubernetes cluster- to get cluster information, get status of other nodes, etc
- To deploy an application on cluster
  - \$ kubectl run hello-min
- To view cluster information
  - \$ kubectl cluster-info
- To list all nodes information
  - \$ kubectl get nodes
- Using kubectl we can run thousand instance of same application with single command.
  - \$ kubectl run --replicas=1000 my-web-server
- We can confifure Kubernetes such that it can automatically handle traffic load and scale-up or down the instance depending on traffic, do load balancing, etc
  - \$ kubectl scale --replicas=2000 my-web-server
- with rolling-update command it can also upgrade these thousands of instances.
  - \$ kubectl rolling-update my-web-server --image=web-server:2
  - \$ kubectl rolling-update my-web-server --rollback (Rollback updates)
  - Kubernetes provides different advance network providers, storage, security, Authentication & Authorization [.assets/k8.png]

---

## Relationship b/w docker and Kubernetes:

- k8 uses Docker Host inorder to host docker containers.
- K8 also provides alternative of docker -> Rocket
