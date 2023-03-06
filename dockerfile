FROM centos:7

RUN yum -y install curl xz rpm-build
RUN curl -L -o /tmp/centos7-minimal.rpm http://mirror.centos.org/centos/7.9.2009/os/x86_64/Packages/centos-release-7-9.2009.1.el7.centos.x86_64.rpm
