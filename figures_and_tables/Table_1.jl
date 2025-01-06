#################################################################################################################################################################################################################################
#                   Preparatory work
#################################################################################################################################################################################################################################

using StatFiles
using DataFrames
using Printf
using PrettyTables
using Statistics 
df = DataFrame(load("/Users/alibenra/Desktop/Replication_Julia/Data-main-15-12-2021.dta"))

#################################################################################################################################################################################################################################
#   Creating a function to replicate the sutex package in STATA to directly compute a summary statistics table
#   Function: replicate_sutex(df, vars; digits=2)
#   Description: Compute mean, standard deviation (in parentheses), min, and max for each column in `vars`, returning a new DataFrame. Round to `digits` decimals
#################################################################################################################################################################################################################################

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

#################################################################################################################################################################################################################################
#   Table 1. Summary Statistics of Main Variables for all 4,018 Days from January 1, 2006 until December 31, 2016. All Variables are Measured at the Daily Level.
#################################################################################################################################################################################################################################
# Specify the variables to summarize
vars = [:drones, :attacks, :gusts, :wind, :mil_act, :ramadan, :tmean2_mir, :prec_mir]

# Using the replicate_sutex function
summary_table = replicate_sutex(df, vars, digits=2)

# SHowing it as a DataFrame:
summary_table

# Save the LaTeX table to the same directory as this script
file_path = joinpath(@__DIR__, "summary_table.tex")

# Define the table title
table_title = "Table 1. Summary Statistics of Main Variables for all 4,018 Days from January 1, 2006 until December 31, 2016. All Variables are Measured at the Daily Level."

# Write the LaTeX table to the file with a caption
open(file_path, "w") do io
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
println("LaTeX file successfully saved to: $file_path")