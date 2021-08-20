module CoordinateSystemsCore

using StaticArrays

export AbstractCoordinateSystem, Cartesian, Spherical
export point, coordinate, coordinate_system, with_coordinate_system
export AbstractPoint, Point

# We accept several user input types, but always store and compute as SVector
const CoordinateType{N} = Union{NTuple{N}, SVector{N}}

abstract type AbstractCoordinateSystem{N} end
abstract type FixedOriginCoordinateSystem{N} <: AbstractCoordinateSystem{N} end
struct Cartesian{N} <: FixedOriginCoordinateSystem{N} end
struct Spherical{N} <: FixedOriginCoordinateSystem{N} end

@inline Base.ndims(::AbstractCoordinateSystem{N}) where N = N
@inline Base.ndims(::Type{<:AbstractCoordinateSystem{N}}) where N = N

include("points.jl")
include("coordinate_conversions.jl")
include("utils.jl")

"""
    coordinate_system_type(x)

Get the coordinate system type of object `x`.
"""
@inline coordinate_system_type(::Type{<:AbstractPoint{CT}}) where CT = CT
@inline coordinate_system_type(::Type{<:CoordinateType{N}}) where N = Cartesian{N}
@inline coordinate_system_type(x::Union{AbstractPoint, CoordinateType}) = coordinate_system_type(typeof(x))

end # module
