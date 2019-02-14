@testset "yen" begin

    # Call function and determine threshold on some synthetic data.
    samples = map(x->gaussian_mixture(x, P₁ = 0.5, μ₁ = 64, σ₁ = 15, P₂ = 0.5, μ₂ = 192, σ₂ = 15), 0:255)
    edges = 0:255
    t = find_threshold(Yen(), samples, edges)
    @test t == 127

    edges = 0:255
    samples = map(x->surge(x, A = 20 ,k=0.04),edges)
    t = find_threshold(Yen(), samples, edges)
    @test t == 134

    # Call function and determine threshold on lana image for which we know
    # what the correct threshold should be (based on an implementation in
    # another project).
    img = testimage("lena_gray_512")
    edges, counts = build_histogram(img,  256)
    t = find_threshold(Yen(), counts[1:end], edges)
    @test round(t*256) == 120

end
