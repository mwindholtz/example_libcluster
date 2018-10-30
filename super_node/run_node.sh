#!/bin/sh

if [[ $# -eq 0 ]] ; then
    echo "Usage: $0 <node_name>"
    exit 0
fi

export ERL_ZFLAGS=""
iex --name node${1}@127.0.0.1 -S mix
