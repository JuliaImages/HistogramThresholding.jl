@testset "Balanced" begin

    # Call function and determine threshold on some synthetic data.
    samples = map(x->gaussian_mixture(x, P₁ = 0.5, μ₁ = 64, σ₁ = 15, P₂ = 0.5, μ₂ = 192, σ₂ = 15), 0:255)
    edges = 0:255
    t = find_threshold(Balanced(), samples, edges)
    @test t == 128

    # Call function and determine threshold on moonsurface image
    img = testimage("moonsurface")
    edges, counts = build_histogram(img,  256)
    t = find_threshold(Balanced(), counts[1:end], edges)
    @test t ≈ 0.5530790786724538

    # Call function and determine threshold on cameraman image
    img = testimage("cameraman")
    edges, counts = build_histogram(img,  256)
    t = find_threshold(Balanced(), counts[1:end], edges)
    @test t ≈ 0.16796875

    # Same as above, but passing image directly.
    t = find_threshold(img, Balanced(); nbins = 256)
    @test t ≈ 0.16796875

end
