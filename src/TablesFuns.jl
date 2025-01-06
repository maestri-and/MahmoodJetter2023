###############################################################################
############################## TablesFuns.JL #################################

############# This script defines the functions used to replicate #############
############################ Table 1 and Table 2 ##############################
######################### in Mahmood & Jetter, 2023 ###########################
###############################################################################


module TablesFuns

"""
# TablesFuns Module

This module defines functions used to replicate Table 1 and Table 2, as well as their respective panels, 
from Mahmood & Jetter (2023). The functions are designed for creating summary statistics tables, 
regression result tables, and panel-specific outputs with LaTeX and plain text formats.

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

"""


#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#---------------# 0. IMPORTING LIBRARIES AND DEFINING EXPORTS #---------------#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

using DataFrames
using Printf
using Statistics
using PrettyTables
using GLM
using CovarianceMatrices

export replicate_sutex, generate_table1, create_multiple_model_table2, 
    generate_table2_panelA, generate_table2_panelB, generate_table2_panelD

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#------# a. Creating a function to replicate the sutex package in STATA #-----#
#------------# to directly compute a summary statistics table #---------------#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
    """
        replicate_sutex(df::DataFrame, vars::Vector{Symbol}; digits::Int=2) -> DataFrame

    Replicates the functionality of the `sutex` package in Stata by generating a summary statistics table for the specified variables in a DataFrame.

    # Arguments
    - `df::DataFrame`: The input DataFrame.
    - `vars::Vector{Symbol}`: A list of column names for which to compute summary statistics.
    - `digits::Int`: The number of decimal places to which the summary statistics should be rounded (default is `2`).

    # Returns
    A `DataFrame` containing the following columns:
    - `Variable`: The name of each variable.
    - `Mean`: The mean value of the variable.
    - `SD`: The standard deviation of the variable, displayed in parentheses.
    - `Min`: The minimum value of the variable.
    - `Max`: The maximum value of the variable.

    If a column contains only missing values or is empty, the function returns "NA" for all its summary statistics.

    # Example

    ```julia
    df = DataFrame(
        A = [1.123, 2.456, 3.789],
        B = [missing, 5.678, 6.789],
        C = [missing, missing, missing]
    )

    vars = [:A, :B, :C]
    summary_table = replicate_sutex(df, vars; digits=3)

    # Output:
    # │ Variable │ Mean  │ SD      │ Min   │ Max   │
    # │----------│-------│---------│-------│-------│
    # │ A        │ 2.456 │ (1.333) │ 1.123 │ 3.789 │
    # │ B        │ 6.234 │ (0.786) │ 5.678 │ 6.789 │
    # │ C        │ NA    │ (NA)    │ NA    │ NA    │
    ```

    # Notes
    - Missing values in the input columns are skipped when computing the summary statistics.
    - The function gracefully handles columns with all missing values or empty data by returning "NA" for the summary statistics.
    """

    function replicate_sutex(df::DataFrame, vars::Vector{Symbol}; digits=2)
        # Prepare an empty DataFrame to hold results
        result = DataFrame(
            Variable = String[],
            Mean     = String[],
            SD       = String[],
            Min      = String[],
            Max      = String[]
        )
        
        for v in vars
            # Skip missing values for robust stats
            col = skipmissing(df[!, v])
            
            # If column is all missing or empty, handle gracefully
            if isempty(col)
                push!(result, (
                    string(v),  # variable name
                    "NA",       # mean
                    "(NA)",     # sd
                    "NA",       # min
                    "NA"        # max
                ))
            else
                m  = mean(col)
                sd = std(col)
                mn = minimum(col)
                mx = maximum(col)
                
                # Format to desired decimal places; put parentheses around SD
                push!(result, (
                    string(v),
                    @sprintf("%.*f", digits, m),
                    @sprintf("(%.*f)", digits, sd),
                    @sprintf("%.*f", digits, mn),
                    @sprintf("%.*f", digits, mx)
                ))
            end
        end
        
        return result
    end

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#--#  b. Function generating Table 1. Summary Statistics of Main Variables #--#
#-----# for all 4,018 Days from January 1, 2006 until December 31, 2016. #----#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

    """
        generate_table1(df::DataFrame)

    Generates "Table 1" summarizing key variables from the given DataFrame, saves 
    the summary table in both LaTeX and plain text formats, and displays it as a 
    DataFrame.

    # Arguments
    - `df::DataFrame`: The input DataFrame containing the data to be summarized.

    # Description
    This function calculates summary statistics for a predefined set of variables 
    using the `replicate_sutex` function. The resulting summary table includes 
    the mean, standard deviation (in parentheses), minimum, and maximum for each 
    variable. The table is displayed in the REPL and saved as:
    - A LaTeX-formatted table (`summary_table.tex`) in the `output` folder.
    - A plain text file (`summary_table.txt`) in the same `output` folder.

    The summary statistics table contains information for 4,018 days from January 1, 2006, 
    to December 31, 2016, measured at the daily level.

    # Predefined Variables
    The function summarizes the following variables from the input DataFrame:
    - `:drones`
    - `:attacks`
    - `:gusts`
    - `:wind`
    - `:mil_act`
    - `:ramadan`
    - `:tmean2_mir`
    - `:prec_mir`

    # Output
    - The summary table is displayed as a DataFrame.
    - The table is saved in two formats:
    - `summary_table.tex`: A LaTeX-formatted file including the table environment and a caption.
    - `summary_table.txt`: A plain text file with the table content and title.

    # Files Created
    The function saves the files in a folder named `output` relative to the script's location. 
    Ensure the folder exists or the function will fail.

    # Notes
    - The function uses the `PrettyTables` package to format the tables for LaTeX and plain text outputs.
    - The table title is included in both the LaTeX and text files.
    - Ensure the `output` folder exists before running the function.
    - The function requires the `replicate_sutex` function to compute the summary statistics.

    # Example

    ```julia
    # Load necessary packages
    using DataFrames, PrettyTables

    # Example DataFrame
    df = DataFrame(
        drones = rand(1:10, 100),
        attacks = rand(1:20, 100),
        gusts = rand(1:15, 100),
        wind = rand(1:25, 100),
        mil_act = rand(1:5, 100),
        ramadan = rand(0:1, 100),
        tmean2_mir = rand(15.0:1.0:30.0, 100),
        prec_mir = rand(0.0:0.1:5.0, 100)
    )

    # Generate the summary table
    generate_table1(df)

    # Output Files:
    # - output/summary_table.tex
    # - output/summary_table.txt
    ```
    """
    
    function generate_table1(df)
        # Specify the output folder (predefined, not passed as an argument)
        output_folder = "output"

        # Specify the variables to summarize
        vars = [:drones, :attacks, :gusts, :wind, :mil_act, :ramadan, :tmean2_mir, :prec_mir]

        # Using the replicate_sutex function
        summary_table = replicate_sutex(df, vars, digits=2)

        # Displaying the table as a DataFrame
        display(summary_table)

        # Save the LaTeX table to the same directory as this script
        latex_file_path = joinpath(output_folder, "summary_table.tex")
        text_file_path = joinpath(output_folder, "summary_table.txt")  # Path for the text file

        # Define the table title
        table_title = "Table 1. Summary Statistics of Main Variables for all 4,018 Days from January 1, 2006 until December 31, 2016. All Variables are Measured at the Daily Level."

        # Write the LaTeX table to the file with a caption
        open(latex_file_path, "w") do io
            # Write the LaTeX table environment opening
            write(io, """
            \\begin{table}[ht]
            \\centering
            \\caption{$table_title}
            \\label{tab:summary_statistics}
            """)
            
            # Use PrettyTables to write the tabular content
            pretty_table(
                io,
                summary_table;
                backend=Val(:latex)
            )
            
            # Write the LaTeX table environment closing
            write(io, """
            \\end{table}
            """)
        end
        println("LaTeX file successfully saved to: $latex_file_path")

        # Write the text table to the file with the title
        open(text_file_path, "w") do io
            # Write the title at the top of the file
            write(io, "$table_title\n\n")
            # Use PrettyTables to write the tabular content
            pretty_table(io, summary_table; backend=Val(:text))  # Save as plain text
        end
        println("Text file successfully saved to: $text_file_path")
    end



