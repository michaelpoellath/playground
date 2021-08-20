#!/bin/bash

arch="$(uname -m)"  # -i is only linux, -m is linux and apple
if [[ "$arch" = x86_64* ]]; then
    # NOTE: Rosetta Terminals will print x86_64 also for M1
    # Need to use uname -a to figure out that its ARM


    libs=(helm argo argocd tilt-dev/tap/ctlptl tilt-dev/tap/tilt go-task/tap/go-task hashicorp/tap/vault)
    cmd=echo
    if [[ "$(uname -a)" = *ARM64* ]]; then
        # M1 Mac
        cmd="arch -arm64 brew install"
    else
        cmd="brew install"
    fi

    for lib in ${libs[@]}; do
        ${cmd} ${lib}
    done

elif [[ "$arch" = i*86 ]]; then
    echo 'unsupported'
elif [[ "$arch" = arm* ]]; then
    echo 'unsupported'
elif test "$arch" = aarch64; then
    echo 'unsupported'
else
    exit 1
fi
