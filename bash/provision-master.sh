#!/usr/bin/env bash

# initialize kubernetes cluster
envsubst < ${REPO_PATH}/cluster/default-master.yaml > ${REPO_PATH}/cluster/master.yaml
kubeadm init --config ${REPO_PATH}/cluster/master.yaml
rm ${REPO_PATH}/cluster/master.yaml

# setup kubeconfig file for root user
mkdir -p $HOME/.kube
sudo cp -Rf /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# copy kubeconfig file into vagrant user environment
mkdir /home/vagrant/.kube
sudo cp -Rf /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown -R vagrant:vagrant /home/vagrant/.kube

# install calico
kubectl apply -f ${REPO_PATH}/calico/

# enable completion commands
echo "source <(kubectl completion bash)" >> /home/vagrant/.bashrc
echo "alias k=kubectl" >> /home/vagrant/.bashrc
echo "complete -F __start_kubectl k" >> /home/vagrant/.bashrc

# remove RANDFILE configuration for openssl to avoid a warning message
# https://github.com/openssl/openssl/issues/7754
sed -i "s/RANDFILE\s*=\s*\$ENV::HOME\/\.rnd/#/" /etc/ssl/openssl.cnf
