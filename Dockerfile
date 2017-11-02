FROM ubuntu
MAINTAINER jeder@redhat.com

LABEL RUN docker run -it --privileged -v /sys/bus/pci/devices:/sys/bus/pci/devices -v /sys/kernel/mm/hugepages:/sys/kernel/mm/hugepages -v /sys/devices/system/node:/sys/devices/system/node -v /dev:/dev --name NAME -e NAME=NAME -e IMAGE=IMAGE IMAGE"

# Setup yum repos, or use subscription-manager

# Install DPDK support packages.
RUN apt update
RUN apt install -y hugepages libpcap-dev curl build-essential
RUN apt install -y linux-headers-$(uname -r)
RUN apt install -y libnuma-dev
#RUN apt build-dep linux-image-$(uname -r)

# Build DPDK and pktgen-dpdk for x86_64-native-linuxapp-gcc.
WORKDIR /root
COPY ./build_dpdk.sh /root/build_dpdk.sh
COPY ./dpdk-profile.sh /etc/profile.d/
RUN /root/build_dpdk.sh

# Defaults to a bash shell, you could put your DPDK-based application here.
CMD ["/usr/bin/bash"]
