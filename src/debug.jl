using Images, TestImages, HistogramThresholding


function gaussian(z;P₁,μ₁,σ₁)
    (P₁ / (σ₁*√(2*π))) * exp( -(z-μ₁)^2 / (2*σ₁^2) )
end

function surge(t;A,k)
    A*t*exp(-k*t)
end


# FInd threshold for moon surface image
img = testimage("moonsurface")
edges, counts = build_histogram(img,256)
index = find_threshold(UniThreshold(),counts[1:end], edges)
t = edges[index]

#= FInd threshold for synthetic data
edges = 0:255
counts = collect(255:-1:0)
counts[2] = 1
counts[100] = 10
counts[150] = 0
index = find_threshold(UniThreshold(),counts, edges)
=#

# Making bin after max very low
edges = 0:255
samples = collect(255:-1:0)
samples[2] = 1
samples
t = find_threshold(UniThreshold(),samples,edges)

# Surge Function (also technically a test for no 0 bins as well)
edges = 0:255
samples = map(x->surge(x, A = 20 ,k=0.04),edges)
t = find_threshold(UniThreshold(),samples,edges)

# multiple zero bins

samples = fill(10,256)
samples[5] = 5
samples[100] = 0
samples[120] = 1
samples[150] = 0
t = find_threshold(UniThreshold(),samples,edges)

# Different number of bins

edges = 0:200
samples = collect(200:-1:0)
samples[2] = 1
t = find_threshold(UniThreshold(),samples,edges)



# binarises the image
img_binary = map(img) do val
    if val < t
        return Gray(0)
    else
        return Gray(1)
    end
end
# displays it
img_binary
