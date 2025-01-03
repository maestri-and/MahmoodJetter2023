using DataFrames
using Statistics
using GLM
using StatsPlots
using Binscatters
using PrettyTables

#################################################################################################################################################################################################################################
#   Creating a function to improve upon the Binscatter.jl to customize the plot, display regression results, 
#   and automate the production of figures
#   
#   Description: The binscatter_improved function creates a binscatter plot and regression table to analyze the relationship 
#       between a dependent variable and an independent variable, controlling for additional covariates. It generates a customizable 
#       plot with a linear fit and saves it as a PDF, while also displaying regression results (coefficients, p-values, confidence 
#       intervals) for the independent variable and intercept.
#################################################################################################################################################################################################################################

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
    script_dir = @__DIR__  # Directory where the script is located
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