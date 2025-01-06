# Julia Replication Package for Mahmood, R., & Jetter, M. (EJ, 2023)

**Authors:** MAESTRI Andrea & BENRAMDANE Ali

**Course:** Computational Economics, Fall 2024 - M2, Master's in Economics, Sciences Po

**Paper reference:** Mahmood, Rafat, and Michael Jetter. "Gone with the wind: The consequences of US drone strikes in Pakistan." The Economic Journal 133, no. 650 (2023): 787-811.

## Overview of the package

The present package generates the main findings published by Mahmood, R. & Jetter, M. in "Gone with the wind: The consequences of US drone strikes in Pakistan" (EJ, 2023).

The replicated outputs encompass the *Empirical Findings: Terrorism section*, including the First Stage, Reduced Form, Placebo estimations, and key IV results, as well as the *Empirical Findings: Beliefs and Attitudes* section of the paper.

All data was made publicly available by the authors. The original code, written in STATA, along with the data, can be found in the folder 'original_package' within this remote repository. Access to the published original package can be accessed [here](https://academic.oup.com/ej/article-abstract/133/650/787/6751902) with the appropriate credentials.

The replicator should expect the code to take approximately 3 minutes and 49 seconds to run, including the compilation time, when using Julia 1.11.1.

## Content of the package

### Description of folders
- `./data`: contains all useful raw datasets used for the project, including `GTD_and_SATP_data.csv`, `anti-us_sentiment.csv`, `data_panel.csv`, `drones_data.csv`, `news_sentiment.csv`, and `weather_data.csv`
- `./docs`: contains project documentation, including user guides and the script for generating them, to support understanding and contributions to the project.
- `./original_package`: contains the original code written in STATA, the corresponding data, the authors' README.pdf file, and the paper published by the authors in the Economic Journal.
- `./output`: folder where all outputs produced by running the package are saved; figures are stored in PDF format, while tables are saved in both TXT and LaTeX file formats.
- `./src`: contains all source files for the project, including the main script and modularized functions.
  1. `WranglingFuns.jl`: includes all functions required for data wrangling.
  2. `TablesFuns.jl`: contains functions needed to produce results and generate Tables 1 and 2.
  3. `FiguresFuns.jl`: contains functions required to produce Figures 2 through 7.
  4. `main.jl`: the primary script orchestrating the execution of all functions.
- `./test`: contains test scripts to verify the functionality and integrity of the functions developed for the package.

*This package also includes the file for the present `README.md`, as well as a `run.jl` script allowing to compile the code and generate all outputs.*

### Overview of main modules
| Module Name   | Script            | Description                                                                             |
|---------------|-------------------|-----------------------------------------------------------------------------------------|
| WranglingFuns | WranglingFuns.jl | This script defines the functions used to prepare the data for the replication of the results |
| TablesFuns    | TablesFuns.jl    | This script defines the functions used to replicate Table 1 and Table 2                |
| FiguresFuns   | FiguresFuns.jl   | This script defines the functions used to replicate Figures 2, 3, 4, 5, 6 & 7         |


## Software and Package Requirements

The replication was conducted using **Julia 1.11.1**. Below are the package requirements for this project:

- **Binscatters**: v0.4.0
- **CSV**: v0.10.15
- **CovarianceMatrices**: v0.22.0
- **DataFrames**: v1.7.0
- **Dates**: v1.11.0
- **DelimitedFiles**: v1.9.1
- **Documenter**: v1.8.0
- **FixedEffectModels**: v1.11.0
- **GLM**: v1.9.0
- **Plots**: v1.40.9
- **PrettyTables**: v2.4.0
- **Printf**: v1.11.0
- **ShiftedArrays**: v2.0.0
- **StatFiles**: v0.8.0
- **Statistics**: v1.11.1
- **StatsPlots**: v0.15.7

## Instruction for replication
**To be updated**

To ensure reproducibility, configure your Julia environment to match the setup defined in this repository, and then execute the `run` and `run_tests` functions.
1. Import `PackageName`
    ```julia
    using PackageName
    ```
2. Set up the project environment:
   ```julia
   using Pkg
   Pkg.activate(".")
   Pkg.instantiate()
   ```
3. To replicate the results and run the unit tests, execute the following commands:
    ```julia
    # Run the full replication process
    PackageName.run()

    # Run the test suite to verify functionality
    PackageName.run_tests()
    ```
## Notes regarding Replicated Paper Outputs 

### List of replicated outputs
The package replicates the following outputs from the paper:
- **Table 1**: Summary Statistics of Main Variables for all 4,018 Days from January 1, 2006 until December 31, 2016. Replicated columns include Variable, Mean, (SD), Min, and (Max).
  
- **Figure 2**: Binned Scatterplots of Wind Conditions (x-axis) against the Number of Contemporary Drone Strikes and Terror Attacks in the Subsequent Seven Days at Various Locations.
  
- **Table 2**: Main Results including coefficients and HAC standard errors for the 5 regression columns.
  
- **Figure 3**: Predicting Additional Terror Attacks **(a)** and Deaths from Terror Attacks **(b)** per Day after Drone Strikes, employing alternative time windows for the dependent variable. 
  - *Notes: Each point represents the coefficient related to drone strikes in a 2SLS regression.*
  
- **Figure 4**: IV Results from Predicting **(a)** the Number of TNI Articles Mentioning Drone, a US-Related Keyword, or a Terror-Group-Related Keyword on Days t + 1 until t + 7, and **(b)** the Emotional Content of Drone-Related Articles on Days t + 1 until t + 7.
  
- **Figure 5**: IV Results from Predicting **(a)** Emotional Content of Articles Mentioning a US-Related Keyword on Days t + 1 until t + 7, and **(b)** Emotional Content of Articles Mentioning a Terror-Group-Related Keyword on Days t + 1 until t + 7.
  
- **Figure 6**: IV Results from Predicting **(a)** Anti-US and Anti-Terror-Group Protests on Days t + 1 until t + 7, and **(b)** Anti-US and Anti-Terror-Group Protests on Days t + 1 until t + 14.
  
- **Figure 7**: IV Results from Predicting Google Searches for Various Topics on **(a)** Days t + 1 until t + 7, and **(b)** Days t + 1 until t + 14.

### Comments on Output Accuracy

All outputs produced by this package match exactly the results presented in the paper, with one exception: the HAC standard errors (SE) in Panel A for second-stage regressions. This discrepancy arises from computational differences between STATA and Julia packages when calculating standard errors for two-stage least squares (2SLS) regressions. Specifically, the HAC SEs in Panel A produced by the `CovarianceMatrices package exhibit an average deviation of 22.7% (all smaller) compared to the paper’s results. This difference can be considered minor and does not affect the overall conclusions. Importantly, for first-stage (Panel B) and OLS regressions (Panel D), all HAC SEs **align perfectly** with the paper’s outputs, including across all specified bandwidths and lags. Furthermore, all other regression results, including coefficients, HAC SEs, and confidence intervals used to replicate figures, are an **exact match** to the paper’s outputs, validating the package’s **high level of accuracy**.

The primary reason for the discrepancy in Panel A lies in the need to compute the 2SLS regression manually using the `GLM` package to leverage the `CovarianceMatrices` package for HAC SE computation. This workaround is necessary because `CovarianceMatrices` is currently not compatible with `FixedEffectModels, the package that allows for running the second-stage regression directly. As a result, the manually computed standard errors may not fully account for additional uncertainty arising from the first stage of the 2SLS estimation.

### Potential Extension 

A valuable extension of this package would involve enabling compatibility of the `CovarianceMatrices` package with `FixedEffectModels`, or alternatively adding HAC SE computation functionality to the `Vcov.jl` package, built for the `FixedEffectModels` but which currently only for the following types of SE: includes `Vcov.simple()`, `Vcov.robust()`, and `Vcov.cluster(…)`. One could also consider creating another compatible package, to directly compute HAC SEs for second-stage regressions using rigorous econometric formulas. This would allow for direct computation of HAC SEs for second-stage regressions using rigorous econometric formulas, eliminating the need for manual 2SLS computation. While this remains outside the scope of the current replication, it would be a valuable project to consider, particularly as part of an econometrics package design exercise.






