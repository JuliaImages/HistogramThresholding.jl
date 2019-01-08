"""
```
t = find_threshold(Intermodes(),  histogram, edges)
```

Under the assumption that the histogram is bimodal the histogram is smoothed using 3-mean smoothing untill modes remain. The threshold is then set such that it is the average value of the two modes.

# Arguments

The function arguments are described in more detail below.

##  `histogram`

An `AbstractArray` storing the frequency distribution.

##  `edges`

An `AbstractRange` specifying how the intervals for the frequency distribution
are divided.

## Reference

Glasbey, C. (1993). An Analysis of Histogram-Based Thresholding Algorithms. CVGIP: Graphical Models and Image Processing, [online] 55(6), pp.532-537. Available at: http://www.sciencedirect.com/science/article/pii/S1049965283710400.
"""

function find_threshold(algorithm::Intermodes, histogram::AbstractArray, edges::AbstractRange)
    #initilize number of maximums to be all values and create local copy of histogram
    num_max=length(histogram)
    histogram_local=copy(histogram)
    histogram_local=Array{Float64}(histogram_local)
    num_max = 0

    #check initial local maxima
    for i in eachindex(histogram)
        if (i > 1) && (i < length(histogram))
            if (histogram[i] > histogram[i-1]) && (histogram[i] > histogram[i+1])
            num_max+=1
            end
        end
    end

    #smooth histogram untill only two peaks remain
    while num_max > 2
        num_max = 0
        smooth_histsogram = similar(histogram_local)
        for i in eachindex(histogram_local)
            if (i > 1) && (i < length(histogram_local))
                m=histogram_local[i-1]+histogram_local[i]+histogram_local[i+1]
                m=m/3
                smooth_histsogram[i]=m
            elseif i == 1
                m=histogram_local[i]+histogram_local[i]+histogram_local[i+1]
                m=m/3
                smooth_histsogram[i]=m
            elseif i == length(histogram_local)
                m=histogram_local[i-1]+histogram_local[i]+histogram_local[i]
                m=m/3
                smooth_histsogram[i]=m
            end
        end

        #check number of local maxima
        for i in eachindex(smooth_histsogram)
            if (i > 1) && (i < length(smooth_histsogram))
                if (smooth_histsogram[i] > smooth_histsogram[i-1]) && (smooth_histsogram[i] > smooth_histsogram[i+1])
                num_max+=1
                end
            end
        end
        histogram_local = copy(smooth_histsogram)
    end

    #setup initial max, min and threshold value (t)
    min = typemax(Int)
    max = [0.0,0.0]
    maxt = [-1,-1]
    t = -1

    #find local maxima
    for i in eachindex(histogram_local)
        if (i > 1) && (i < length(histogram_local))
            if (histogram_local[i] > histogram_local[i-1]) && (histogram_local[i] > histogram_local[i+1])
                if maxt[1] == -1
                    maxt[1] = i
                elseif maxt[2] == -1
                    maxt[2] = i
                else
                    return 0
                end
            end
        end
    end

    #check for binomial
    if maxt[1] == -1
         return 0
    end

    if maxt[2] == -1
        return 0
    end

    #calculate final threshold value
    t = (maxt[1] + maxt[2]) / 2
    t = round(Int, t)
    t = edges[t]
    return t
end
