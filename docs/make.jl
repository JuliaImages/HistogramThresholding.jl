using Documenter, HistogramThresholding

format = Documenter.HTML(edit_link = "master",
                         prettyurls = get(ENV, "CI", nothing) == "true")

makedocs(modules  = [HistogramThresholding],
         format   = format,
         sitename = "HistogramThresholding",
         pages    = ["index.md"])

deploydocs(repo="github.com/JuliaImages/HistogramThresholding.jl.git")
