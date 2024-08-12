#!/bin/bash

IP=$(ip a | grep eth0 | grep inet | awk '{print $2}' | cut -d / -f 1)
#Here we create a kubeadm config rather than providing individual flags to the kubeadm init command. It is done this way because we need to add 2 kubelet settings which are needed for communication with the containerd CRI and for installing the metrics-server.
cat > kubeadm-config.yaml << EOF
# kubeadm-config.yaml
kind: ClusterConfiguration
apiVersion: kubeadm.k8s.io/v1beta3
kubernetesVersion: v1.30.2
networking:
  serviceSubnet: "10.96.0.0/16"
  podSubnet: "10.244.0.0/16"
  dnsDomain: "cluster.local"
controlPlaneEndpoint: "${IP}:6443"
---
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
cgroupDriver: systemd
serverTLSBootstrap: true
EOF

kubeadm init --config kubeadm-config.yaml

mkdir /home/ubuntu/.kube
cp /etc/kubernetes/admin.conf /home/ubuntu/.kube/config
chown ubuntu:ubuntu /home/ubuntu/.kube/config
chmod 600 /home/ubuntu/.kube/config

mkdir /root/.kube
cp /etc/kubernetes/admin.conf /root/.kube/config
chmod 600 /root/.kube/config

kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.3/manifests/tigera-operator.yaml

for s in $(seq 60 -10 10)
do
    echo "Waiting $s seconds for calico deployment pods to be running"
    sleep 10
done

kubectl apply -f /root/calico/calico.yaml