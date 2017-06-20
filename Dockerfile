FROM ubuntu:14.04
MAINTAINER johnsonyue version: 0.01

ENV DEBIAN_FRONTEND noninteractive
ENV USER root
ENV HOMEDIR=/home/kernel
RUN mkdir -p $HOMEDIR
WORKDIR $HOMEDIR

#replace default apt source & install necessary packages.
RUN sed -i 's/archive.ubuntu.com/debian.ustc.edu.cn/g' /etc/apt/sources.list
#gnome desktop & tightvncserver
RUN apt-get update && \
    apt-get install -y --no-install-recommends ubuntu-desktop && \
    apt-get install -y gnome-panel gnome-settings-daemon metacity nautilus gnome-terminal && \
    apt-get install -y tightvncserver && \
    mkdir /root/.vnc
#common env.
RUN apt-get install -y vim wget build-essential libx11-dev libxrandr-dev

#vnc
ADD xstartup vimrc molokai.vim ./
COPY xstartup /root/.vnc/xstartup
#Vim.
ENV TERM=xterm-256color
RUN mkdir -p /root/.vim/colors/
COPY vimrc /root/.vim/
COPY molokai.vim /root/.vim/colors
#bochs.
RUN wget https://downloads.sourceforge.net/project/bochs/bochs/2.6.9/bochs-2.6.9.tar.gz && \
    tar zxvf bochs-2.6.9.tar.gz && cd bochs-2.6.9 && \ 
    ./configure --enable-debugger --enable-disasm LDFLAGS='-pthread' && \
    make && make install
#code.
ADD code.tar.gz ./
RUN tar zxvf code.tar.gz

WORKDIR $HOMEDIR
#use default entrypoint: /bin/sh -c
CMD ["/bin/bash"]
