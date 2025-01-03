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
    standardise_var, generate_moving_average, get_lags

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
    generate_moving_average(df::DataFrame, varlist::Vector{String}, intervals::Vector; direction=:leads) -> DataFrame

Generates moving averages for the specified variables in the DataFrame over the given intervals. Supports both lead and lag moving averages. Missing values are not skipped to match Stata behavior.

# Arguments
- `df::DataFrame`: The input DataFrame.
- `varlist::Vector{String}`: A list of column names to calculate the moving averages for.
- `intervals::Vector`: A vector of intervals (either integers or ranges) specifying the number of periods for the moving average.
- `direction::Symbol`: The direction of the moving average. It can be `:lags` (averaging over previous periods) or `:leads` (averaging over future periods, default is `:leads`).

# Returns
A `DataFrame` with the original columns and additional columns containing the calculated moving averages.

# Example

```julia
df = DataFrame(A = [1, 2, 3, 4, 5], B = [5, 4, 3, 2, 1])
varlist = ["A", "B"]
intervals = [2, 3]
df_with_moving_avg = generate_moving_average(df, varlist, intervals, direction=:lags)
"""

function generate_moving_average(df, varlist, intervals; direction=:leads)
    # Function to generate moving averages for the specified 
    # variables in the DataFrame over the given intervals.
    # Missing values are not skipped when computing averages, to match Stata behaviour.
    df_copy = copy(df)
    
    # Check if the direction argument is valid
    if direction != :lags && direction != :leads
        throw(ArgumentError("Invalid direction. Choose either :lags or :leads"))
    end

    # Check max length - used for leads
    max_lead = length(df_copy[:,1]) 
    
    for var in varlist
        for interval in intervals
            # Check if interval is a range or an integer
            if typeof(interval) == Int
                # Single integer, calculate moving average over 1 to interval
                # Check if the average is for lags or leads

                # Lags, moving average over last n periods
                if direction == :lags
                    # Define column name
                    new_col = Symbol(var, "avg", interval)
                    # Compute moving average, handling cases in which there aren't enough lags
                    df_copy[!, new_col] = [i < interval ? missing : 
                                            mean(df_copy[i-interval+1:i, var])
                                            for i in 1:nrow(df_copy)]
                end
                
                # Leads, moving average over last n periods
                if direction == :leads
                    # Define column name
                    new_col = Symbol(var, "in", interval)
                    # Compute moving average, handling cases in which there aren't enough leads
                    df_copy[!, new_col] = [i + interval > max_lead ? missing : 
                                            mean(df_copy[i+1:i+interval, var])
                                            for i in 1:nrow(df_copy)]
                end
                
            elseif typeof(interval) == UnitRange{Int64}
                if direction == :leads
                    # If range of integers, calculate moving average for the specific range
                    start, stop = first(interval), last(interval)
                    new_col = Symbol(var, "$(start)to$(stop)")
                    
                    # Calculate the moving average for the range
                    df_copy[!, new_col] = [i + stop > max_lead ? missing :
                                            mean(df_copy[i+start:i+stop, var])
                                            for i in 1:nrow(df_copy)]
                elseif direction == :lags
                # Raise an error for unsupported types of intervals for lags
                throw(ArgumentError("Unsupported range interval type for lags."))
                end

            else
                # Raise an error for unsupported types in the intervals argument
                throw(ArgumentError("Unsupported interval type: $(typeof(interval)). Make sure that you include only integers or ranges in your interval specification."))
            end
        end
    end
    
    return df_copy
end

function get_lags(df, varlist, tdiffs)
    # Function to generate lags or leads of selected variables
    df_copy = copy(df)

    for var in varlist
        for t in tdiffs
                # Define column name
                new_col = Symbol(var, t)

                # Get lag
                df_copy[!, new_col] = [i <= t ? missing : 
                                            df_copy[i-t, var]
                                            for i in 1:nrow(df_copy)]
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