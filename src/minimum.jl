"""
```
t = find_threshold(MinimumIntermodes(),  histogram, edges)
```

Under the assumption that the histogram is bimodal the histogram is smoothed
using a length-3 mean filter until two modes remain. The threshold is then set
to the minimum value between the two modes.

# Output

Returns `t`, a real number that specifies the threshold.

# Arguments

The function arguments are described in more detail below.

##  `histogram`

An `AbstractArray` storing the frequency distribution.

##  `edges`

An `AbstractRange` specifying how the intervals for the frequency distribution
are divided.

# Example

Compute the threshold for the "camerman" image in the `TestImages` package.

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
t = find_threshold(MinimumIntermodes(),counts[1:end], edges)
```

# Reference

1. C. A. Glasbey, “An Analysis of Histogram-Based Thresholding Algorithms,” CVGIP: Graphical Models and Image Processing, vol. 55, no. 6, pp. 532–537, Nov. 1993. [doi:10.1006/cgip.1993.1040](https://doi.org/10.1006/cgip.1993.1040)
"""
function find_threshold(algorithm::MinimumIntermodes, histogram::AbstractArray, edges::AbstractRange)
    histogram_local = smooth_histogram(histogram, 1000)
    indices = find_maxima_indices(histogram_local)
    if length(indices) != 2
        return 0
    end
    t = 0
    min_value = typemax(Float64)
    for i = min(indices[1],indices[2]):max(indices[1],indices[2])
        if histogram_local[i] < min_value
            min_value = histogram_local[i]
            t = i
        end
    end
    index = round(Int, t)
    return edges[index]
end
