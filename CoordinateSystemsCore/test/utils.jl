@testset "utils" begin
    @testset "with_coordinate_system" begin
        x = point((2, 3))
        p = with_coordinate_system(identity, Spherical{2}(), x)
        @test p == coordinates(Spherical{2}(), x)

        x = point((1, 2))
        y = point(Spherical{2}(), (4, 5))
        z = with_coordinate_system(Cartesian{2}(), x, y) do p, q
            point(Cartesian{2}(), mapreduce(coordinates, +, (p, q)))
        end
        @test coordinates(x) ≈ coordinates(z) - coordinates(Cartesian{2}(), y)
    end
end
