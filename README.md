# HistogramThresholding.jl

[![][action-img]][action-url]
[![][pkgeval-img]][pkgeval-url]
[![][codecov-img]][codecov-url]
[![][docs-stable-img]][docs-stable-url]
[![][docs-dev-img]][docs-dev-url]

A Julia package for analyzing a one-dimensional histogram and automatically choosing a threshold which partitions the histogram into two parts.  

A full list of algorithms can be found in the [documentation](https://juliaimages.github.io/HistogramThresholding.jl/stable). The algorithms were devised in the context of image processing applications but could prove useful in a variety of scenarios. 

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


[pkgeval-img]: https://juliaci.github.io/NanosoldierReports/pkgeval_badges/H/HistogramThresholding.svg
[pkgeval-url]: https://juliaci.github.io/NanosoldierReports/pkgeval_badges/report.html
[action-img]: https://github.com/juliaimages/HistogramThresholding.jl/workflows/CI/badge.svg
[action-url]: https://github.com/juliaimages/HistogramThresholding.jl/actions
[codecov-img]: https://codecov.io/gh/juliaimages/HistogramThresholding.jl/branch/master/graph/badge.svg
[codecov-url]: https://codecov.io/gh/juliaimages/HistogramThresholding.jl
[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://juliaimages.github.io/HistogramThresholding.jl/stable
[docs-dev-img]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-dev-url]: https://juliaimages.github.io/HistogramThresholding.jl/dev
