FROM centos:7

RUN yum groupinstall "Development Tools" -y
RUN yum install kernel kernel-devel kernel-headers -y
RUN mkdir -p /lib/modules/`uname -r`/
RUN ln -s /usr/src/kernels/`uname -r`/ /lib/modules/`uname -r`/build
