using CoordinateSystems
using Documenter

makedocs(;
    modules=[CoordinateSystems, CoordinateSystemsCore],
    sitename="CoordinateSystems.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://johnnychen94.github.io/CoordinateSystems.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "Terminology" => "terminology.md",
        "API" => "api.md"
    ],
    doctest=false # this is enabled in Unit Test
)

deploydocs(;
    repo="github.com/johnnychen94/CoordinateSystems.jl",
)
