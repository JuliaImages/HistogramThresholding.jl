using Images, TestImages, Colors#, HistogramThresholding

img = testimage("mandrill")
img_g = Gray.(img)

edges, counts = build_histogram(img_g,256,0,1)
histogram = counts[1:end]
#t = find_threshold(MinThreshold, histogram, edges)
t = find_threshold(histogram, edges)

img_binary = map(img_g) do val
    if val < t
        return Gray(0)
    else
        return Gray(1)
    end
end
# Display the binarized image in Juno.
img_binary

function find_threshold(histogram::AbstractArray, edges::AbstractRange)
    numMax=length(histogram)
    histogramLocal=copy(histogram)
    n = 0
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
            if (i > 1) && (i < length(histogramLocal))
                if (smoothHist[i] > smoothHist[i-1]) && (smoothHist[i] > smoothHist[i+1])
                numMax+=1
                end
            end
        end
        histogramLocal = copy(smoothHist)
        @show numMax
    end

    min = 10000000
    max = [0.0,0.0]
    maxt = [-1,-1]
    t = -1

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

    if maxt[1]>maxt[2]
        temp=maxt[2]
        temp2=maxt
        maxt[2]=maxt[1]
        maxt[1]=temp
        max[2]=max[1]
        max[1]=temp
    end
    @show max
    @show maxt

    for i = maxt[1]:maxt[2]
        if histogramLocal[i]<min
            min = histogramLocal[i]
            t = i
        end
    end

    #@show histogramLocal
    t = t+n
    t = t*edges[2]
    @show t
    return t
end