#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#--#  c. Function summarizing regression results from multiple models used #--#
#---------------#  to generate the different panels of table 2 #--------------#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
  
    """
    create_multiple_model_table2(models, independent_var::String, column_titles::Vector{String}, bw_fixed::Vector{Int}, bw_variable::Vector{Int}, table_title::String, table_subtitle::String, table_caption::String)

    Generates a LaTeX and plain text table summarizing regression results from multiple models. The table includes coefficients, and heteroscedasticity- and autocorrelation-robust (HAC) standard errors computed using fixed and variable bandwidths. The LaTeX table is saved in the specified output folder, along with a plain text version of the same table.

    # Arguments
    - `models::Vector`: A vector of regression models to be summarized in the table.
    - `independent_var::String`: The name of the independent variable.
    - `column_titles::Vector{String}`: A vector of strings representing the titles for each column in the table.
    - `bw_fixed::Vector{Int}`: A vector of integers specifying the fixed bandwidth for each model.
    - `bw_variable::Vector{Int}`: A vector of integers specifying the variable bandwidth for each model.
    - `table_title::String`: The title of the table to be displayed in the LaTeX file.
    - `table_subtitle::String`: The subtitle of the table to be displayed in the LaTeX file.
    - `table_caption::String`: The caption for the table, explaining the content.

    # Returns
    This function does not return a value. It generates two files:
    - A LaTeX file: Contains a formatted table with the regression results, which can be compiled into a PDF.
    - A plain text file: Contains the same table, but in a simple text format.

    The LaTeX table will include the following columns:
    - Coefficient values for the second coefficient of each model.
    - HAC standard errors calculated with both fixed and variable bandwidths.
    
    Both the LaTeX and text files will include a header with the provided title and subtitle, followed by the regression results, and will save to a directory defined as `output`.

    # Example

    ```julia
    models = [model1, model2, model3]  # Assume these are pre-fitted regression models
    independent_var = "Income"
    column_titles = ["Model 1", "Model 2", "Model 3"]
    bw_fixed = [10, 15, 20]
    bw_variable = [5, 10, 15]
    table_title = "Regression Results"
    table_subtitle = "Impact of Income on Terror Attacks"
    table_caption = "This table shows regression results with coefficients and HAC standard errors using fixed and variable bandwidths."

    create_multiple_model_table2(models, independent_var, column_titles, bw_fixed, bw_variable, table_title, table_subtitle, table_caption)
    ```
    # Notes
    - The function assumes the second coefficient from each model is the coefficient of interest. Ensure that your models are structured accordingly.
    - HAC standard errors are computed using the Bartlett kernel for both fixed and variable bandwidths.
    """

    function create_multiple_model_table2(
        models, 
        independent_var::String, 
        column_titles::Vector{String}, 
        bw_fixed::Vector{Int}, 
        bw_variable::Vector{Int}, 
        table_title::String, 
        table_subtitle::String, 
        table_caption::String
        )
        # Check that the number of models matches the number of column titles, fixed bandwidths, and variable bandwidths
        if length(models) != length(column_titles) || length(models) != length(bw_fixed) || length(models) != length(bw_variable)
            error("The number of models, column titles, fixed bandwidths, and variable bandwidths must match.")
        end

        # Define the row labels
        row_labels = [independent_var, "HAC SE (Fixed BW)", "HAC SE (Variable BW)"]

        # Initialize an empty array to store table content
        table_content = []

        # Loop through each model and compute the results
        for (i, model) in enumerate(models)
            # Extract statistics
            coef_value = @sprintf("%.4f", coef(model)[2])  # Assuming the second coefficient is the one we need
            hac_se_fixed = @sprintf("(%.4f)", stderror(Bartlett(bw_fixed[i]), model, prewhite=false)[2])  # Fixed bandwidth
            hac_se_variable = @sprintf("[%.4f]", stderror(Bartlett(bw_variable[i]), model, prewhite=false)[2])  # Variable bandwidth

            # Add the results as a column
            push!(table_content, [coef_value, hac_se_fixed, hac_se_variable])
        end

        # Combine the row labels and the table content into the final table
        final_table = hcat(row_labels, hcat(table_content...))

        # Add the header
        header = vcat(["Data dimensions of dependent variable: terror attacks"], column_titles)

        # Specify the output folder (predefined, not passed as an argument)
        output_folder = "output"

        # Save the LaTeX table to the same directory as this script
        latex_file_path = joinpath(output_folder, "$table_subtitle.tex")
        text_file_path = joinpath(output_folder, "$table_subtitle.txt")  # Path for the text file

        # Write the LaTeX table to the file with a title, subtitle, and caption
        open(latex_file_path, "w") do io
            # Manually write the LaTeX table content
            write(io, """
            \\textbf{$table_title} \\\\
            \\textit{$table_subtitle} \\\\

            \\caption{$table_caption}
            \\label{tab:regression_results}

            \\resizebox{\\textwidth}{!}{
            \\begin{tabular}{p{3cm}p{2cm}p{2cm}p{2cm}p{2cm}p{2cm}}
            \\hline
            """)
            
            # Write the header row
            write(io, " & " * join(column_titles, " & ") * " \\\\\n")
            write(io, "\\hline\n")

            # Write each row of the table
            for row in eachrow(final_table)
                row_data = join(row, " & ")
                write(io, "$row_data \\\\\n")
            end

            # Close the LaTeX table environment
            write(io, """
            \\hline
            \\end{tabular}
            }
            """)
        end
        println("LaTeX file successfully saved to: $latex_file_path")

        # Write the text table to the file with the title, subtitle, and caption
        open(text_file_path, "w") do io
            # Write the title, subtitle, and caption at the top of the file
            write(io, "$table_title\n")
            write(io, "$table_subtitle\n\n")
            write(io, "Caption: $table_caption\n\n")
            # Use PrettyTables to write the tabular content
            pretty_table(io, final_table, header = header, backend=Val(:text))  # Save as plain text
        end
        println("Text file successfully saved to: $text_file_path")
    end


