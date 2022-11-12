module GenPkg

using UUIDs
using ArgParse
using Mustache


function parse_cli()
     s = ArgParseSettings()
     @add_arg_table! s begin
         "name"
             help = "package name"
             required = true
     end
     opts = parse_args(s)
end

function main()
     pkg_name = parse_cli()["name"]
     template_dir = @__DIR__
     isdir(pkg_name) && error("Folder exists")
     temp_dir = tempdir()
     pkg_dir = joinpath(temp_dir, pkg_name)
     mkdir(pkg_dir)
     mkdir(joinpath(pkg_dir, "src"))
     mkdir(joinpath(pkg_dir, "test"))
     project_tpl  = joinpath(template_dir, "Project.toml.tpl")
     open(joinpath(pkg_dir, "Project.toml"), "w") do f
         write(f,  Mustache.render(read(project_tpl, String), Dict("PKG_NAME"=>pkg_name, "PKG_UUID"=>string(uuid4()))))
     end
     main_tpl  = joinpath(template_dir, "main.jl.tpl")
     open(joinpath(pkg_dir, "src", "$(pkg_name).jl"), "w") do f
         write(f,  Mustache.render(read(main_tpl, String), Dict("PKG_NAME"=>pkg_name)))
     end
     test_tpl  = joinpath(template_dir, "test.jl.tpl")
     open(joinpath(pkg_dir, "test", "runtests.jl"), "w") do f
         write(f,  Mustache.render(read(test_tpl, String),  Dict("PKG_NAME"=>pkg_name)))
     end
     bin_tpl  = joinpath(template_dir, "bin.jl.tpl")
     open(joinpath(pkg_dir,  lowercase(pkg_name)), "w") do f
         write(f,  Mustache.render(read(bin_tpl, String),  Dict("PKG_NAME"=>pkg_name)))
     end
     chmod(joinpath(pkg_dir,  lowercase(pkg_name)), 0o755)
     mv(pkg_dir, pkg_name)
end
end
