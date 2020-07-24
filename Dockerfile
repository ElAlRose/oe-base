# This Dockefile generate a image for the elbe buildsystem
#
# tested with elbe-v0.5.5-13-gad384e9

# baseimage is ubuntu precise (LTS)
FROM ubuntu:bionic

# Maintainer
MAINTAINER Silvio F. <silvio@port1024.net>

# set debian/ubuntu config environment to noninteractive
ENV DEBIAN_FRONTEND noninteractive

# setup the initsystem
RUN dpkg-divert --local --rename --add /sbin/initctl && ln -sf /bin/true /sbin/initctl

# change some location settings
RUN ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime

# update and upgrade
RUN apt-get update -y && apt-get upgrade -y

# development base installation
RUN apt-get install -y git build-essential openssh-server vim supervisor \
		       gawk wget diffstat unzip texinfo chrpath libsdl1.2-dev \
		       xterm python2.7 cpio flex bison gettext dialog autoconf \
		       libxml-parser-perl lzop bc file python-git \
		       dnsmasq dnsutils sudo \
		       aptitude tig mercurial-git \
		       gcc-multilib g++-multilib libc6-dev dpkg locales \
		       libdbus-glib-1-dev rsync git-lfs socat

# clean up
RUN apt-get clean

# additions
ADD adds/supervisord.conf /etc/supervisord.conf

# create oe user
RUN groupadd -g 1000 oe
RUN useradd -d /oe-home -g oe -m -s /bin/bash -u 1000 oe
RUN echo "root:foo" | chpasswd
RUN echo "oe:foo" | chpasswd

# sudo for oe
RUN echo "%oe  ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/oegrp
RUN chmod 0440 /etc/sudoers.d/oegrp

# some filesystem bugfixes
RUN grep -vF -e rootfs -e devpts /proc/mounts > /etc/mtab ; true

# some dns thingies
RUN echo "addn-hosts=/etc/althosts" >> /etc/dnsmasq.conf
RUN echo "user=root" >> /etc/dnsmasq.conf

# secure back channel
RUN cd /oe-home ; \
    git clone https://github.com/turicas/sbc.git ;\
    cp sbc/sbc /usr/local/bin ;\
    mkdir .sbc ;\
    cp -a sbc/plugins .sbc
ADD adds/sbc-notify.sh /usr/local/bin/sbc-notify.sh
RUN chmod a+x /usr/local/bin/sbc-notify.sh

# correction for filesystems
RUN ln -sf /bin/bash /bin/sh

# repo tool
ADD http://commondatastorage.googleapis.com/git-repo-downloads/repo /usr/local/bin/repo
RUN chmod a+rx /usr/local/bin/repo

# ssh and startup configuration
RUN mkdir -v /var/run/sshd
CMD ["/usr/sbin/sshd", "-D"]
EXPOSE 22
