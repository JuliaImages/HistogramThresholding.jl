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
    "text": "t = find_threshold(Otsu(),  histogram, edges)\n\nUnder the assumption that the histogram is bimodal the threshold is set so that the resultant inter-class variance is maximal.\n\nArguments\n\nThe function arguments are described in more detail below.\n\nhistogram\n\nAn AbstractArray storing the frequency distribution.\n\nedges\n\nAn AbstractRange specifying how the intervals for the frequency distribution are divided.\n\nReference\n\nNobuyuki Otsu (1979). \"A threshold selection method from gray-level histograms\". IEEE Trans. Sys., Man., Cyber. 9 (1): 62–66. doi:10.1109/TSMC.1979.4310076\n\n\n\n\n\n"
},

{
    "location": "#HistogramThresholding.find_threshold-Tuple{MinThreshold,AbstractArray,AbstractRange}",
    "page": "HistogramThresholding.jl Documentation",
    "title": "HistogramThresholding.find_threshold",
    "category": "method",
    "text": "t = find_threshold(MinThreshold(),  histogram, edges)\n\nUnder the assumption that the histogram is bimodal the histogram is smoothed using a length-3 mean filter until 2 modes remain. The threshold is then set to the minimum value between the two modes.\n\nArguments\n\nThe function arguments are described in more detail below.\n\nhistogram\n\nAn AbstractArray storing the frequency distribution.\n\nedges\n\nAn AbstractRange specifying how the intervals for the frequency distribution are divided.\n\nReference\n\nC. A. Glasbey, “An Analysis of Histogram-Based Thresholding Algorithms,” CVGIP: Graphical Models and Image Processing, vol. 55, no. 6, pp. 532–537, Nov. 1993. doi:10.1006/cgip.1993.1040\n\n\n\n\n\n"
},

{
    "location": "#HistogramThresholding.find_threshold-Tuple{Intermodes,AbstractArray,AbstractRange}",
    "page": "HistogramThresholding.jl Documentation",
    "title": "HistogramThresholding.find_threshold",
    "category": "method",
    "text": "t = find_threshold(Intermodes(),  histogram, edges)\n\nUnder the assumption that the histogram is bimodal the histogram is smoothed using a length-3 mean filter until 2 modes remain. The threshold is then set to the average value of the two modes.\n\nArguments\n\nThe function arguments are described in more detail below.\n\nhistogram\n\nAn AbstractArray storing the frequency distribution.\n\nedges\n\nAn AbstractRange specifying how the intervals for the frequency distribution are divided.\n\nReference\n\nC. A. Glasbey, “An Analysis of Histogram-Based Thresholding Algorithms,” CVGIP: Graphical Models and Image Processing, vol. 55, no. 6, pp. 532–537, Nov. 1993. doi:10.1006/cgip.1993.1040\n\n\n\n\n\n"
},

{
    "location": "#HistogramThresholding.jl-Documentation-1",
    "page": "HistogramThresholding.jl Documentation",
    "title": "HistogramThresholding.jl Documentation",
    "category": "section",
    "text": "find_threshold(::Otsu,  ::AbstractArray, ::AbstractRange)\nfind_threshold(::MinThreshold,  ::AbstractArray, ::AbstractRange)\nfind_threshold(::Intermodes,  ::AbstractArray, ::AbstractRange)"
},

]}
