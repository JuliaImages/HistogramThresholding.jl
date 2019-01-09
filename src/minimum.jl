"""
```
t = find_threshold(MinThreshold(),  histogram, edges)
```

Under the assumption that the histogram is bimodal the histogram is smoothed using a length-3 mean filter until 2 modes remain. The threshold is then set to the minimum value between the two modes.

# Arguments

The function arguments are described in more detail below.

##  `histogram`

An `AbstractArray` storing the frequency distribution.

##  `edges`

An `AbstractRange` specifying how the intervals for the frequency distribution
are divided.

## Reference

C. A. Glasbey, “An Analysis of Histogram-Based Thresholding Algorithms,” CVGIP: Graphical Models and Image Processing, vol. 55, no. 6, pp. 532–537, Nov. 1993. doi:10.1006/cgip.1993.1040
"""

function find_threshold(algorithm::MinThreshold, histogram::AbstractArray, edges::AbstractRange)
    #smooth histogram
    histogram_local = smooth_histogram(histogram)

    #find local maxima
    maxt = find_modes(histogram_local)

    #check for binomial
    if maxt[1] == -1
         return 0
    end

    if maxt[2] == -1
        return 0
    end

    #swap maxima to be in correct order
    if maxt[1] > maxt[2]
        temp = maxt[2]
        temp2 = maxt
        maxt[2] = maxt[1]
        maxt[1] = temp
        max[2] = max[1]
        max[1] = temp
    end

    #find local minima betwen maxima
    min=typemax(Float64)
    for i = maxt[1]:maxt[2]
        if histogram_local[i]<min
            min = histogram_local[i]
            t = i
        end
    end

    #scale to histogram
    t_pos = round(Int, t)
    t = edges[t_pos]
    return t
end
