"""
```
find_threshold(Entropy(),counts,edges)
```
An algorithm for finding the threshold value for a gray-level histogram using
the entropy of the histogram.

# Output

Returns the point in the `AbstractRange` which corresponds to the threshold bin in the histogram.

# Details

This algorithm uses the entropy of a gray level histogram to produce a threshold
value.

Let ``f_1, f_2, \\ldots, f_I`` be the frequencies in the various bins of the
histogram and ``I`` the number of bins. With ``N = \\sum_{i=1}^{I}f_i``, let
``p_i = \\frac{f_i}{N}`` (``i = 1, \\ldots, I``) denote the probability
distribution of gray levels. From this distribution one derives two additional
distributions. The first defined for discrete values ``1`` to ``s`` and the
other, from ``s+1`` to ``I``. These distributions are

```math
A: \\frac{p_1}{P_s}, \\frac{p_2}{P_s}, \\ldots, \\frac{p_s}{P_s}
\\quad \\text{and} \\quad
B: \\frac{p_{s+1}}{1-P_s}, \\ldots, \\frac{p_n}{1-P_s}
\\quad \\text{where} \\quad
P_s = \\sum_{i=1}^{s}p_i.
```
The entropies associated with each distribution are as follows:

```math
H(A) = \\ln(P_s) + \\frac{H_s}{P_s}
```
```math
H(B) = \\ln(1-P_s) + \\frac{H_n-H_s}{1-P_s}
```
```math
\\quad \\text{where} \\quad
H_s = -\\sum_{i=1}^{s}p_i\\ln{p_i}
\\quad \\text{and} \\quad
H_n = -\\sum_{i=1}^{I}p_i\\ln{p_i}.
```


Combining these two entropy functions we have

```math
\\psi(s) = \\ln(P_s(1-P_s)) + \\frac{H_s}{P_s} + \\frac{H_n-H_s}{1-P_s}.
```
Finding the discrete value ``s`` which maximises the function ``\\psi(s)`` produces
the sought-after threshold value (i.e. the bin which determines the threshold).

See Section 4 of [1] for more details on the derivation of the entropy.

# Options

## Choices for `counts`
You can specify an `AbstractArray` which should be a 1D array of frequencies for
a histogram. You should submit the corresponding `edges` range for the bins of
the histogram. The function will throw an error if it detects that the `edges`
and `counts` have different lengths.

## Choices for `edges`
You can specify an `AbstractRange` which should be the corresponding range for
the bins of the histogram array passed into `counts`.

# Example

```julia

using TestImages, Images

img = testimage("cameraman")
# building a histogram with 256 bins
edges, counts = build_histogram(img, 256)
#=
  The `counts` array stores at index 0 the frequencies that were below the
  first bin edge. Since we are seeking a threshold over the interval
  partitioned by `edges` we need to discard the first bin in `counts`
  so that the dimensions of `edges` and `counts` match.
=#
find_threshold(EntropyThresholding(), counts[1:end], edges)
```

# References
[1] J. N. Kapur, P. K. Sahoo, and A. K. C. Wong, “A new method for gray-level picture thresholding using the entropy of the histogram,” *Computer Vision, Graphics, and Image Processing*, vol. 29, no. 1, p. 140, Jan. 1985.[doi:10.1016/s0734-189x(85)90156-2](https://doi.org/10.1016/s0734-189x%2885%2990156-2)
"""
function find_threshold(::Entropy, counts::AbstractArray, edges::AbstractRange)
    if length(edges) != length(counts)
        error("the lengths of edges and counts must match")
    end
    nbins = length(counts)
    pdf = counts ./ sum(counts)
    Ψₘₐₓ = 0
    Hₛ = H(pdf)
    Hₙ = -1*Hₛ[nbins]
    Pₛ = cumsum(pdf)
    # Pₛ might exceed 1 for float-point numerical stability issue (issue #35)
    Pₛ = _maybe_inplace_clamp01(Pₛ)

    # Here we use a trivial findmax implementation so as to avoid additional memory allocation.
    # Generally nbins are small number (e.g., 256) so fancy findmax strategy might give less
    # performance boost.
    threshold_bin = 1
    @inbounds for i in 1:nbins
        Pᵢ = Pₛ[i]
        Hᵢ = -1*Hₛ[i]
        Ψᵢ = log(Pᵢ*(1-Pᵢ)) + (Hᵢ/Pᵢ) + ((Hₙ-Hᵢ)/(1-Pᵢ))
        if Ψᵢ > Ψₘₐₓ
            Ψₘₐₓ = Ψᵢ
            threshold_bin = i
        end
    end
    edges[threshold_bin]
end

if VERSION > v"1.5"
    function H(pdf::AbstractArray{T}) where T
        f(x) = x == 0 ? zero(T) : convert(T, x*log(x)) # To avoid NaN when x == 0
        cumsum(f(x) for x in pdf)
    end
else
    function H(pdf::AbstractArray{T}) where T
        f(x) = x == 0 ? zero(T) : convert(T, x*log(x)) # To avoid NaN when x == 0
        cumsum(f.(pdf))
    end
end

# We can't assure that all array types support setindex!, so here we only optimize
# for the `Vector`, which is `counts[1:end]`. `SubArray` may or may not be writable.
_maybe_inplace_clamp01(A::AbstractArray{T}) where T = clamp.(A, zero(T), one(T))
_maybe_inplace_clamp01(A::Vector{T}) where T = clamp!(A, zero(T), one(T))
