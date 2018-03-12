#!/usr/bin/env bash

VERSION=1.0.1
CMD=ciao

D=$HOME/.ciao
F=$D/domains
STATE=$D/.state
OVERRIDES=$D/overrides


SRC_PATH=$D/.etc_hosts~orig
DEST_PATH=/etc/hosts
        
IPv4_DEST="127.0.0.1"
IPv6_DEST="fe80::1%lo0"
