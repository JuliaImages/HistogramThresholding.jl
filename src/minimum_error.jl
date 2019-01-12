
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
function find_threshold(algorithm::MinimumError, histogram::AbstractArray, edges::AbstractRange)

  startindex = first(axes(histogram, 1))
  endindex = last(axes(histogram, 1))
  totalpx = sum(Float64,histogram)

  μ₁P₁list = calculate_μ₁P₁(histogram, startindex, endindex, edges)
  μ₁P₁list_sum = sum(μ₁P₁list)

  P₁ = 0.0
  μ₁P₁ = 0.0
  minJvalue = typemax(Float64)
  minJindex = startindex

  for threshold = startindex:endindex

    P₁ += histogram[threshold]
    P₂ = totalpx - P₁

    μ₁P₁ += μ₁P₁list[threshold]
    μ₁ = μ₁P₁ / P₁
    μ₂ = (μ₁P₁list_sum - μ₁P₁) / P₂

    σ²₁ = calculate_σ²₁P₁(threshold, μ₁, histogram, startindex, edges) / P₁
    σ²₂ = calculate_σ²₂P₂(threshold, μ₂, histogram, endindex, edges) / P₂

    J = 1.0
    if (P₁ != 0.0 && σ²₁ != 0.0)
      J += 2P₁ * log(sqrt(σ²₁) / P₁)
    end
    if (P₂ != 0.0 && σ²₂ != 0.0)
      J += 2P₂ * log(sqrt(σ²₂) / P₂)
    end

    if (J < minJvalue)
      minJvalue = J
      minJindex = threshold
    end
  end
  edges[minJindex]
end

function calculate_μ₁P₁(histogram, startindex, endindex, edges)
  μ₁P₁list = zeros(Float64, startindex:endindex)
  for g = startindex:endindex
    μ₁P₁list[g] = histogram[g] * edges[g]
  end
  μ₁P₁list
end

function calculate_σ²₁P₁(threshold, μ₁, histogram, startindex, edges)
  σ²₁P₁ = 0.0
  for g = startindex:threshold
    σ²₁P₁ += (edges[g] - μ₁)^2 * histogram[g]
  end
  σ²₁P₁
end

function calculate_σ²₂P₂(threshold, μ₂, histogram, endindex, edges)
  σ²₂P₂ = 0.0
  for g = (threshold + 1):endindex
    σ²₂P₂ += (edges[g] - μ₂)^2 * histogram[g]
  end
  σ²₂P₂
end
