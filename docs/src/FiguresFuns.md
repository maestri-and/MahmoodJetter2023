# FiguresFuns

This module defines functions used to replicate the figures in Mahmood & Jetter (2023). 
It provides tools for generating binscatters, creating plots, running regressions, 
and producing the various figures presented in the paper.

## Overview

The `FiguresFuns` module is designed to streamline the creation of visualizations and 
regression outputs used in the replication of the study. The module incorporates 
methods for preprocessing data, extracting coefficients, and rendering publication-ready plots.

## Exports

The module exports the following key functions:
- `binscatter_improved`
- `generate_figure2a`, `generate_figure2b`, ..., `generate_figure2f`
- `run_regressions`, `extract_coefficients`, `create_plot`, `process_analysis`
- `run_regressions_figure3`, `generate_figure3`, `generate_figure4`
- `generate_figure5`, `generate_figure6`, `generate_figure7`

Please refer to the individual function documentation for further details 
on their usage and implementation.

## Usage

```julia
using FiguresFuns

# Example: Generating a binscatter
binscatter_improved(data, :x_var, :y_var, nbins=10)

# Example: Generating Figure 2a
generate_figure2a(data)

# Example: Running regressions and creating a plot
results = run_regressions(data, "model_specification")
plot = create_plot(results)
```

```@autodocs
Modules = [MahmoodJetter2023.FiguresFuns]
Order = [:function, :type]
```