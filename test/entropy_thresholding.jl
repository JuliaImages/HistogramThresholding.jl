@testset "entropy_thresholding" begin
    img = testimage("cameraman")
    edges, histogram = build_histogram(img,256)
    @test_throws ErrorException find_threshold(Entropy(),histogram,edges)
    @test find_threshold(Entropy(),histogram[1:256],edges) ≈ 0.76171875

    img = testimage("mandril_gray")
    edges, histogram = build_histogram(img,256)
    @test find_threshold(Entropy(),histogram[1:256],edges) ≈ 0.408517187461257

    # Same as above, but passing image directly.
    t = find_threshold(img, Entropy(); nbins = 256)
    @test t ≈ 0.408517187461257

    # There are some performance tweaks, make sure generic arrays are not broken.
    f(counts) = find_threshold(Entropy(),counts,edges)
    @test f(view(histogram, 1:256)) ==
          f(view(SVector{257}(collect(histogram)), 2:257)) ==
          f(SVector{256}(histogram[1:256])) ==
          f(histogram[1:256])
end
