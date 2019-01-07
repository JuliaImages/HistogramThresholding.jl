push!(LOAD_PATH,"../src/")
using Documenter, HistogramThresholding
makedocs(sitename="Documentation",
            Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true"))
deploydocs(repo = "github.com/zygmuntszpak/HistogramThresholding.jl.git")
