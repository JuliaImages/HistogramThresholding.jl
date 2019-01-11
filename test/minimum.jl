@testset "minimum" begin

    # Call function and determine threshold on some synthetic data.
    samples = map(x->gaussian_mixture(x, P₁ = 0.5, μ₁ = 64, σ₁ = 15, P₂ = 0.5, μ₂ = 192, σ₂ = 15), 0:255)
    edges = 0:255
    t = find_threshold(MinThreshold(), samples, edges)
    @test t == 128

    # Call function and determine threshold on cameraman image for which we know
    # what the correct threshold should be (based on implementation in other projects).
    img = testimage("cameraman")
    edges, counts = build_histogram(img,  256)
    t = find_threshold(MinThreshold(), counts[1:end], edges)
    @test t == 0.296875


end
