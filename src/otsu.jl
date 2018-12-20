function find_threshold(algorithm::Otsu, histogram::AbstractArray, edges::AbstractRange)
  N = sum(histogram)
  histogram = histogram / N

  μ₀ = 0
  μT = mean(histogram)
  max_σb = 0.0
  threshold = 1

  for i in eachindex(histogram)
    ω₀ = sum(histogram[first(histogram):i])
    ω₁ = sum(histogram[i+1:end])
  end

  #
  # for t in 1:bins
  #     ω0 += histogram[t]
  #     ω1 = 1 - ω0
  #     μt += t*histogram[t]
  #
  #     σb = (μT*ω0-μt)^2/(ω0*ω1)
  #
  #     if(σb > max_σb)
  #         max_σb = σb
  #         thres = t
  #     end
  # end
  #
  # return T((edges[thres-1]+edges[thres])/2)

end
