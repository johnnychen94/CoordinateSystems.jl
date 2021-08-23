@testset "CoordinateSystem" begin
    @testset "Cartesian" begin
        M2 = @inferred Cartesian{2}()
        @test ndims(M2) == 2
        M3 = @inferred Cartesian{3}()
        @test ndims(M3) == 3
        @test M2 != M3
        @test_throws MethodError Cartesian()
    end

    @testset "Spherical" begin
        M2 = @inferred Spherical{2}()
        @test ndims(M2) == 2
        M3 = @inferred Spherical{3}()
        @test ndims(M3) == 3
    end

    @testset "transition_map" begin
        @testset "Cartesian <-> Spherical" begin
            for dims in [0, 1, 2, 3, 5, 10, 50]
                M, N = Cartesian{dims}(), Spherical{dims}()
                ϕ = transition_map(M, N)
                ϕ⁻¹ = transition_map(N, M)

                x = rand(dims)
                y = @inferred ϕ(x)
                @test y isa Vector
                x̂ = ϕ⁻¹(y)
                @test x̂ ≈ x

                # Ensure our performance tweak for SVector is numerically correct
                x = SVector{dims}(x)
                sy = @inferred ϕ(x)
                @test sy isa Union{SVector, MVector}
                @test y ≈ sy
                x̂ = ϕ⁻¹(y)
                @test x̂ ≈ x

                # maps origin to origin
                @test ϕ(zeros(dims)) ≈ zeros(dims)
                @test ϕ⁻¹(zeros(dims)) ≈ zeros(dims)
            end
        end
    end
end
