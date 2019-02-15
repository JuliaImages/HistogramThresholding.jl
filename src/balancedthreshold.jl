"""
```
t = find_threshold(Balanced(), histogram, edges)
```

Balanced histogram thresholding weighs a histogram and compares the overall weight
of each side of the histogram. Each iteration weight is removed from the heavier
side and the start/middle/end points are recalculated. The agorithm continues
untill the start and end points have converged to meet the middle point.

# Output

Returns a real number `t` that specifies the threshold.

# Details

If after the start and end points have converged the final position is at the
initial start or end point then the histogram must have a single peak and has
failed to find a threshold. In this case the algorithm will fall back to using
the `UnimodalRosin` method to select a threshold.

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
t = find_threshold(Balanced(), counts[1:end], edges)
```

# Reference

1. "BI-LEVEL IMAGE THRESHOLDING - A Fast Method", Proceedings of the First International Conference on Bio-inspired Systems and Signal Processing, 2008. Available: [10.5220/0001064300700076](https://doi.org/10.5220/0001064300700076)
"""
function find_threshold(algorithm::Balanced, histogram::AbstractArray, edges::AbstractRange)
    # set initial start/middle/end points and weigths
    Iₛ = 1
    Iₑ = length(histogram)
    Iₘ = round(Int, (Iₛ + Iₑ) / 2)
    Wₗ = 0
    Wᵣ = 0
    for i = 1:Iₘ
        Wₗ += histogram[i]
    end
    for i = Iₘ:Iₑ
        Wᵣ += histogram[i]
    end
    while Iₛ < Iₑ
        if Wₗ < Wᵣ
            Wᵣ -= histogram[Iₑ]
            Iₑ -= 1
            if (Iₛ + Iₑ) / 2 < Iₘ
                Wₗ -= histogram[Iₘ]
                Wᵣ += histogram[Iₘ]
                Iₘ -= 1
            end
        else
            Wₗ -= histogram[Iₛ]
            Iₛ += 1
            if (Iₛ + Iₑ) / 2 > Iₘ
                Wₗ += histogram[Iₘ + 1]
                Wᵣ -= histogram[Iₘ + 1]
                Iₘ += 1
            end
        end
    end
    if Iₘ == 1 || Iₘ == length(histogram)
        @warn "Failed to threshold. Falling back to `UnimodalRosin` method."
        return find_threshold(UnimodalRosin(), histogram, edges)
    else
        return edges[Iₘ]
    end
end
