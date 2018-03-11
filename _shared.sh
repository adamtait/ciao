#!/usr/bin/env bash

VERSION=1.0.1
CMD=ciao

D=$HOME/.dns_blocker
F=$D/domains
STATE=$D/.state

SRC_PATH=$D/.etc_hosts~orig
DEST_PATH=/etc/hosts
        
