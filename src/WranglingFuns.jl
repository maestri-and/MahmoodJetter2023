###############################################################################
############################## WRANGLING_FUNCTIONS.JL ##############################

##### This script defines the functions used to prepare the data for the ######
############ replication of the results in Mahmood & Jetter, 2023 #############
###############################################################################


module WranglingFuns

"""
# WranglingFuns Module

This module defines functions used to prepare and preprocess data for replicating the results 
in Mahmood & Jetter (2023). It includes utilities for data cleaning, transformation, and 
variable standardization to ensure consistency with the paper's methodology.

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
"""

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#---------------# 0. IMPORTING LIBRARIES AND DEFINING EXPORTS #---------------#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#


using CSV
using DataFrames
using Statistics
using Dates

export import_and_merge_csv_data, def_logs, replace_na_with_zeros,
    standardise_var, generate_moving_average, get_lags, wrangle_raw_mj_data


#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#----------------# 1. DEFINING AUXILIARY WRANGLING FUNCTIONS #----------------#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#


#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#----------------# a. Importing and merging raw csv datasets #----------------#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

    """
    import_and_merge_csv_data(dir::String, csvnames::Vector{String}, mergecol::Symbol) -> DataFrame

Imports multiple CSV files from a specified directory and merges them into a single DataFrame based on a common column.

# Arguments
- `dir::String`: The directory path where the CSV files are located.
- `csvnames::Vector{String}`: A list of CSV file names to be imported and merged.
- `mergecol::Symbol`: The column name on which to merge all the DataFrames.

# Returns
A `DataFrame` that contains the merged data from all the CSV files, joined on the specified column.

# Example

```julia
dir = "data"
csvnames = ["drones_data.csv", "anti-us_sentiment.csv", "GTD_and_SATP_data.csv", "news_sentiment.csv", "weather_data.csv"]
merged_data = import_and_merge_csv_data(dir, csvnames, :date)
"""

    function import_and_merge_csv_data(dir::String, csvnames::Vector{String}, mergecol::Symbol)
        # Initialize an empty DataFrame for merging
        df = DataFrame()

        # Loop through each file name in the csvnames list
        for filename in csvnames
            # Construct the full file path
            filepath = joinpath(dir, filename)
            
            # Import the CSV file
            data = CSV.read(filepath, DataFrame)
            
            # If df is empty, initialize it with the first DataFrame
            if isempty(df)
                df = copy(data)
            else
                # Merge the current DataFrame with df on the specified column
                df = leftjoin(df, data, on = mergecol)
            end
        end

        # Return the merged dataset
        return df
    end


#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#---------------------# b. Log transformation function #----------------------#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#


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
            log_values = map(x -> isnothing(x) ? missing : log(x + (add_one ? 1 : 0)), df_copy[:, idx])
    
            # Insert log column after the original column
            df_copy = insertcols(df_copy, idx + 1, Symbol(new_col) => log_values)
        end

        return df_copy
    end

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#------------------# c. Replacing missing values with zeros #-----------------#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#


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
            df[!, var] .= coalesce.(df[!, var], 0)
        end
        return df
    end


#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#-----------------------# d. Standardising variables #------------------------#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#


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


#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#---------------# e. Generate future and past moving averages #---------------#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#


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


#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#-----------------# f. Define custom lag-generating function #----------------#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#


"""
    get_lags(df, varlist, tdiffs)

Generates lagged versions of specified variables in the input DataFrame `df`. The function creates new columns by shifting the specified variables (`varlist`) by the time differences defined in `tdiffs`. Lags are applied for each time step in `tdiffs`, and missing values are set for rows where the lag would go out of bounds.

### Arguments:
- `df::DataFrame`: The input DataFrame containing the data.
- `varlist::Vector{Symbol}`: A list of variable names (columns) for which lags will be generated.
- `tdiffs::Vector{Int}`: A list of time differences (lags) to apply. Each value in this list represents the number of time steps by which to shift the respective variable.

### Returns:
- `DataFrame`: A copy of the input DataFrame with new columns for each lag of the selected variables.

### Example:

```julia
df = DataFrame(date = 1:5, attacks = [1, 2, 3, 4, 5], deaths = [5, 4, 3, 2, 1])
varlist = [:attacks, :deaths]
tdiffs = [1, 2]

lagged_df = get_lags(df, varlist, tdiffs)
println(lagged_df)
"""

