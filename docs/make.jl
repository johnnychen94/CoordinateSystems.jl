using CoordinateSystems
using Documenter

DocMeta.setdocmeta!(CoordinateSystems, :DocTestSetup, :(using CoordinateSystems); recursive=true)

makedocs(;
    modules=[CoordinateSystems],
    authors="Johnny Chen <johnnychen94@hotmail.com>",
    repo="https://github.com/johnnychen94/CoordinateSystems.jl/blob/{commit}{path}#{line}",
    sitename="CoordinateSystems.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://johnnychen94.github.io/CoordinateSystems.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/johnnychen94/CoordinateSystems.jl",
)
