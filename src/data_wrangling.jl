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
using Dates
using ShiftedArrays
include("submodules/wrangling_funs.jl")
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

    mjdata = replace_na_with_zeros(mjdata, varlist)

    mjdata = generate_moving_average(mjdata, varlist, [7])

    mjdata = get_lags(mjdata, varlist, vcat(1:14))

    # 10. Generating binary indicators for days of the week and months
    mjdata[!, :dum] .= mjdata.dronesin7 .> 0

    # Generating binary indicators for days of the week (dow)
    mjdata[!, :dow] .= dayofweek.(mjdata.date)  # Get day of the week (1 = Monday, 7 = Sunday)
    dows = [Symbol("dows", i) for i in 1:7]  # Generate names for the day of the week columns

    # Create binary indicator columns for each day of the week
    for i in 1:7
        mjdata[!, dows[i]] .= (mjdata.dow .== i) .+ 0  # 1 if true, 0 if false
    end

    # Generating binary indicators for months (month)
    mjdata[!, :months] .= month.(mjdata.date)  # Get the month
    months = [Symbol("months", i) for i in 1:12]  # Generate names for the month columns

    # Create binary indicator columns for each month
    for i in 1:12
        mjdata[!, months[i]] .= (mjdata.months .== i) .+ 0  # 1 if true, 0 if false
    end

    # Format date
    # 5. Formatting Date (if necessary)
    sort!(mjdata, :date)
    # mjdata.date_str .= Dates.format(mjdata.date, "yyyy-mm-dd")    

# end

