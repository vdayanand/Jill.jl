#!/bin/bash
#=
exec julia --color=yes --project={{{PKG_PATH}}} --startup-file=no "${BASH_SOURCE[0]}" "$@"
=#
using {{PKG_NAME}}
{{PKG_NAME}}.main()
