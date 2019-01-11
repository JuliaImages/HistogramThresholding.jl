# Counts the number of local maxima.
function count_maxima(histogram::AbstractArray)
    maxima_count = 0
    bounds = axes(histogram,1)
    valid_range = first(bounds)+1:last(bounds)-1
    for i in valid_range
        if  histogram[i-1] < histogram[i] > histogram[i+1]
            maxima_count += 1
        end
    end
    return maxima_count
end

function find_maxima_indices(histogram::AbstractArray)
    indices = Array{Int, 1}()
    t = 0
    bounds = axes(histogram,1)
    valid_range = first(bounds)+1:last(bounds)-1
    for i in valid_range
        if histogram[i-1] < histogram[i] > histogram[i+1]
            push!(indices, i)
        end
    end
    return indices
end

function smooth_histogram(histogram::AbstractArray, max_iterations::Int)
    histogram_local = convert.(Float32,histogram)
    maxima_count = count_maxima(histogram)
    smooth_histogram = similar(histogram_local)
    bounds = axes(histogram_local,1)
    lb = first(bounds)
    ub = last(bounds)
    iterations = 0
    # Smooth histogram until at most two peaks remain or max_iterations is reached
    while maxima_count > 2 && iterations < max_iterations
        smooth_histogram[lb] = (2*histogram_local[lb] + histogram_local[lb+1]) / 3
        smooth_histogram[ub] = (2*histogram_local[ub] + histogram_local[ub-1]) / 3
        for i in lb+1:ub-1
            smooth_histogram[i] = (histogram_local[i-1] + histogram_local[i] + histogram_local[i+1]) / 3
        end
        maxima_count = count_maxima(smooth_histogram)
        histogram_local = copy(smooth_histogram)
        iterations += 1
    end
    return histogram_local
end
