@doc raw"""
```
t = find_threshold(Balanced(), histogram, edges)
```

Computes the threshold value using Yen's maximum corrilation criterion for
bileval thresholding.

# Output

Returns a real number `t` that specifies the threshold.

# Details

The algorithm computes the corilation between the two sides of the threshold and
attempts to maximize the corilation. The corrilation is defined as ``C(X)=-\ln{
\sum\limits_{i \ge 0} p_i^2}``.

# Arguments

The function arguments are described in more detail below.

##  `histogram`

An `AbstractArray` storing the frequency distribution.

##  `edges`

An `AbstractRange` specifying how the intervals for the frequency distribution
are divided.

# Example

Compute the threshold for the "cameraman" image in the `TestImages` package.

```julia

using TestImages, ImageContrastAdjustment, HistogramThresholding

img = testimage("cameraman")
edges, counts = build_histogram(img, 256)
#=
  The `counts` array stores at index 0 the frequencies that were below the
  first bin edge. Since we are seeking a threshold over the interval
  partitioned by `edges` we need to discard the first bin in `counts`
  so that the dimensions of `edges` and `counts` match.
=#
t = find_threshold(Yen(), counts[1:end], edges)
```

# Reference

1. Yen JC, Chang FJ, Chang S (1995), "A New Criterion for Automatic Multilevel Thresholding", IEEE Trans. on Image Processing 4 (3): 370-378, [doi:10.1109/83.366472](https://doi.org/10.1109/83.366472)
"""
function find_threshold(algorithm::Yen, histogram::AbstractArray, edges::AbstractRange)
    total = sum(histogram)
    m = length(histogram)
    p = zeros(m)

    # calulate probability
    for i in eachindex(p)
        p[i] = histogram[i]/total
    end

    # setup sums
    Pₛ = 0
    Gₛ = 0
    G′ₛ = sum(p.^2)
    max_TC = typemin(Float64)
    t = 0
    for s in eachindex(p[1:m-1])
        # update sums
        Pₛ += p[s]
        Gₛ += p[s]^2
        G′ₛ -= p[s]^2

        # calculate TC
        TC = -log(Gₛ * G′ₛ) + 2 * log(Pₛ * (1 - Pₛ))
        if TC > max_TC
            max_TC = TC
            t = s
        end
    end

    return edges[t]
end
