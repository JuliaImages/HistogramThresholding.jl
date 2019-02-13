# HistogramThresholding.jl

[![Build Status](https://travis-ci.com/zygmuntszpak/HistogramThresholding.jl.svg?branch=master)](https://travis-ci.com/zygmuntszpak/HistogramThresholding.jl)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/zygmuntszpak/HistogramThresholding.jl?svg=true)](https://ci.appveyor.com/project/zygmuntszpak/HistogramThresholding-jl)
[![Codecov](https://codecov.io/gh/zygmuntszpak/HistogramThresholding.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/zygmuntszpak/HistogramThresholding.jl)

[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://zygmuntszpak.github.io/HistogramThresholding.jl/stable)
[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://zygmuntszpak.github.io/HistogramThresholding.jl/dev)

A Julia package for analyzing a one-dimensional histogram and automatically choosing a threshold which partitions the histogram into two parts.  

A full list of algorithms can be found in the [documentation](https://zygmuntszpak.github.io/HistogramThresholding.jl/stable). The algorithms were devised in the context of image processing applications but could prove useful in a variety of scenarios. 

The general usage pattern is:
```julia
t = find_threshold(algorithm::ThresholdAlgorithm, histogram::AbstractArray, edges::AbstractRange)
```
where `length(histogram)` must match `length(edges)`. 

## Example
Suppose one wants to binarize an image. Binarization requires choosing a grey level (a threshold `t`) such that all pixel intensities below that threshold are set to black and all intensities equal or above the threshold are set to white. One can attempt to choose a reasonable threshold automatically by analyzing the distribution of intensities in the image. 

```julia
using HistogramThresholding
using TestImages # For the moonsurface image.  
using ImageContrastAdjustment # For the build_histogram() function.

img = testimage("moonsurface")
edges, counts = build_histogram(img,256)
#=
  The `counts` array stores at index 0 the frequencies that were below the
  first bin edge. Since we are seeking a threshold over the interval
  partitioned by `edges` we need to discard the first bin in `counts`
  so that the dimensions of `edges` and `counts` match.
=#
t = find_threshold(UnimodalRosin(), counts[1:end], edges)

# The threshold `t` can now be used to determine which intensities should be
# set to 0 (black), and which intensities should be set to 1 (white). 
```
