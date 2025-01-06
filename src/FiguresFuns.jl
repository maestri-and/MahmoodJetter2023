###############################################################################
############################# FiguresFuns.JL ##################################

####### This script defines the functions used to replicate all Figures  ######
######################### in Mahmood & Jetter, 2023 ###########################
###############################################################################


module FiguresFuns

"""
# FiguresFuns Module

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
"""


#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#---------------# 0. IMPORTING LIBRARIES AND DEFINING EXPORTS #---------------#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

using DataFrames
using Statistics
using GLM
using StatsPlots
using Binscatters
using PrettyTables
using Plots
using FixedEffectModels

export binscatter_improved, generate_figure2a, generate_figure2b, 
    generate_figure2c, generate_figure2d, generate_figure2e, generate_figure2f,
    run_regressions, extract_coefficients, create_plot, process_analysis, 
    run_regressions_figure3, generate_figure3, generate_figure4, generate_figure5,
    generate_figure6, generate_figure7

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#-----# a. Function improving upon an existing Julia binscatter function #----#
#--------------# replicating the STATA binscatter function #------------------#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

    """
    binscatter_improved(df::DataFrame, dep_var::Symbol, indep_var::Symbol, controls::Vector{Symbol}; xlabel::String = "Independent Variable", ylabel::String = "Dependent Variable", title_prefix::String = "Binscatter", n_bins::Int = 10, ylim_range::Tuple{Float64, Float64} = (0.0, 0.2), yticks_step::Float64 = 0.05, output_filename::String = "binscatter.pdf")

    Creates a customizable binscatter plot and regression table to analyze the 
    relationship between a dependent variable and an independent variable, controlling 
    for additional covariates. The function generates a binscatter plot with a linear 
    fit and displays regression results (coefficients, p-values, confidence intervals) 
    for the independent variable and intercept. The plot is saved as a PDF, and a regression results 
    table is shown in the console.

    # Arguments
    - `df::DataFrame`: The input DataFrame containing the data for analysis.
    - `dep_var::Symbol`: The dependent variable (e.g., `:drones`).
    - `indep_var::Symbol`: The independent variable (e.g., `:gusts`).
    - `controls::Vector{Symbol}`: A vector of control variables (e.g., `[:dows1, :dows2, :ramadan]`).
    - `xlabel::String`: The label for the x-axis (default is "Independent Variable").
    - `ylabel::String`: The label for the y-axis (default is "Dependent Variable").
    - `title_prefix::String`: A prefix for the plot title (default is "Binscatter").
    - `n_bins::Int`: The number of bins for the binscatter plot (default is 10).
    - `ylim_range::Tuple{Float64, Float64}`: The range for the y-axis (default is (0.0, 0.2)).
    - `yticks_step::Float64`: The step size for the y-axis ticks (default is 0.05).
    - `output_filename::String`: The filename for saving the plot (default is "binscatter.pdf").

    # Returns
    This function does not return a value. It generates the following outputs:
    - A binscatter plot saved as a PDF file with the specified filename in the `output` directory.
    - A regression table displayed in the console, showing the coefficients, standard errors, 
        t-statistics, p-values, and 95% confidence intervals for the intercept and independent variable.

    # Example

    ```julia
    df = DataFrame(...)  # Your dataset
    binscatter_improved(df, :drones, :gusts, [:dows1, :ramadan, :date], xlabel="Gusts", ylabel="Drone Strikes", title_prefix="Binscatter with Controls", n_bins=15, output_filename="binscatter_custom.pdf")
    ```
    # Notes
    - Missing data for the dependent or independent variables are automatically dropped.
    - The regression formula dynamically includes the dependent variable, independent variable, and control variables.
    """

    function binscatter_improved(
        df::DataFrame, 
        dep_var::Symbol,  # Dependent variable (e.g., :drones)
        indep_var::Symbol,  # Independent variable (e.g., :gusts)
        controls::Vector{Symbol};  # Control variables (e.g., [:dows1, :dows2, :ramadan, ...])
        xlabel::String = "Independent Variable", 
        ylabel::String = "Dependent Variable", 
        title_prefix::String = "Binscatter", 
        n_bins::Int = 10,  # Number of bins for the binscatter plot
        ylim_range::Tuple{Float64, Float64} = (0.0, 0.2), 
        yticks_step::Float64 = 0.05, 
        output_filename::String = "binscatter.pdf"
        )
        # Step 1: Drop rows with missing data in the dependent or independent variables
        variables_to_check = [dep_var, indep_var]  # List of variables to check for missing data
        df_clean = dropmissing(df, variables_to_check)

        # Step 2: Dynamically construct the regression formula
        # Combine the dependent variable, independent variable, and controls into a formula
        formula = Term(dep_var) ~ Term(indep_var) + sum(Term.(controls))

        # Step 3: Fit the regression model
        model = lm(formula, df_clean)

        # Extract the p-value for the independent variable
        indep_index = findfirst(==(string(indep_var)), coeftable(model).rownms)
        p_value = coeftable(model).cols[4][indep_index]  # P-value for the independent variable

        # Create a dynamic title for the plot
        title_text = "$title_prefix (p = $(round(p_value, digits=4)))"

        # Step 4: Generate the binscatter plot
        p = binscatter(df_clean, formula, n = n_bins; seriestype = :linearfit, 
                    xlabel = xlabel,
                    xguidefontsize = 10,  
                    ylabel = ylabel,
                    yguidefontsize = 10, 
                    title = title_text,
                    titlefont = 10,
                    ylim = ylim_range, 
                    yticks = ylim_range[1]:yticks_step:ylim_range[2])

        # Show the plot
        display(p)

        # Save the plot
        script_dir = "output"  # Directory where the script is located
        output_path = joinpath(script_dir, output_filename)  # Combine directory with file name
        savefig(output_path)
        println("Plot saved at $output_path")

        # Step 5: Extract regression results for the independent variable and intercept
        intercept_index = findfirst(==("(Intercept)"), coeftable(model).rownms)  # Index for intercept

        results = DataFrame(
            Term = ["Intercept", string(indep_var)],  # Terms to display
            Coefficient = [coef(model)[intercept_index], coef(model)[indep_index]],  # Coefficients
            StdErr = [coeftable(model).cols[2][intercept_index], coeftable(model).cols[2][indep_index]],  # Std Errors
            tStatistic = [coeftable(model).cols[3][intercept_index], coeftable(model).cols[3][indep_index]],  # t-Statistics
            pValue = [coeftable(model).cols[4][intercept_index], coeftable(model).cols[4][indep_index]],  # p-values
            Lower95CI = [confint(model)[intercept_index, 1], confint(model)[indep_index, 1]],  # Lower 95% CI
            Upper95CI = [confint(model)[intercept_index, 2], confint(model)[indep_index, 2]]   # Upper 95% CI
        )

        # Step 6: Display the table nicely with PrettyTables
        pretty_table(
            results,
            header = ["Term", "Coefficient", "Std. Error", "t-Statistic", "p-Value", "Lower 95% CI", "Upper 95% CI"],
            formatters = ft_printf("%.4f"),  # Format numeric values to 4 decimal places
            alignment = :l,  # Align text to the left
            title = "Regression Results for Intercept and Independent Variable"
        )
    end


