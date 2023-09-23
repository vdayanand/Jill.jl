#!/bin/bash
julia --color=yes --project={{{PKG_PATH}}} --startup-file=no {{{PKG_PATH}}}/bin/main.jl "$@"
