abstract type AbstractPoint{CT<:CoordinateSystem, N, T} end
@inline Base.eltype(::AbstractPoint{CT,N,T}) where {CT,N,T} = T
@inline Base.ndims(::AbstractPoint{CT,N}) where {CT,N} = N
@inline Base.:(==)(x::AbstractPoint, y::AbstractPoint) = with_coordinate_system(==, coordinate_system(x), x, y)
@inline function Base.isapprox(x::AbstractPoint, y::AbstractPoint; kwargs...)
    with_coordinate_system(coordinate_system(x), x, y) do p, q
        isapprox(p, q; kwargs...)
    end
end

"""
    coordinates([chart::CoordinateSystem,] x::AbstractPoint)

Get the coordinate of point `x` in the coordinate system `chart` with appropriate coordinate map.
The default system is [`coordinate_system(x)`](@ref coordinate_system), i.e., `x`'s own coordinate
system.

To construct a point without coordinate mapping, use [`point(chart, coordinates(x))`](@ref point).

# Examples

```jldoctest
julia> x = point(0, 1)
Point([0, 1])

julia> coordinates(x)
2-element SVector{2, $Int} with indices SOneTo(2):
 0
 1

julia> coordinates(Spherical{2}(), x) ≈ [1, pi/2]
true
```

If `x` is not a point object, then `coordinates` becomes a identity map:

```jldoctest
julia> coordinates([1, 2])
2-element $(Vector{Int}):
 1
 2

julia> coordinates((1, 2))
(1, 2)

julia> coordinates(CartesianIndex(3, 3))
CartesianIndex(3, 3)

julia> coordinates("something_strange")
"something_strange"
```
"""
coordinates(::AbstractPoint) = error("Not implemented")
@inline coordinates(xs) = xs
@inline coordinates(x, y::AbstractPoint) = coordinates(coordinate_system(x), y)
function coordinates(chart::CoordinateSystem, x::AbstractPoint)
    map_to = transition_map(chart, coordinate_system(x))
    map_to(coordinates(x))
end

"""
    point([chart::CoordinateSystem,] x)

A convenient constructor to build an efficient point representation of `x` on coordinate system
`chart`. The default system is [`coordinate_system(x)`](@ref coordinate_system).

When comparing two points under different coordinate systems, they will be adapted to the same
coordinate system first and then compare their local coordinates.

# Examples

```jldoctest
julia> p = point(Cartesian{2}(), (0, 1))
Point([0, 1])

julia> q = point(Spherical{2}(), (1, pi/2))
Point{Spherical{2}}([1.0, 1.5707963267948966])

julia> point(Cartesian{2}(), q) ≈ p
true

julia> point(Cartesian{2}(), q) == q
true
```

!!! tip "Performance"
    For better performance, one might use `SVector`/`MVector` from StaticArrays.jl because
    their sizes are known prior in compile time. When `Tuple` is provided, it will be
    converted to `SVector` internally.

To get the transformed coordinates under given coordinate system `chart`, one can use
[`coordinates`](@ref).
"""
@inline point(chart::CoordinateSystem, x) = Point(chart, x)
@inline point(chart::CoordinateSystem, p::AbstractPoint) = point(chart, coordinates(chart, p))
@inline point(x) = point(coordinate_system(x), x)

# convenient constructor
@inline point(xs::Real...) = point(xs)
@inline point(chart::CoordinateSystem, xs::Real...) = point(chart, xs)

"""
    coordinate_system(x::AbstractPoint)::CoordinateSystem

Get the native coordinate system of point `x`. For vector of length `N`, it's coordinate are `Cartesian{N}()`.

!!! note
    For generic vector types (e.g., `Vector`) whose length is not known at compile time, it can't infer
    the default coordinate system.
"""
coordinate_system(::AbstractPoint) = error("Not implemented.")
coordinate_system(::AT) where AT = error("Unable to infer the default coordinate system for dynamic length vector type $(AT)")
@inline coordinate_system(::StaticVector{N}) where N = Cartesian{N}()
@inline coordinate_system(::NTuple{N}) where N = Cartesian{N}()
@inline coordinate_system(::CartesianIndex{N}) where N = Cartesian{N}()

###
# Point
###

"""
    Point([chart::CoordinateSystem,] x)

Construct a point with local coordinates `x` under given coordinate system `chart`.
"""
struct Point{CT<:CoordinateSystem,N,T,AT<:AbstractVector} <: AbstractPoint{CT,N,T}
    chart::CT
    # Every local coordinates `x` is a point in the Euclidean space and thus we require it be a
    # vector. Generic vector-like objects such as `Tuple` or `CartesianIndex` are not allowed even
    # though they share similar internal data layout with `Vector`. Instead, we use `to_vec` to do
    # the conversion.
    x::AT
end
@inline Point(x) = Point(coordinate_system(x), x)
@inline Point(chart::CT, x) where {CT<:CoordinateSystem} = Point(chart, to_vec(x))
@inline Point(chart::CT, x::AbstractVector{T}) where {CT<:CoordinateSystem,T} = Point{CT,ndims(CT),T,typeof(x)}(chart,x)

@inline coordinates(x::Point) = x.x
@inline coordinate_system(p::Point) = p.chart

@inline Base.show(io::IO, x::Point) = _show(io::IO, x)
function _show(io::IO, x::Point{<:Cartesian})
    # Here we bless the Cartesian system and don't show its type
    print(io, "Point(", coordinates(x), ")")
end
function _show(io::IO, x::Point{CT}) where CT<:CoordinateSystem
    print(io, "Point{", CT, "}(", coordinates(x), ")")
end
