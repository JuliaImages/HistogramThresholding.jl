function find_number_modes(histogram::AbstractArray)
    num_max = 0
    #check for local maxima
    for i in eachindex(histogram)
        if (i > 1) && (i < length(histogram))
            if (histogram[i] > histogram[i-1]) && (histogram[i] > histogram[i+1])
            num_max += 1
            end
        end
    end
    return num_max
end

function find_modes(histogram::AbstractArray)
    #find the modes in bimodal histogram
    maxt = [-1,-1]
    for i in eachindex(histogram)
        if (i > 1) && (i < length(histogram))
            if (histogram[i] > histogram[i-1]) && (histogram[i] > histogram[i+1])
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
    return maxt
end

function smooth_histogram(histogram::AbstractArray)
    histogram_local = copy(histogram)
    histogram_local = Array{Float64}(histogram_local)
    num_max = find_number_modes(histogram)

    #smooth histogram untill only two peaks remain
    while num_max > 2
        num_max = 0
        smooth_histogram = similar(histogram_local)
        for i in eachindex(histogram_local)
            if (i > 1) && (i < length(histogram_local))
                m = histogram_local[i-1] + histogram_local[i] + histogram_local[i+1]
                m = m/3
                smooth_histogram[i] = m
            elseif i == 1
                m = histogram_local[i] + histogram_local[i] + histogram_local[i+1]
                m = m/3
                smooth_histogram[i] = m
            elseif i == length(histogram_local)
                m = histogram_local[i-1] + histogram_local[i] + histogram_local[i]
                m = m/3
                smooth_histogram[i] = m
            end
        end

        #check number of local maxima
        num_max = find_number_modes(smooth_histogram)
        histogram_local = copy(smooth_histogram)
    end
    return histogram_local
end