#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#--# d. Functions generating Table 2. Main Results. All Regressions Account #-#
#-----------------#  for the Full Set of Control Variables. #-----------------#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

# The same documentation is provided for the following functions:
## 1. generate_table2_panelA
## 2. generate_table2_panelB
## 3. generate_table2_panelD

#----------------------------#  Table 2. Panel A #----------------------------#
    """
    generate_table2_panelA(df)

    Generates a LaTeX table summarizing the results of the second-stage of five IV regressions (Panel A) using the provided DataFrame. 
    The function cleans the data, performs regressions, and creates a table that includes coefficients and heteroscedasticity- 
        and autocorrelation-robust (HAC) standard errors using both fixed and variable bandwidths.

    # Arguments
    - `df::DataFrame`: The input DataFrame containing the data for the analysis.

    # Returns
    This function does not return a value. It generates a LaTeX and plain text table that summarizes the results of the second-stage 
        regressions in Panel A. The table is saved in the `output` folder.

    The LaTeX table will display results for five regressions:
    1. Days t + 1 until t + 7
    2. Days t + 1 until t + 7 (alternative model)
    3. Three-day averages
    4. Six-day averages
    5. 14-day averages

    The table includes coefficients and HAC standard errors computed using the two bandwidths specified in the paper 
    for each model.

    # Example

    ```julia
    df = DataFrame(...)  # Your dataset
    generate_table2_panelA(df)
    ```
    """

    function generate_table2_panelA(df)
        #################################################################################################################################################################################################################################
        #                   Cleaning the data frame
        #################################################################################################################################################################################################################################
            variables_with_missing = [
            :attacksin7, :drones, :gusts, :dows1, :dows2, :dows3, :dows4, :dows5, :dows6, :ramadan, 
            :date, :months1, :months2, :months3, :months4, :months5, :months6, :months7, :months8, 
            :months9, :months10, :months11, :mil_act1, :mil_act2, :mil_act3, :mil_act4, :mil_act5, 
            :mil_act6, :mil_act7, :mil_act8, :mil_act9, :mil_act10, :mil_act11, :mil_act12, :mil_act13, 
            :mil_act14, :attacks1, :attacks2, :attacks3, :attacks4, :attacks5, :attacks6, :attacks7, 
            :attacks8, :attacks9, :attacks10, :attacks11, :attacks12, :attacks13, :attacks14, 
            :tmean2_mir, :lnprec
            ]

            df_clean = dropmissing(df, variables_with_missing)
        
        #################################################################################################################################################################################################################################
        #                   Panel B: first-stage results, predicting drone strikes on day t
        #################################################################################################################################################################################################################################
            # Regression (1)
            fB_1 = @formula(drones ~ gusts + dows1 + dows2 + dows3 + dows4 + dows5 + dows6 + ramadan + date + months1 + 
            months2 + months3 + months4 + months5 + months6 + months7 + months8 + months9 + months10 + months11 +
            mil_act1 + mil_act2 + mil_act3 + mil_act4 + mil_act5 + mil_act6 + mil_act7 + mil_act8 + mil_act9 + mil_act10 + 
            mil_act11 + mil_act12 + mil_act13 + mil_act14 + attacks1 + attacks2 + attacks3 + attacks4 +
            attacks5 + attacks6 + attacks7 + attacks8 + attacks9 + attacks10 +
            attacks11 + attacks12 + attacks13 + attacks14 + tmean2_mir + lnprec)

            panelB_1_HAC = lm(fB_1, df_clean)

            # Regression (2)
            fB_2 = @formula(drones ~ wind + dows1 + dows2 + dows3 + dows4 + dows5 + dows6 + ramadan + date + months1 + 
            months2 + months3 + months4 + months5 + months6 + months7 + months8 + months9 + months10 + months11 +
            mil_act1 + mil_act2 + mil_act3 + mil_act4 + mil_act5 + mil_act6 + mil_act7 + mil_act8 + mil_act9 + mil_act10 + 
            mil_act11 + mil_act12 + mil_act13 + mil_act14 + attacks1 + attacks2 + attacks3 + attacks4 +
            attacks5 + attacks6 + attacks7 + attacks8 + attacks9 + attacks10 +
            attacks11 + attacks12 + attacks13 + attacks14 + tmean2_mir + lnprec)

            panelB_2_HAC = lm(fB_2, df_clean)

            # Regression (3)
            df_subset_A3 = filter(:ign3 => x -> x == 0, df_clean) #Filter the dataset for observations where ign3 == 0

            fB_3 = @formula(dronesavg3 ~ gustsavg3 + dows1 + dows2 + dows3 + dows4 + dows5 + dows6 + ramadan + date + months1 + 
            months2 + months3 + months4 + months5 + months6 + months7 + months8 + months9 + months10 + months11 +
            + mil_actavg3 + mil_actavg3lag + mil_actavg3lag2 + mil_actavg3lag3 + mil_actavg3lag4 + attacksavg3 + attacksavg3lag +
            attacksavg3lag2 + attacksavg3lag3 + attacksavg3lag4 + tmean2_miravg3 + lnprecavg3)

            panelB_3_HAC = lm(fB_3, df_subset_A3)

            # Regression (4)
            df_subset_A6 = filter(:ign6 => x -> x == 0, df_clean) #Filter the dataset for observations where ign6 == 0

            fB_6 = @formula(dronesavg6 ~ gustsavg6 + dows1 + dows2 + dows3 + dows4 + dows5 + dows6 +
            ramadan + date + months1 + months2 + months3 + months4 + months5 + months6 + months7 + months8 +
            months9 + months10 + months11 + mil_actavg6 + mil_actavg6lag + attacksavg6 + attacksavg6lag +
            tmean2_miravg6 + lnprecavg6)

            panelB_6_HAC = lm(fB_6, df_subset_A6)

            # Regression (5)
            df_subset_A14 = filter(:ign14 => x -> x == 0, df_clean) #Filter the dataset for observations where ign14 == 0

            fB_14 = @formula(dronesavg14 ~ gustsavg14 + ramadan + date +
            months1 + months2 + months3 + months4 + months5 + months6 + months7 +
            months8 + months9 + months10 + months11 + mil_actavg14 + attacksavg14 +
            tmean2_miravg14 + lnprecavg14)

            panelB_14_HAC = lm(fB_14, df_subset_A14)

        #################################################################################################################################################################################################################################
        #                   Panel A: Second Stage following Panel B regressions
        #################################################################################################################################################################################################################################

            # Regression (1)
            df_clean.fitted_dronesA = predict(panelB_1_HAC)

            fA_1_2SLS = @formula(attacksin7 ~ fitted_dronesA +dows1 + dows2 + dows3 + dows4 + dows5 + dows6 + ramadan + date + months1 + 
            months2 + months3 + months4 + months5 + months6 + months7 + months8 + months9 + months10 + months11 +
            mil_act1 + mil_act2 + mil_act3 + mil_act4 + mil_act5 + mil_act6 + mil_act7 + mil_act8 + mil_act9 + mil_act10 + 
            mil_act11 + mil_act12 + mil_act13 + mil_act14 + attacks1 + attacks2 + attacks3 + attacks4 +
            attacks5 + attacks6 + attacks7 + attacks8 + attacks9 + attacks10 +
            attacks11 + attacks12 + attacks13 + attacks14 + tmean2_mir + lnprec)

            panelA_1_2SLS = lm(fA_1_2SLS, df_clean)


            # Regression (2)
            df_clean.fitted_drones2 = predict(panelB_2_HAC)

            fA_2_2SLS = @formula(attacksin7 ~ fitted_drones2 + dows1 + dows2 + dows3 + dows4 + dows5 + dows6 + ramadan + date + months1 + 
            months2 + months3 + months4 + months5 + months6 + months7 + months8 + months9 + months10 + months11 +
            mil_act1 + mil_act2 + mil_act3 + mil_act4 + mil_act5 + mil_act6 + mil_act7 + mil_act8 + mil_act9 + mil_act10 + 
            mil_act11 + mil_act12 + mil_act13 + mil_act14 + attacks1 + attacks2 + attacks3 + attacks4 +
            attacks5 + attacks6 + attacks7 + attacks8 + attacks9 + attacks10 +
            attacks11 + attacks12 + attacks13 + attacks14 + tmean2_mir + lnprec)

            panelA_2_2SLS = lm(fA_2_2SLS, df_clean)

            # Regression (3)
            df_subset_A3.fitted_drones3 = predict(panelB_3_HAC)

            fA_3_2SLS = @formula(attacksavg3lead ~ fitted_drones3 + dows1 + dows2 + dows3 + dows4 + dows5 + dows6 + ramadan + date + months1 + 
            months2 + months3 + months4 + months5 + months6 + months7 + months8 + months9 + months10 + months11 +
            + mil_actavg3 + mil_actavg3lag + mil_actavg3lag2 + mil_actavg3lag3 + mil_actavg3lag4 + attacksavg3 + attacksavg3lag +
            attacksavg3lag2 + attacksavg3lag3 + attacksavg3lag4 + tmean2_miravg3 + lnprecavg3)

            panelA_3_2SLS = lm(fA_3_2SLS, df_subset_A3)

            # Regression (4)
            df_subset_A6.fitted_drones6 = predict(panelB_6_HAC)

            fA_6_2SLS = @formula(attacksavg6lead ~ fitted_drones6 + dows1 + dows2 + dows3 + dows4 + dows5 + dows6 +
            ramadan + date + months1 + months2 + months3 + months4 + months5 + months6 + months7 + months8 +
            months9 + months10 + months11 + mil_actavg6 + mil_actavg6lag + attacksavg6 + attacksavg6lag +
            tmean2_miravg6 + lnprecavg6)

            panelA_6_2SLS = lm(fA_6_2SLS, df_subset_A6)

            # Regression (5)
            df_subset_A14.fitted_drones14 = predict(panelB_14_HAC)

            fA_14_2SLS = @formula(attacksavg14lead ~ fitted_drones14 + ramadan + date +
            months1 + months2 + months3 + months4 + months5 + months6 + months7 +
            months8 + months9 + months10 + months11 + mil_actavg14 + attacksavg14 +
            tmean2_miravg14 + lnprecavg14)

            panelA_14_2SLS = lm(fA_14_2SLS, df_subset_A14)

            # Defining necessary elements to generate the tables
            column_titles = [
                "Days t + 1 until t + 7 (1)",
                "Days t + 1 until t + 7 (2)",
                "Three-day averages (3)",
                "Six-day averages (4)",
                "14-day averages (5)"
            ]

            # Define bandwidths for HAC SE (Fixed BW) and HAC SE (Variable BW)
            bw_fixed = [1, 1, 1, 1, 1]  # Fixed bandwidth for HAC SE (e.g., 1 for all columns)
            bw_variable = [15, 15, 5, 3, 2]  # Variable bandwidth for HAC SE

            models_A = [panelA_1_2SLS, panelA_2_2SLS, panelA_3_2SLS, panelA_6_2SLS, panelA_14_2SLS]

            independent_var = "Drones strikes"

            create_multiple_model_table2(
            models_A,
            independent_var,
            column_titles,
            bw_fixed,
            bw_variable,
            "Table 2. Main Results. All Regressions Account for the Full Set of Control Variables",
            "Panel A Second Stage Results",
            "Fixed BW HAC SE account for bandwidth 1, while Variable BW HAC SE account for bandwidth 15 in columns (1) and (2), and for five, three and two lags in columns (3), (4) and (5), respectively."
            )
    end

