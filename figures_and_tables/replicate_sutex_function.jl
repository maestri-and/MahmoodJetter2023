using DataFrames
using Printf
using Statistics
using PrettyTables

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