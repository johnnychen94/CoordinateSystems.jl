module CoordinateSystemsCore

using StaticArrays

export CoordinateSystem, Cartesian, Spherical
export point, coordinates, coordinate_system, transition_map, with_coordinate_system
export AbstractPoint, Point

include("systems.jl")
include("points.jl")
include("transition_map.jl")
include("utils.jl")

end # module
