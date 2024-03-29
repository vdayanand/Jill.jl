module Jill

using UUIDs
using Mustache
using TOML
using Pkg

function atomic_write(fun::Function, dest::AbstractString)
    path, _ = mktemp()
    open(path, "w") do f
        fun(f)
    end
    mv(path, dest; force=true)
end

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
    proj = TOML.parsefile("Project.toml")
    pkg_name = if haskey(proj, "name")
        proj["name"]
    else
        error("Package Docgen seems to be missing name in its Project.toml")
    end
    mkpath(dirname(binfile))
    touch(binfile)
    open(binfile, "w") do f
         write(f,  Mustache.render(read(bin_tpl, String),  Dict("PKG_NAME"=>pkg_name)))
    end
    Pkg.instantiate()
end

function generate_package_path(path)
    path = abspath(path)
    mkpath(dirname(path))
    cd(dirname(path)) do
        create_package_tree(basename(path))
    end
end

function generate_exec_path(path)
    path = abspath(path)
    if !isdir(path)
        generate_package_path(path)
    end
    cd(path) do
        create_exec_tree(basename(path))
    end
end

function install(path)
    path = abspath(path)
    pkg_name = basename(path)
    projectfile = joinpath(path, "Project.toml")
    if isfile(projectfile)
        proj = TOML.parsefile(projectfile)
        if haskey(proj, "name")
            pkg_name = proj["name"]
        else
            error("Package Docgen seems to be missing name in its Project.toml")
        end
    else
        error("Project.toml is missing at $path")
    end
    cd(path) do
        Pkg.instantiate()
    end
    main_file = joinpath(path, "src", pkg_name *".jl")
    bin_file = joinpath(path, "bin", "main.jl")
    if !isfile(main_file) || !isfile(bin_file)
        error("$path is not a julia application")
    end
    mainfile = abspath(bin_file)
    project = abspath(path)
    depot_bin_dir = joinpath(Pkg.depots1(), "bin")
    mkpath(depot_bin_dir)
    execfile = joinpath(depot_bin_dir, lowercase(pkg_name))
    atomic_write(execfile) do f
        write(f,  Mustache.render(read(joinpath(@__DIR__, "exec.tpl"), String),  Dict("PKG_PATH"=>path)))
    end
    chmod(execfile, 0o777)
end

end
