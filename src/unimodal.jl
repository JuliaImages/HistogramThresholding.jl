"""
```
t = find_threshold(Unimodal(), histogram, edges)
```

Generates a threshold value for array `histogram` and interval `edges`
using Rosin's algorithm.


# Output
Returns `t`, a real number that specifies the image's threshold using `edges`,
an interval that specifies how the histogram is divided into bins, and `histogram`,
an array that contains the frequencies of each bin.


# Details
This algorithm first selects the bin in the histogram with the highest frequency.
The algorithm then searches from the location of the maximum bin to the last bin
of the histogram for the first bin with a frequency of 0 (known as the minimum bin.).
A line is then drawn that passes through both the maximum and minimum bins. The
bin with the greatest orthogonal distance to the line is chosen as the threshold
value.


## Assumptions
This algorithm assumes that:

* The histogram is unimodal
* There is always at least one bin that has a frequency of 0. If not, the
algorithm will use the last bin as the minimum bin.
* If the histogram includes multiple bins with a frequency of 0, the algorithm
will select the first zero bin as its minimum.
* If there are multiple bins with the greatest orthogonal distance, the leftmost
bin is selected as the threshold.


# Example

Compute the threshold for the "moonsurface" image in the TestImages package.
```julia

using TestImages, HistogramThresholding

img = testimage("moonsurface")
edges, counts = build_histogram(img,256)
t = find_threshold(UniThreshold(),counts, edges)
```


# Reference
[1] P. L. Rosin, “Unimodal thresholding,” Pattern Recognition, vol. 34, no. 11, pp. 2083–2096, Nov. 2001.


# See Also
"""
function find_threshold(algorithm::UniThreshold, histogram::AbstractArray, edges::AbstractRange)
    #= Calculates the orthogonal distance between the line (slope m,
    y-intercept c), and the point (co-ordinates x₀, y₀).
    =#
    function calculate_distance(m::Real, c::Real, x₀::Real, y₀::Real)
        abs(m*x₀ + -1*y₀ + c) / sqrt((m)^2 + 1)
    end

    # Finds the index & value of bin with highest value.
    max_val, max_index = findmax(histogram)

    # Initialise minimum bin index.
    min_index = 1
    found_min = false

    # Find the first zero bin.
    for j in max_index:last(first(axes(histogram)))
        if histogram[j] == 0.0
            min_index = j
            found_min = true
            break
        end
    end

    # If no zero bin is found, use the last bin.
    if found_min == false
        min_index = last(first(axes(histogram)))
    end

    # Find slope and y-intercept of the line.
    m = max_val / (max_index - min_index)
    c = -m*min_index

    # Initialise the maximum bin as having the inital greatest distance.
    t = max_index
    max_distance = calculate_distance(m, c, t, histogram[t])

    # Find bin with the greatest distance.
    for k in max_index:min_index
        if calculate_distance(m, c, k, histogram[k]) > max_distance
            max_distance = calculate_distance(m, c, k, histogram[k])
            t = k
        end
    end

    # Return the greatest distance.
    return edges[t]
end
