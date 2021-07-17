#!/bin/bash

arch="$(uname -m)"  # -i is only linux, -m is linux and apple
if [[ "$arch" = x86_64* ]]; then
    # NOTE: Rosetta Terminals will print x86_64 also for M1
    # Need to use uname -a to figure out that its ARM
    if [[ "$(uname -a)" = *ARM64* ]]; then
        # M1 Mac

        arch -arm64 brew install helm
        arch -arm64 brew install argo
        arch -arm64 brew install argocd
        arch -arm64 brew install txn2/tap/kubefwd
        arch -arm64 brew install tilt-dev/tap/ctlptl
        arch -arm64 brew install tilt-dev/tap/tilt
    else
        echo 'unsupported'

    fi
elif [[ "$arch" = i*86 ]]; then
    echo 'unsupported'
elif [[ "$arch" = arm* ]]; then
    echo 'unsupported'
elif test "$arch" = aarch64; then
    echo 'unsupported'
else
    exit 1
fi
