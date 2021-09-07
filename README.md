# kubernetes-kubeadm-vagrant-virtualbox

Easy to configure Kubernetes cluster.

![kubernetes made with kubeadm](images/k8s.jpg)

This is a Kubernetes cluster that you can configure to your liking to test the latest features available.

## Why another Kubernetes cluster?

Let's think about the following questions for a second:

* *How fast can you test new versions of Kubernetes?*

    After a new version of Kubernetes is announced, it is very common to have to wait for the platforms to have the new version available. If you are restless and curious, you are going to want to have a repository like this one to access the new features and test them.

* *What elements can I configure of a cluster?*

    On platforms, the configuration framework is quite closed. If you want to customize the behavior of the control plane, you will need to do so elsewhere. With this repository you will be able to modify everything you need: networks, webhooks, cri or any other element thanks to the Kubeadm configuration files.

## The default cluster

If you start the cluster with the default configurations you will get the following:

* 1 node control-plane, 2 VCPU 2GB RAM
* 2 nodes workers, 1 VCPU 1GB RAM
* [Calico](https://www.projectcalico.org) for network communications and policies

## Installation

### Previous requirements

* Have installed [VirtualBox](https://www.virtualbox.org/wiki/Downloads)  `>= 6.1.26`
* Have installed [Vagrant](https://www.vagrantup.com/downloads.html) `>= 2.2.18`

### Up and running

Clone the repository and access the downloaded folder.

```bash
{
    git clone git@github.com:mmorejon/kubernetes-kubeadm-vagrant-virtualbox.git
    cd kubernetes-kubeadm-vagrant-virtualbox
}
```

Start the cluster creation using the following Vagrant command:

```bash
vagrant up
```

> The construction of the cluster takes approximately 5 minutes. The time may vary depending on the network speed.

## Access the cluster

Use the following command to access control-plane. This node is configured with the tools you need to work with Kubernetes (eg `kubectl`,` config` file).

```bash
vagrant ssh master
```

Check cluster status

```bash
kubectl get nodes

NAME     STATUS   ROLES                  AGE     VERSION
master   Ready    control-plane,master   7m20s   v1.22.1
node1    Ready    <none>                 4m38s   v1.22.1
node2    Ready    <none>                 2m13s   v1.22.1
```

The cloned repository is synchronized within the master node. In this way you can include files to deploy services or include configurations.

```bash
# repository parameters
REPO_PATH = "/home/vagrant/k8s"
```

## Cluster customization

### Resources

You can adapt the nodes resources through the variables established in the `Vagrantfile` file.

```bash
# master node parameters
MASTER_CPU = "2"
MASTER_RAM = "2048"
# node parameters
NODE_COUNT = 2
NODE_CPU = "1"
NODE_RAM = "1024"
```

### Kubernetes version

The Kubernetes version can be changed through `Vagrantfile` file.

```bash
# kubernetes parameters
KUBERNETES_VERSION = "1.22.1"
```

### Kubeadm settings

The `cluster` folder contains the configuration used by Kubeadm to create the cluster. Modify the files to your liking and re-create the cluster for its implementation.

```yaml
# snippet from the default-master.yaml file
apiVersion: kubeadm.k8s.io/v1beta2
kind: ClusterConfiguration
clusterName: kubernetes
kubernetesVersion: ${KUBERNETES_VERSION}
apiServer:
  timeoutForControlPlane: 4m0s
certificatesDir: /etc/kubernetes/pki
networking:
  podSubnet: 10.244.0.0/16
```

## Contributions

All suggestions, recommendations are welcome!
