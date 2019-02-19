@doc raw"""
```
t = find_threshold(Moments(), histogram, edges)
```

The following rule determines the threshold:  if one assigns all observations
below the threshold to a value z₀ and all observations above the threshold to a
value z₁, then the first three moments of the original histogram must match the
moments of this specially constructed bilevel histogram.

# Output

Returns a real number `t` in `edges`. The `edges` parameter represents an
`AbstractRange` which specifies the intervals associated with the histogram bins.

# Details

Let ``f_i`` ``(i=1 \ldots I)`` denote the number of observations in the
``i``th bin of the histogram and ``z_i`` ``(i=1 \ldots I)`` the observed value
associated with the ``i``th bin.  Then the probability that an observation ``z_i``
belongs to the ``i``th bin is given by  ``p_i = \frac{f_i}{N}`` (``i = 1,
\ldots, I``), where ``N = \sum_{i=1}^{I}f_i``.

Moments can be computed from the histogram ``f`` in the following way:

```math
m_k = \frac{1}{N} \sum_i p_i (z_i)^k \quad k = 0,1,2,3, \ldots.
```
The principle of moment-preserving thresholding is to select a threshold value,
as well as two representative values ``z_0`` and ``z_1`` (``z_0 < z_1``),
such that if all below-threshold values in ``f`` are replaced by ``z_0`` and
all above-threshold values are replaced by ``z_1``, then this specially constructed
bilevel histogram ``g`` will have the same first three moments as ``f``.

Concretely, let ``q_0`` and ``q_1`` denote the fractions of observations below
and above the threshold in ``f``, respectively. The constraint that the first
three moments in ``g`` must equal the first three moments in ``f`` can be
expressed by the following system of four equations

```math
\begin{aligned}
   q_0 (z_0)^0 + q_1 (z_1)^0   & = m_0 \\
   q_0 (z_0)^1 + q_1 (z_1)^1   & = m_1 \\
   q_0 (z_0)^2 + q_1 (z_1)^2   & = m_2 \\
   q_0 (z_0)^3 + q_1 (z_1)^3   & = m_3 \\
\end{aligned}
```
where the left-hand side represents the moments of ``g`` and the right-hand side
represents the moments of ``f``. To find the desired treshold value, one first solves
the four equations to obtain ``q_0`` and ``q_1``, and then chooses the threshold
``t`` such that ``q_0 = \sum_{z_i \le t} p_i``.


# Arguments

The function arguments are described in more detail below.

##  `histogram`

An `AbstractArray` storing the frequency distribution.

##  `edges`

An `AbstractRange` specifying how the intervals for the frequency distribution
are divided.

# Example

Compute the threshold for the "cameraman" image in the `TestImages` package.

```julia
using TestImages, ImageContrastAdjustment, HistogramThresholding

img = testimage("cameraman")
edges, counts = build_histogram(img,256)
#=
  The `counts` array stores at index 0 the frequencies that were below the
  first bin edge. Since we are seeking a threshold over the interval
  partitioned by `edges` we need to discard the first bin in `counts`
  so that the dimensions of `edges` and `counts` match.
=#
t = find_threshold(Moments(), counts[1:end], edges)
```

# Reference

[1] W.-H. Tsai, “Moment-preserving thresolding: A new approach,” Computer Vision, Graphics, and Image Processing, vol. 29, no. 3, pp. 377–393, Mar. 1985. [doi:10.1016/0734-189x(85)90133-1](https://doi.org/10.1016/0734-189x%2885%2990133-1)
"""
function find_threshold(algorithm::Moments, histogram::AbstractArray, edges::AbstractRange)
    n = sum(histogram)
    m₀ = 1.0
    m₁, m₂, m₃ =  compute_moments(histogram, edges, n)
    c₀, c₁ = compute_auxiliary_values(m₀, m₁, m₂, m₃)
    z₀, z₁ = compute_gray_levels(c₀, c₁)
    p₀, p₁ = compute_pixel_fractions(z₀, z₁, m₁)
    threshold_percentile = p₀
    target_count = ceil(Int,threshold_percentile * n)
    final_bin = determine_threshold(histogram, target_count)
    return edges[final_bin]
end

function determine_threshold(histogram, target_count)
    #= Finding the bin for which the bins below and including it contain p₀
      pixels. =#
    current_count = 0
    temp_bin = 0
    final_bin = 0
    holding_pixel_value = 0
    while current_count <= target_count
        temp_bin += 1
        current_count += histogram[temp_bin]
        if abs(target_count - current_count) <= abs(target_count - holding_pixel_value)
            holding_pixel_value = current_count
            final_bin = temp_bin
        end
    end
    final_bin
end

function compute_moments(histogram, edges, n)
    m₁ = 0.0
    m₂ = 0.0
    m₃ = 0.0
    # Compute the moments from the histogram. (eq 2)
    for j in eachindex(histogram)
        m₁ += (histogram[j] / n) * edges[j]
        m₂ += (histogram[j] / n) * (edges[j])^2
        m₃ += (histogram[j] / n) * (edges[j])^3
    end
    m₁, m₂, m₃
end

function compute_auxiliary_values(m₀, m₁, m₂, m₃)
    # Appendix A.1.i calculates the auxiliary values c.
    cₐ = det([m₀ m₁;
              m₁ m₂])
    c₀ = (1/cₐ) * det([-m₂ m₁;
                       -m₃ m₂])
    c₁ = (1/cₐ) * det([m₀ -m₂;
                       m₁ -m₃])
    c₀, c₁
end

function compute_gray_levels(c₀, c₁)
    #= Appendix A.1.ii calculates grey values z which are the bi-level intensities
     associated with the hypothetical "unblurred" image. =#
    z₀ = (1/2) * ( -c₁ - sqrt(c₁^2 - 4*c₀))
    z₁ = (1/2) * ( -c₁ + sqrt(c₁^2 - 4*c₀))
    z₀, z₁
end

function compute_pixel_fractions(z₀, z₁, m₁)
    #= Appendix A.1.iii calculates the fraction of pixels below and above the
     threshold. =#
    pₐ = det([1 1;
              z₀ z₁])
    p₀ = (1/pₐ) * det([1 1;
                       m₁ z₁])
    p₁ = 1 - p₀
    p₀, p₁
end

function preserved_moments(p₀, z₀, p₁, z₁)
    # Moments of the resulting image should be identical (eq 3).
    m₁₀ = p₀ * (z₀)^0 + p₁ * (z₁)^0
    m₁₁ = p₀ * (z₀)^1 + p₁ * (z₁)^1
    m₁₂ = p₀ * (z₀)^2 + p₁ * (z₁)^2
    m₁₃ = p₀ * (z₀)^3 + p₁ * (z₁)^3
    m₁₀, m₁₁, m₁₂, m₁₃
end
