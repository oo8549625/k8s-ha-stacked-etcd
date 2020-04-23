#kubenetes
sudo kubeadm init --config kubeadm.yaml  --upload-certs -v=7
mkdir -p $HOME/.kube
sudo cp -f /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

#gitlab-runner
sudo chmod 666 /etc/kubernetes/admin.conf

#CNI
#Fannel
# sudo sysctl net.bridge.bridge-nf-call-iptables=1
# kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
#Calico
curl https://docs.projectcalico.org/v3.10/manifests/calico.yaml -O
sed -i -e "s?192.168.0.0/16?10.244.0.0/16?g" calico.yaml
kubectl apply -f calico.yaml

#let master node work
#kubernetes出于安全考量默認情况下無法在master節點上部署pod, 以下指令允许master節點部署pod
kubectl taint nodes --all node-role.kubernetes.io/master-

#helm repo update
helm repo add stable https://kubernetes-charts.storage.googleapis.com
helm repo update

# admin clusterrole
kubectl create clusterrolebinding default-admin --clusterrole cluster-admin --serviceaccount=default:default

#user ownership for kubectl
sudo chown -R $USER $HOME/.kube
