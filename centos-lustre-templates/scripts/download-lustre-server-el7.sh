#!/bin/sh
# Download the Lustre server packages for EL7 distributions

if [ "$1" != "" ] && echo $1 | head -1 |awk '/^[0-9.]*$/{exit 0}{exit 1}'; then
  wget -N -r -np -l 1 -nd --accept .rpm --reject "*debuginfo*" \
  -P rpms/lustre-server/$1/el7 \
  https://downloads.hpdd.intel.com/public/lustre/lustre-$1/el7/server/RPMS/x86_64
else
  echo "ERROR: Invalid version number."
  exit 1
fi
