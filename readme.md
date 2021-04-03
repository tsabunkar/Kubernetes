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

- Most popular containerizing techonlogy - docker
- Docker images are run as instance is called containers

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
