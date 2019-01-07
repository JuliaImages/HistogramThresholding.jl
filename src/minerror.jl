# Minimum error method

using HistogramThresholding

function find_threshold(algorithm::MinError, histogram::AbstractArray, edges::AbstractRange)

  startindex = first(axes(histogram, 1))
  endindex = last(axes(histogram, 1))
  totalpx = sum(histogram)

  μ₁P₁list = calculate_μ₁P₁(histogram, startindex, endindex)
  μ₁P₁list_sum = sum(μ₁P₁list)

  P₁ = 0.0
  μ₁P₁ = 0.0
  minJvalue = typemax(Float64)
  minJindex = startindex

  for threshold = startindex:endindex

    P₁ += histogram[threshold]
    P₂ = totalpx - P₁

    μ₁P₁ += μ₁P₁list[threshold]
    μ₁ = μ₁P₁/P₁
    μ₂ = (μ₁P₁list_sum - μ₁P₁)/P₂

    σ²₁ = calculate_σ²₁P₁(threshold, μ₁, histogram, startindex)/P₁
    σ²₂ = calculate_σ²₂P₂(threshold, μ₂, histogram, endindex)/P₂

    J = 1.0
    if (P₁ != 0.0 && σ²₁ != 0.0)
      J += 2P₁ * log(sqrt(σ²₁)/P₁)
    end
    if (P₂ != 0.0 && σ²₂ != 0.0)
      J += 2P₂ * log(sqrt(σ²₂)/P₂)
    end

    if (J < minJvalue)
      minJvalue = J
      minJindex = threshold
    end
  end
  minJindex
end

function calculate_μ₁P₁(histogram, startindex, endindex)
  μ₁P₁list = zeros(Float64, startindex:endindex)

  for g = startindex:endindex
    μ₁P₁list[g] = histogram[g] * g
  end
  μ₁P₁list
end

function calculate_σ²₁P₁(threshold, μ₁, histogram, startindex)
  σ²₁P₁ = 0.0
  for g = startindex:threshold
    σ²₁P₁ += (g - μ₁)^2 * histogram[g]
  end
  σ²₁P₁
end

function calculate_σ²₂P₂(threshold, μ₂, histogram, endindex)
  σ²₂P₂ = 0.0
  for g = (threshold + 1):endindex
    σ²₂P₂ += (g - μ₂)^2 * histogram[g]
  end
  σ²₂P₂
end
