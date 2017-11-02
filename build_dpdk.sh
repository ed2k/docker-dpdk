#!/bin/bash

################################################################################
#
#  build_dpdk.sh
#
#             - Build DPDK and pktgen-dpdk for 
#
#  Usage:     Adjust variables below before running, if necessary.
#
#  MAINTAINER:  jeder@redhat.com
#
#
################################################################################

################################################################################
#  Define Global Variables and Functions
################################################################################

URL=http://fast.dpdk.org/rel/dpdk-17.08.tar.xz
BASEDIR=/root
VERSION=17.08
PACKAGE=dpdk
DPDKROOT=$BASEDIR/$PACKAGE-$VERSION
CONFIG=x86_64-native-linuxapp-gcc


# Download/Build DPDK
cd $BASEDIR
curl $URL | tar xJ
cd $DPDKROOT
make config T=$CONFIG
sed -ri 's,(PMD_PCAP=).*,\1y,' build/.config
make config T=$CONFIG install

# Download/Build pktgen-dpdk
URL=http://dpdk.org/browse/apps/pktgen-dpdk/snapshot/pktgen-3.4.2.tar.xz
BASEDIR=/root
VERSION=3.4.2
PACKAGE=pktgen
PKTGENROOT=$BASEDIR/$PACKAGE-$VERSION
cd $BASEDIR
curl $URL | tar xJ

# Silence compiler info message
sed -i '/Wwrite-strings$/ s/$/ -Wno-unused-but-set-variable/' $DPDKROOT/mk/toolchain/gcc/rte.vars.mk
cd $PKTGENROOT
RTE_SDK=$DPDKROOT make
ln -s $PKTGENROOT/app/app/$CONFIG/pktgen /usr/bin
