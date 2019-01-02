# Minimum error method

using HistogramThresholding

function find_threshold(algorithm::MinError, histogram::AbstractArray, edges::AbstractRange)

  len = length(edges)
  totalpx = sum(histogram)

  μ₁P₁list = calc_μ₁P₁(histogram, len)
  μ₁P₁list_sum = sum(μ₁P₁list)

  P₁ = 0
  μ₁P₁ = 0
  minJvalue = nothing
  minJindex = nothing

  for threshold = 1:len

    P₁ += histogram[threshold]
    P₂ = totalpx - P₁

    μ₁P₁ += μ₁P₁list[threshold]
    μ₁ = μ₁P₁/P₁
    μ₂ = (μ₁P₁list_sum - μ₁P₁)/P₂

    σ²₁ = calc_σ²₁P₁(threshold, μ₁, histogram)/P₁
    σ²₂ = calc_σ²₂P₂(threshold, μ₂, histogram, len)/P₂

    J = 1
    if (P₁ != 0 && σ²₁ != 0)
      J += 2P₁ * log(sqrt(σ²₁)/P₁)
    end
    if (P₂ != 0 && σ²₂ != 0)
      J += 2P₂ * log(sqrt(σ²₂)/P₂)
    end

    if (minJvalue == nothing || J < minJvalue)
      minJvalue = J
      minJindex = threshold
    end
  end
  minJindex
end

function calc_μ₁P₁(histogram, len)
  μ₁P₁list = zeros(len)
  for g = 1:len
    μ₁P₁list[g] = histogram[g] * (g - 1)
  end
  μ₁P₁list
end

function calc_σ²₁P₁(threshold, μ₁, histogram)
  σ²₁P₁ = 0
  for g = 1:threshold
    σ²₁P₁ += ((g - 1) - μ₁)^2 * histogram[g]
  end
  σ²₁P₁
end

function calc_σ²₂P₂(threshold, μ₂, histogram, len)
  σ²₂P₂ = 0
  for g = (threshold + 1):len
    σ²₂P₂ += ((g - 1) - μ₂)^2 * histogram[g]
  end
  σ²₂P₂
end
