#!/bin/bash
exec sudo -E -u docker PATH=$BUNDLE_BIN:$PATH docker-ssh-exec $@