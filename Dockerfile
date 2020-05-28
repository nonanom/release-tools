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
RUN yum makecache
RUN yum -y install epel-release initscripts
RUN yum -y update
RUN yum -y install \
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
      wget \
      sshpass \
      openssh-server
RUN yum clean all

# HashiCorp Vault
RUN curl --silent --junk-session-cookies --location --insecure --remote-name https://releases.hashicorp.com/vault/1.2.3/vault_1.2.3_linux_amd64.zip
RUN unzip -qq vault_1.2.3_linux_amd64.zip && rm vault_1.2.3_linux_amd64.zip && chmod +x vault && mv vault /usr/local/bin/vault

# Upgrade pip3
RUN pip3 install --upgrade pip

# Install Ansible using pip3
RUN pip3 install ansible

# Install additional dependencies
RUN pip3 install ansible[azure] \
    azure-cli \
    boto \
    apache-libcloud \
    pyrax \
    cs

# Install Helm
RUN wget https://get.helm.sh/helm-v3.2.1-linux-amd64.tar.gz && \
    tar -zxvf helm-v3.0.0-linux-amd64.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/helm

# Upgrade azure-cli
RUN pip3 install --upgrade azure-cli

# Install kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl && sudo mv ./kubectl /usr/local/bin/kubectl

# Disable requiretty
RUN sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/'  /etc/sudoers
