@testset "entropy_thresholding" begin
    img = testimage("cameraman")
    edges, histogram = build_histogram(img,256)
    @test_throws ErrorException find_threshold(EntropyThresholding(),histogram,edges)
    @test find_threshold(EntropyThresholding(),histogram[1:256],edges) == 0.76171875
end
