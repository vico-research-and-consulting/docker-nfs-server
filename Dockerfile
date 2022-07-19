FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -qq && apt-get install -y nfs-kernel-server runit inotify-tools unzip -qq
RUN mkdir -p /exports

COPY setups/nfs-common /etc/default/nfs-common
COPY setups/nfs-kernel-server /etc/default/nfs-kernel-server
COPY setups/quota /etc/default/quota
COPY setups/nfs-static-ports.conf /etc/sysctl.d/nfs-static-ports.conf
COPY setups/nfs-static-ports.conf /etc/sysctl.conf
COPY setups/nfs /etc/sysconfig/nfs

RUN mkdir -p /etc/sv/nfs
ADD nfs.init /etc/sv/nfs/run
ADD nfs.stop /etc/sv/nfs/finish

ADD nfs_setup.sh /usr/local/bin/nfs_setup

RUN echo "rpc.nfsd 2049/tcp" >> /etc/services && \
    echo "rpc.nfsd 2049/udp" >> /etc/services && \
    echo "nfs 111/tcp" >> /etc/services && \
    echo "nfs 111/udp" >> /etc/services && \
    echo "rpc.statd-bc 32765/tcp" >> /etc/services && \
    echo "rpc.statd-bc 32765/udp" >> /etc/services && \
    echo "rpc.statd 32766/tcp" >> /etc/services && \
    echo "rpc.statd 32766/udp" >> /etc/services && \
    echo "rpc.mountd 32767/tcp" >> /etc/services && \
    echo "rpc.mountd 32767/udp" >> /etc/services && \
    echo "rcp.lockd 32768/tcp" >> /etc/services && \
    echo "rcp.lockd 32768/udp" >> /etc/services && \
    echo "rpc.quotad 32769/tcp" >> /etc/services && \
    echo "rpc.quotad 32769/udp" >> /etc/services && \
    mkdir -p /etc/modprobe.d/ && \
    echo 'options lockd nlm_udpport=32768 nlm_tcpport=32768' >> /etc/modprobe.d/local.conf

VOLUME /exports

EXPOSE 111/tcp 111/udp 2049/tcp 2049/udp 32765-32769/tcp 32765-32769/udp

ENTRYPOINT ["/usr/local/bin/nfs_setup"]
