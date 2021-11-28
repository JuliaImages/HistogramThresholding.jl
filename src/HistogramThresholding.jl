module HistogramThresholding


using LinearAlgebra
using ImageBase

# TODO: port ThresholdAPI to ImagesAPI
include("ThresholdAPI/ThresholdAPI.jl")
import .ThresholdAPI: AbstractThresholdAlgorithm,
                      find_threshold, build_histogram

struct MinimumIntermodes <: AbstractThresholdAlgorithm end
struct Intermodes <: AbstractThresholdAlgorithm end
struct UnimodalRosin <: AbstractThresholdAlgorithm end
struct Moments <: AbstractThresholdAlgorithm end
struct Balanced <: AbstractThresholdAlgorithm end
struct Entropy <: AbstractThresholdAlgorithm end


include("common.jl")
include("algorithms/otsu.jl")
include("algorithms/yen.jl")
include("algorithms/minimum_error.jl")
include("unimodal.jl")
include("moments.jl")
include("minimum.jl")
include("intermodes.jl")
include("balancedthreshold.jl")
include("entropy_thresholding.jl")
include("deprecations.jl")


export
  # main functions
  find_threshold,
  build_histogram,
  Otsu,
  UnimodalRosin,
  Moments,
  MinimumIntermodes,
  Intermodes,
  MinimumError,
  Balanced,
  Yen,
  Entropy
end # module
