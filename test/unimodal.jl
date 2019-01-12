@testset "unimodal" begin
    #= Tests a histogram in which the bin directly following the maximum has an
    intensity of 1,therefore making the distance from the second bin to
    the line always the longest
    =#
    edges = 0:255
    samples = collect(255:-1:0)
    samples[2] = 1
    t = find_threshold(UnimodalRosin(),samples,edges)
    @test t == 1

    # Tests using a unimodal test image from the TestImages package
    img = testimage("moonsurface")
    edges, samples = build_histogram(img,256)
    t = find_threshold(UnimodalRosin(),samples, edges)
    @test t == 0.5530790786724538

    #= Tests a histogram that resembles a unimodal image, using a
    surge function. Also tests the scenario in which there are no bins
    with an intensity of 0. In this case, the algorithm should use the
    last bin as the minimum.
    =#
    edges = 0:255
    samples = map(x->surge(x, A = 20 ,k=0.04),edges)
    t = find_threshold(UnimodalRosin(),samples,edges)
    @test t == 112

    edges = 0:200
    samples = collect(200:-1:0)
    samples[2] = 1
    t = find_threshold(UnimodalRosin(),samples,edges)
    @test t == 1
end
