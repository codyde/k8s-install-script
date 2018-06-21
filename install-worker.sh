export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/root/bin

swapoff -a

#Manually remove swap files from /etc/fstab at this point 

yum install iptables-services.x86_64 -y
systemctl stop firewalld.service
systemctl disable firewalld.service
systemctl mask firewalld.service
systemctl start iptables
systemctl enable iptables
systemctl unmask iptables
iptables -F
service iptables save

yum install -y yum-utils

yum install -y docker
systemctl enable docker && systemctl start docker

sysctl net.bridge.bridge-nf-call-iptables=1

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

setenforce 0 

sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/sysconfig/selinux && cat /etc/sysconfig/selinux

## Reboot to ensure SED is disabled completed 

yum install -y kubelet kubeadm kubectl
systemctl enable kubelet && systemctl start kubelet