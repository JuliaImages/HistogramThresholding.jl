# Minimum error method

using HistogramThresholding

function find_threshold(algorithm::Minerror, histogram::AbstractArray, edges::AbstractRange)

  len = length(edges)
  Jarray = zeros(len)

  for threshold = 1:len
    P₁ = calc_P₁(threshold, histogram)
    P₂ = calc_P₂(threshold, histogram, len)
    μ₁ = calc_μ₁(threshold, histogram)/P₁
    μ₂ = calc_μ₂(threshold, histogram, len)/P₂
    σ²₁ = calc_σ²₁(threshold, histogram, μ₁)/P₁
    σ²₂ = calc_σ²₂(threshold, histogram, μ₂, len)/P₂

    # println("P₁: $P₁ P₂: $P₂ μ₁: $μ₁ μ₂: $μ₂ σ²₁: $σ²₁ σ²₂: $σ²₂ hist: $(histogram[threshold])")

    J = 1

    if (P₁ != 0 && σ²₁ != 0)
      J += 2(P₁*log(sqrt(σ²₁)) - P₁*log(P₁))
    end
    if (P₂ != 0 && σ²₂ != 0)
      J += 2(P₂*log(sqrt(σ²₂)) - P₂*log(P₂))
    end

    Jarray[threshold] = J
  end

  tIndex = findmin(Jarray)[2]
end

function calc_P₁(threshold::Int, histogram)
  count = 0
  for g = 1:threshold
    count += histogram[g]
  end
  count
end

function calc_P₂(threshold::Int, histogram, length)
  count = 0
  for g = threshold+1:length
    count += histogram[g]
  end
  count
end

function calc_μ₁(threshold::Int, histogram)
  count = 0
  for g = 1:threshold
    count += histogram[g]*g
  end
  count
end

function calc_μ₂(threshold::Int, histogram, length)
  count = 0
  for g = threshold+1:length
    count += histogram[g]*g
  end
  count
end

function calc_σ²₁(threshold::Int, histogram, μ₁)
  count = 0
  for g = 1:threshold
    count += (g - μ₁)^2 * histogram[g]
  end
  count
end

function calc_σ²₂(threshold::Int, histogram, μ₂, length)
  count = 0
  for g = threshold+1:length
    count += (g - μ₂)^2 * histogram[g]
  end
  count
end