function get_lags(df, varlist, tdiffs)
    # Function to generate lags of selected variables for 
    # selected time differences. 
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


#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#---------------# 2. DEFINE MAIN TOP-LEVEL WRANGLING FUNCTION #---------------#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#


"""
    wrangle_raw_mj_data!(mjdata::DataFrame)

Performs data wrangling operations on the raw data used to replicate the results in Mahmood & Jetter, 2023. 
This includes replacing missing values, generating logs, standardizing variables, creating moving averages, 
lags, leads, and binary indicators, and handling sentiment variables.

# Arguments
- `mjdata::DataFrame`: The raw DataFrame containing the data that needs to be wrangled.

# Details
1. **Missing Values**: Replaces missing values with zeros for selected variables.
2. **Logs and Standardization**: Generates logs for specific variables and standardizes them.
3. **Moving Averages, Lags, and Leads**: Calculates moving averages for selected variables, as well as lags and leads for time series analysis.
4. **Binary Indicators**: Creates binary indicators for days of the week and months based on the `date` column.
5. **Sentiment Variables**: Adjusts and generates moving averages and lags for sentiment-related variables.
6. **Custom Variables**: Defines new custom variables and indicators, such as `severein7`, `attacksafglag1`, and `attacksafglag2`.
7. **Date Handling**: Creates and formats additional date-related columns for analysis.

# Returns
The wrangled `DataFrame` with additional computed columns and processed variables.

# Example
```julia
# Example: Wrangling raw data
using DataFrames, CSV, Statistics, Dates, .WranglingFuns

# Load raw data from CSV files
dir = "data"
csvnames = ["drones_data.csv", "anti-us_sentiment.csv", "GTD_and_SATP_data.csv", "news_sentiment.csv", "weather_data.csv"]
merged_data = import_and_merge_csv_data(dir, csvnames, :date)

# Apply the wrangling function to the raw data
wrangle_raw_mj_data!(mjdata)

# Display the first few rows of the processed data
first(mjdata, 5)
"""

