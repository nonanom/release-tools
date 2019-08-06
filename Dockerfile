FROM centos:latest
RUN yum update -y
RUN yum install -y epel-release python-pip python-devel libffi-devel openssl-devel gcc sudo which
RUN pip install --upgrade pip
RUN pip install ansible
RUN systemctl enable sshd
ENTRYPOINT ["ansible-playbook"]
