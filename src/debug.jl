using Images, TestImages, HistogramThresholding

img = testimage("mandrill")
img_g = Gray.(img)

edges, counts = build_histogram(img_g,256,0,1)
histogram = counts[1:end]
t = find_threshold(MinThreshold, histogram, edges)

img_binary = map(img_g) do val
    if val < t
        return Gray(0)
    else
        return Gray(1)
    end
end
# Display the binarized image in Juno.]
img_binary
