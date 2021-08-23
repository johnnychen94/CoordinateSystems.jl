module Transformations

using CoordinateSystemsCore
using CoordinateSystemsCore: to_vec
import CoordinateSystemsCore: coordinate_system
using Functors

export Translation

abstract type CoordinateTransformation{CT<:CoordinateSystem} end
abstract type AbstractAffineMap{CT} <: CoordinateTransformation{CT} end

@inline coordinate_system(trans::CoordinateTransformation) = trans.chart

@inline function Base.show(io::IO, trans::CoordinateTransformation)
    fields = map(fieldnames(typeof(trans))) do fn
        string(getproperty(trans, fn))
    end
    print(io, basetype(trans), "(", join(fields, ", ") , ")")
end

include("translation.jl")
include("utils.jl")

end
