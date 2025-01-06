# MahmoodJetter2023

`MahmoodJetter2023` is a Julia package designed to replicate the results presented in Mahmood & Jetter (2023). It offers a comprehensive suite of functions to streamline data preparation, generate tables and figures, and execute high-level replication tasks.

The package is organized into five main submodules:

- **WranglingFuns**: Contains functions for importing, cleaning, and preprocessing data, including handling missing values, variable transformations, and creating moving averages.
- **TablesFuns**: Provides tools to replicate summary statistics and regression tables, such as Table 1 and Table 2, from Mahmood & Jetter (2023). It supports generating LaTeX and plain text tables.
- **FiguresFuns**: Focuses on generating visualizations, including binscatter plots, regression figures, and publication-ready figures for the study.
- **RunningFuns**: The high-level module that executes the core replication process, including data cleaning and running the main analysis scripts to replicate the results of the study.
- **TestingFuns**: This module provides functionality to define and execute unit tests for the replication package of Mahmood & Jetter (2023). It ensures that the replication pipeline performs as expected and produces consistent results.


## Modules
- [WranglingFuns](WranglingFuns.md): Data wrangling and preprocessing functions for analysis.
- [TablesFuns](TablesFuns.md): Functions for generating summary statistics and regression tables.
- [FiguresFuns](FiguresFuns.md): Tools for creating figures and visualizations.
- [RunningFuns](RunningFuns.md): High-level functions to run the full replication process.
- [TestingFuns](TestingFuns.md): High-level functions to execute unit tests for the replication package.
