FROM centos:latest
RUN yum update -y
RUN yum install -y epel-release
RUN yum install -y python2-pip
RUN yum install -y sudo which
RUN yum install -y libffi-devel openssl-devel gcc
RUN pip2 install --upgrade pip
RUN pip2 install ansible
