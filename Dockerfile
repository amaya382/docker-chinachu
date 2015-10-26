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
RUN git clone git://github.com/kanreisa/Chinachu.git chinachu && \
cd chinachu && \
sed -i -e "s/git clone --branch=master \$LIBVPX_GIT \"\$USR_DIR\/src\/libvpx\"/git clone --branch=v1.4.0 \$LIBVPX_GIT \"\$USR_DIR\/src\/libvpx\"/" chinachu && \
echo 1 | ./chinachu installer && \
mkdir data recorded

# chinachu data
RUN ln -s /root/chinachu-data/config.json /root/chinachu/config.json && \
ln -s /root/chinachu-data/rules.json /root/chinachu/rules.json && \
ln -s /root/chinachu-data/data/recorded.json /root/chinachu/data/recorded.json && \
ln -s /root/chinachu-data/data/recording.json /root/chinachu/data/recording.json && \
ln -s /root/chinachu-data/data/reserves.json /root/chinachu/data/reserves.json && \
ln -s /root/chinachu-data/data/schedule.json /root/chinachu/data/schedule.json

# chinachu-operator daemon
RUN mkdir -p /etc/service/chinachu-operator
RUN echo "#!/bin/sh\n\
echo \$\$ > /var/run/chinachu-operator.pid\n\
exec /root/chinachu/chinachu service operator execute" > /etc/service/chinachu-operator/run
RUN chmod +x /etc/service/chinachu-operator/run

# chinachu-wui daemon
RUN mkdir -p /etc/service/chinachu-wui
RUN echo "#!/bin/sh\n\
echo \$\$ > /var/run/chinachu-wui.pid\n\
exec /root/chinachu/chinachu service wui execute" > /etc/service/chinachu-wui/run
RUN chmod +x /etc/service/chinachu-wui/run

RUN apt-get clean && rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*
EXPOSE 10772