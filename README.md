# kubernetes-kubeadm-vagrant-virtualbox

Easy to configure Kubernetes cluster.

![kubernetes made with kubeadm](images/k8s.jpg)

This is a Kubernetes cluster that you can configure to your liking to test the latest features available.

## Why another Kubernetes cluster?

Let's think about the following questions for a second:

* *How fast can you test new versions of Kubernetes?*

    After a new version of Kubernetes is announced, it is very common to have to wait for the platforms to have the new version available. If you are restless and curious, you are going to want to have a repository like this one to access the new features and test them.

* *What elements can be configured in a cluster?*

    On platforms, the configuration framework is quite closed. If you want to customize the behavior of the control plane, you will need to do so elsewhere. With this repository you will be able to modify everything you need: networks, webhooks, cri or any other element thanks to the Kubeadm configuration files.

## The default cluster

If you start the cluster with the default configurations you will get the following:

* 1 node control-plane, 2 VCPU 2GB RAM
* 2 nodes workers, 1 VCPU 1GB RAM
* [Calico](https://www.projectcalico.org) for network communications and policies
* (Optional) Nginx controller [v1.0.0](https://github.com/kubernetes/ingress-nginx/releases/tag/controller-v1.0.0)
* (Optional) Metrics server [v0.3.7](https://github.com/kubernetes-sigs/metrics-server/releases/tag/v0.3.7)

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

### Installing nginx

Access the master node.

```bash
vagrant ssh master
```

Deploy the service.

```bash
k apply -f k8s/ingress/nginx/
```

<details>
  <summary>Result</summary>

  ```
  namespace/ingress-nginx created
  serviceaccount/ingress-nginx created
  configmap/ingress-nginx-controller created
  clusterrole.rbac.authorization.k8s.io/ingress-nginx created
  clusterrolebinding.rbac.authorization.k8s.io/ingress-nginx created
  role.rbac.authorization.k8s.io/ingress-nginx created
  rolebinding.rbac.authorization.k8s.io/ingress-nginx created
  service/ingress-nginx-controller-admission created
  service/ingress-nginx-controller created
  deployment.apps/ingress-nginx-controller created
  ingressclass.networking.k8s.io/nginx created
  validatingwebhookconfiguration.admissionregistration.k8s.io/ingress-nginx-admission created
  serviceaccount/ingress-nginx-admission created
  clusterrole.rbac.authorization.k8s.io/ingress-nginx-admission created
  clusterrolebinding.rbac.authorization.k8s.io/ingress-nginx-admission created
  role.rbac.authorization.k8s.io/ingress-nginx-admission created
  rolebinding.rbac.authorization.k8s.io/ingress-nginx-admission created
  job.batch/ingress-nginx-admission-create created
  job.batch/ingress-nginx-admission-patch created
  service/ingress-nginx-controller configured
  ```
</details>

Acceda al IP del nodo master a través del [navegador](http://192.168.100.10/) o utilizando la consola.

```bash
curl 192.168.100.10

<html>
<head><title>404 Not Found</title></head>
<body>
<center><h1>404 Not Found</h1></center>
<hr><center>nginx</center>
</body>
</html>
```

### Installing metrics-server

Access the master node.

```bash
vagrant ssh master
```

Deploy the service.

```bash
k apply -f k8s/metrics-server/
```

<details>
  <summary>Result</summary>

  ```
  clusterrole.rbac.authorization.k8s.io/system:aggregated-metrics-reader created
  clusterrolebinding.rbac.authorization.k8s.io/metrics-server:system:auth-delegator created
  rolebinding.rbac.authorization.k8s.io/metrics-server-auth-reader created
  apiservice.apiregistration.k8s.io/v1beta1.metrics.k8s.io created
  serviceaccount/metrics-server created
  deployment.apps/metrics-server created
  service/metrics-server created
  clusterrole.rbac.authorization.k8s.io/system:metrics-server created
  clusterrolebinding.rbac.authorization.k8s.io/system:metrics-server created
  ```
</details>

## Contributions

All suggestions, recommendations are welcome!
