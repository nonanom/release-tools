FROM centos:latest

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
      hostname \
      python3 \
      python3-pip \
      libffi-devel \
      openssl-devel \
      gcc \
      sshpass \
      openssh-server \
 && yum clean all

# Upgrade pip3
RUN pip3 install --upgrade pip

# Install Ansible using pip3
RUN pip3 install ansible

# Install additional dependencies
RUN pip install ansible[azure] \
    boto \
    apache-libcloud \
    pyrax \
    cs

# Disable requiretty
RUN sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/'  /etc/sudoers
