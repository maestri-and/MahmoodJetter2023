using Documenter

# Import the package
using MJ2023Replicator

# Define the documentation
makedocs(
    sitename = "MJ2023Replicator",
    modules = [MJ2023Replicator],
    format = Documenter.HTML(),
    pages = [
        "Home" => "index.md",
        "Modules" => [
            "WranglingFuns" => "src/WranglingFuns.md",
            "TablesFuns" => "src/TablesFuns.md",
            "FiguresFuns" => "src/FiguresFuns.md",
            "RunningFuns" => "src/RunningFuns.md",
        ],
    ]
)
