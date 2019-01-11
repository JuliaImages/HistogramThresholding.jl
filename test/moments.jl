@testset "moments" begin

# Build histogram from an image correctly and compare the threshold to the answer
# from another implementation.
img = testimage("cameraman")
imgg = gray.(img)
imgg_uint8 = reinterpret.(imgg)
edges, counts = build_histogram(imgg_uint8, 0:1:255)
t1 = find_threshold(Moments(),counts[1:end], 0:1:255)
@test t1 == 111

# Build a histogram from an array and compare the threshold to that in another
# implementation.
arr = [10  8 10  9 20 21 32 30 40 41 41 40;
       12 10 11 10 19 20 30 28 38 40 40 39;
       10  9 10  8 20 21 30 29 42 40 40 39;
       11 10  9 11 19 21 31 30 40 42 38 40]
edges, counts = build_histogram(arr, 0:255)
t2 = find_threshold(Moments(), counts[1:end], edges)
@test t2 == 27

end
