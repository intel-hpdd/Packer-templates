#!/bin/sh
# Download the Lustre e2fsprogs packages for EL7 distributions
wget -N -r -np -l 1 -nd --accept .rpm --reject "*debuginfo*" \
-P ../rpms/lustre-e2fsprogs/el7 \
https://downloads.hpdd.intel.com/public/e2fsprogs/latest/el7/RPMS/x86_64
