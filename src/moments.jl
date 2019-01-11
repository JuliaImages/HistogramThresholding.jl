"""
```
t = find_threshold(Moments(),  histogram, edges)
```

When run on a bilevel histogram, will find two grey values for the resulting
image to consist of, the fraction of pixels that belong to each grey value, and
set the threshold such that the correct number of pixels are below it for the
previous statements to be true.

# Arguments

The function arguments are described in more detail below.

##  `histogram`

An `AbstractArray` storing the frequency distribution.

##  `edges`

An `AbstractRange` specifying how the intervals for the frequency distribution
are divided.

## Reference

[1] W.-H. Tsai, “Moment-preserving thresolding: A new approach,” Computer Vision, Graphics, and Image Processing, vol. 29, no. 3, pp. 377–393, Mar. 1985. [doi:10.1016/0734-189x(85)90133-1](https://doi.org/10.1016/0734-189x(85)90133-1)
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
    # (2) compute the moments from a histogram
    for j in eachindex(histogram)
        m₁ += (histogram[j] / n) * edges[j]
        m₂ += (histogram[j] / n) * (edges[j])^2
        m₃ += (histogram[j] / n) * (edges[j])^3
    end
    m₁, m₂, m₃
end

function compute_auxiliary_values(m₀, m₁, m₂, m₃)
    # Appendix A.1.i calculates the auxiliary values c
    cₐ = det([m₀ m₁;
              m₁ m₂])
    c₀ = (1/cₐ) * det([-m₂ m₁;
                       -m₃ m₂])
    c₁ = (1/cₐ) * det([m₀ -m₂;
                       m₁ -m₃])
    c₀, c₁
end

function compute_gray_levels(c₀, c₁)
    #= Appendix A.1.ii calculates grey values z which are the bi-level colours
     the resulting image will show in =#
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

function preserve_moments(p₀, z₀, p₁, z₁)
    # (3) Preserving the moments of the resulting image.
    m₁₀ = p₀ * (z₀)^0 + p₁ * (z₁)^0
    m₁₁ = p₀ * (z₀)^1 + p₁ * (z₁)^1
    m₁₂ = p₀ * (z₀)^2 + p₁ * (z₁)^2
    m₁₃ = p₀ * (z₀)^3 + p₁ * (z₁)^3
end
