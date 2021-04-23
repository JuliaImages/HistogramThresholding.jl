using HistogramThresholding, TestImages, ColorTypes, ImageContrastAdjustment
using StaticArrays
using Test, Aqua, Documenter

@testset "Project meta quality checks" begin
    # Not checking compat section for test-only dependencies
    Aqua.test_all(HistogramThresholding; project_extras=true, deps_compat=true, stale_deps=true, project_toml_formatting=true)
    
    DocMeta.setdocmeta!(HistogramThresholding, :DocTestSetup, :(using HistogramThresholding); recursive=true)
    doctest(HistogramThresholding, manual = false)
end

function gaussian_mixture(z;P₁,μ₁,σ₁,P₂,μ₂,σ₂)
    (P₁ / (σ₁*√(2*π))) * exp( -(z-μ₁)^2 / (2*σ₁^2) )  +  (P₂ / (σ₂*√(2*π))) * exp( -(z-μ₂)^2 / (2*σ₂^2) )
end

function surge(t;A,k)
    A*t*exp(-k*t)
end

@testset "HistogramThresholding.jl" begin
    include("otsu.jl")
    include("minimum.jl")
    include("intermodes.jl")
    include("unimodal.jl")
    include("moments.jl")
    include("minimum_error.jl")
    include("balancedthreshold.jl")
    include("yen.jl")
    include("entropy_thresholding.jl")
end
