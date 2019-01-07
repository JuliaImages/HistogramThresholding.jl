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

TBA
"""

function find_threshold(algorithm::Intermodes, histogram::AbstractArray, edges::AbstractRange)
    #initilize number of maximums to be all values and create local copy of histogram
    numMax=length(histogram)
    histogramLocal=copy(histogram)
    n = 0
    numMax = 0
    for i in eachindex(histogram)
        if (i > 1) && (i < length(histogram))
            if (histogram[i] > histogram[i-1]) && (histogram[i] > histogram[i+1])
            numMax+=1
            end
        end
    end

    #smooth histogram untill only two peaks remain
    while numMax > 2
        n += 1
        numMax = 0
        smoothHist = []
        for i in eachindex(histogramLocal)
            if (i > 1) && (i < length(histogramLocal))
                m=histogramLocal[i-1]+histogramLocal[i]+histogramLocal[i+1]
                m=m/3
                push!(smoothHist,m)
            end
        end

        for i in eachindex(smoothHist)
            if (i > 1) && (i < length(smoothHist))
                if (smoothHist[i] > smoothHist[i-1]) && (smoothHist[i] > smoothHist[i+1])
                numMax+=1
                end
            end
        end
        histogramLocal = copy(smoothHist)
    end

    @show length(histogram)

    #setup initial max, min and threshold value (t)
    min = typemax(Int)
    max = [0.0,0.0]
    maxt = [-1,-1]
    t = -1

    #find local maxima
    for i in eachindex(histogramLocal)
        if (i > 1) && (i < length(histogramLocal))
            if (histogramLocal[i] > histogramLocal[i-1]) && (histogramLocal[i] > histogramLocal[i+1])
                @show i
                if maxt[1] == -1
                    maxt[1] = i
                    #max[1] = histogramLocal[i]
                elseif maxt[2] == -1
                    maxt[2] = i
                    #max[i] = histogramLocal[i]
                end
            end
        end
    end

    #calculate final threshold value and correct for lost bins
    t = (maxt[1] + maxt[2]) / 2
    t = floor(Int, t) + n
    t = edges[t]
    return t
end