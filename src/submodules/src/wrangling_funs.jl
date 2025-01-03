###############################################################################
############################## WRANGLING_FUNCTIONS.JL ##############################

##### This script defines the functions used to prepare the data for the ######
############ replication of the results in Mahmood & Jetter, 2023 #############
###############################################################################


module Wrangling_funs

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#---------------# 0. Importing libraries and defining exports #---------------#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

using CSV
using DataFrames
using Statistics

export import_and_merge_datasets, def_logs, replace_na_with_zeros,
    standardise_var, generate_moving_average

    """
    import_and_merge_datasets() -> DataFrame

Imports and merges the raw datasets needed to replicate the results in Mahmood & Jetter, 2023.

# Arguments
- None

# Returns
A `DataFrame` containing the merged raw data.
"""

    function import_and_merge_datasets()
        # Import raw data 
        drones_df = CSV.read("data/drones_data.csv", DataFrame)
        anti_us_df = CSV.read("data/anti-us_sentiment.csv", DataFrame)
        gtd_df = CSV.read("data/GTD_and_SATP_data.csv", DataFrame)
        news_df = CSV.read("data/news_sentiment.csv", DataFrame)
        weather_df = CSV.read("data/weather_data.csv", DataFrame)

        # Merge using "date" column
        mjdata = drones_df

        for df in [anti_us_df, gtd_df, news_df, weather_df]
            mjdata = leftjoin(mjdata, df, on = :date)
        end

        # Return dataset
        return mjdata
    end

    """
    def_logs(df::DataFrame, varlist::Vector{String}; add_one::Bool=true) -> DataFrame

Generates log-transformed columns for the specified variables in the DataFrame. Optionally adds 1 to handle zero values before applying the log transformation.

# Arguments
- `df::DataFrame`: The input DataFrame.
- `varlist::Vector{String}`: A list of column names to transform.
- `add_one::Bool`: Whether to add 1 to zero values before applying the log (default is `true`).

# Returns
A `DataFrame` with new columns containing the log-transformed values of the specified columns.

# Example

```julia
df = DataFrame(A = [0, 2, 3], B = [1, 0, 4])
varlist = ["A", "B"]
df_with_logs = def_logs(df, varlist)   # with default add_one=true

df_no_correction = def_logs(df, varlist, add_one=false)  # without adding 1 for zero values
"""

    function def_logs(df, varlist; add_one=true)
        # Function to generate logs of selected variables
        # Corrected with a +1 for zero values if add_one is true
        df_copy = copy(df)

        for var in varlist
            # Define new column name
            new_col = string("ln", var)
    
            # Get column position
            idx = findfirst(isequal(var), names(df_copy))
    
            # Apply log transformation, adjusting for zero values if needed
            log_values = log.(df_copy[:, idx]) .+ (add_one ? 1 : 0)
    
            # Insert log column after the original column
            df_copy = insertcols(df_copy, idx + 1, Symbol(new_col) => log_values)
        end

        return df_copy
    end

    """
    replace_na_with_zeros(df::DataFrame, col::Symbol) -> DataFrame

Replaces missing values in a specified column of the DataFrame with zeros.

# Arguments
- `df::DataFrame`: The input DataFrame.
- `col::Symbol`: The column to process.

# Returns
A `DataFrame` with missing values in the specified column replaced by zeros.

# Example

```julia
df = DataFrame(A = [0, missing, 3], B = [1, 0, missing])
varlist = ["A", "B"]
df_with_zeros = replace_na_with_zeros(df, varlist)   

"""

    function replace_na_with_zeros(df, varlist)
        # Function to replace missing values with zeros
        # for a set of columns of a dataframe
        for var in varlist
            df .= coalesce.(df, 0)
        end
        return df
    end

    """
    standardise_var(df::DataFrame, varlist::Vector{String}) -> DataFrame

Standardizes the specified variables in the DataFrame by subtracting the mean and dividing by the standard deviation.

# Arguments
- `df::DataFrame`: The input DataFrame.
- `varlist::Vector{String}`: A list of column names to standardize.

# Returns
A `DataFrame` with the original columns renamed and the new standardized columns inserted before them.

# Example

```julia
df = DataFrame(A = [1, 2, 3], B = [4, 5, 6])
varlist = ["A", "B"]
df_standardized = standardise_var(df, varlist)
"""

    function standardise_var(df, varlist)
        # Function to standardise chosen variables in a df
        for var in varlist
            # Define new column names
            new_col = string(var, "orig")
            std_col = string(var, "std")
    
            # Get column position
            idx = findfirst(isequal(var), names(df))
    
            # Create a new column for the standardized values and assign it to a vector
            std_values = (df[!, idx] .- mean(skipmissing(df[!, idx]))) ./ std(skipmissing(df[!, idx]))
    
            # Insert the new column just before the old column
            insertcols!(df, idx, std_col => std_values)
    
            # Rename the columns
            rename!(df, var => new_col)
            rename!(df, std_col => var)
        end
    
        return df
    end

    """
    generate_moving_average(df::DataFrame, varlist::Vector{String}, intervals::Vector{Int}) -> DataFrame

Generates moving averages for the specified variables in the DataFrame over the given intervals.

# Arguments
- `df::DataFrame`: The input DataFrame.
- `varlist::Vector{String}`: A list of column names for which to generate moving averages.
- `intervals::Vector{Int}`: A vector of interval lengths for the moving averages.

# Returns
A `DataFrame` with the moving averages added as new columns. The original DataFrame remains unchanged.

# Example
```julia
using DataFrames
using Statistics

# Sample DataFrame
df = DataFrame(attacks = rand(1:100, 100), deaths = rand(1:100, 100))

# List of variables to generate moving averages for
varlist = ["attacks", "deaths"]

# Vector of interval lengths
intervals = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 21, 28]

# Generate moving averages
df_with_averages = generate_moving_average(df, varlist, intervals)

# Display the DataFrame with moving averages
println(df_with_averages)
"""

    function generate_moving_average(df, varlist, intervals)
        # Function to generate moving averages for the specified 
        # variables in the DataFrame over the given intervals.
        df_copy = copy(df)
        for var in varlist
            for interval in intervals
                # Define the new column name for the moving average
                new_col = Symbol(var, "in", interval)
    
                # Calculate the moving average
                df_copy[!, new_col] = [mean(skipmissing(df_copy[max(1, i-interval+1):i, var])) for i in 1:nrow(df_copy)]
            end
        end
        return df_copy
    end            
        
end

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#


###############################################################################


###############################################################################


###############################################################################


###############################################################################



###############################################################################



###############################################################################