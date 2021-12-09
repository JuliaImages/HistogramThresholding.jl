
@doc raw"""
```
t = find_threshold(histogram, edges, MinimumError())
t = find_threshold(img, MinimumError(); nbins = 256)
```

Under the assumption that the histogram is a mixture of two Gaussian
distributions the threshold is chosen such that the expected misclassification
error rate is minimised.

# Output

Returns a real number `t` in `edges`. The `edges` parameter represents an
`AbstractRange` which specifies the intervals associated with the histogram bins.

# Extended help 

# Details

Let ``f_i`` ``(i=1 \ldots I)`` denote the number of observations in the
``i``th bin of the histogram. Then the probability that an observation
belongs to the ``i``th bin is given by  ``p_i = \frac{f_i}{N}`` (``i = 1,
\ldots, I``), where ``N = \sum_{i=1}^{I}f_i``.

The minimum error thresholding method assumes that one can find a threshold
``T`` which partitions the data into two categories,  ``C_0`` and ``C_1``, such that
the data can be modelled by a mixture of two Gaussian distribution. Let
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

Kittler and Illingworth proposed to use the minimum error criterion function
```math
J(T) = 1 + 2 \left[ P_0(T) \ln \sigma_0(T) + P_1(T) \ln \sigma_1(T) \right] - 2 \left[P_0(T) \ln P_0(T) + P_1(T) \ln P_1(T) \right]
```
to assess the discreprancy between the mixture of Gaussians implied by a particular threshold ``T``,
and the piecewise-constant probability density function represented by the histogram.
The discrete value ``T`` which minimizes the function ``J(T)`` produces
the sought-after threshold value (i.e. the bin which determines the threshold).

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
t = find_threshold(counts[1:end], edges, MinimumError())
```

# References

1. J. Kittler and J. Illingworth, “Minimum error thresholding,” Pattern Recognition, vol. 19, no. 1, pp. 41–47, Jan. 1986. [doi:10.1016/0031-3203(86)90030-0](https://doi.org/10.1016/0031-3203%2886%2990030-0)
2. Q.-Z. Ye and P.-E. Danielsson, “On minimum error thresholding and its implementations,” Pattern Recognition Letters, vol. 7, no. 4, pp. 201–206, Apr. 1988. [doi:10.1016/0167-8655(88)90103-1](https://doi.org/10.1016/0167-8655%2888%2990103-1)
"""
struct MinimumError <: AbstractThresholdAlgorithm end

function (::MinimumError)(histogram::AbstractArray, edges::AbstractRange)
    frequencies = cumsum(histogram)
    X = cumsum(edges .* histogram)
    X² = cumsum(edges.^2 .* histogram)
    𝔼X₁, 𝔼X₁², 𝔼X₂, 𝔼X₂² = compute_expectations(frequencies, X, X²)
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

#=
  If the histogram consists of integers then we risk integer overflow when we
  take the cumulative sums. Hence, we explicitlty convert the histogram to
  Float.
=#
function (minimum_error::MinimumError)(histogram::AbstractArray{T}, edges::AbstractRange) where T <: Int
    minimum_error(convert.(Float64, histogram), edges)
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
