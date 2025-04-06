#!/usr/bin/sh

echo ""
echo ""
echo "🏰 Welcome to KubeCrown - Kubernetes Master Node Installer"
echo "__________________________________________________________"
echo ""
echo "This script will gracefully prepare your system and install:"
echo ""
echo "   • Containerd            (Container Runtime)"
echo "   • Etcd                  (Distributed Key-Value Store)"
echo "   • API Server            (Kubernetes Control Plane)"
echo "   • Controller Manager    (Cluster Controller Logic)"
echo "   • Scheduler             (Pod Scheduling Engine)"
echo ""
echo "Please ensure you are running this script on a clean, Linux Ubuntu host."
echo "Root privileges are required."
echo ""
sleep 1
echo ""
echo "Would you like to continue?"
echo ""
read action

case $action in

   Yes|YES|Y|y|yes)
      echo ""
      echo "Starting installation"
      ;;
   No|NO|N|n|no|nO)
      echo ""
      echo "Exiting KubeCrown"
      ;;
   *)
      echo ""
      echo "Unkown option"
      ;;
esac

echo ""
echo "Let the crown be placed — setting up your Kubernetes master node..."
echo ""
sleep 1

cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

sudo modprobe
sudo modprobe br_netfilter

echo "Setting up required sysctl params"
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward                = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sudo sysctl --system
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | \
  gpg --dearmor | sudo tee /etc/apt/keyrings/kubernetes-apt-keyring.gpg > /dev/null

echo "Installing containerd"
sudo apt install containerd

sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
sudo systemctl restart containerd

echo 'Adding K8S repo'
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] \
https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /" | \
sudo tee /etc/apt/sources.list.d/kubernetes.list > /dev/null

echo "Installing Kubelet, Kubectl and Kubeadm"
apt update -y
sudo apt-mark unhold kubelet kubeadm kubectl
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl



