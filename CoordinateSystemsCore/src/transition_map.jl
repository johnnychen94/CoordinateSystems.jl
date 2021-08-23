"""
    transition_map(to::CoordinateSystem, from::CoordinateSystem)

Get the transition map from chart `from` to chart `to`.

# Examples

```jldoctest
julia> mapfn = transition_map(Cartesian{2}(), Spherical{2}());

julia> mapfn([1, pi/2]) ≈ [0, 1]
true

julia> mapfn = transition_map(Spherical{2}(), Cartesian{2}());

julia> mapfn([0, 1]) ≈ [1, pi/2]
true
```
"""
transition_map

@inline transition_map(to::CT, from::CT) where CT<:CoordinateSystem = identity

@inline function transition_map(to::Cartesian{N}, from::Spherical{N}) where N
    Base.@propagate_inbounds function Spherical_to_Cartesian(x::AbstractVector{T}) where T
        length(x) <= 1 && return x
        y = similar(x, float(T))
        cache = first(x)
        @inbounds for i in 2:length(x)
            s, c = sincos(x[i])
            y[i-1] = cache * c
            cache *= s
        end
        y[end] = cache
        return y
    end

    # Note: it is also possible to code generate the optimized version for generic N > 3 case
    @inline Spherical_to_Cartesian(x::SVector{1}) = x
    @inline function Spherical_to_Cartesian(x::SVector{2})
        s, c = sincos(x[2])
        return SVector(x[1] * c, x[1] * s)
    end
    @inline function Spherical_to_Cartesian(x::SVector{3})
        r = x[1]
        s1, c1 = sincos(x[2])
        s2, c2 = sincos(x[3])
        return SVector(r * c1, r * s1 * c2, r * s1 * s2)
    end
    return Spherical_to_Cartesian
end

@inline function transition_map(to::Spherical{N}, from::Cartesian{N}) where N
    Base.@propagate_inbounds function Cartesian_to_Spherical(x::AbstractVector{T}) where T
        length(x) <= 1 && return x
        y = similar(x, float(T))
        cache = zero(float(eltype(x)))

        cache += x[end]^2 + x[end-1]^2
        y[end] = 2atan(x[end], x[end-1] + sqrt(cache))
        @inbounds for i in length(x)-1:-1:2
            y[i] = atan(sqrt(cache), x[i-1])
            cache += x[i-1]^2
        end
        y[1] = sqrt(cache)
        return y
    end

    # Note: it is also possible to code generate the optimized version for generic N > 3 case
    @inline Cartesian_to_Spherical(x::SVector{1}) = x
    @inline function Cartesian_to_Spherical(x::SVector{2})
        r = hypot(x[1], x[2])
        θ = atan(x[2], x[1])
        return SVector(r, θ)
    end
    @inline function Cartesian_to_Spherical(x::SVector{3})
        cache = zero(float(eltype(x)))
        cache += x[2]^2+x[3]^2
        θ2 = 2atan(x[3], x[2]+sqrt(cache))
        θ1 = atan(cache, x[1])
        r = sqrt(cache + x[1]^2)
        return SVector(r, θ1, θ2)
    end
    return Cartesian_to_Spherical
end
