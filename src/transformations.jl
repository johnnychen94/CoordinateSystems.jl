abstract type AbstractCoordinateTransformation{N, CT<:AbstractCoordinateSystem} end
abstract type AbstractAffineMap{N,CT} <: AbstractCoordinateTransformation{N,CT} end

###
# Translation
###
struct Translation{N, CT<:AbstractCoordinateSystem, V} <: AbstractAffineMap{N,CT}
    cs::CT
    translation::V
    function Translation{N, CT, V}(cs::CT, translation::V) where {N,CT<:AbstractCoordinateSystem,V}
        if N != length(translation)
            throw(ArgumentError("Coordinate system $(CT) dimension $(ndims(cs)) should be equal to translation vector length $(length(translation))."))
        end
        new{N,CT,V}(cs, translation)
    end
end
@inline function Translation(cs::CT, x) where {CT<:AbstractCoordinateSystem}
    x = SVector(x)
    return Translation{ndims(CT),CT,typeof(x)}(cs, x)
end
@inline Translation(x) = Translation(coordinate_system(x), x)
@inline Translation(xs::Real...) = Translation(SVector(xs))

function (trans::Translation)(x::AbstractPoint)
    with_coordinate_system(trans.cs, x) do p
        SVector(p) + trans.translation
    end
end

function Base.show(io::IO, trans::Translation{N,Cartesian{N}}) where N
    print(io, "Translation", Tuple(trans.translation))
end
