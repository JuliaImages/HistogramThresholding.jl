
"""
```
t = find_threshold(MinimumError(),  histogram, edges)
```

Under the assumption that the histogram is a mixture of two Gaussian
distributions the threshold is chosen such that the expected misclassification
error rate is minimised.

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
t = find_threshold(MinimumError(),counts[1:end], edges)
```

# References

1. J. Kittler and J. Illingworth, “Minimum error thresholding,” Pattern Recognition, vol. 19, no. 1, pp. 41–47, Jan. 1986. [doi:10.1016/0031-3203(86)90030-0](https://doi.org/10.1016/0031-3203%2886%2990030-0)
2. Q.-Z. Ye and P.-E. Danielsson, “On minimum error thresholding and its implementations,” Pattern Recognition Letters, vol. 7, no. 4, pp. 201–206, Apr. 1988. [doi:10.1016/0167-8655(88)90103-1](https://doi.org/10.1016/0167-8655%2888%2990103-1)
"""
function find_threshold(algorithm::MinimumError, _histogram::AbstractArray, edges::AbstractRange)
  # If the histogram consists of integers then we risk integer overflow when we
  # take the cumulative sums. Hence, we explicitlty convert the histogram to
  # Float.
  histogram = convert.(Float64, _histogram)
  frequencies = cumsum(histogram)
  X = cumsum(edges .* histogram)
  X² = cumsum(edges.^2 .* histogram)
  𝔼X₁, 𝔼X₁², 𝔼X₂, 𝔼X₂² = compute_expectations(frequencies, X, X²)
  # Debug Win32 overflow error
  @show minimum(frequencies), maximum(frequencies), frequencies[end], eltype(frequencies)
  @show minimum(X), maximum(X), X[end], eltype(X)
  @show minimum(X²), maximum(X²), X²[end], eltype(X²)
  @show minimum(𝔼X₁), maximum(𝔼X₁), 𝔼X₁[end], eltype(𝔼X₁)
  @show minimum(𝔼X₁²), maximum(𝔼X₁²), 𝔼X₁²[end], eltype(𝔼X₁²)
  @show minimum(𝔼X₂), maximum(𝔼X₂), 𝔼X₂[end], eltype(𝔼X₂)
  @show minimum(𝔼X₂²), maximum(𝔼X₂²), 𝔼X₂²[end], eltype(𝔼X₂²)


  minJ = typemax(Float64)
  index = firstindex(frequencies)
  for t =  firstindex(frequencies):lastindex(frequencies)-1
      P₁ = max(frequencies[t] / frequencies[end], eps())
      P₂ = 1 - P₁
      # Var(X) = E[X²] - E[X]² = E[X²] - μ²
      σ₁ = sqrt(max(𝔼X₁²[t] - 𝔼X₁[t]^2, eps()))
      σ₂ = sqrt(max(𝔼X₂²[t] - 𝔼X₂[t]^2, eps()))
      J = 1 + 2*(P₁*log(σ₁) + P₂*log(σ₂)) - 2*(P₁*log(P₁)+ P₂*log(P₂))
      if (J < minJ && isfinite(J))
        minJ = J
        index = t
      end
  end
  edges[index]
end

function compute_expectations(frequencies, X, X²)
  dimensions = axes(frequencies)
  𝔼X₁ = zeros(dimensions)
  𝔼X₁² = zeros(dimensions)
  𝔼X₂ = zeros(dimensions)
  𝔼X₂² = zeros(dimensions)
  for i = firstindex(X):lastindex(X)-1
    𝔼X₁[i] = X[i] / frequencies[i]
    𝔼X₁²[i] = X²[i] / frequencies[i]
    𝔼X₂[i] = (X[end] - X[i]) /  (frequencies[end] - frequencies[i])
    𝔼X₂²[i] = (X²[end] - X²[i]) /  (frequencies[end] - frequencies[i])
  end
  𝔼X₁, 𝔼X₁², 𝔼X₂, 𝔼X₂²
end
