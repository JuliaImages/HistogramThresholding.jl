module HistogramThresholding

using Images
using LinearAlgebra

abstract type HistogramDistribution end
struct Unimodal <: HistogramDistribution end
struct Bimodal <: HistogramDistribution end


abstract type ThresholdAlgorithm end
struct Otsu <: ThresholdAlgorithm end
struct UniThreshold <: ThresholdAlgorithm end

include("otsu.jl")
include("unimodal.jl")




export
	# main functions
    find_threshold,
	Otsu,
	UniThreshold
end # module
