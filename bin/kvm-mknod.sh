#!/bin/bash
# If possible, create the /dev/kvm device node.

set -e

function ensureCorrectPermissions() {
  # ensure that kvm group has correct id
  NODE_GROUP=$(ls -n /dev/kvm | cut -d " " -f 4)
  KVM_GROUP=$(getent group kvm | cut -d ":" -f 3)

  if [ $NODE_GROUP -ne $KVM_GROUP ]; then
    echo >&2 "Change kvm group id from $KVM_GROUP to $NODE_GROUP"
    groupmod -g $NODE_GROUP kvm
  fi
}

if [ ! -e /dev/kvm ]; then
  mknod /dev/kvm c 10 $(grep '\<kvm\>' /proc/misc | cut -f 1 -d' ') || {
    echo >&2 "Unable to make /dev/kvm node; software emulation will be used"
    echo >&2 "(This can happen if the container is run without -privileged)"
    exit 1
  }
fi

dd if=/dev/kvm count=0 2>/dev/null || {
  echo >&2 "Unable to open /dev/kvm; qemu will use software emulation"
  echo >&2 "(This can happen if the container is run without -privileged)"
}

ensureCorrectPermissions
