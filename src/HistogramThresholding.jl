module HistogramThresholding

using Images
using LinearAlgebra

abstract type ThresholdAlgorithm end
struct Otsu <: ThresholdAlgorithm end
struct MinimumError <: ThresholdAlgorithm end
struct MinimumIntermodes <: ThresholdAlgorithm end
struct Intermodes <: ThresholdAlgorithm end
struct UnimodalRosin <: ThresholdAlgorithm end
struct Moments <: ThresholdAlgorithm end

include("common.jl")
include("otsu.jl")
include("minimum_error.jl")
include("unimodal.jl")
include("moments.jl")
include("minimum.jl")
include("intermodes.jl")

export
  # main functions
  find_threshold,
  Otsu,
  UnimodalRosin,
  Moments,
  MinimumIntermodes,
  Intermodes,
  MinimumError
end # module
