module GenPkg

using UUIDs
using ArgParse
using Mustache
using TOML

function create_package_tree(pkg_name)
     template_dir = @__DIR__
     isdir(pkg_name) && error("Folder exists")
     mktempdir() do temp_dir
         pkg_dir = joinpath(temp_dir, pkg_name)
         mkpath(joinpath(pkg_dir, "src"))
         mkpath(joinpath(pkg_dir, "test"))
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
         mv(pkg_dir, pkg_name)
     end
end

function create_exec_tree(pkg_name)
    binfile = joinpath("bin", "main.jl")
    isfile(binfile) && error("main.jl exists")
    template_dir = @__DIR__
    bin_tpl  = joinpath(template_dir, "binmain.jl.tpl")
    pkg_name = TOML.parsefile("Project.toml")["name"]
    mkpath(dirname(binfile))
    touch(binfile)
    open(binfile, "w") do f
         write(f,  Mustache.render(read(bin_tpl, String),  Dict("PKG_NAME"=>pkg_name)))
    end
end

function generate_package_path(path)
    mkpath(dirname(path))
    cd(dirname(path)) do
        create_package_tree(basename(path))
    end
end

function generate_exec_path(path)
    if !isdir(path)
        generate_package_path(path)
    end
    cd(path) do
        create_exec_tree(basename(path))
    end
end

end
