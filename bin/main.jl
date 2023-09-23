using Jill
using ArgParse

function main()
    s = ArgParseSettings(;usage="jill: simple application installer")
    @add_arg_table! s begin
        "op"
           help = "{create_package|create_exec|install_exec}"
           required = true
        "path"
           help = "package of the package"
           required = true
    end
    options = parse_args(s)
    if options["op"] == "create-package"
        Jill.generate_package_path(abspath(options["path"]))
    elseif options["op"] == "create-exec"
        Jill.generate_exec_path(abspath(options["path"]))
    elseif options["op"] == "install"
        Jill.install(abspath(options["path"]))
    else
        println("Unsupported operation $(options["op"])")
    end
end
main()
