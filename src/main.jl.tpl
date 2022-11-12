module {{PKG_NAME}}
#=
using ArgParse

function parse_cli()
    s = ArgParseSettings()
    @add_arg_table! s begin
        "name"
            help = "package name"
            required = true
    end
    opts = parse_args(s)
end
=#

function main()
    @info "hello {{PKG_NAME}}"
end


end # module
