@testset "coordinate_system" begin
    @test coordinate_system((1, 2)) == Cartesian{2}()
    @test coordinate_system(SVector(1, 2)) == Cartesian{2}()
    @test coordinate_system(MVector(1, 2)) == Cartesian{2}()
    @test coordinate_system(CartesianIndex(1, 2)) == Cartesian{2}()

    # the length of Vector is unknown at compile time
    @test_throws ErrorException coordinate_system([1, 2])
end

@testset "Point" begin
    @testset "Cartesian" begin
        for dims in [1, 2, 3, 4, 50]
            x0 = ntuple(identity, dims)
            chart = Cartesian{dims}()
            ref = Point(chart, x0)
            for x in [x0, SVector(x0), MVector(x0), CartesianIndex(x0)]
                @test point(x) == point(chart, x) == Point(x) == ref
            end
            @test coordinates(ref) == collect(x0)
            @test point(ref) === ref
            # convenient constructor
            @test point(x0) === point(x0...) === point(chart, x0) === point(chart, x0...)

            # range and vector
            x = 1:dims
            @test point(chart, x) == Point(chart, x)
            x = collect(x0)
            @test point(chart, x) == Point(chart, x)

            x = collect(x0)
            @test coordinates(x) == x
            @test_throws ErrorException point(x)
        end
    end

    @testset "Spherical" begin
        for dims in [1, 2, 3, 4, 50]
            x0 = ntuple(identity, dims)
            chart = Spherical{dims}()
            ref = Point(chart, x0)
            for x in [x0, SVector(x0), MVector(x0), CartesianIndex(x0), 1:dims, collect(x0)]
                @test point(chart, x) == ref
            end
            @test coordinates(ref) == collect(x0)
            @test point(ref) === ref
        end
    end

    @testset "show" begin
        @test "Point([1, 2])" == repr(point(1, 2))
        @test "Point{Spherical{2}}([1, 2])" == repr(point(Spherical{2}(), 1, 2))
    end
end

@testset "coordinates" begin
    @testset "query" begin
        x = point(Spherical{2}(), (1, pi))
        @test coordinates(x) == [1, pi]
        @test coordinates(Cartesian{2}(), x) ≈ [-1, 0]
        y = point((-1, 0))
        @test coordinates(y) == [-1, 0]
        @test coordinates(Spherical{2}(), y) ≈ [1, pi]

        x̂, ŷ = coordinates.(Cartesian{2}(), (x, y))
        @test x̂ ≈ [-1, 0]
        @test ŷ ≈ [-1, 0]
        x̂, ŷ = coordinates.(Spherical{2}(), (x, y))
        @test x̂ ≈ [1, pi]
        @test ŷ ≈ [1, pi]

        for x in [1, (1, ), [1, ], :symbol, "string"]
            @test x === coordinates(x)
        end
    end

    @testset "conversion" begin
        @testset "Spherical -> Cartesian" begin
            x = point(Spherical{2}(), (1, pi))
            @test coordinates(x) == [1, pi]
            @test coordinates(Cartesian{2}(), x) ≈ [-1, 0]

            y = point(Cartesian{2}(), x)
            @test coordinates(y) ≈ [-1, 0]
            @test x ≈ y
        end
        @testset "Cartesian -> Spherical" begin
            x = point((-1, 0))
            @test coordinates(x) == [-1, 0]
            @test coordinates(Spherical{2}(), x) ≈ [1, pi]

            y = point(Spherical{2}(), x)
            @test coordinates(y) ≈ [1, pi]
            @test x ≈ y
        end
    end
end
