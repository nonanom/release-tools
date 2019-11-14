FROM centos:latest
RUN yum update -y
RUN yum install -y epel-release
RUN yum install -y sudo which
RUN yum install -y libffi-devel openssl-devel gcc
RUN yum install -y python3-pip
RUN pip3 install --upgrade pip
RUN pip3 install ansible
