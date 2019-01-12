@testset "minimum_error" begin

    samples = map(x->gaussian_mixture(x, P₁ = 0.5, μ₁ = 64, σ₁ = 15, P₂ = 0.5, μ₂ = 192, σ₂ = 15), 0:255)
    edges = 0:255
    t = find_threshold(MinimumError(), round.(Int,samples * 10^10), edges)
    @test t == 128
    t = find_threshold(MinimumError(), samples, edges)
    @test t == 128

    # Replicates the result of Figure 2 in the original paper of Kittler and Illingworth.
    samples = map(x->gaussian_mixture(x, P₁ = 0.5, μ₁ = 50, σ₁ = 4, P₂ = 0.5, μ₂ = 150, σ₂ = 30), 0:255)
    edges = 0:255
    t = find_threshold(MinimumError(), ceil.(Int,samples * 10^10), edges)
    @test t == 64
    t = find_threshold(MinimumError(), samples, edges)
    @test t == 64

    img = testimage("cameraman")
    # Uses the underlying UInt8 type when counting the intensity frequencies.
    edges, counts = build_histogram(reinterpret.(gray.(img)), 0:1:255)
    t = find_threshold(MinimumError(),counts[1:end], 0:1:255)
    @test t == 25
end