#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#-----------------------------------------------------------------------------#
#-------------# b. Functions generating Figures 2(a) - 2(f) #-----------------#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

    """
    generate_figure2a(df::DataFrame)

    Generates a binscatter plot for the relationship between wind gusts and drone 
    strikes, controlling for a set of covariates. The plot includes a linear fit, 
    and the figure is saved as a PDF. The function utilizes the `binscatter_improved` 
    function for plotting and regression analysis.

    # Arguments
    - `df::DataFrame`: The input DataFrame containing the data for analysis.

    # Returns
    This function does not return a value. It generates the following output:
    - A binscatter plot saved as a PDF file with the filename `"figure_2a.pdf"` in the `output` directory.

    # Example

    ```julia
    df = DataFrame(...)  # Your dataset
    generate_figure2a(df)
    ```

    # Notes
    The documentation for this function serves as a model for the following functions:
    - generate_figure2b
    - generate_figure2c
    - generate_figure2d
    - generate_figure2e
    - generate_figure2f
    """

    function generate_figure2a(df)
        # Defining the control variables for figures 2(a) to 2(d)
        controls = [:dows2, :dows3, :dows4, :dows5, :dows6, :dows7, :ramadan, :date, 
        :months2, :months3, :months4, :months5, :months6, :months7, :months8, :months9, 
        :months10, :months11, :months12, :mil_act1, :mil_act2, :mil_act3, :mil_act4, 
        :mil_act5, :mil_act6, :mil_act7, :mil_act8, :mil_act9, :mil_act10, :mil_act11, 
        :mil_act12, :mil_act13, :mil_act14, :attacks1, :attacks2, :attacks3, :attacks4, 
        :attacks5, :attacks6, :attacks7, :attacks8, :attacks9, :attacks10, :attacks11, 
        :attacks12, :attacks13, :attacks14, :tmean2_mir, :lnprec]

        binscatter_improved(
            df,
            :drones,
            :gusts,
            controls,
            xlabel = "Wind gusts on day t",
            ylabel = "Drone strikes on day t",
            title_prefix = "Wind gusts in Miran Shah and drone strikes",
            n_bins = 10,
            ylim_range = (0.0, 0.2),
            yticks_step = 0.05,
            output_filename = "figure_2a.pdf"
        )
    end

    function generate_figure2b(df)
        # Defining the control variables for figures 2(a) to 2(d)
        controls = [:dows2, :dows3, :dows4, :dows5, :dows6, :dows7, :ramadan, :date, 
        :months2, :months3, :months4, :months5, :months6, :months7, :months8, :months9, 
        :months10, :months11, :months12, :mil_act1, :mil_act2, :mil_act3, :mil_act4, 
        :mil_act5, :mil_act6, :mil_act7, :mil_act8, :mil_act9, :mil_act10, :mil_act11, 
        :mil_act12, :mil_act13, :mil_act14, :attacks1, :attacks2, :attacks3, :attacks4, 
        :attacks5, :attacks6, :attacks7, :attacks8, :attacks9, :attacks10, :attacks11, 
        :attacks12, :attacks13, :attacks14, :tmean2_mir, :lnprec]

        # Call the function for figure 2b
        binscatter_improved(
            df,
            :drones,
            :gusts_karachi,
            controls,
            xlabel = "Wind gusts on day t",
            ylabel = "Drone strikes on day t",
            title_prefix = "Wind gusts in Karachi and drone strikes",
            n_bins = 10,
            ylim_range = (0.0, 0.2),
            yticks_step = 0.05,
            output_filename = "figure_2b.pdf"
        )
    end

    function generate_figure2c(df)
        # Defining the control variables for figures 2(a) to 2(d)
        controls = [:dows2, :dows3, :dows4, :dows5, :dows6, :dows7, :ramadan, :date, 
        :months2, :months3, :months4, :months5, :months6, :months7, :months8, :months9, 
        :months10, :months11, :months12, :mil_act1, :mil_act2, :mil_act3, :mil_act4, 
        :mil_act5, :mil_act6, :mil_act7, :mil_act8, :mil_act9, :mil_act10, :mil_act11, 
        :mil_act12, :mil_act13, :mil_act14, :attacks1, :attacks2, :attacks3, :attacks4, 
        :attacks5, :attacks6, :attacks7, :attacks8, :attacks9, :attacks10, :attacks11, 
        :attacks12, :attacks13, :attacks14, :tmean2_mir, :lnprec]

        # Call the function for the figure 2c
        binscatter_improved(
            df,
            :attacksin7,
            :gusts,
            controls,
            xlabel = "Wind gusts on day t",
            ylabel = "Terror attacks per day on days t+1 to t+7",
            title_prefix = "Wind gusts in Miran Shah and subsequent terror attacks",
            n_bins = 10,
            ylim_range = (2.6, 3.1),
            yticks_step = 0.1,
            output_filename = "figure_2c.pdf"
        )
    end

    function generate_figure2d(df)
        # Defining the control variables for figures 2(a) to 2(d)
        controls = [:dows2, :dows3, :dows4, :dows5, :dows6, :dows7, :ramadan, :date, 
        :months2, :months3, :months4, :months5, :months6, :months7, :months8, :months9, 
        :months10, :months11, :months12, :mil_act1, :mil_act2, :mil_act3, :mil_act4, 
        :mil_act5, :mil_act6, :mil_act7, :mil_act8, :mil_act9, :mil_act10, :mil_act11, 
        :mil_act12, :mil_act13, :mil_act14, :attacks1, :attacks2, :attacks3, :attacks4, 
        :attacks5, :attacks6, :attacks7, :attacks8, :attacks9, :attacks10, :attacks11, 
        :attacks12, :attacks13, :attacks14, :tmean2_mir, :lnprec]

        # Call the function for the figure 2d
        binscatter_improved(
            df,
            :attacksin7,
            :gusts_karachi,
            controls,
            xlabel = "Wind gusts on day t",
            ylabel = "Terror attacks per day on days t+1 to t+7",
            title_prefix = "Wind gusts in Karachi and and subsequent terror attacks",
            n_bins = 10,
            ylim_range = (2.6, 3.1),
            yticks_step = 0.1,
            output_filename = "figure_2d.pdf"
        )
    end

    function generate_figure2e(df)
        # Defining the control variables for figure 2(e)
        controls2e = [:dows2, :dows3, :dows4, :dows5, :dows6, :dows7, :ramadan, :date, 
        :months2, :months3, :months4, :months5, :months6, :months7, :months8, :months9, 
        :months10, :months11, :months12, :mil_act1, :mil_act2, :mil_act3, :mil_act4, 
        :mil_act5, :mil_act6, :mil_act7, :mil_act8, :mil_act9, :mil_act10, :mil_act11, 
        :mil_act12, :mil_act13, :mil_act14, :attacks2, :attacks3, :attacks4, 
        :attacks5, :attacks6, :attacks7, :attacks8, :attacks9, :attacks10, :attacks11, 
        :attacks12, :attacks13, :attacks14, :tmean2_mir, :lnprec]

        # Call the function for the figure 2e
        binscatter_improved(
            df,
            :attacks1,
            :gusts,
            controls2e,
            xlabel = "Wind gusts on day t",
            ylabel = "Terror attacks on day t-1",
            title_prefix = "Wind gusts in Miran Shah and past terror attacks",
            n_bins = 10,
            ylim_range = (2.4, 3.2),
            yticks_step = 0.2,
            output_filename = "figure_2e.pdf"
        )
    end

    function generate_figure2f(df)
        # Defining the control variables for figure 2(f)
        controls2f = [:dows2, :dows3, :dows4, :dows5, :dows6, :dows7, :ramadan, :date, 
        :months2, :months3, :months4, :months5, :months6, :months7, :months8, :months9, 
        :months10, :months11, :months12, :mil_act2, :mil_act3, :mil_act4, 
        :mil_act5, :mil_act6, :mil_act7, :mil_act8, :mil_act9, :mil_act10, :mil_act11, 
        :mil_act12, :mil_act13, :mil_act14, :attacks1, :attacks2, :attacks3, :attacks4, 
        :attacks5, :attacks6, :attacks7, :attacks8, :attacks9, :attacks10, :attacks11, 
        :attacks12, :attacks13, :attacks14, :tmean2_mir, :lnprec]

        # Call the function for the figure 2f
        binscatter_improved(
            df,
            :mil_act1,
            :gusts,
            controls2f,
            xlabel = "Wind gusts on day t",
            ylabel = "Pakistani military actions on day t-1",
            title_prefix = "Wind gusts in Miran Shah and past Pakistani military actions",
            n_bins = 10,
            ylim_range = (0.6, 1.4),
            yticks_step = 0.2,
            output_filename = "figure_2f.pdf"
        )
    end

