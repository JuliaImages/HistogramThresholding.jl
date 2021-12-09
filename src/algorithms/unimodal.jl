"""
```
t = find_threshold(histogram, edges, UnimodalRosin())
t = find_threshold(img, UnimodalRosin(); nbins = 256)
```

Generates a threshold assuming a unimodal distribution using Rosin's algorithm.

# Output

Returns a real number `t` in `edges`. The `edges` parameter represents an
`AbstractRange` which specifies the intervals associated with the histogram bins.

# Extended help 

# Details
This algorithm first selects the bin in the histogram with the highest
frequency. The algorithm then searches from the location of the maximum bin to
the last bin of the histogram for the first bin with a frequency of 0 (known as
the minimum bin.). A line is then drawn that passes through both the maximum and
minimum bins. The bin with the greatest orthogonal distance to the line is
chosen as the threshold value.


## Assumptions
This algorithm assumes that:

* The histogram is unimodal.
* There is always at least one bin that has a frequency of 0. If not, the algorithm will use the last bin as the minimum bin.

If the histogram includes multiple bins with a frequency of 0, the algorithm
will select the first zero bin as its minimum. If there are multiple bins with
the greatest orthogonal distance, the leftmost bin is selected as the threshold.

# Arguments

The function arguments are described in more detail below.

##  `histogram`

An `AbstractArray` storing the frequency distribution.

##  `edges`

An `AbstractRange` specifying how the intervals for the frequency distribution
are divided.

# Example

Compute the threshold for the "moonsurface" image in the `TestImages` package.

```julia
using TestImages, ImageContrastAdjustment, HistogramThresholding

img = testimage("moonsurface")
edges, counts = build_histogram(img,256)
#=
  The `counts` array stores at index 0 the frequencies that were below the
  first bin edge. Since we are seeking a threshold over the interval
  partitioned by `edges` we need to discard the first bin in `counts`
  so that the dimensions of `edges` and `counts` match.
=#
t = find_threshold(counts[1:end], edges, UnimodalRosin())
```

# Reference
1. P. L. Rosin, “Unimodal thresholding,” Pattern Recognition, vol. 34, no. 11, pp. 2083–2096, Nov. 2001.[doi:10.1016/s0031-3203(00)00136-9](https://doi.org/10.1016/s0031-3203%2800%2900136-9)
"""
struct UnimodalRosin <: AbstractThresholdAlgorithm end

function (::UnimodalRosin)(histogram::AbstractArray, edges::AbstractRange)
    #=
      Calculates the orthogonal distance between the line (slope m,
      y-intercept c), and the point (coordinates x₀, y₀).
    =#
    function calculate_distance(m::Real, c::Real, x₀::Real, y₀::Real)
        abs(m*x₀ + -1*y₀ + c) / sqrt((m)^2 + 1)
    end

    # Finds the index & value of the bin with highest value.
    max_val, max_index = findmax(histogram)

    # Initialise minimum bin index.
    min_index = 1
    found_min = false

    # Find the first zero bin.
    for j in max_index:lastindex(histogram)
        if histogram[j] == 0.0
            min_index = j
            found_min = true
            break
        end
    end

    # If no zero bin is found, use the last bin.
    if found_min == false
        min_index = lastindex(histogram)
    end

    # Find slope and y-intercept of the line.
    m = max_val / (max_index - min_index)
    c = -m*min_index

    # Initialise the maximum bin as having the inital greatest distance.
    t = max_index
    max_distance = calculate_distance(m, c, t, histogram[t])

    # Find bin with the greatest distance.
    for k in max_index:min_index
        if calculate_distance(m, c, k, histogram[k]) > max_distance
            max_distance = calculate_distance(m, c, k, histogram[k])
            t = k
        end
    end

    # Return the threshold corresponding to the greatest distance.
    return edges[t]
end
