include("Temporary_data_cleaning.jl")
include("output_table1.jl")
include("outptut_table2.jl")
include("output_figure2.jl")
include("output_figures3to7.jl")

# Specify the file path
file_path = "/Users/alibenra/Desktop/Replication_Julia/Temporary.dta"

# Specify the variables to check for missing values for regressions to clean the data accordingly
variables_to_check = [
    :attacksin7, :drones, :gusts, :dows1, :dows2, :dows3, :dows4, :dows5, :dows6, :ramadan, 
    :date, :months1, :months2, :months3, :months4, :months5, :months6, :months7, :months8, 
    :months9, :months10, :months11, :mil_act1, :mil_act2, :mil_act3, :mil_act4, :mil_act5, 
    :mil_act6, :mil_act7, :mil_act8, :mil_act9, :mil_act10, :mil_act11, :mil_act12, :mil_act13, 
    :mil_act14, :attacks1, :attacks2, :attacks3, :attacks4, :attacks5, :attacks6, :attacks7, 
    :attacks8, :attacks9, :attacks10, :attacks11, :attacks12, :attacks13, :attacks14, 
    :tmean2_mir, :lnprec
]

# Call the function to prepare the data
df, df_clean = prepare_data(file_path, variables_to_check)

# Generate Table 1
generate_table1(df)

# Generate Tables 2
generate_table2_panelA(df_clean)
generate_table2_panelB(df_clean)
generate_table2_panelD(df_clean)

# Generate plots from Figure 2
generate_figure2a(df)
generate_figure2b(df)
generate_figure2c(df)
generate_figure2d(df)
generate_figure2e(df)
generate_figure2f(df)

# Generate Figures 3 to 7
generate_figure3(df_clean)
generate_figure4(df_clean)
generate_figure5(df_clean)
generate_figure6(df_clean)
generate_figure7(df_clean)