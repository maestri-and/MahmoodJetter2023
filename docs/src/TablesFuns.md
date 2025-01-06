# TablesFuns

This module defines functions used to replicate Table 1 and Table 2, as well as their respective panels, from Mahmood & Jetter (2023). The functions are designed for creating summary statistics tables, regression result tables, and panel-specific outputs with LaTeX and plain text formats.

## Exports
The module provides the following key functions:
- `replicate_sutex`: Mimics Stata's `sutex` functionality for generating summary statistics.
- `generate_table1`: Summarizes key variables into Table 1 and exports the results.
- `create_multiple_model_table2`: Creates a multi-model regression table for Table 2.
- `generate_table2_panelA`: Generates Panel A of Table 2 with second-stage IV regression results.
- `generate_table2_panelB`: Generates Panel B of Table 2 with first-stage IV regression results.
- `generate_table2_panelD`: Generates Panel D of Table 2 with OLS regression results.

## Usage

```julia
using TablesFuns

# Example: Creating a summary statistics table
summary_table = replicate_sutex(data, [:var1, :var2])

# Example: Generating Table 1
generate_table1(data)

# Example: Generating Table 2 with multiple models
create_multiple_model_table2(models, "independent_var", ["Model 1", "Model 2"], [2, 4], [3, 5], "Table Title", "Subtitle", "Caption")
```

```@autodocs
Modules = [MahmoodJetter2023.TablesFuns]
Order = [:function, :type]
```