@inline convert_map(to::CT, from::CT) where CT<:FixedOriginCoordinateSystem = identity

# TODO: generalize to N dimensional case
#       https://en.wikipedia.org/wiki/N-sphere
@inline function convert_map(to::Cartesian{2}, from::Spherical{2})
    @inline function (x::CoordinateType{2})
        s, c = sincos(x[2])
        return SVector(x[1] * c, x[1] * s)
    end
end
@inline function convert_map(to::Spherical{2}, from::Cartesian{2})
    @inline function (x::CoordinateType{2})
        r = hypot(x[1], x[2])
        θ = atan(x[2], x[1])
        return SVector(r, θ)
    end
end
