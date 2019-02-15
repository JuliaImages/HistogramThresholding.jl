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
struct Balanced <: ThresholdAlgorithm end
struct Yen <: ThresholdAlgorithm end
struct EntropyThresholding <: ThresholdAlgorithm end


include("common.jl")
include("otsu.jl")
include("minimum_error.jl")
include("unimodal.jl")
include("moments.jl")
include("minimum.jl")
include("intermodes.jl")
include("balancedthreshold.jl")
include("yen.jl")
include("entropy_thresholding.jl")


export
  # main functions
  find_threshold,
  Otsu,
  UnimodalRosin,
  Moments,
  MinimumIntermodes,
  Intermodes,
  MinimumError,
  Balanced,
  Yen,
  EntropyThresholding
end # module
