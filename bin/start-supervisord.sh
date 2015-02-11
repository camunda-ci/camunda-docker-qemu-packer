#!/bin/bash

/usr/local/bin/kvm-mknod.sh
/usr/local/bin/setup-bridge.sh

exec /usr/bin/supervisord