function wrangle_raw_mj_data(mjdata)
    
    #-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
    #  a. Replacing missing values, generating logs and standardizing variables   #
    #-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
        
        # Drop extra column - duplicated column from anti-us_sentiment.csv
        if "zarb1" in names(mjdata)
            select!(mjdata, Not(:zarb1))
        elseif "zarb_1" in names(mjdata)
            select!(mjdata, Not(:zarb_1))
        end

        # Define logs for selected variables
        mjdata = def_logs(mjdata, ["preciraq", "precisrael"]; add_one = true)
    
        # Replacing missing values with a zero
        varlist = ["avgterrornegemo", "avgterrornousnegemo", "avgterrornodronenegemo", 
        "avgusnegemo", "avgdronenegemo", "avgusnodronenegemo", "avgusnoterrornegemo", 
        "avgterrorposemo", "avgterrornousposemo", "avgterrornodroneposemo", 
        "avgusposemo", "avgdroneposemo", "avgusnodroneposemo", "avgusnoterrorposemo", 
        "avgterroranger", "avgterrornousanger", "avgterrornodroneanger", "avgusanger", 
        "avgdroneanger", "avgusnoterroranger", "avgusnodroneanger", "topterrornegemo", 
        "topterrornousnegemo", "topterrornodronenegemo", "topusnegemo", 
        "topusnodronenegemo", "topusnoterrornegemo", "topterrorposemo", 
        "topterrornousposemo", "topterrornodroneposemo", "topusposemo", 
        "topusnodroneposemo", "topusnoterrorposemo", "topterroranger", 
        "topterrornousanger", "topterrornodroneanger", "topusanger", 
        "topusnodroneanger", "topusnoterroranger", "senavgterrornegemo", 
        "senavgterrornousnegemo", "senavgterrornodronenegemo", "senavgterrorposemo", 
        "senavgterrornousposemo", "senavgterrornodroneposemo", "senavgterroranger", 
        "senavgterrornousanger", "senavgterrornodroneanger", "senavgusnegemo", 
        "senavgusnodronenegemo", "senavgusnoterrornegemo", "senavgusposemo", 
        "senavgusnodroneposemo", "senavgusnoterrorposemo", "senavgusanger", 
        "senavgusnodroneanger", "senavgusnoterroranger"]
    
        mjdata = replace_na_with_zeros(mjdata, varlist)
    
        # Set values to missing if date is before 16892
        for var in varlist 
            mjdata[!, var] = ifelse.(mjdata[!, :date] .< 16892, missing, mjdata[!, var])
        end
    
        # Add variables to standardise
        add_vars_to_std = split("jihad prot_ter prot_terdum prot_us prot_usdum tvideo zarb ghazwa usaid usimmi usefp")
        append!(varlist, add_vars_to_std)
       
        # Standardise selected columns
        mjdata = standardise_var(mjdata, varlist)
    
    #-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
    #---#  b. Generating moving averages, leads, lags and binary indicators   #---#
    #-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
    
        # Sort dataframe by date
        sort!(mjdata, :date)
    
        # Generate selected moving averages for selected groups of variables
        # 1. Attacks and deaths
        mjdata = generate_moving_average(mjdata, 
                                        ["attacks", "deaths"], 
                                        vcat(1:14, 21, 28); 
                                        direction=:leads)
    
        mjdata = generate_moving_average(mjdata, 
                                        ["attacks", "deaths"], 
                                        [15:21, 15:28, 15:70]; 
                                        direction=:leads)
    
        # 2. [a_reltargeted attrel ... fata nonfata]
        varlist = split("a_reltargeted attrel attnonrel attsep drones jihad tvideo 
                        zarb ghazwa usaid usimmi usefp prot_us prot_usdum prot_ter 
                        prot_terdum bomb assault kidnapping assassination govt 
                        business private fata nonfata")
    
        mjdata = replace_na_with_zeros(mjdata, varlist)
    
        mjdata = generate_moving_average(mjdata, varlist, [7, 14])
    
        # 3. attacksiraq and attacksisrael
        varlist = split("attacksiraq attacksisrael")
    
        mjdata = replace_na_with_zeros(mjdata, varlist)
    
        mjdata = generate_moving_average(mjdata, varlist, [7])
    
        
        # 4. attacksiraq and attacksisrael
        varlist = split("numdrone numus numterror avgusnodroneanger avgdronenegemo 
                        avgdroneanger avgdroneposemo avgusnegemo avgusanger avgusposemo 
                        avgusnoterrornegemo avgusnoterroranger avgusnoterrorposemo 
                        avgusnodronenegemo avgusnodroneposemo avgterrornegemo 
                        avgterroranger avgterrorposemo avgterrornousnegemo 
                        avgterrornousanger avgterrornousposemo avgterrornodronenegemo 
                        avgterrornodroneanger avgterrornodroneposemo")
    
        mjdata = generate_moving_average(mjdata, varlist, [7, 14])
    
        # 5. Lags [gusts wind ... prot_ter prot_terdum]
        varlist = split("gusts wind drones attacks deaths mil_act attacksisrael 
                        attacksafg severe w_total jihad tvideo zarb attacksiraq 
                        avgusnodroneanger numdrone numus numterror a_reltargeted 
                        attrel attnonrel attsep avgdronenegemo avgdroneanger 
                        avgdroneposemo avgusnegemo avgusanger avgusposemo 
                        avgusnoterrornegemo avgusnoterroranger avgusnoterrorposemo 
                        avgusnodronenegemo avgusnodroneposemo avgterrornegemo 
                        avgterroranger avgterrorposemo avgterrornousnegemo 
                        avgterrornousanger avgterrornousposemo 
                        avgterrornodronenegemo avgterrornodroneanger 
                        avgterrornodroneposemo ghazwa usaid usimmi usefp bomb 
                        assault kidnapping assassination govt business private 
                        fata nonfata prot_us prot_usdum prot_ter prot_terdum")
        
        mjdata = get_lags(mjdata, varlist, vcat(1:14))
    
        # 6. Define new variables
        # a. New indicators
        mjdata[!, :severein7] = mjdata.deathsin7 ./ mjdata.attacksin7
        mjdata[!, :severelag14] = sum.(eachrow(mjdata[!, [Symbol("deaths", i) for i in 1:14]]))./ 
                                    sum.(eachrow(mjdata[!, [Symbol("attacks", i) for i in 1:14]]))
        mjdata[!, :attacksafglag1] = sum.(eachrow(mjdata[!, [Symbol("attacksafg", i) for i in 1:7]]))
        mjdata[!, :attacksafglag2] = sum.(eachrow(mjdata[!, [Symbol("attacksafg", i) for i in 1:14]]))
        
        # Replace NaNs with missing 
        mjdata[!, :severein7] .= [ismissing(x) || isnan(x) ? missing : x for x in mjdata[!, :severein7]]
        mjdata[!, :severelag14] .= [ismissing(x) || isnan(x) ? missing : x for x in mjdata[!, :severelag14]]


        # b. date and ign
        mjdata[!, :date3] = mjdata[!, :date] ./ 3
        mjdata[!, :date6] = mjdata[!, :date] ./ 6
        mjdata[!, :date14] = mjdata[!, :date] ./ 14
    
        mjdata[!, :ign3] = mod.(mjdata.date3, 1) .> 0
        mjdata[!, :ign6] = mod.(mjdata.date6, 1) .> 0
        mjdata[!, :ign14] = mod.(mjdata.date14, 1) .> 0
    
    
        # 7. Lags [attacks drones gusts tmean2_mir lnprec mil_act]
        sort!(mjdata, :date)
        varlist = split("attacks drones gusts tmean2_mir lnprec mil_act")
    
        mjdata = generate_moving_average(mjdata, varlist, [3, 6, 14]; direction = :lags)
         
        
        # 8. Lags and leads of lags
        varlist = ["attacks", "mil_act", "drones"]
    
        max_lead = length(mjdata[:, 1])
    
        for var in ["attacks", "mil_act", "drones"]
            for suffix in ["avg3", "avg6", "avg14"]
                col = Symbol(var * suffix)
        
                if suffix == "avg3"
                    mjdata[!, Symbol(var * "avg3lag")] = [i <= 3 ? missing : mjdata[i-3, col] for i in 1:nrow(mjdata)]
                    mjdata[!, Symbol(var * "avg3lag2")] = [i <= 6 ? missing : mjdata[i-6, col] for i in 1:nrow(mjdata)]
                    mjdata[!, Symbol(var * "avg3lag3")] = [i <= 9 ? missing : mjdata[i-9, col] for i in 1:nrow(mjdata)]
                    mjdata[!, Symbol(var * "avg3lag4")] = [i <= 12 ? missing : mjdata[i-12, col] for i in 1:nrow(mjdata)]
                    mjdata[!, Symbol(var * "avg3lead")] = [i > max_lead - 3 ? missing : mjdata[i+3, col] for i in 1:nrow(mjdata)]
                elseif suffix == "avg6"
                    mjdata[!, Symbol(var * "avg6lag")] = [i <= 6 ? missing : mjdata[i-6, col] for i in 1:nrow(mjdata)]
                    mjdata[!, Symbol(var * "avg6lag2")] = [i <= 12 ? missing : mjdata[i-12, col] for i in 1:nrow(mjdata)]
                    mjdata[!, Symbol(var * "avg6lead")] = [i > max_lead - 6 ? missing : mjdata[i+6, col] for i in 1:nrow(mjdata)]
                elseif suffix == "avg14"
                    mjdata[!, Symbol(var * "avg14lag")] = [i <= 14 ? missing : mjdata[i-14, col] for i in 1:nrow(mjdata)]
                    mjdata[!, Symbol(var * "avg14lag2")] = [i <= 28 ? missing : mjdata[i-28, col] for i in 1:nrow(mjdata)]
                    mjdata[!, Symbol(var * "avg14lead")] = [i > max_lead - 14 ? missing : mjdata[i+14, col] for i in 1:nrow(mjdata)]
                end
            end
        end
    
        # 9. Sentiment variables: correcting averages and generating leads and lags
        varlist = split("avgusnegemo avgusanger avgusposemo avgusnoterrornegemo 
                        avgusnoterroranger avgusnoterrorposemo avgusnodronenegemo 
                        avgusnodroneanger avgusnodroneposemo avgterrornegemo 
                        avgterroranger avgterrorposemo avgterrornousnegemo 
                        avgterrornousanger avgterrornousposemo avgterrornodronenegemo 
                        avgterrornodroneanger avgterrornodroneposemo")
    
        for var in varlist
            mjdata[!, var] .= ifelse.(ismissing.(mjdata.senavgusnegemo), missing, mjdata[!, var])
        end
    
        varlist = split("senavgusnegemo senavgusanger senavgusposemo 
                        senavgusnoterrornegemo senavgusnoterroranger senavgusnoterrorposemo 
                        senavgusnodronenegemo senavgusnodroneanger senavgusnodroneposemo 
                        senavgterrornegemo senavgterroranger senavgterrorposemo 
                        senavgterrornousnegemo senavgterrornousanger senavgterrornousposemo 
                        senavgterrornodronenegemo senavgterrornodroneanger senavgterrornodroneposemo
                        topusnegemo topusanger topusposemo topusnoterrornegemo 
                        topusnoterroranger topusnoterrorposemo topusnodronenegemo 
                        topusnodroneanger topusnodroneposemo topterrornegemo 
                        topterroranger topterrorposemo topterrornousnegemo 
                        topterrornousanger topterrornousposemo topterrornodronenegemo 
                        topterrornodroneanger topterrornodroneposemo")
    
        # mjdata = replace_na_with_zeros(mjdata, varlist)
    
        mjdata = generate_moving_average(mjdata, varlist, [7])
    
        mjdata = get_lags(mjdata, varlist, vcat(1:14))
    
        # 10. Generating binary indicators for days of the week and months
        mjdata[!, :dum] .= mjdata.dronesin7 .> 0

        # Correct if missing
        mjdata[:, :dum] = [ismissing.(mjdata[i, :dum]) ? 1 : mjdata[i, :dum] .+ 0 for i in 1:4018]


        # Map date correctly
        start_date = Date("2006-01-01")

        # Modify the existing date col
        mjdata.date .= [Dates.format(start_date + Day(d - 16802), "dd-mm-yyyy") for d in mjdata.date]
        mjdata.date = Date.(mjdata.date, "dd-mm-yyyy")

        # 1-7 where 1 is Monday - this does not match original data
        # Generating binary indicators for days of the week (dow)
        # mjdata[!, :dow] .= dayofweek.(mjdata.date)  # Get day of the week (1 = Monday, 7 = Sunday)
        # dows = [Symbol("dows", i) for i in 1:7]  # Generate names for the day of the week columns
    
        # # Create binary indicator columns for each day of the week
        # for i in 1:7
        #     mjdata[!, dows[i]] .= (mjdata.dow .== i) .+ 0  # 1 if true, 0 if false
        # end

        # 0-6 where 1 is Monday - this matches original data
        # Generating binary indicators for days of the week (dow)
        mjdata[!, :dow] .= dayofweek.(mjdata.date)  # Get day of the week (1 = Monday, 7 = Sunday)
        mjdata.dow = mjdata.dow .% 7 # Transform into 0 to 6 with 0 being Sunday

        dows = [Symbol("dows", i) for i in 1:7]  # Generate names for the day of the week columns

        # Create binary indicator columns for each day of the week
        for i in 1:7
            mjdata[!, dows[i]] .= (mjdata.dow .== (i - 1)) .+ 0  # 1 if true, 0 if false
        end
    
        # Generating binary indicators for months (month)
        mjdata[!, :month] .= month.(mjdata.date)  # Get the month
        months = [Symbol("months", i) for i in 1:12]  # Generate names for the month columns
    
        # Create binary indicator columns for each month
        for i in 1:12
            mjdata[!, months[i]] .= (mjdata.month .== i) .+ 0  # 1 if true, 0 if false
        end
    
        # Format date
        # 5. Formatting Date (if necessary)
        #sort!(mjdata, :date)
        # mjdata.date_str .= Dates.format(mjdata.date, "yyyy-mm-dd")
        
        # Reverting to integer encoding for dates to run regressions
        epoch = Date("1960-01-01")
        mjdata[!, :date] = Dates.value.(mjdata[!, :date] .- epoch)
    
        return mjdata
    
    end

end

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#-------------------------# END OF WRANGLING MODULE #-------------------------#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#