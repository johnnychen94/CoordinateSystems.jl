"""
    with_coordinate_system(f, cs::AbstractCoordinateSystem, xs::AbstractPoint...)

Apply function `f(xs...)` on coordinate system `cs`.

Every point `x`∈`xs` will be maped to the working coordinate system `cs` before calling `f`, and the
result `y` will be maped back to its original coordinate system.
"""
function with_coordinate_system(f, cs::AbstractCoordinateSystem, x::AbstractPoint)
    y = f(coordinate(cs, x))
    map_from = convert_map(coordinate_system(x), cs)
    return typeof(x)(map_from(y))
end
function with_coordinate_system(f, cs::AbstractCoordinateSystem, xs::PT...) where PT<:AbstractPoint
    y = f(coordinate(cs, xs)...)
    map_from = convert_map(coordinate_system(first(xs)), cs)(y)
    @. PT(map_from(ys))
end

