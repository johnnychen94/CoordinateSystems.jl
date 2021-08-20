abstract type AbstractPoint{CT<:AbstractCoordinateSystem, N, T} end
@inline Base.eltype(::AbstractPoint{CT,N,T}) where {CT,N,T} = T
@inline Base.ndims(::AbstractPoint{CT,N}) where {CT,N} = N
@inline function Base.:(==)(x::AbstractPoint, y::AbstractPoint)
    cs = coordinate_system(x)
    return coordinate(cs, x) == coordinate(cs, y)
end

"""
    coordinate([cs::AbstractCoordinateSystem,] x::AbstractPoint)
    coordinate([cs::AbstractCoordinateSystem,] xs::AbstractPoint...)

Get the coordinate of point `x` in the coordinate system `cs` with appropriate coordinate map. The
default system is [`coordinate_system(x)`](@ref coordinate_system).

To construct a point without coordinate mapping, use [`point(cs, coordinate(x))`](@ref point).
"""
coordinate(::AbstractPoint) = error("Not implemented")
@inline coordinate(::CT, x::AbstractPoint{CT,N}) where {N,CT<:AbstractCoordinateSystem} = coordinate(x)

function coordinate(cs::AbstractCoordinateSystem, x::AbstractPoint)
    map_to = convert_map(cs, coordinate_system(x))
    map_to(coordinate(x))
end
function coordinate(cs::AbstractCoordinateSystem, xs::NTuple{N,PT}) where {N, PT<:AbstractPoint}
    map_to = convert_map(cs, coordinate_system(first(xs)))
    @. map_to(coordinate(xs))
end
@inline coordinate(cs::AbstractCoordinateSystem, xs::PT...) where {PT<:AbstractPoint} = coordinate(cs, xs)

# It is ambiguious to get the coordinate of a point whose coordinate system is unknown.
# We would want the user to explicitly construct the point, e.g., `coordinate(point(2, 3)) == [2, 3]`.
coordinate(xs::Real...) = error("Do you mean `point$xs`?")
coordinate(xs::CoordinateType) = error("Do you mean `point($xs)`?")

"""
    point([cs::AbstractCoordinateSystem,] x)

A convenient constructor to build an efficient point representation of `x` on coordinate system `cs`.
The default system is [`coordinate_system(x)`](@ref coordinate_system).

One should use [`coordinate`](@ref) to convert a point `x` to another coordinate system.
"""
point(::AbstractCoordinateSystem, ::CoordinateType) = error("Not implemented.")
@inline point(x::AbstractPoint) = x
# Unlike `coordinate`, constructing a point from a coordinate is always assumed to be
# Cartesian system.
@inline point(x::CoordinateType) = point(coordinate_system(x), SVector(x))
@inline point(xs::Real...) = point(xs)

"""
    coordinate_system(x)::AbstractCoordinateSystem

Get the native coordinate system of point `x`.
"""
coordinate_system(::AbstractPoint) = error("Not implemented.")
@inline coordinate_system(::CoordinateType{N}) where {N} = Cartesian{N}()

###
# Point - a point type whose origin coordinate is fixed.
###

"""
    Point([cs::FixedOriginCoordinateSystem,] x)

A point type whose origin `(0, 0, ..., 0)` is preserved under coordinate transformations.
"""
struct Point{CT<:FixedOriginCoordinateSystem,N,T,AT<:SVector} <: AbstractPoint{CT,N,T}
    x::AT
    function Point{CT,N,T,AT}(x::AT) where {CT<:FixedOriginCoordinateSystem,N,T,AT<:SVector}
        length(x) == N || throw(DimensionMismatch("length of coordinate vector $(length(x)) should be equal to $(N)."))
        eltype(x) == T || throw(ArgumentError("eltype of coordinate vector $(eltype(x)) should be equal to $(T)."))
        ndims(CT) == N || throw(DimensionMismatch("Dimension of coordinate system $(ndims(x)) should be equal to $(N)."))
        new{CT,N,T,AT}(x)
    end
end
@inline function Point{CT}(x::CoordinateType{N}) where {CT,N}
    x = SVector(x)
    Point{CT,N,eltype(x),typeof(x)}(x)
end
@inline Point(x::CoordinateType) = Point(coordinate_system(x), x)
@inline Point(::CT, x::CoordinateType) where {CT} = Point{CT}(x)

@inline coordinate(x::Point) = x.x
@inline coordinate_system(::Point{CT}) where CT = CT()

@inline point(cs::FixedOriginCoordinateSystem, x::CoordinateType) = Point(cs, x)
@inline point(cs::FixedOriginCoordinateSystem, xs::Real...) = point(cs, xs)
@inline point(cs::FixedOriginCoordinateSystem, p::Point) = point(cs, coordinate(cs, p))

Base.show(io::IO, x::Point) = _show(io::IO, x)
function _show(io::IO, x::Point{<:Cartesian})
    print(io, "Point", Tuple(x.x))
end
function _show(io::IO, x::Point{CT}) where CT<:AbstractCoordinateSystem
    print(io, "Point{", CT, "}", Tuple(x.x))
end
