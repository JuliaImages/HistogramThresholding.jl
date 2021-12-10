using Base: depwarn
DeprecatedAlgorithms = Union{Otsu, Yen, MinimumError, Moments,
                             MinimumIntermodes, Intermodes, Balanced,
                             Entropy, UnimodalRosin}
function find_threshold(algorithm::DeprecatedAlgorithms,  histogram::AbstractArray, edges::AbstractRange)
    depwarn("find_threshold(alg, histogram, edges) is deprecated, use find_threshold(histogram, edges, alg) instead", :find_threshold)
    return find_threshold(histogram, edges, algorithm)

end