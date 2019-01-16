"""
```
t = find_threshold(MinimumIntermodes(), histogram, edges; maxiter = 8000)
```

Under the assumption that the histogram is bimodal the histogram is smoothed
using a length-3 mean filter until two modes remain. The threshold is then set
to the minimum value between the two modes.

# Output

Returns `t`, a real number that specifies the threshold.

# Details

If after `maxiter` iterations the smoothed histogram is still not bimodal then
the algorithm will fall back to using the `UnimodalRosin` method to select
a threshold.

# Arguments

The function arguments are described in more detail below.

##  `histogram`

An `AbstractArray` storing the frequency distribution.

##  `edges`

An `AbstractRange` specifying how the intervals for the frequency distribution
are divided.

## `maxiter`

An `Int` that specifies the maximum number of smoothing iterations. If left
unspecified a default value of 8000 is used.

# Example

Compute the threshold for the "cameraman" image in the `TestImages` package.

```julia
using TestImages, ImageContrastAdjustment, HistogramThresholding

img = testimage("cameraman")
edges, counts = build_histogram(img,256)
#=
  The `counts` array stores at index 0 the frequencies that were below the
  first bin edge. Since we are seeking a threshold over the interval
  partitioned by `edges` we need to discard the first bin in `counts`
  so that the dimensions of `edges` and `counts` match.
=#
t = find_threshold(MinimumIntermodes(), counts[1:end], edges)
```

# Reference

1. C. A. Glasbey, “An Analysis of Histogram-Based Thresholding Algorithms,” *CVGIP: Graphical Models and Image Processing*, vol. 55, no. 6, pp. 532–537, Nov. 1993. [doi:10.1006/cgip.1993.1040](https://doi.org/10.1006/cgip.1993.1040)
2. J. M. S. Prewitt and M. L. Mendelsohn, “THE ANALYSIS OF CELL IMAGES*,” *Annals of the New York Academy of Sciences*, vol. 128, no. 3, pp. 1035–1053, Dec. 2006. [doi:10.1111/j.1749-6632.1965.tb11715.x](https://doi.org/10.1111/j.1749-6632.1965.tb11715.x)
"""
function find_threshold(algorithm::MinimumIntermodes, histogram::AbstractArray, edges::AbstractRange; maxiter::Int = 8000)
    bimodal_histogram = smooth_histogram(histogram, maxiter)
    indices = find_maxima_indices(bimodal_histogram)
    if length(indices) != 2
        warn("Failed to find two modes. Falling back to `UnimodalRosin` method.")
        return find_threshold(UnimodalRosin(), bimodal_histogram, edges)
    else
        t = 0
        min_value = typemax(Float64)
        for i = min(indices[1],indices[2]):max(indices[1],indices[2])
            if bimodal_histogram[i] < min_value
                min_value = bimodal_histogram[i]
                t = i
            end
        end
        index = round(Int, t)
        return edges[index]
    end
end
