"""
```
t = find_threshold(Unimodal(),  histogram, edges)
```

This method generates a threshold using Rosin's algorithm for unimodal images.
It assumes that:

*  The histogram is unimodal
*  There is always at least one bin that has a frequency of 0, to be used as
the minimum. If not, the algorithm will use the last bin.
*  If there are multiple zero bins, the algorithm will use the first zero bin.

# Arguments

The function arguments are described in more detail below.

##  `histogram`

An `AbstractArray` storing the frequency distribution.

##  `edges`

An `AbstractRange` specifying how the intervals for the frequency distribution
are divided.

## Reference

Rosin, P. (2001). Unimodal thresholding. Pattern Recognition, [online] 34(11), pp.2083-2096. Available at: https://users.cs.cf.ac.uk/Paul.Rosin/resources/papers/unimodal2.pdf.

"""


#= Calculates the distance between the line calculated with slope m,
y-intercept c, and a point wit \h co-ordinates x₀, y₀
=#
function calc_dist(m::Real, c::Real, x₀::Real, y₀::Real)
    return abs(m*x₀ + -1*y₀ + c) / sqrt((m)^2 + (-1)^2)
end


function find_threshold(algorithm::UniThreshold,  histogram::AbstractArray, edges::AbstractRange)

    # Find the index & value of bin with highest value
    max_val = findmax(histogram)[1]
    max_index = findmax(histogram)[2]

    # initialise min bin index
    min_index = 1
    found_min = false

    #Find the first zero bin. If no zero bin is found, use the last bin
    for j in max_index:last(first(axes(histogram)))
        if histogram[j] == 0.0
            min_index = j
            found_min = true
            break
        end
    end

    if found_min == false
        min_index = last(first(axes(histogram)))
    end

    # Find slope and c value of the line
    m = (max_val-0) / (max_index - min_index)
    c = -m*min_index


    # Find the greatest distance
    t = max_index
    for k in max_index:min_index
        if calc_dist(m, c, k, histogram[k]) > calc_dist(m, c, t, histogram[t])
            t = k
        end
    end

    # Return the greatest distance
    return edges[t]

end
