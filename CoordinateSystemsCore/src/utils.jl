"""
    to_vec(x)

Convert input `x` to vector without allocating memories.
"""
@inline to_vec(x::AbstractVector) = x
@inline to_vec(x::CartesianIndex) = SVector(x.I)
@inline to_vec(x::Tuple) = SVector(x)
@inline to_vec(x::T) where T = error("Converting type $T to vector representation isn't supported yet.")

"""
    with_coordinate_system(f, chart::AbstractCoordinateSystem, xs::AbstractPoint...)

Apply function `f(xs...)` on coordinate system `chart`. Every point `x`∈`xs` will be maped to the
working coordinate system `chart` before calling `f`. If the output of `f` has points, then their
coordinate system will be `chart`.
"""
@inline with_coordinate_system(f, chart, xs::AbstractPoint...) = f(coordinates.(chart, xs)...)
