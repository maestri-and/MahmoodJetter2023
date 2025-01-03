###############################################################################
############################## DATA_WRANGLING.JL ##############################

############### This script cleans and prepare the data for the ###############
############ replication of the results in Mahmood & Jetter, 2023 #############
###############################################################################

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#-------------------# 0. Importing libraries and modules #--------------------#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

using CSV
using DataFrames
using Statistics
include("submodules/wrangling_functions.jl")
using Main.Wrangling_funs


#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#--------------------# 1. Importing and merging raw data #--------------------#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

mjdata = import_and_merge_datasets()


#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#-----------------------------# 1. Wrangle data #-----------------------------#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

# function wrangle_raw_mj_data()
    
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#  a. Replacing missing values, generating logs and standardizing variables   #
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

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
#-----------#  b. Generating changes, leads, lags and binary indicators   #------------#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

    # Sort dataframe by date
    mjdata = sort(mjdata, :date)

    # Generate selected moving averages for selected variables
    mjdata = generate_moving_average(mjdata, ["attacks", "deaths"], vcat(1:14, 21, 28))
# end



orig_var_list = varlist .* "orig"
orig_var_list = vcat(varlist, orig_var_list)
orig_var_list

means = DataFrame(varname = String[], idx = Int[], mean = Float64[], sd = Float64[])
for var in orig_var_list
    idx = findfirst(isequal(var), names(mjdata))
    meanvar = mean(skipmissing(mjdata[!, idx]))
    sdvar = std(skipmissing(mjdata[!, idx]))

    push!(means, (var, idx, meanvar, sdvar))  # Use a tuple for the row
end
vscodedisplay(means)
# mjdata[:, 54:59]
# [:, "senavgusnoterroranger"]