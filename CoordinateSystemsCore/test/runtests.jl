using CoordinateSystemsCore
using CoordinateSystemsCore: transition_map
using StaticArrays

using Test, Aqua, Documenter

@testset "CoordinateSystemsCore" begin
    include("utils.jl")
    include("transition_map.jl")
    include("points.jl")
end
