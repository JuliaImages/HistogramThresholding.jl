@testset "entropy_thresholding" begin
    img = testimage("cameraman")
    edges, histogram = build_histogram(img,256)
    @test_throws ErrorException find_threshold(Entropy(),histogram,edges)
    @test find_threshold(Entropy(),histogram[1:256],edges) == 0.76171875

    img = testimage("mandril_gray")
    edges, histogram = build_histogram(img,256)
    @test find_threshold(Entropy(),histogram[1:256],edges) == 0.408517187461257

end
