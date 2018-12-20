using Images, TestImages, HistogramThresholding

img = testimage("mandrill")
img_g = Gray.(img)

edges, counts = build_histogram(img_g,256,0,1)
histogram = counts[1:end]
t = find_threshold(Otsu(0.5,0.5), histogram)
