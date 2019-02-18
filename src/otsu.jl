@doc raw"""
```
t = find_threshold(Otsu(), histogram, edges)
```

Under the assumption that the histogram is bimodal the threshold is
set so that the resultant between-class variance is maximal.

# Output

Returns a real number `t` in `edges`. The `edges` parameter represents an
`AbstractRange` which specifies the intervals associated with the histogram bins.


# Details

Let ``f_i`` ``(i=1 \ldots I)`` denote the number of observations in the
``i``th bin of the histogram. Then the probability that an observation
belongs to the ``i``th bin is given by  ``p_i = \frac{f_i}{N}`` (``i = 1,
\ldots, I``), where ``N = \sum_{i=1}^{I}f_i``.

The choice of a threshold ``T`` partitions the data into two categories, ``C_0``
and ``C_1``. Let
```math
P_0(T) = \sum_{i = 1}^T p_i \quad \text{and} \quad P_1(T) = \sum_{i = T+1}^I p_i
```
denote the cumulative probabilities,
```math
\mu_0(T) = \sum_{i = 1}^T i \frac{p_i}{P_0(T)} \quad \text{and} \quad \mu_1(T) = \sum_{i = T+1}^I i \frac{p_i}{P_1(T)}
```
denote the means, and
```math
\sigma_0^2(T) = \sum_{i = 1}^T (i-\mu_0(T))^2 \frac{p_i}{P_0(T)} \quad \text{and} \quad \sigma_1^2(T) = \sum_{i = T+1}^I (i-\mu_1(T))^2 \frac{p_i}{P_1(T)}
```
denote the variances of categories ``C_0`` and ``C_1``, respectively.
Furthermore, let
```math
\mu = P_0(T)\mu_0(T) + P_1(T)\mu_1(T),
```
represent the overall mean,
```math
\sigma_b^2(T) = P_0(T)(\mu_0(T) - \mu)^2 + P_1(T)(\mu_1(T) - \mu)^2,
```
the between-category variance, and
```math
\sigma_w^2(T) = P_0(T) \sigma_0^2(T) +  P_1(T)\sigma_1^2(T)
```
the within-category variance, respectively.

Finding the discrete value ``T`` which maximises the function ``\sigma_b^2(T)``
produces the sought-after threshold value (i.e. the bin which determines the
threshold). As it turns out, that threshold value is equal to the threshold
decided by minimizing the within-category variances criterion ``\sigma_w^2(T)``.
Furthermore, that threshold is also the same as the threshold calculated by
maximizing the ratio of between-category variance to within-category variance.

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
edges, counts = build_histogram(img,256)
#=
  The `counts` array stores at index 0 the frequencies that were below the
  first bin edge. Since we are seeking a threshold over the interval
  partitioned by `edges` we need to discard the first bin in `counts`
  so that the dimensions of `edges` and `counts` match.
=#
t = find_threshold(Otsu(), counts[1:end], edges)
```

# Reference

1. Nobuyuki Otsu (1979). “A threshold selection method from gray-level histograms”. *IEEE Trans. Sys., Man., Cyber.* 9 (1): 62–66. [doi:10.1109/TSMC.1979.4310076](http://dx.doi.org/doi:10.1109/TSMC.1979.4310076)
"""
function find_threshold(algorithm::Otsu,  histogram::AbstractArray, edges::AbstractRange)
  N = sum(histogram)
  pdf = histogram / N
  first_bin = firstindex(pdf)
  last_bin = lastindex(pdf)
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
