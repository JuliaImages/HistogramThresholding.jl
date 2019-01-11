"""
```
t = find_threshold(Intermodes(),  histogram, edges)
```

Under the assumption that the histogram is bimodal the histogram is smoothed using a length-3 mean filter until 2 modes remain. The threshold is then set to the average value of the two modes.

# Arguments

The function arguments are described in more detail below.

##  `histogram`

An `AbstractArray` storing the frequency distribution.

##  `edges`

An `AbstractRange` specifying how the intervals for the frequency distribution
are divided.

## Reference

C. A. Glasbey, “An Analysis of Histogram-Based Thresholding Algorithms,” CVGIP: Graphical Models and Image Processing, vol. 55, no. 6, pp. 532–537, Nov. 1993. doi:10.1006/cgip.1993.1040
"""
function find_threshold(algorithm::Intermodes, histogram::AbstractArray, edges::AbstractRange)
    histogram_local = smooth_histogram(histogram, 1000)
    indices = find_maxima_indices(histogram_local)
    if length(indices)!=2
        return 0
    end
    index = round(Int, (indices[1] + indices[2]) / 2)
    return edges[index]
end
