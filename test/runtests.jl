using HistogramThresholding, Images, TestImages
using Test

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
end
