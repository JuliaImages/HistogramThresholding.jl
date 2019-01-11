"""
```
t = find_threshold(MinThreshold(),  histogram, edges)
```

Under the assumption that the histogram is bimodal the histogram is smoothed using a length-3 mean filter until 2 modes remain. The threshold is then set to the minimum value between the two modes.

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
function find_threshold(algorithm::MinThreshold, histogram::AbstractArray, edges::AbstractRange)
    histogram_local = smooth_histogram(histogram, 1000)
    indices = find_maxima_indices(histogram_local)
    if length(indices)!=2
        return 0
    end
    t=0
    min_value=typemax(Float64)
    for i = min(indices[1],indices[2]):max(indices[1],indices[2])
        if histogram_local[i]<min_value
            min_value = histogram_local[i]
            t = i
        end
    end
    index = round(Int, t)
    return edges[index]
end
