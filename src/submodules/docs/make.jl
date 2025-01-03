using Documenter
include("../src/wrangling_funs.jl")  # Adjust the path if necessary
using .Wrangling_funs

makedocs(
    sitename = "Wrangling_funs Documentation",
    modules = [Wrangling_funs],
    format = Documenter.HTML(),
    version = "0.1.0"
)