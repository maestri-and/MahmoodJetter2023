include("Table_2_function.jl")

#################################################################################################################################################################################################################################
#                   Generating Panel A
################################################################################################################################################################################################################################

function generate_table2_panelA(df)
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
        "14-day averages"
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

#################################################################################################################################################################################################################################
#                   Generating Panel B
################################################################################################################################################################################################################################

function generate_table2_panelB(df)
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
        "14-day averages"
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

#################################################################################################################################################################################################################################
#                   Generating Panel D
################################################################################################################################################################################################################################

function generate_table2_panelD(df)
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
        "14-day averages"
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

