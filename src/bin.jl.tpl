#!/bin/bash
#=
exec julia --color=yes  --startup-file=no "${BASH_SOURCE[0]}" "$@"
=#
cd(@__DIR__)
using Pkg
Pkg.activate(".")
using {{PKG_NAME}}
{{PKG_NAME}}.main()
