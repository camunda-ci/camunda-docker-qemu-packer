#!/bin/bash

/usr/local/bin/kvm-mknod.sh

exec /usr/bin/supervisord
