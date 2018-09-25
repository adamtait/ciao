#!/usr/bin/env bash

VERSION=1.0.2
CMD=ciao

# Paths
D=$HOME/.ciao
F=$D/domains
STATE=$D/.state
OVERRIDES=$D/overrides


# Default Configuration
SRC_PATH=$D/.etc_hosts~orig
DEST_PATH=/etc/hosts
DEST_PATH_REQUIRES_SUDO=true
        
IPv4_DEST="127.0.0.1"
IPv6_DEST="fe80::1%lo0"

DEST_DNS_FIRST=false

AFTER_CHANGES_RUN="sudo dscacheutil -flushcache"



# Local Configuration
CONFIG_PATH=$D/config
source $CONFIG_PATH
