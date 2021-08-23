###
# Translation
###

"""
    Translation([chart = coordinate_system(v)], v) <: AbstractAffineMap

Construct the `Translation` transformation for translating points by offset `v` under coordinate
system `chart`.

# Examples

```jldoctest
julia> trans = Translation(Cartesian{2}(), (2, 3))
Translation(Cartesian{2}(), [2, 3])

julia> trans((1, 2))
Point([3, 5])

julia> trans = Translation(Spherical{2}(), (0, pi/2)) # rotate by 90 degree in Cartesian system
Translation(Spherical{2}(), [0.0, 1.5707963267948966])

julia> coordinates(Cartesian{2}(), trans((1, 0))) ≈ [0, 1]
true
```

When `v` is a point object with different coordinate system, it will be transformed to `chart`
system first:

```jldoctest
julia> trans = Translation((2, 3))
Translation(Cartesian{2}(), [2, 3])

julia> p = point(Spherical{2}(), [1, pi/2]) # [0, 1] in Cartesian system
Point{Spherical{2}}([1.0, 1.5707963267948966])

julia> trans(p)
Point([2.0, 4.0])
```

"""
struct Translation{CT<:CoordinateSystem,V} <: AbstractAffineMap{CT}
    chart::CT
    translation::V
    function Translation{CT,V}(chart::CT, translation::V) where {CT<:CoordinateSystem,V}
        if ndims(chart) != length(translation)
            throw(ArgumentError("Coordinate system $(CT) dimension $(ndims(chart)) should be equal to translation vector length $(length(translation))."))
        end
        new{CT,V}(chart, translation)
    end
end
@inline function Translation(chart::CT, x) where {CT<:CoordinateSystem}
    x = to_vec(x)
    return Translation{CT,typeof(x)}(chart, x)
end
@inline Translation(x) = Translation(coordinate_system(x), x)

@functor Translation (translation, )

(trans::Translation)(x) = point(coordinate_system(trans), to_vec(x) + trans.translation)
(trans::Translation{CT})(x::AbstractPoint{CT}) where CT = trans(x)
function (trans::Translation)(x::AbstractPoint)
    chart = coordinate_system(trans)
    with_coordinate_system(trans, chart, x)
end