###############################################################################
#              Useful function to generate Figures 3, 4, 5, 6 & 7
###############################################################################

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#------# c. Function which runs 2SLS regressions for a set of dependent #-----#
#---------------# variables over a specified time window #--------------------#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

    """
    run_regressions(dependent_vars, time_window, df_clean)

    Runs 2SLS regressions for a set of dependent variables over a specified time window 
    and stores the results in a dictionary. The function dynamically constructs 
    regression formulas for each dependent variable, including both the lagged variables 
    and a set of control variables, and computes robust standard errors. The function is 
    useful to produce figures 4, 5, 6 and 7.

    # Arguments
    - `dependent_vars::Vector{Symbol}`: A vector of symbols representing the dependent variables to be regressed (e.g., `[:attacksin7, :attacksin14]`).
    - `time_window::Int`: The time window to be used in the regression, influencing both the dependent variable and the lagged variables (e.g., 7 for a 7-day window).
    - `df_clean::DataFrame`: The cleaned DataFrame containing the data for the regressions.

    # Returns
    A `Dict` where the keys are the names of the dependent variables (e.g., `:attacksin7`), and the values are the regression results stored as objects returned by the `reg` function (e.g., fitted model, coefficient estimates, robust standard errors, etc.).

    # Example

    ```julia
    df_clean = DataFrame(...)  # Your cleaned dataset
    dependent_vars = [:attacksin7, :attacksin14]
    time_window = 7
    results = run_regressions(dependent_vars, time_window, df_clean)

    # Accessing results for a specific dependent variable
    results[:attacksin7]  # Regression results for the 'attacksin7' dependent variable
    ````

    # Note
    - The regression includes robust standard errors using the Vcov.robust() function.
    """
    # Function to run regressions
    function run_regressions(dependent_vars, time_window, df_clean)
        results = Dict()
        for dep_var in dependent_vars
            # Construct the dependent variable name
            dep_var_time = Symbol("$(dep_var)in$time_window")
            
            # Construct lagged variables dynamically as symbols
            lagged_vars = [Symbol("$(dep_var)$i") for i in 1:14]

            # Dynamically construct the formula
            formula = @eval @formula($dep_var_time ~ (drones ~ gusts) + attacks + $(Symbol("attacksin$time_window")) + 
                                dows1 + dows2 + dows3 + dows4 + dows5 + dows6 + ramadan + date + 
                                months1 + months2 + months3 + months4 + months5 + months6 + months7 + 
                                months8 + months9 + months10 + months11 + mil_act1 + mil_act2 + mil_act3 + 
                                mil_act4 + mil_act5 + mil_act6 + mil_act7 + mil_act8 + mil_act9 + 
                                mil_act10 + mil_act11 + mil_act12 + mil_act13 + mil_act14 + $(lagged_vars...) + 
                                tmean2_mir + lnprec)

            # Run regression and store results
            println("Running regression for $dep_var_time")
            try
                result = reg(df_clean, formula, Vcov.robust())
                results[dep_var] = result
            catch e
                println("Error running regression for $dep_var_time: $e")
            end
        end
        return results
    end

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#-----------# d. Function which extracts coefficients and errors #------------#
#-----------------------------------------------------------------------------#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

    """
    extract_coefficients(results::Dict, dependent_vars::Vector{Symbol})

    Extracts the coefficients and standard errors for the variable `drones` from 
    a set of regression results. For each dependent variable specified, the function 
    looks up the corresponding regression result, extracts the coefficient and 
    standard error for `drones`, and computes the 95% confidence interval.

    # Arguments
    - `results::Dict`: A dictionary where the keys are the names of the dependent variables, and the values are the corresponding regression results (e.g., regression outputs from the `reg` function).
    - `dependent_vars::Vector{Symbol}`: A vector of symbols representing the dependent variables for which the coefficients and standard errors are to be extracted (e.g., `[:attacksin7, :attacksin14]`).

    # Returns
    A tuple of two vectors:
    - `coeffs::Vector{Float64}`: A vector of coefficients for `drones` extracted from each regression result.
    - `errors::Vector{Float64}`: A vector of the 95% confidence intervals for `drones`, calculated as 1.96 times the standard error.

    # Example

    ```julia
    results = Dict(
        :attacksin7 => regression_result_1,
        :attacksin14 => regression_result_2
    )

    dependent_vars = [:attacksin7, :attacksin14]
    coeffs, errors = extract_coefficients(results, dependent_vars)

    # coeffs contains the extracted coefficients for 'drones' in each regression
    # errors contains the 95% confidence intervals for 'drones'
    ```
    """
    # Function to extract coefficients and errors
    function extract_coefficients(results, dependent_vars)
        coeffs = []
        errors = []
        for dep_var in dependent_vars
            if haskey(results, dep_var)
                result = results[dep_var]
                ct = coeftable(result)
                df = DataFrame(ct)

                # Find the row corresponding to "drones"
                row = filter(row -> row[1] == "drones", eachrow(df)) |> first

                # Extract coefficient and standard error
                coef = row[2]
                se = row[3]

                # Append to lists
                push!(coeffs, coef)
                push!(errors, 1.96 * se)  # 95% confidence interval
            else
                println("No result found for $dep_var")
            end
        end
        return coeffs, errors
    end

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#--------# d. Function which creates the plots of regression results #--------#
#-----------------------------------------------------------------------------#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

    """
    create_plot(coeffs, errors, labels, title_text, x_axis_title, ylim_values, yticks_step, xrotation_angle, output_path)

    Creates a plot displaying the coefficients of a regression model (involving the effect of drone strikes), with error 
    bars representing the standard errors. The plot includes labels, a title, and custom axis settings, and is saved as an image file.

    # Arguments
    - `coeffs::Vector{Float64}`: A vector of coefficients to be plotted (e.g., coefficients for `drones` from a regression).
    - `errors::Vector{Float64}`: A vector of error values for each coefficient (e.g., standard errors or 95% confidence intervals).
    - `labels::Vector{String}`: A vector of labels corresponding to each coefficient (e.g., the names of the variables for which the coefficients are calculated).
    - `title_text::String`: The title of the plot.
    - `x_axis_title::String`: The title for the x-axis.
    - `ylim_values::Tuple{Float64, Float64}`: The limits for the y-axis (e.g., `(0.0, 0.5)`).
    - `yticks_step::Float64`: The step size between y-axis ticks (e.g., `0.05`).
    - `xrotation_angle::Float64`: The angle for rotating the x-axis labels (e.g., `45` for angled labels).
    - `output_path::String`: The file path where the plot should be saved (e.g., `"output/plot.png"`).

    # Returns
    This function does not return a value. It generates and saves the plot as an image at the specified output path.

    # Example

    ```julia
    coeffs = [0.25, 0.4, -0.1, 0.5]
    errors = [0.05, 0.07, 0.03, 0.06]
    labels = ["Model 1", "Model 2", "Model 3", "Model 4"]
    title_text = "Effect of Drone Strikes on Terror Attacks"
    x_axis_title = "Model"
    ylim_values = (0.0, 1.0)
    yticks_step = 0.1
    xrotation_angle = 45
    output_path = "output/drone_strike_plot.pdf"

    create_plot(coeffs, errors, labels, title_text, x_axis_title, ylim_values, yticks_step, xrotation_angle, output_path)
    ```

    # Notes 
    - A red horizontal dashed line at 0 is added to the plot to show the baseline.
    """
    # Function to create the plot
    function create_plot(coeffs, errors, labels, title_text, x_axis_title, ylim_values, yticks_step, xrotation_angle, output_path)
        # Create the plot
        plt = scatter(1:length(coeffs), coeffs, ylim=ylim_values, yerr=errors, label="", marker=:diamond, color=:navy)

        # Set x-axis ticks with labels
        xticks = (1:length(labels), labels)

        # Add horizontal line at 0
        hline!([0], color=:red, linestyle=:dash, label="")

        # Add axis labels and title
        xlabel!(x_axis_title, guidefont=font(10))  # Customizable x-axis title
        ylabel!("Coefficient of drone strikes", guidefont=font(10))
        title!(title_text, titlefont=font(12))

        # Generate y-axis ticks based on the range and step
        yticks = collect(ylim_values[1]:yticks_step:ylim_values[2])
        plot!(xticks=xticks, yticks=yticks, xrotation=xrotation_angle, xlims=(0.5, length(labels) + 0.5))

        # Display the plot
        display(plt)

        # Save the plot
        savefig(output_path)
        println("Plot saved at $output_path")
    end

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#------# e. Function which compiles all previous ones to output plots #-------#
#----------------------# for figures 4, 5, 6 & 7 #----------------------------#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

    """
    process_analysis(dependent_vars, time_window, labels, title_text, x_axis_title, ylim_values, yticks_step, xrotation_angle, output_file, df_clean)

    Automates the workflow for running regressions, extracting coefficients and errors, and generating a plot. The function orchestrates the steps by calling `run_regressions`, `extract_coefficients`, and `create_plot` in sequence. This helps streamline the process of analyzing regression results and visualizing the coefficients with error bars.

    # Arguments
    - `dependent_vars::Vector{Symbol}`: A vector of symbols representing the dependent variables to be used in the regressions (e.g., `[:attacksin7, :attacksin14]`).
    - `time_window::Int`: The time window to be used in the regression (e.g., `7` for a 7-day window).
    - `labels::Vector{String}`: A vector of strings for labeling each coefficient (e.g., the names of models or variables).
    - `title_text::String`: The title for the plot.
    - `x_axis_title::String`: The title for the x-axis of the plot.
    - `ylim_values::Tuple{Float64, Float64}`: The limits for the y-axis (e.g., `(0.0, 0.5)`).
    - `yticks_step::Float64`: The step size for the y-axis ticks (e.g., `0.05`).
    - `xrotation_angle::Float64`: The angle to rotate the x-axis labels for better readability (e.g., `45`).
    - `output_file::String`: The file path for saving the plot (e.g., `"output/plot.png"`).
    - `df_clean::DataFrame`: The cleaned DataFrame containing the data for the regressions.

    # Returns
    This function does not return a value. It generates and saves a plot, automating the entire workflow of regression analysis and visualization.

    # Example

    ```julia
    dependent_vars = [:attacksin7, :attacksin14]
    time_window = 7
    labels = ["Model 1", "Model 2"]
    title_text = "Effect of Drone Strikes on Terror Attacks"
    x_axis_title = "Model"
    ylim_values = (0.0, 1.0)
    yticks_step = 0.1
    xrotation_angle = 45
    output_file = "output/drone_strike_plot.pdf"
    df_clean = DataFrame(...)  # Your cleaned dataset

    process_analysis(dependent_vars, time_window, labels, title_text, x_axis_title, ylim_values, yticks_step, xrotation_angle, output_file, df_clean)
    ```
    """
    # Main function to automate the workflow
    function process_analysis(dependent_vars, time_window, labels, title_text, x_axis_title, ylim_values, yticks_step, xrotation_angle, output_file, df_clean)
        results = run_regressions(dependent_vars, time_window, df_clean)
        coeffs, errors = extract_coefficients(results, dependent_vars)
        create_plot(coeffs, errors, labels, title_text, x_axis_title, ylim_values, yticks_step, xrotation_angle, output_file)
    end

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#----------# f. Specific function to run regressions for Figure 3 #-----------#
#-----------------------------------------------------------------------------#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

    """
    run_regressions_figure3(dependent_vars, time_window, additional_vars, df_clean)

Runs multiple regressions for a set of dependent variables, including both time-specific 
variables (e.g., "attacksin1", "attacksin2", ...) and variables with a specific syntax 
(e.g., "attacks15to21", "attacks15to28"). The function stores the regression results in 
a dictionary and uses robust standard errors.

# Arguments
- `dependent_vars::String`: The base name of the dependent variable (e.g., `"attacksin"`). This will be dynamically used to generate dependent variables like `"attacksin1"`, `"attacksin2"`, ..., `"attacksin14"`.
- `time_window::Int`: The time window for the regressions (not directly used in the function but can inform the range of time variables).
- `additional_vars::Vector{Tuple{String, String}}`: A vector of tuples where each tuple contains an outcome variable name (e.g., `"attacks15to21"`) and a label for the regression (e.g., `"attacks15to21_label"`).
- `df_clean::DataFrame`: The cleaned DataFrame containing the data for the regressions.

# Returns
A dictionary (`Dict`) where the keys are the names of the regression results (e.g., `"e1"`, `"e2"`, ..., for the time-specific variables, and the labels for the additional variables) and the values are the regression results (fitted models and other relevant output).

# Example

```julia
dependent_vars = "attacksin"  # Base name for dependent variables
time_window = 7
additional_vars = [("attacks15to21", "Attacks 15-21 days"),("attacks15to28", "Attacks 15-28 days")]
df_clean = DataFrame(...)  # Your cleaned dataset

results = run_regressions_figure3(dependent_vars, time_window, additional_vars, df_clean)

# Accessing results for specific regressions
results["e1"]  # Results for the regression with "attacksin1"
results["Attacks 15-21 days"]  # Results for the regression with "attacks15to21"
```

# Notes
- This function is essentially the same as `run_regressions_figure` and only varies to take into account specific variable syntax.
    """

    function run_regressions_figure3(dependent_vars, time_window, additional_vars, df_clean)
        results = Dict()
        
        # First loop: "attacksin1", "attacksin2", ..., "attacksin14"
        for x in [1:14; 21; 28]
            dep_var = Symbol("$(dependent_vars)in$x")  # Construct the dependent variable name
            
            # Dynamically construct the formula
            formula = @eval @formula($dep_var ~ (drones ~ gusts) + dows1 + dows2 + dows3 + dows4 + dows5 + dows6 +
                                    ramadan + date + months1 + months2 + months3 + months4 + months5 + months6 +
                                    months7 + months8 + months9 + months10 + months11 +
                                    mil_act1 + mil_act2 + mil_act3 + mil_act4 + mil_act5 + mil_act6 + mil_act7 + mil_act8 +
                                    mil_act9 + mil_act10 + mil_act11 + mil_act12 + mil_act13 + mil_act14 +
                                    $(Symbol("$(dependent_vars)1")) + $(Symbol("$(dependent_vars)2")) + 
                                    $(Symbol("$(dependent_vars)3")) + $(Symbol("$(dependent_vars)4")) +
                                    $(Symbol("$(dependent_vars)5")) + $(Symbol("$(dependent_vars)6")) +
                                    $(Symbol("$(dependent_vars)7")) + $(Symbol("$(dependent_vars)8")) +
                                    $(Symbol("$(dependent_vars)9")) + $(Symbol("$(dependent_vars)10")) +
                                    $(Symbol("$(dependent_vars)11")) + $(Symbol("$(dependent_vars)12")) +
                                    $(Symbol("$(dependent_vars)13")) + $(Symbol("$(dependent_vars)14")) +
                                    tmean2_mir + lnprec)

            # Run regression and store results
            println("Running regression for $dep_var")
            try
                result = reg(df_clean, formula, Vcov.robust())
                results["e$x"] = result
            catch e
                println("Error running regression for $dep_var: $e")
            end
        end
        
        # Second loop: Additional variables ("attacks15to21", "attacks15to28", etc.)
        for (outcome, label) in additional_vars
            outcome_var = Symbol(outcome)  # Construct the dependent variable name
            
            # Dynamically construct the formula
            formula = @eval @formula($outcome_var ~ (drones ~ gusts) + dows1 + dows2 + dows3 + dows4 + dows5 + dows6 +
                                    ramadan + date + months1 + months2 + months3 + months4 + months5 + months6 +
                                    months7 + months8 + months9 + months10 + months11 +
                                    mil_act1 + mil_act2 + mil_act3 + mil_act4 + mil_act5 + mil_act6 + mil_act7 + mil_act8 +
                                    mil_act9 + mil_act10 + mil_act11 + mil_act12 + mil_act13 + mil_act14 +
                                    $(Symbol("$(dependent_vars)1")) + $(Symbol("$(dependent_vars)2")) +
                                    $(Symbol("$(dependent_vars)3")) + $(Symbol("$(dependent_vars)4")) +
                                    $(Symbol("$(dependent_vars)5")) + $(Symbol("$(dependent_vars)6")) +
                                    $(Symbol("$(dependent_vars)7")) + $(Symbol("$(dependent_vars)8")) +
                                    $(Symbol("$(dependent_vars)9")) + $(Symbol("$(dependent_vars)10")) +
                                    $(Symbol("$(dependent_vars)11")) + $(Symbol("$(dependent_vars)12")) +
                                    $(Symbol("$(dependent_vars)13")) + $(Symbol("$(dependent_vars)14")) +
                                    tmean2_mir + lnprec)
            
            # Run regression and store results
            println("Running regression for $outcome_var")
            try
                result = reg(df_clean, formula, Vcov.robust())
                results[label] = result
            catch e
                println("Error running regression for $outcome_var: $e")
            end
        end

        return results
    end

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#-------------# g. Functions generating Figures 3, 4, 5, 6 & 7 #--------------#
#-----------------------------------------------------------------------------#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

    """
    generate_figure3(df_clean)

Generates Figures 3a and 3b, which show the relationship between subsequent 
terror attacks and deaths per day after drone strikes. The function runs 
regressions for both attacks and deaths, extracts the relevant coefficients, 
and creates plots for each, saving them as PDF files.

# Arguments
- `df_clean::DataFrame`: The cleaned DataFrame containing the data for the regressions.

# Returns
This function does not return a value. It generates and saves two plots:
1. **Figure 3a**: A plot showing subsequent terror attacks per day after drone strikes.
2. **Figure 3b**: A plot showing subsequent terror deaths per day after drone strikes.

Both plots are saved as PDF files in the `output` folder.

# Example

```julia
df_clean = DataFrame(...)  # Your cleaned dataset
generate_figure3(df_clean)
```
# Notes
- The documentation for this function serves as a model for the following functions:
- generate_figure4
- generate_figure5
- generate_figure6
- generate_figure7

"""

    function generate_figure3(df_clean)
        # Figure 3a: Subsequent terror attacks per day
        dependent_vars_attacks = "attacks"
        additional_vars_attacks = [
            ("attacks15to21", "e17"),
            ("attacks15to28", "e18"),
            ("attacks15to70", "e19")
        ]
        labels_attacks = [
            "1", "1–2", "1–3", "1–4", "1–5", "1–6", "1–7", "1–8", "1–9", "1–10",
            "1–11", "1–12", "1–13", "1–14", "1–21", "1–28", "15–21", "15–28", "15–70"
        ]
        title_text_attacks = "Subsequent terror attacks per day"
        x_axis_title_attacks = "Days after drone strikes"
        output_file_attacks = joinpath("output", "subsequent_terror_plot.pdf")
        ylim_attacks = (-5, 10)  # Y-axis limits
        yticks_step_attacks = 5  # Step size for y-axis ticks
        xrotation_attacks = 90  # Vertical x-labels

        results_attacks = run_regressions_figure3(dependent_vars_attacks, 7, additional_vars_attacks, df_clean)
        coeffs, errors = extract_coefficients(results_attacks, ["e1", "e2", "e3", "e4", "e5", "e6", "e7", "e8", "e9", "e10", "e11", "e12", "e13", "e14", "e21", "e28", "e17", "e18", "e19"])
        create_plot(coeffs, errors, labels_attacks, title_text_attacks, x_axis_title_attacks, ylim_attacks, yticks_step_attacks, xrotation_attacks, output_file_attacks)

        #Figure 3b: Subsequent terror deaths per day
        dependent_vars_deaths = "deaths"
        additional_vars_deaths = [
            ("deaths15to21", "e17"),
            ("deaths15to28", "e18"),
            ("deaths15to70", "e19")
        ]
        labels_deaths = [
            "1", "1–2", "1–3", "1–4", "1–5", "1–6", "1–7", "1–8", "1–9", "1–10",
            "1–11", "1–12", "1–13", "1–14", "1–21", "1–28", "15–21", "15–28", "15–70"
        ]
        title_text_deaths = "Subsequent terror deaths per day"
        x_axis_title_deaths = "Days after drone strikes"
        output_file_deaths = joinpath("output", "subsequent_deaths_plot.pdf")
        ylim_deaths = (-10, 30)  # Y-axis limits
        yticks_step_deaths = 5  # Step size for y-axis ticks
        xrotation_deaths = 90  # Vertical x-labels

        results_deaths = run_regressions_figure3(dependent_vars_deaths, 7, additional_vars_deaths, df_clean)
        coeffs, errors = extract_coefficients(results_deaths, ["e1", "e2", "e3", "e4", "e5", "e6", "e7", "e8", "e9", "e10", "e11", "e12", "e13", "e14", "e21", "e28", "e17", "e18", "e19"])
        create_plot(coeffs, errors, labels_deaths, title_text_deaths, x_axis_title_deaths, ylim_deaths, yticks_step_deaths, xrotation_deaths, output_file_deaths)
    end

    function generate_figure4(df_clean)
        #Figure 4a: Number of Drone Articles (Frequency of TNI Articles)
        dependent_vars = ["numdrone", "numus", "numterror"]
        labels = [
            "# of drone articles", 
            "# of US articles", 
            "# of terror group articles"
        ]
        title_text_drone = "(a) Frequency of TNI articles"
        x_axis_title_drone = " "
        output_file_drone = joinpath("output", "frequency_of_tni_articles.pdf")
        ylim_drone = (-1, 10)  # Y-axis limits
        yticks_step_drone = 1  # Step size for y-axis ticks
        xrotation_drone = 0  
        process_analysis(dependent_vars, 7, labels, title_text_drone, x_axis_title_drone, ylim_drone, yticks_step_drone, xrotation_drone, output_file_drone, df_clean)

        #Figure 4b: Sentiment of Drone-Related TNI Articles
        dependent_vars = ["avgdronenegemo", "avgdroneanger", "avgdroneposemo"]
        labels = [
            "Negative emotions", 
            "Anger", 
            "Positive emotions"
        ]
        title_text_sentiment = "(b) Sentiment of drone-related TNI articles"
        x_axis_title_sentiment = ""
        output_file_sentiment = joinpath("output", "sentiment_of_tni_articles.pdf")
        ylim_sentiment = (-0.5, 2.3)  # Y-axis limits
        yticks_step_sentiment = 0.5  # Step size for y-axis ticks
        xrotation_sentiment = 0 
        process_analysis(dependent_vars, 7, labels, title_text_sentiment, x_axis_title_sentiment, ylim_sentiment, yticks_step_sentiment, xrotation_sentiment, output_file_sentiment, df_clean)
    end

    function generate_figure5(df_clean)
        #Figure 5a: TNI Articles Mentioning US-Related Keyword
        dependent_vars = [
        "avgusnegemo", "avgusanger", "avgusposemo",
        "avgusnoterrornegemo", "avgusnoterroranger", "avgusnoterrorposemo",
        "avgusnodronenegemo", "avgusnodroneanger", "avgusnodroneposemo"
        ]
        labels = [
            "Negative\nemotions", 
            "Anger", 
            "Positive\nemotions",
            "Negative\nemotions\n(no terror)", 
            "Anger\n(no terror)", 
            "Positive\nemotions\n(no terror)",
            "Negative\nemotions\n(no drone)", 
            "Anger\n(no drone)", 
            "Positive\nemotions\n(no drone)"
        ]
        title_text_us = "(a) TNI articles mentioning US-related keyword"
        x_axis_title_us = " "
        output_file_us = joinpath("output", "tni_articles_us_keywords.pdf")
        ylim_us = (-1.5, 2.5)  # Y-axis limits
        yticks_step_us = 0.5  # Step size for y-axis ticks
        xrotation_us = 0
        process_analysis(dependent_vars, 7, labels, title_text_us, x_axis_title_us, ylim_us, yticks_step_us, xrotation_us, output_file_us, df_clean)

        #Figure 5b: TNI Articles Mentioning Terror-Group-Related Keyword
        dependent_vars = [
        "avgterrornegemo", "avgterroranger", "avgterrorposemo",
        "avgterrornousnegemo", "avgterrornousanger", "avgterrornousposemo",
        "avgterrornodronenegemo", "avgterrornodroneanger", "avgterrornodroneposemo"
        ]
        labels = [
            "Negative\nemotions", 
            "Anger", 
            "Positive\nemotions",
            "Negative\nemotions\n(no US)", 
            "Anger\n(no US)", 
            "Positive\nemotions\n(no US)",
            "Negative\nemotions\n(no drone)", 
            "Anger\n(no drone)", 
            "Positive\nemotions\n(no drone)"
        ]
        title_text_terror = "(b) TNI articles mentioning terror-group-related keyword"
        x_axis_title_terror = " "
        output_file_terror = joinpath("output", "tni_articles_terror_keywords.pdf")
        ylim_terror = (-3, 1)  # Y-axis limits
        yticks_step_terror = 0.5  # Step size for y-axis ticks
        xrotation_terror = 0
        process_analysis(dependent_vars, 7, labels, title_text_terror, x_axis_title_terror, ylim_terror, yticks_step_terror, xrotation_terror, output_file_terror, df_clean)
    end

    function generate_figure6(df_clean)
        #Figure 6a: Protests on Days t + 1 to t + 7
        dependent_vars = ["prot_us", "prot_usdum", "prot_ter", "prot_terdum"]
        labels = [
            "Anti-US protests", 
            "Anti-US protests\n(binary)", 
            "Anti-terror protests", 
            "Anti-terror protests\n(binary)"
        ]
        title_text_7 = "(a) Protests on days t + 1 until t + 7"
        x_axis_title_7 = " "
        output_file_7 = joinpath("output", "protests_on_days_t_plus_1_to_t_plus_7.pdf")
        ylim_7 = (-2, 5)  # Specify the y-axis limits
        yticks_step_7 = 1  # Specify the step size for y-axis ticks
        xrotation_7 = 0
        process_analysis(dependent_vars, 7, labels, title_text_7, x_axis_title_7, ylim_7, yticks_step_7, xrotation_7, output_file_7, df_clean)

        #Figure 6b: Protests on Days t + 1 to t + 7
        title_text_14 = "(b) Protests on days t + 1 until t + 14"
        x_axis_title_14 = " "
        output_file_14 = joinpath("output", "protests_on_days_t_plus_1_to_t_plus_14.pdf")
        ylim_14 = (-2, 5)  # Specify the y-axis limits
        yticks_step_14 = 1  # Specify the step size for y-axis ticks
        xrotation_14 = 0
        process_analysis(dependent_vars, 14, labels, title_text_14, x_axis_title_14, ylim_14, yticks_step_14, xrotation_14, output_file_14, df_clean)
    end

    function generate_figure7(df_clean)
        #Figure 7a: Google searches on days t + 1 until t + 7
        dependent_vars = ["jihad", "tvideo", "zarb", "ghazwa", "usaid", "usimmi", "usefp"]
        labels = [
            "Jihad", 
            "Taliban\nvideo", 
            "Zarb-e-\nMomin", 
            "Ghazwa e \nHind", 
            "USAID", 
            "US\nimmigration", 
            "USEFP"
        ]
        title_text_7 = "Google searches on days t + 1 until t + 7"
        x_axis_title_7 = " "
        output_file_7 = joinpath("output", "google_searches_days_t_plus_1_to_t_plus_7.pdf")
        ylim_7 = (-1, 2)  # Specify the y-axis limits
        yticks_step_7 = 0.5
        xrotation_7 = 0
        process_analysis(dependent_vars, 7, labels, title_text_7, x_axis_title_7, ylim_7, yticks_step_7, xrotation_7, output_file_7, df_clean)

        #Figure 7b: Google searches on days t + 1 until t + 14
        title_text_14 = "Google searches on days t + 1 until t + 14"
        x_axis_title_14 = " "
        output_file_14 = joinpath("output", "google_searches_days_t_plus_1_to_t_plus_14.pdf")
        ylim_14 = (-1, 2)  # Specify the y-axis limits
        yticks_step_14 = 0.5
        xrotation_14 = 0
        process_analysis(dependent_vars, 14, labels, title_text_14, x_axis_title_14, ylim_14, yticks_step_14, xrotation_14, output_file_14, df_clean)
    end

end

