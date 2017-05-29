#!/bin/sh
# Install the Lustre patched e2fsprogs packages
cd /root/lustre-e2fsprogs && \
yum -y localinstall \
e2fsprogs-[0-9]* \
e2fsprogs-libs-[0-9]* \
libcom_err-[0-9]* \
libss-[0-9]*
