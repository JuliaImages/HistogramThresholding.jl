# This is a temporary module to validate `AbstractImageFilter` idea
# proposed in https://github.com/JuliaImages/ImagesAPI.jl/pull/3
module ThresholdAPI

using ImageBase
using MappedArrays

"""
    AbstractImageAlgorithm

The root of image algorithms type system
"""
abstract type AbstractImageAlgorithm end

"""
    AbstractImageFilter <: AbstractImageAlgorithm

Filters are image algorithms whose input and output are both images
"""
abstract type AbstractImageFilter <: AbstractImageAlgorithm end

include("find_threshold.jl")
include("build_histogram.jl")

export build_histogram

end  # module ThresholdAPI