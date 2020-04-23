#docker installation instructions
sudo apt install docker.io -y
sudo systemctl enable docker
sudo cat <<EOF >/etc/docker/daemon.json
{
"exec-opts":["native.cgroupdriver=cgroupfs"]                                                                             
}
EOF
sudo systemctl restart docker
sudo usermod -aG docker $USER
#helm installation instructions
sudo curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
sudo chmod 700 get_helm.sh
sudo ./get_helm.sh
#kubeadm kubelet kubectl installation instructions
sudo cat <<EOF > /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system

#ipvs module
mkdir -p /etc/sysconfig/modules/
sudo cat > /etc/sysconfig/modules/ipvs.modules <<EOF
#!/bin/bash
modprobe -- ip_vs
modprobe -- ip_vs_rr
modprobe -- ip_vs_wrr
modprobe -- ip_vs_sh
modprobe -- nf_conntrack_ipv4
EOF
sudo chmod 755 /etc/sysconfig/modules/ipvs.modules 
sudo bash /etc/sysconfig/modules/ipvs.modules 
sudo lsmod | grep -e ip_vs -e nf_conntrack_ipv4
lsmod | grep -e ipvs -e nf_conntrack_ipv4
cut -f1 -d " "  /proc/modules | grep -e ip_vs -e nf_conntrack_ipv4

#ipvs installation
sudo apt install ipset ipvsadm -y

#kubernetes installation
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
sudo systemctl enable kubelet

sudo swapoff -a
