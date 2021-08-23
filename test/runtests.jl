using CoordinateSystems
using StaticArrays
using Test, Pkg, Aqua, Documenter

# Although CoordinateSystemsCore is an independent package, we also trigger its test here.
@testset "Project meta quality checks" begin
    if VERSION >= v"1.3"
        DocMeta.setdocmeta!(CoordinateSystemsCore, :DocTestSetup, :(using CoordinateSystemsCore, StaticArrays); recursive=true)    
        DocMeta.setdocmeta!(CoordinateSystems, :DocTestSetup, :(using CoordinateSystems, StaticArrays); recursive=true)
        doctest(CoordinateSystems, manual = false)
        doctest(CoordinateSystemsCore, manual = false)
    end
    if VERSION >= v"1.6"
        Aqua.test_ambiguities([CoordinateSystemsCore, CoordinateSystems, Base, Core])
        for pkg in [CoordinateSystemsCore, CoordinateSystems]
            Aqua.test_all(pkg;
                        ambiguities=false,
                        project_extras=true,
                        deps_compat=true,
                        stale_deps=true,
                        project_toml_formatting=true
            )
        end
    end
end

Pkg.test("CoordinateSystemsCore")

@testset "CoordinateSystems.jl" begin
    include("transformations.jl")
end
