push!(LOAD_PATH,"../src/")
using Documenter

# Import the package
using MahmoodJetter2023

# Define the documentation
makedocs(
    sitename = "MahmoodJetter2023",
    modules = [MahmoodJetter2023],
    format = Documenter.HTML(),
    pages = [
        "Home" => "src/index.md",
        "Modules" => [
            "WranglingFuns" => "src/WranglingFuns.md",
            "TablesFuns" => "src/TablesFuns.md",
            "FiguresFuns" => "src/FiguresFuns.md",
            "RunningFuns" => "src/RunningFuns.md",
        ],
    ]
)