#----------------------------#  Table 2. Panel B #----------------------------#
    """
    generate_table2_panelB(df)

    Generates a LaTeX table summarizing the results of the first-stage of five IV regressions (Panel B) using the provided DataFrame. 
    The function cleans the data, performs regressions, and creates a table that includes coefficients and heteroscedasticity- 
        and autocorrelation-robust (HAC) standard errors using both fixed and variable bandwidths.

    # Arguments
    - `df::DataFrame`: The input DataFrame containing the data for the analysis.

    # Returns
    This function does not return a value. It generates a LaTeX and plain text table that summarizes the results of the first-stage 
        regressions in Panel B. The table is saved in the `output` folder.

    The LaTeX table will display results for five regressions:
    1. Days t + 1 until t + 7
    2. Days t + 1 until t + 7 (alternative model)
    3. Three-day averages
    4. Six-day averages
    5. 14-day averages

    The table includes coefficients and HAC standard errors computed using the two bandwidths specified in the paper 
    for each model.

    # Example

    ```julia
    df = DataFrame(...)  # Your dataset
    generate_table2_panelB(df)
    ```
    """

    function generate_table2_panelB(df)
        #################################################################################################################################################################################################################################
        #                   Cleaning the data frame
        #################################################################################################################################################################################################################################
            variables_with_missing = [
            :attacksin7, :drones, :gusts, :dows1, :dows2, :dows3, :dows4, :dows5, :dows6, :ramadan, 
            :date, :months1, :months2, :months3, :months4, :months5, :months6, :months7, :months8, 
            :months9, :months10, :months11, :mil_act1, :mil_act2, :mil_act3, :mil_act4, :mil_act5, 
            :mil_act6, :mil_act7, :mil_act8, :mil_act9, :mil_act10, :mil_act11, :mil_act12, :mil_act13, 
            :mil_act14, :attacks1, :attacks2, :attacks3, :attacks4, :attacks5, :attacks6, :attacks7, 
            :attacks8, :attacks9, :attacks10, :attacks11, :attacks12, :attacks13, :attacks14, 
            :tmean2_mir, :lnprec
            ]
            
            df_clean = dropmissing(df, variables_with_missing)

        #################################################################################################################################################################################################################################
        #                   Panel B: first-stage results, predicting drone strikes on day t
        #################################################################################################################################################################################################################################
            # Regression (1)
            fB_1 = @formula(drones ~ gusts + dows1 + dows2 + dows3 + dows4 + dows5 + dows6 + ramadan + date + months1 + 
            months2 + months3 + months4 + months5 + months6 + months7 + months8 + months9 + months10 + months11 +
            mil_act1 + mil_act2 + mil_act3 + mil_act4 + mil_act5 + mil_act6 + mil_act7 + mil_act8 + mil_act9 + mil_act10 + 
            mil_act11 + mil_act12 + mil_act13 + mil_act14 + attacks1 + attacks2 + attacks3 + attacks4 +
            attacks5 + attacks6 + attacks7 + attacks8 + attacks9 + attacks10 +
            attacks11 + attacks12 + attacks13 + attacks14 + tmean2_mir + lnprec)

            panelB_1_HAC = lm(fB_1, df_clean)

            # Regression (2)
            fB_2 = @formula(drones ~ wind + dows1 + dows2 + dows3 + dows4 + dows5 + dows6 + ramadan + date + months1 + 
            months2 + months3 + months4 + months5 + months6 + months7 + months8 + months9 + months10 + months11 +
            mil_act1 + mil_act2 + mil_act3 + mil_act4 + mil_act5 + mil_act6 + mil_act7 + mil_act8 + mil_act9 + mil_act10 + 
            mil_act11 + mil_act12 + mil_act13 + mil_act14 + attacks1 + attacks2 + attacks3 + attacks4 +
            attacks5 + attacks6 + attacks7 + attacks8 + attacks9 + attacks10 +
            attacks11 + attacks12 + attacks13 + attacks14 + tmean2_mir + lnprec)

            panelB_2_HAC = lm(fB_2, df_clean)

            # Regression (3)
            df_subset_A3 = filter(:ign3 => x -> x == 0, df_clean) #Filter the dataset for observations where ign3 == 0

            fB_3 = @formula(dronesavg3 ~ gustsavg3 + dows1 + dows2 + dows3 + dows4 + dows5 + dows6 + ramadan + date + months1 + 
            months2 + months3 + months4 + months5 + months6 + months7 + months8 + months9 + months10 + months11 +
            + mil_actavg3 + mil_actavg3lag + mil_actavg3lag2 + mil_actavg3lag3 + mil_actavg3lag4 + attacksavg3 + attacksavg3lag +
            attacksavg3lag2 + attacksavg3lag3 + attacksavg3lag4 + tmean2_miravg3 + lnprecavg3)

            panelB_3_HAC = lm(fB_3, df_subset_A3)

            # Regression (4)
            df_subset_A6 = filter(:ign6 => x -> x == 0, df_clean) #Filter the dataset for observations where ign6 == 0

            fB_6 = @formula(dronesavg6 ~ gustsavg6 + dows1 + dows2 + dows3 + dows4 + dows5 + dows6 +
            ramadan + date + months1 + months2 + months3 + months4 + months5 + months6 + months7 + months8 +
            months9 + months10 + months11 + mil_actavg6 + mil_actavg6lag + attacksavg6 + attacksavg6lag +
            tmean2_miravg6 + lnprecavg6)

            panelB_6_HAC = lm(fB_6, df_subset_A6)

            # Regression (5)
            df_subset_A14 = filter(:ign14 => x -> x == 0, df_clean) #Filter the dataset for observations where ign14 == 0

            fB_14 = @formula(dronesavg14 ~ gustsavg14 + ramadan + date +
            months1 + months2 + months3 + months4 + months5 + months6 + months7 +
            months8 + months9 + months10 + months11 + mil_actavg14 + attacksavg14 +
            tmean2_miravg14 + lnprecavg14)

            panelB_14_HAC = lm(fB_14, df_subset_A14)

            # Defining necessary elements to generate the tables
            column_titles = [
                "Days t + 1 until t + 7 (1)",
                "Days t + 1 until t + 7 (2)",
                "Three-day averages (3)",
                "Six-day averages (4)",
                "14-day averages (5)"
            ]

            # Define bandwidths for HAC SE (Fixed BW) and HAC SE (Variable BW)
            bw_fixed = [1, 1, 1, 1, 1]  # Fixed bandwidth for HAC SE (e.g., 1 for all columns)
            bw_variable = [15, 15, 5, 3, 2]  # Variable bandwidth for HAC SE

            models_B = [panelB_1_HAC, panelB_2_HAC, panelB_3_HAC, panelB_6_HAC, panelB_14_HAC]

            independent_var = "Wind gusts for (1) & (3) to (5) - Wind speed for (2)"

            create_multiple_model_table2(
            models_B,
            independent_var,
            column_titles,
            bw_fixed,
            bw_variable,
            "Table 2. Main Results. All Regressions Account for the Full Set of Control Variables",
            "Panel B First Stage Results",
            "Fixed BW HAC SE account for bandwidth 1, while Variable BW HAC SE account for bandwidth 15 in columns (1) and (2), and for five, three and two lags in columns (3), (4) and (5), respectively."
        )
    end

