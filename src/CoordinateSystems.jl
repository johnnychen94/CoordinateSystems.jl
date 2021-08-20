module CoordinateSystems

using Reexport
using StaticArrays

include("CoordinateSystemsCore/CoordinateSystemsCore.jl")
@reexport using .CoordinateSystemsCore

export Translation

include("transformations.jl")

end
