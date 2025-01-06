using Documenter

# Import the package
using MahmoodJetter2023

# Define the documentation
makedocs(
    sitename = "MahmoodJetter2023",
    modules = [MahmoodJetter2023],
    format = Documenter.HTML(),
    pages = [
        "Home" => "index.md",
        "Modules" => [
            "WranglingFuns" => "WranglingFuns.md",
            "TablesFuns" => "TablesFuns.md",
            "FiguresFuns" => "FiguresFuns.md",
            "RunningFuns" => "RunningFuns.md",
        ],
    ]
)
