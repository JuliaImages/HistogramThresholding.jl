@testset "moments" begin

img = testimage("cameraman")
edges, counts = build_histogram(reinterpret.(gray.(img)), 0:1:255)
t1 = find_threshold(Moments(),counts[1:end], 0:1:255)
@test t1 == 111

# This replicates a test described in the original publication. 
arr = [10  8 10  9 20 21 32 30 40 41 41 40;
       12 10 11 10 19 20 30 28 38 40 40 39;
       10  9 10  8 20 21 30 29 42 40 40 39;
       11 10  9 11 19 21 31 30 40 42 38 40]
edges, counts = build_histogram(arr, 0:255)
t2 = find_threshold(Moments(), counts[1:end], edges)
@test t2 == 27

# This test reaches into the internals of the implementation to verify that
# the moments are indeed preserved.
m₀ = 1.0
m₁, m₂, m₃ =  HistogramThresholding.compute_moments(counts[1:end], edges, sum(counts[1:end]))
c₀, c₁ = HistogramThresholding.compute_auxiliary_values(m₀, m₁, m₂, m₃)
z₀, z₁ = HistogramThresholding.compute_gray_levels(c₀, c₁)
p₀, p₁ = HistogramThresholding.compute_pixel_fractions(z₀, z₁, m₁)
m₁₀, m₁₁, m₁₂, m₁₃ = HistogramThresholding.preserved_moments(p₀, z₀, p₁, z₁)
@test m₀ ≈ m₁₀
@test m₁ ≈ m₁₁
@test m₂ ≈ m₁₂
@test m₃ ≈ m₁₃

end
