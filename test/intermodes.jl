@testset "intermodes" begin

    # Call function and determine threshold on some synthetic data.
    samples = map(x->gaussian_mixture(x, P₁ = 0.5, μ₁ = 64, σ₁ = 15, P₂ = 0.5, μ₂ = 192, σ₂ = 15), 0:255)
    edges = 0:255
    t = find_threshold(Intermodes(), samples, edges)
    @test t == 128

    edges = 0:255
    samples = map(x->surge(x, A = 20 ,k=0.04),edges)
    t = find_threshold(Intermodes(), samples, edges)
    @test t == 112

    # Call function and determine threshold on cameraman image for which we know
    # what the correct threshold should be (based on an implementation in
    # another project).
    img = testimage("cameraman")
    edges, counts = build_histogram(img,  256)
    t = find_threshold(Intermodes(), counts[1:end], edges)
    @test t ≈ 0.34765625

    # Same as above, but passing image directly.
    t = find_threshold(img, Intermodes(); nbins = 256)
    @test t ≈  0.34765625
end
