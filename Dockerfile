FROM centos:7

# Install systemd -- See https://hub.docker.com/_/centos/
RUN yum -y update; yum clean all; \
(cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

# Install dependencies
RUN yum makecache \
 && yum -y install epel-release initscripts \
 && yum -y update \
 && yum -y install \
      sudo \
      which \
      jq \
      unzip \
      hostname \
      python3 \
      python3-pip \
      libffi-devel \
      openssl-devel \
      gcc \
      sshpass \
      openssh-server \
 && yum clean all

# HashiCorp Vault
RUN curl --silent --junk-session-cookies --location --insecure --remote-name https://releases.hashicorp.com/vault/1.2.3/vault_1.2.3_linux_amd64.zip
RUN unzip -qq vault_1.2.3_linux_amd64.zip && rm vault_1.2.3_linux_amd64.zip && chmod +x vault && mv vault /usr/local/bin/vault

# Upgrade pip3
RUN pip3 install --upgrade pip

# Install Ansible using pip3
RUN pip3 install ansible

# Install Helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && chmod 700 get_helm.sh && ./get_helm.sh

# Install additional dependencies
RUN pip3 install ansible[azure] \
    azure-cli \
    boto \
    apache-libcloud \
    pyrax \
    cs
    
# Upgrade azure-cli
RUN pip3 install --upgrade azure-cli

# Install kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl && sudo mv ./kubectl /usr/local/bin/kubectl

# Disable requiretty
RUN sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/'  /etc/sudoers
