push!(LOAD_PATH,"../src/")
using Documenter, HistogramThresholding
makedocs(sitename="Documentation",
            Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true"))
deploydocs(repo = "github.com/betttris13/HistogramThresholding.jl.git")
