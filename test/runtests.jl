using CoordinateSystems
using StaticArrays
using Test, TestEnv, Aqua, Documenter

# Although CoordinateSystemsCore is an independent package, we also trigger its test here.

@testset "Project meta quality checks" begin
    DocMeta.setdocmeta!(CoordinateSystemsCore, :DocTestSetup, :(using CoordinateSystemsCore, StaticArrays); recursive=true)    
    DocMeta.setdocmeta!(CoordinateSystems, :DocTestSetup, :(using CoordinateSystems, StaticArrays); recursive=true)
    doctest(CoordinateSystems, manual = false)
    doctest(CoordinateSystemsCore, manual = false)

    for pkg in [CoordinateSystemsCore, CoordinateSystems]
        Aqua.test_all(pkg;
                      ambiguities=true,
                      project_extras=true,
                      deps_compat=true,
                      stale_deps=true,
                      project_toml_formatting=true
        )
    end
end

@testset "CoordinateSystemsCore.jl" begin
    TestEnv.activate("CoordinateSystemsCore") do
        include(joinpath(pkgdir(CoordinateSystemsCore), "test", "runtests.jl"))
    end
end

@testset "CoordinateSystems.jl" begin
    include("transformations.jl")
end
