var documenterSearchIndex = {"docs": [

{
    "location": "#",
    "page": "HistogramThresholding.jl Documentation",
    "title": "HistogramThresholding.jl Documentation",
    "category": "page",
    "text": ""
},

{
    "location": "#HistogramThresholding.find_threshold-Tuple{Otsu,AbstractArray,AbstractRange}",
    "page": "HistogramThresholding.jl Documentation",
    "title": "HistogramThresholding.find_threshold",
    "category": "method",
    "text": "t = find_threshold(Otsu(), histogram, edges)\n\nUnder the assumption that the histogram is bimodal the threshold is set so that the resultant inter-class variance is maximal.\n\nOutput\n\nReturns a real number t that specifies the threshold.\n\nArguments\n\nThe function arguments are described in more detail below.\n\nhistogram\n\nAn AbstractArray storing the frequency distribution.\n\nedges\n\nAn AbstractRange specifying how the intervals for the frequency distribution are divided.\n\nExample\n\nCompute the threshold for the \"cameraman\" image in the TestImages package.\n\nusing TestImages, ImageContrastAdjustment, HistogramThresholding\n\nimg = testimage(\"cameraman\")\nedges, counts = build_histogram(img,256)\n#=\n  The `counts` array stores at index 0 the frequencies that were below the\n  first bin edge. Since we are seeking a threshold over the interval\n  partitioned by `edges` we need to discard the first bin in `counts`\n  so that the dimensions of `edges` and `counts` match.\n=#\nt = find_threshold(Otsu(), counts[1:end], edges)\n\nReference\n\nNobuyuki Otsu (1979). \"A threshold selection method from gray-level histograms\". IEEE Trans. Sys., Man., Cyber. 9 (1): 62–66. doi:10.1109/TSMC.1979.4310076\n\n\n\n\n\n"
},

{
    "location": "#HistogramThresholding.find_threshold-Tuple{MinimumIntermodes,AbstractArray,AbstractRange}",
    "page": "HistogramThresholding.jl Documentation",
    "title": "HistogramThresholding.find_threshold",
    "category": "method",
    "text": "t = find_threshold(MinimumIntermodes(), histogram, edges; maxiter = 8000)\n\nUnder the assumption that the histogram is bimodal the histogram is smoothed using a length-3 mean filter until two modes remain. The threshold is then set to the minimum value between the two modes.\n\nOutput\n\nReturns t, a real number that specifies the threshold.\n\nDetails\n\nIf after maxiter iterations the smoothed histogram is still not bimodal then the algorithm will fall back to using the UnimodalRosin method to select a threshold.\n\nArguments\n\nThe function arguments are described in more detail below.\n\nhistogram\n\nAn AbstractArray storing the frequency distribution.\n\nedges\n\nAn AbstractRange specifying how the intervals for the frequency distribution are divided.\n\nmaxiter\n\nAn Int that specifies the maximum number of smoothing iterations. If left unspecified a default value of 8000 is used.\n\nExample\n\nCompute the threshold for the \"cameraman\" image in the TestImages package.\n\nusing TestImages, ImageContrastAdjustment, HistogramThresholding\n\nimg = testimage(\"cameraman\")\nedges, counts = build_histogram(img,256)\n#=\n  The `counts` array stores at index 0 the frequencies that were below the\n  first bin edge. Since we are seeking a threshold over the interval\n  partitioned by `edges` we need to discard the first bin in `counts`\n  so that the dimensions of `edges` and `counts` match.\n=#\nt = find_threshold(MinimumIntermodes(), counts[1:end], edges)\n\nReference\n\nC. A. Glasbey, “An Analysis of Histogram-Based Thresholding Algorithms,” CVGIP: Graphical Models and Image Processing, vol. 55, no. 6, pp. 532–537, Nov. 1993. doi:10.1006/cgip.1993.1040\nJ. M. S. Prewitt and M. L. Mendelsohn, “THE ANALYSIS OF CELL IMAGES,” *Annals of the New York Academy of Sciences, vol. 128, no. 3, pp. 1035–1053, Dec. 2006. doi:10.1111/j.1749-6632.1965.tb11715.x\n\n\n\n\n\n"
},

{
    "location": "#HistogramThresholding.find_threshold-Tuple{Intermodes,AbstractArray,AbstractRange}",
    "page": "HistogramThresholding.jl Documentation",
    "title": "HistogramThresholding.find_threshold",
    "category": "method",
    "text": "t = find_threshold(Intermodes(), histogram, edges; maxiter = 8000)\n\nUnder the assumption that the histogram is bimodal the histogram is smoothed using a length-3 mean filter until two modes remain. The threshold is then set to the average value of the two modes.\n\nOutput\n\nReturns a real number t that specifies the threshold.\n\nDetails\n\nIf after maxiter iterations the smoothed histogram is still not bimodal then the algorithm will fall back to using the UnimodalRosin method to select a threshold.\n\nArguments\n\nThe function arguments are described in more detail below.\n\nhistogram\n\nAn AbstractArray storing the frequency distribution.\n\nedges\n\nAn AbstractRange specifying how the intervals for the frequency distribution are divided.\n\nmaxiter\n\nAn Int that specifies the maximum number of smoothing iterations. If left unspecified a default value of 8000 is used.\n\nExample\n\nCompute the threshold for the \"cameraman\" image in the TestImages package.\n\n\nusing TestImages, ImageContrastAdjustment, HistogramThresholding\n\nimg = testimage(\"cameraman\")\nedges, counts = build_histogram(img,256)\n#=\n  The `counts` array stores at index 0 the frequencies that were below the\n  first bin edge. Since we are seeking a threshold over the interval\n  partitioned by `edges` we need to discard the first bin in `counts`\n  so that the dimensions of `edges` and `counts` match.\n=#\nt = find_threshold(Intermodes(), counts[1:end], edges)\n\nReference\n\nC. A. Glasbey, “An Analysis of Histogram-Based Thresholding Algorithms,” CVGIP: Graphical Models and Image Processing, vol. 55, no. 6, pp. 532–537, Nov. 1993. doi:10.1006/cgip.1993.1040\n\n\n\n\n\n"
},

{
    "location": "#HistogramThresholding.find_threshold-Tuple{MinimumError,AbstractArray,AbstractRange}",
    "page": "HistogramThresholding.jl Documentation",
    "title": "HistogramThresholding.find_threshold",
    "category": "method",
    "text": "t = find_threshold(MinimumError(), histogram, edges)\n\nUnder the assumption that the histogram is a mixture of two Gaussian distributions the threshold is chosen such that the expected misclassification error rate is minimised.\n\nOutput\n\nReturns a real number t that specifies the threshold.\n\nArguments\n\nThe function arguments are described in more detail below.\n\nhistogram\n\nAn AbstractArray storing the frequency distribution.\n\nedges\n\nAn AbstractRange specifying how the intervals for the frequency distribution are divided.\n\nExample\n\nCompute the threshold for the \"cameraman\" image in the TestImages package.\n\nusing TestImages, ImageContrastAdjustment, HistogramThresholding\n\nimg = testimage(\"cameraman\")\nedges, counts = build_histogram(img,256)\n#=\n  The `counts` array stores at index 0 the frequencies that were below the\n  first bin edge. Since we are seeking a threshold over the interval\n  partitioned by `edges` we need to discard the first bin in `counts`\n  so that the dimensions of `edges` and `counts` match.\n=#\nt = find_threshold(MinimumError(), counts[1:end], edges)\n\nReferences\n\nJ. Kittler and J. Illingworth, “Minimum error thresholding,” Pattern Recognition, vol. 19, no. 1, pp. 41–47, Jan. 1986. doi:10.1016/0031-3203(86)90030-0\nQ.-Z. Ye and P.-E. Danielsson, “On minimum error thresholding and its implementations,” Pattern Recognition Letters, vol. 7, no. 4, pp. 201–206, Apr. 1988. doi:10.1016/0167-8655(88)90103-1\n\n\n\n\n\n"
},

{
    "location": "#HistogramThresholding.find_threshold-Tuple{Moments,AbstractArray,AbstractRange}",
    "page": "HistogramThresholding.jl Documentation",
    "title": "HistogramThresholding.find_threshold",
    "category": "method",
    "text": "t = find_threshold(Moments(), histogram, edges)\n\nThe following rule determines the threshold:  if one assigns all observations below the threshold to a value z₀ and all observations above the threshold to a value z₁, then the first three moments of the original histogram must match the moments of this specially constructed bilevel histogram.\n\nOutput\n\nReturns a real number t that specifies the threshold.\n\nArguments\n\nThe function arguments are described in more detail below.\n\nhistogram\n\nAn AbstractArray storing the frequency distribution.\n\nedges\n\nAn AbstractRange specifying how the intervals for the frequency distribution are divided.\n\nExample\n\nCompute the threshold for the \"cameraman\" image in the TestImages package.\n\nusing TestImages, ImageContrastAdjustment, HistogramThresholding\n\nimg = testimage(\"cameraman\")\nedges, counts = build_histogram(img,256)\n#=\n  The `counts` array stores at index 0 the frequencies that were below the\n  first bin edge. Since we are seeking a threshold over the interval\n  partitioned by `edges` we need to discard the first bin in `counts`\n  so that the dimensions of `edges` and `counts` match.\n=#\nt = find_threshold(Moments(), counts[1:end], edges)\n\nReference\n\n[1] W.-H. Tsai, “Moment-preserving thresolding: A new approach,” Computer Vision, Graphics, and Image Processing, vol. 29, no. 3, pp. 377–393, Mar. 1985. doi:10.1016/0734-189x(85)90133-1\n\n\n\n\n\n"
},

{
    "location": "#HistogramThresholding.find_threshold-Tuple{UnimodalRosin,AbstractArray,AbstractRange}",
    "page": "HistogramThresholding.jl Documentation",
    "title": "HistogramThresholding.find_threshold",
    "category": "method",
    "text": "t = find_threshold(UnimodalRosin(), histogram, edges)\n\nGenerates a threshold assuming a unimodal distribution using Rosin\'s algorithm.\n\nOutput\n\nReturns t, a real number that specifies the threshold.\n\nDetails\n\nThis algorithm first selects the bin in the histogram with the highest frequency. The algorithm then searches from the location of the maximum bin to the last bin of the histogram for the first bin with a frequency of 0 (known as the minimum bin.). A line is then drawn that passes through both the maximum and minimum bins. The bin with the greatest orthogonal distance to the line is chosen as the threshold value.\n\nAssumptions\n\nThis algorithm assumes that:\n\nThe histogram is unimodal.\nThere is always at least one bin that has a frequency of 0. If not, the algorithm will use the last bin as the minimum bin.\nIf the histogram includes multiple bins with a frequency of 0, the algorithm will select the first zero bin as its minimum.\nIf there are multiple bins with the greatest orthogonal distance, the leftmost bin is selected as the threshold.\n\nArguments\n\nThe function arguments are described in more detail below.\n\nhistogram\n\nAn AbstractArray storing the frequency distribution.\n\nedges\n\nAn AbstractRange specifying how the intervals for the frequency distribution are divided.\n\nExample\n\nCompute the threshold for the \"moonsurface\" image in the TestImages package.\n\nusing TestImages, ImageContrastAdjustment, HistogramThresholding\n\nimg = testimage(\"moonsurface\")\nedges, counts = build_histogram(img,256)\n#=\n  The `counts` array stores at index 0 the frequencies that were below the\n  first bin edge. Since we are seeking a threshold over the interval\n  partitioned by `edges` we need to discard the first bin in `counts`\n  so that the dimensions of `edges` and `counts` match.\n=#\nt = find_threshold(UnimodalRosin(), counts[1:end], edges)\n\nReference\n\nP. L. Rosin, “Unimodal thresholding,” Pattern Recognition, vol. 34, no. 11, pp. 2083–2096, Nov. 2001.doi:10.1016/s0031-3203(00)00136-9\n\n\n\n\n\n"
},

{
    "location": "#HistogramThresholding.jl-Documentation-1",
    "page": "HistogramThresholding.jl Documentation",
    "title": "HistogramThresholding.jl Documentation",
    "category": "section",
    "text": "find_threshold(::Otsu,  ::AbstractArray, ::AbstractRange)\nfind_threshold(::MinimumIntermodes,  ::AbstractArray, ::AbstractRange)\nfind_threshold(::Intermodes,  ::AbstractArray, ::AbstractRange)\nfind_threshold(::MinimumError,  ::AbstractArray, ::AbstractRange)\nfind_threshold(::Moments,  ::AbstractArray, ::AbstractRange)\nfind_threshold(::UnimodalRosin,  ::AbstractArray, ::AbstractRange)"
},

]}
