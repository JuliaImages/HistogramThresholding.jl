"""
```
t = find_threshold(Otsu(),  histogram, edges)
```

Under the assumption that the histogram is bimodal the threshold is
set so that the resultant inter-class variance is maximal.

# Arguments

The function arguments are described in more detail below.

##  `histogram`

An `AbstractArray` storing the frequency distribution.

##  `edges`

An `AbstractRange` specifying how the intervals for the frequency distribution
are divided.

## Reference

Nobuyuki Otsu (1979). "A threshold selection method from gray-level histograms". *IEEE Trans. Sys., Man., Cyber.* 9 (1): 62–66. [doi:10.1109/TSMC.1979.4310076](http://dx.doi.org/doi:10.1109/TSMC.1979.4310076)
"""
function find_threshold(algorithm::Otsu,  histogram::AbstractArray, edges::AbstractRange)
  N = sum(histogram)
  pdf = histogram / N
  histogram_indices = first(axes(pdf))
  first_bin = first(histogram_indices)
  last_bin = last(histogram_indices)
  zeroth_cummulative_moment = cumsum(pdf)
  first_cummulative_moment = cumsum((first_bin:last_bin) .* pdf)
  μ_T = first_cummulative_moment[end]
  σ²_T = sum( ((first_bin:last_bin) .- μ_T).^2  .* pdf )
  maxval = zero(eltype(first(pdf)))

  # Equation (6) for determining the probability of the first class.
  function ω(k)
    let zeroth_cummulative_moment = zeroth_cummulative_moment
      return zeroth_cummulative_moment[k]
    end
  end

  # Equation (7) for determining the mean of the first class.
  function μ(k)
   let first_cummulative_moment = first_cummulative_moment
     return first_cummulative_moment[k]
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
