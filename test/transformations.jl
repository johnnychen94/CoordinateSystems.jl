@testset "Transformations" begin
    @testset "Translation" begin
        @testset "functor" begin
            trans = Translation(Cartesian{2}(), [1, 2])
            q = trans([2, 3])
            @test coordinates(q) == [3, 5]
            @test coordinates(q) isa Vector

            trans = Translation((1, 2))
            p = point(3, 4)
            q = @inferred trans(p)
            @test coordinates(p, q) == [4, 6]

            trans = Translation(Spherical{2}(), (0, pi)) # becomes a rotation
            p = point(3, 4)
            q = @inferred trans(p)
            @test coordinates(p, q) ≈ [-3, -4]

            trans = Translation((3, 4))
            p = point(Spherical{2}(), 1, pi/2)
            q = @inferred trans(p)
            @test coordinates(q) ≈ [3, 5]

            @test_throws ErrorException Translation([1, 2])
        end

        @testset "dimension" begin
            for dims in [1, 2, 5, 10, 50, 100]
                p = point(Spherical{dims}(), point(ones(SVector{dims})))
                translation = rand(dims)
                trans = Translation(Cartesian{dims}(), translation)
                q = @inferred trans(p)
                @test coordinates(q) isa Union{SVector, MVector}
                @test coordinates(trans, q) - coordinates(trans, p) ≈ trans.translation
            end
        end

        @test "Translation(Cartesian{2}(), [3, 4])" == repr(Translation((3, 4)))

        @testset "mixed dimension" begin
            # we may support this in the future, but for now let's disable it
            trans = Translation(Cartesian{3}(), (1, 2, 3))
            @test_throws MethodError trans(point(1))
        end
    end
end
