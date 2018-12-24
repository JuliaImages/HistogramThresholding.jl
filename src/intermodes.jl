function find_threshold(algorithm::Intermodes, histogram::AbstractArray, edges::AbstractRange)
    #initilize number of maximums to be all values and create local copy of histogram
    numMax=length(histogram)
    histogramLocal=copy(histogram)
    n = 0

    #smooth histogram untill only to peaks remain
    while numMax > 2
        n += 1
        numMax=0
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

    #setup initial max, min and threshold value (t)
    min = typemax(Int)
    max = [0.0,0.0]
    maxt = [-1,-1]
    t = -1

    #find local maxima
    for i in eachindex(histogramLocal)
        if (i > 1) && (i < length(histogramLocal))
            if (histogramLocal[i] > histogramLocal[i-1]) && (histogramLocal[i] > histogramLocal[i+1])
                if maxt[1] == -1
                    maxt[1] = i
                    max[1] = histogramLocal[i]
                elseif maxt[2] == -1
                    maxt[2] = i
                    max[2] = histogramLocal[i]
                end
            end
        end
    end

    t = (maxt[1]+maxt[2])/2

     t = t+n
    t = t*edges[2]
    return t
end
