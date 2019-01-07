using Images, TestImages, HistogramThresholding

img = testimage("fabio_gray_512")
img2 = testimage("fabio_gray_512")
img_g = Gray.(img2)
img_g2 = Gray.(img)

edges, counts = build_histogram(img_g,256,0,1)
histogram = counts[1:end]
t = find_threshold(Intermodes(), histogram, edges)
t2 = find_threshold(MinThreshold(), histogram, edges)

img_binary = map(img_g) do val
    if val < t
        return Gray(0)
    else
        return Gray(1)
    end
end

img_binary2 = map(img_g2) do val
    if val < t2
        return Gray(0)
    else
        return Gray(1)
    end
end

# Display the binarized image in Juno.
img_binary
img_binary2
