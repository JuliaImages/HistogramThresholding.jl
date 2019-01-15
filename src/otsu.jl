"""
```
t = find_threshold(Otsu(),  histogram, edges)
```

Under the assumption that the histogram is bimodal the threshold is
set so that the resultant inter-class variance is maximal.

# Output

Returns a real number `t` that specifies the threshold.

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
t = find_threshold(Otsu(),counts[1:end], edges)
```

# Reference

1. Nobuyuki Otsu (1979). "A threshold selection method from gray-level histograms". *IEEE Trans. Sys., Man., Cyber.* 9 (1): 62–66. [doi:10.1109/TSMC.1979.4310076](http://dx.doi.org/doi:10.1109/TSMC.1979.4310076)
"""
function find_threshold(algorithm::Otsu,  histogram::AbstractArray, edges::AbstractRange)
  N = sum(histogram)
  pdf = histogram / N
  histogram_indices = first(axes(pdf))
  first_bin = first(histogram_indices)
  last_bin = last(histogram_indices)
  cumulative_zeroth_moment = cumsum(pdf)
  cumulative_first_moment = cumsum(edges .* pdf)
  μ_T = cumulative_first_moment[end]
  σ²_T = sum( ((first_bin:last_bin) .- μ_T).^2  .* pdf )
  maxval = zero(eltype(first(pdf)))

  # Equation (6) for determining the probability of the first class.
  function ω(k)
    let cumulative_zeroth_moment = cumulative_zeroth_moment
      return cumulative_zeroth_moment[k]
    end
  end

  # Equation (7) for determining the mean of the first class.
  function μ(k)
   let cumulative_first_moment = cumulative_first_moment
     return cumulative_first_moment[k]
   end
  end

  # Equation (18) for determining the between-cass variance.
  function σ²(k)
    let μ_T = μ_T
      return (μ_T*ω(k) - μ(k))^2 / (ω(k) * (1-ω(k)))
    end
  end

  t = first_bin
  for k = first_bin:last_bin - 1
    val = σ²(k)
    if val  > maxval
       maxval = val
       t = k
    end
  end
  return edges[t]
end
