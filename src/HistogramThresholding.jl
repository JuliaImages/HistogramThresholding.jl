module HistogramThresholding


using LinearAlgebra
using ImageBase

# TODO: port ThresholdAPI to ImagesAPI
include("ThresholdAPI/ThresholdAPI.jl")
import .ThresholdAPI: AbstractThresholdAlgorithm,
                      find_threshold, build_histogram


include("common.jl")
include("algorithms/otsu.jl")
include("algorithms/yen.jl")
include("algorithms/minimum_error.jl")
include("algorithms/unimodal.jl")
include("algorithms/moments.jl")
include("algorithms/minimum.jl")
include("algorithms/intermodes.jl")
include("algorithms/balancedthreshold.jl")
include("algorithms/entropy_thresholding.jl")
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
