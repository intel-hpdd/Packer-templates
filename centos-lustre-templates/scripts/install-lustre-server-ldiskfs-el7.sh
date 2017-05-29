#!/bin/sh
# Install the Lustre patched kernel and Lustre server packages
cd /root/lustre-server && \
yum -y install \
kernel-[0-9].*.rpm \
kernel-tools-[0-9].*.rpm \
kernel-tools-libs-[0-9].*.rpm \
kmod-lustre-[0-9].*.rpm \
kmod-lustre-osd-ldiskfs-[0-9].*.rpm \
lustre-[0-9].*.rpm \
lustre-iokit-[0-9].*.rpm \
lustre-osd-ldiskfs-mount-[0-9].*.rpm \
perf-[0-9].*.rpm \
python-perf-[0-9].*.rpm