#----------------------------#  Table 2. Panel D #----------------------------#
 """
    generate_table2_panelD(df)

    Generates a LaTeX table summarizing the results of five OLS regressions (Panel D) using the provided DataFrame. 
    The function cleans the data, performs regressions, and creates a table that includes coefficients and heteroscedasticity- 
        and autocorrelation-robust (HAC) standard errors using both fixed and variable bandwidths.

    # Arguments
    - `df::DataFrame`: The input DataFrame containing the data for the analysis.

    # Returns
    This function does not return a value. It generates a LaTeX and plain text table that summarizes the results of the OLS
        regressions in Panel D. The table is saved in the `output` folder.

    The LaTeX table will display results for five regressions:
    1. Days t + 1 until t + 7
    2. Days t + 1 until t + 7 (alternative model)
    3. Three-day averages
    4. Six-day averages
    5. 14-day averages

    The table includes coefficients and HAC standard errors computed using the two bandwidths specified in the paper 
    for each model.

    # Example

    ```julia
    df = DataFrame(...)  # Your dataset
    generate_table2_panelD(df)
    ```
    """

    function generate_table2_panelD(df)
        #################################################################################################################################################################################################################################
        #                   Cleaning the data frame
        #################################################################################################################################################################################################################################
            variables_with_missing = [
            :attacksin7, :drones, :gusts, :dows1, :dows2, :dows3, :dows4, :dows5, :dows6, :ramadan, 
            :date, :months1, :months2, :months3, :months4, :months5, :months6, :months7, :months8, 
            :months9, :months10, :months11, :mil_act1, :mil_act2, :mil_act3, :mil_act4, :mil_act5, 
            :mil_act6, :mil_act7, :mil_act8, :mil_act9, :mil_act10, :mil_act11, :mil_act12, :mil_act13, 
            :mil_act14, :attacks1, :attacks2, :attacks3, :attacks4, :attacks5, :attacks6, :attacks7, 
            :attacks8, :attacks9, :attacks10, :attacks11, :attacks12, :attacks13, :attacks14, 
            :tmean2_mir, :lnprec
            ]
            
            df_clean = dropmissing(df, variables_with_missing)

        #################################################################################################################################################################################################################################
        #                   Panel D: OLS results
        #################################################################################################################################################################################################################################
            # Regression (1)
            fD_1 = @formula(attacksin7 ~ drones + dows1 + dows2 + dows3 + dows4 + dows5 + dows6 +
            ramadan + date + months1 + months2 + months3 + months4 + months5 + months6 + months7 + months8 +
            months9 + months10 + months11 +
            mil_act1 + mil_act2 + mil_act3 + mil_act4 + mil_act5 + mil_act6 + 
            mil_act7 + mil_act8 + mil_act9 + mil_act10 + mil_act11 + mil_act12 +
            mil_act13 + mil_act14 + 
            attacks1 + attacks2 + attacks3 + attacks4 + attacks5 + attacks6 +
            attacks7 + attacks8 + attacks9 + attacks10 + attacks11 + attacks12 +
            attacks13 + attacks14 + 
            tmean2_mir + lnprec)

            panelD_1 = lm(fD_1, df_clean)

            # Regression (2)
            fD_2 = @formula(attacksin7 ~ drones + dows1 + dows2 + dows3 + dows4 + dows5 + dows6 +
            ramadan + date + months1 + months2 + months3 + months4 + months5 + months6 + months7 + months8 +
            months9 + months10 + months11 +
            mil_act1 + mil_act2 + mil_act3 + mil_act4 + mil_act5 + mil_act6 + 
            mil_act7 + mil_act8 + mil_act9 + mil_act10 + mil_act11 + mil_act12 +
            mil_act13 + mil_act14 + 
            attacks1 + attacks2 + attacks3 + attacks4 + attacks5 + attacks6 +
            attacks7 + attacks8 + attacks9 + attacks10 + attacks11 + attacks12 +
            attacks13 + attacks14 + 
            tmean2_mir + lnprec)

            panelD_2 = lm(fD_2, df_clean)

            # Regression (3)
            df_subset_A3 = filter(:ign3 => x -> x == 0, df_clean) #Filter the dataset for observations where ign3 == 0

            fD_3 = @formula(attacksavg3lead ~ dronesavg3 + dows1 + dows2 + dows3 + dows4 + dows5 + dows6 + ramadan + date + months1 + 
            months2 + months3 + months4 + months5 + months6 + months7 + months8 + months9 + months10 + months11 +
            + mil_actavg3 + mil_actavg3lag + mil_actavg3lag2 + mil_actavg3lag3 + mil_actavg3lag4 + attacksavg3 + attacksavg3lag +
            attacksavg3lag2 + attacksavg3lag3 + attacksavg3lag4 + tmean2_miravg3 + lnprecavg3)

            panelD_3 = lm(fD_3, df_subset_A3)

            # Regression (4)
            df_subset_A6 = filter(:ign6 => x -> x == 0, df_clean) #Filter the dataset for observations where ign6 == 0

            fD_6 = @formula(attacksavg6lead ~ dronesavg6 + dows1 + dows2 + dows3 + dows4 + dows5 + dows6 +
            ramadan + date + months1 + months2 + months3 + months4 + months5 + months6 + months7 + months8 +
            months9 + months10 + months11 + mil_actavg6 + mil_actavg6lag + attacksavg6 + attacksavg6lag +
            tmean2_miravg6 + lnprecavg6)

            panelD_6 = lm(fD_6, df_subset_A6)

            # Regression (5)
            df_subset_A14 = filter(:ign14 => x -> x == 0, df_clean) #Filter the dataset for observations where ign14 == 0

            fD_14 = @formula(attacksavg14lead ~ dronesavg14 + ramadan + date +
            months1 + months2 + months3 + months4 + months5 + months6 + months7 +
            months8 + months9 + months10 + months11 + mil_actavg14 + attacksavg14 +
            tmean2_miravg14 + lnprecavg14)

            panelD_14 = lm(fD_14, df_subset_A14)

            # Defining necessary elements to generate the tables
            column_titles = [
                "Days t + 1 until t + 7 (1)",
                "Days t + 1 until t + 7 (2)",
                "Three-day averages (3)",
                "Six-day averages (4)",
                "14-day averages (5)"
            ]

            # Define lags for Newey-West SE
            nw_fixed = [2, 2, 2, 2, 2]  # Fixed bandwidth for HAC SE (e.g., 1 for all columns)
            nw_variable = [16, 16, 6, 4, 3]  # Variable bandwidth for HAC SE

            models_D = [panelD_1, panelD_2, panelD_3, panelD_6, panelD_14]

            independent_var = "Drone strikes"

            create_multiple_model_table2(
            models_D,
            independent_var,
            column_titles,
            nw_fixed,
            nw_variable,
            "Table 2. Main Results. All Regressions Account for the Full Set of Control Variables",
            "Panel D OLS results",
            "Fixed BW HAC SE account for bandwidth 1, while Variable BW HAC SE account for bandwidth 15 in columns (1) and (2), and for five, three and two lags in columns (3), (4) and (5), respectively. OLS (panel D) displays Newey–West standard errors specifically."
        )
    end


end