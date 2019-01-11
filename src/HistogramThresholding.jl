module HistogramThresholding

using Images
using LinearAlgebra

abstract type HistogramDistribution end
struct Unimodal <: HistogramDistribution end
struct Bimodal <: HistogramDistribution end

abstract type ThresholdAlgorithm end
struct Otsu <: ThresholdAlgorithm end
struct Moments <: ThresholdAlgorithm end

include("otsu.jl")
include("moments.jl")

export
	# main functions
    find_threshold,
	Otsu,
	Moments
end # module
