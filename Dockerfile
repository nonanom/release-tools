FROM centos:latest
RUN yum update -y
RUN yum install -y epel-release
RUN yum install -y python-pip
RUN yum install -y sudo which
RUN yum install -y python-devel libffi-devel openssl-devel gcc
RUN pip install --upgrade pip
RUN pip install ansible
RUN systemctl enable sshd
ENTRYPOINT ["ansible-playbook"]
