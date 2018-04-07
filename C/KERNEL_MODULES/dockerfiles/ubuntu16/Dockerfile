FROM ubuntu:16.04

RUN apt-get update && apt-get upgrade -y
RUN apt-get install build-essential -y
RUN mkdir -p /lib/modules/`uname -r`/
RUN ln -s /usr/src/linux-headers-`uname -r`/ /lib/modules/`uname -r`/build
RUN mkdir -p /lib/modules/`uname -r`/
#RUN /usr/src/linux-headers-`uname -r`/ /lib/modules/`uname -r`-generic/build
# 特定バージョンのKernelでコンパイルする場合
#RUN apt-get install linux-headers -y
#RUN apt-get install linux-source -y
#WORKDIR /usr/src/
#RUN tar jxfv linux-source*.bz2
