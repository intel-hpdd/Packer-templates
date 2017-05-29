#!/bin/sh
# Install the Lustre client packages
cd /root/lustre-client && \
yum -y install \
kmod-lustre-client-[0-9].*.rpm \
lustre-client-[0-9].*.rpm \
lustre-iokit-[0-9].*.rpm
