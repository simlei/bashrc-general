#!/usr/bin/env bash

export GOROOT=${GOROOT:-$(go env | grep GOROOT | cut -d'"' -f2)}
PATH_add "${GOROOT}/bin"
export GOPATH=${GOPATH:-"$HOME/go"}
PATH_add "${GOPATH}/bin"
