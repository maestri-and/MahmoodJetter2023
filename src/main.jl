###############################################################################
################################### MAIN.JL ###################################

############# This script cleans the raw data and replicates all ##############
################# the main results in Mahmood & Jetter, 2023 ##################
###############################################################################

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#-------------------# 0. Importing libraries and modules #--------------------#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

using CSV
using DataFrames
using Statistics
using Dates
include("./WranglingFuns.jl")
include("./TablesFuns.jl")
include("./FiguresFuns.jl")
using .WranglingFuns
using .TablesFuns
using .FiguresFuns


#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#--------------------# 1. Importing and merging raw data #--------------------#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

dir = "data"
csvnames = ["drones_data.csv", "anti-us_sentiment.csv", "GTD_and_SATP_data.csv", "news_sentiment.csv", "weather_data.csv"]
mjdata = import_and_merge_csv_data(dir, csvnames, :date)


#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#-----------------------------# 1. Wrangle data #-----------------------------#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

mjdata = wrangle_raw_mj_data(mjdata)

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#---------------------# 2. Reproduce Tables and Figures #---------------------#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

# Generate Table 1
table1 = generate_table1(mjdata)

# Generate plots from Figure 2
figure2a = generate_figure2a(mjdata)
figure2b = generate_figure2b(mjdata)
figure2c = generate_figure2c(mjdata)
figure2d = generate_figure2d(mjdata)
figure2e = generate_figure2e(mjdata)
figure2f = generate_figure2f(mjdata)

# Generate Tables 2
table2a = generate_table2_panelA(mjdata)
table2b = generate_table2_panelB(mjdata)
table2d = generate_table2_panelD(mjdata)

# Generate Figures 3 to 7
figure3 = generate_figure3(mjdata)
figure4 = generate_figure4(mjdata)
figure5 = generate_figure5(mjdata)
figure6 = generate_figure6(mjdata)
figure7 = generate_figure7(mjdata)