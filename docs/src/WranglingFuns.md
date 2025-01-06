# WranglingFuns

This module defines functions used to prepare and preprocess data for replicating the results in Mahmood & Jetter (2023). It includes utilities for data cleaning, transformation, and variable standardization to ensure consistency with the paper's methodology.

## Exports
The module provides the following key functions:
- `import_and_merge_datasets`: Handles data import and merging operations.
- `def_logs`: Defines log transformations for specific variables.
- `replace_na_with_zeros`: Replaces missing values with zeros in specified columns.
- `standardise_var`: Standardizes variables for consistency in analysis.
- `generate_moving_averages`: Generates moving averages for time-series variables.

## Usage

```julia
using WranglingFuns

# Example: Importing and merging datasets
data = import_and_merge_datasets("dataset1.csv", "dataset2.csv")

# Example: Replacing missing values
data = replace_na_with_zeros(data, [:column1, :column2])
```