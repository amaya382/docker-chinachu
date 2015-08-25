FROM phusion/baseimage:latest
CMD ["/sbin/my_init"]

MAINTAINER amaya <mail@sapphire.in.net>

WORKDIR /root/

RUN echo "Asia/Tokyo" > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata

RUN apt-get update
RUN apt-get install -y software-properties-common wget pkg-config build-essential curl git-core libssl-dev yasm libtool autoconf libboost-all-dev libpcsclite-dev

# Card reader client
RUN apt-get install -y pcsc-tools

# ARIB
RUN git clone git://github.com/stz2012/libarib25.git
RUN cd libarib25 && make -j4 && make install

# recpt1
RUN git clone git://github.com/stz2012/recpt1.git
RUN cd recpt1/recpt1 && ./autogen.sh && ./configure --enable-b25 && make -j4 && make install

# chinachu
RUN useradd -m chinachu
RUN su chinachu -c "cd /home/chinachu/ && \
git clone git://github.com/kanreisa/Chinachu.git chinachu && \
cd chinachu && \
echo 1 | ./chinachu installer && \
mkdir recorded"

# chinachu-operator daemon
RUN mkdir -p /etc/service/chinachu-operator
RUN echo "#!/bin/sh\n\
echo \"\" > /var/run/chinachu-operator.pid\n\
chown chinachu:chinachu /var/run/chinachu-operator.pid\n\
exec /sbin/setuser chinachu sh -c \"echo \\\$\\\$ > /var/run/chinachu-operator.pid && exec /home/chinachu/chinachu/chinachu service operator execute\"" > /etc/service/chinachu-operator/run
RUN chmod +x /etc/service/chinachu-operator/run

# chinachu-wui daemon
RUN mkdir -p /etc/service/chinachu-wui
RUN echo "#!/bin/sh\n\
echo \"\" > /var/run/chinachu-wui.pid\n\
chown chinachu:chinachu /var/run/chinachu-wui.pid\n\
exec /sbin/setuser chinachu sh -c \"echo \\\$\\\$ > /var/run/chinachu-wui.pid && exec /home/chinachu/chinachu/chinachu service wui execute\"" > /etc/service/chinachu-wui/run
RUN chmod +x /etc/service/chinachu-wui/run

# copy existing config/data
COPY chinachu /home/chinachu/chinachu/
RUN chown chinachu:chinachu -R /home/chinachu/chinachu/

RUN apt-get clean && rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*
EXPOSE 10772