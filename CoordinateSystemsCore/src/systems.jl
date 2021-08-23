abstract type CoordinateSystem{N} end

"""
    Cartesian{N}() <: CoordinateSystem

The typical Cartesian coordinate system.
"""
struct Cartesian{N} <: CoordinateSystem{N} end

"""
    Spherical{N}() <: CoordinateSystem

"""
struct Spherical{N} <: CoordinateSystem{N} end

@inline Base.broadcastable(chart::CoordinateSystem) = Ref(chart)
@inline Base.ndims(::CoordinateSystem{N}) where N = N
@inline Base.ndims(::Type{<:CoordinateSystem{N}}) where N = N

