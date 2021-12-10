# usage example for package developer:
#
#     import ThresholdAPI: AbstractThresholdAlgorithm,
#                          find_threshold

"""
    AbstractThresholdAlgorithm <: AbstractImageFilter

The root type for `HistogramThreshold` package.

Any concrete threshold algorithm shall subtype it to support
[`find_threshold`](@ref) API.

# Examples

All algorithms in HistogramThreshold are called in the following pattern:

```julia
# Generate an algorithm instance.
f = Otsu()

# If you already have a histogram and concomitant edges at hand
# you can supply those directly.
t = find_threshold(histogram, edges, f)

# Alternatively, you can supply the raw data and specify histogram 
# construction details.
t = find_threshold(data, f; nbins = 64) 
```

For more examples, please check [`find_threshold`](@ref) and concret
algorithms.
"""
abstract type AbstractThresholdAlgorithm <: AbstractImageFilter end


function find_threshold(histogram::AbstractArray, edges::AbstractArray, f::AbstractThresholdAlgorithm)
    return f(histogram, edges)
end

function find_threshold(data::AbstractArray, f::AbstractThresholdAlgorithm ; nbins::Union{Int,Nothing} = 256)
    edges, counts  = build_histogram(data, nbins) 
    #=
        The `counts` array stores at index 0 the frequencies that were below the
        first bin edge. Since we are seeking a threshold over the interval
        partitioned by `edges` we need to discard the first bin in `counts`
        so that the dimensions of `edges` and `counts` match.
    =#   
    return f(view(counts, 1:lastindex(counts)), edges)
end


### Docstrings

"""
    find_threshold(data::AbstractArray, f::AbstractThresholdAlgorithm; nbins)
    find_threshold(histogram::AbstractArray, edges::AbstractArray, f::AbstractThresholdAlgorithm)

Find a suitable threshold in `data` using algorithm `f` upon constructing a histogram with `nbins`.
Instead of specifing the raw `data`, you can specify a histogram and accompanying edges directly. 

# Output

A real number representing a threshold that can be used to split data into two parts. 

# Examples

Just simply pass an algorithm to `find_threshold`:

```julia
using TestImages, HistogramThreshold
img = testimage("cameraman")
t = find_threshold(img, f ; nbins = 64)
```

```julia
using StatsBase, HistogramThreshold
data = vcat(ones(50,), zeros(50,))
h = fit(Histogram, data)
t = find_threshold(data, f ; nbins = 2)
```

"""
find_threshold