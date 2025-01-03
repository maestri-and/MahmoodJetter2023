include("binscatter_function.jl")

#################################################################################################################################################################################################################################
#                   Figure 2(a) - Binned Scatter Plots of the first stage regression, 
#                                           plotting drone strikes on day t against wind gusts 
#                                           in Miran Shah on the same day, controlling for the full set of covariates
#
#                   Figure 2(b) - Binned Scatter Plots providing a placebo check using wind conditions in Karachi
#################################################################################################################################################################################################################################

function generate_figure2a(df)
    # Defining the control variables for figures 2(a) to 2(d)
    controls = [:dows2, :dows3, :dows4, :dows5, :dows6, :dows7, :ramadan, :date, 
    :months2, :months3, :months4, :months5, :months6, :months7, :months8, :months9, 
    :months10, :months11, :months12, :mil_act1, :mil_act2, :mil_act3, :mil_act4, 
    :mil_act5, :mil_act6, :mil_act7, :mil_act8, :mil_act9, :mil_act10, :mil_act11, 
    :mil_act12, :mil_act13, :mil_act14, :attacks1, :attacks2, :attacks3, :attacks4, 
    :attacks5, :attacks6, :attacks7, :attacks8, :attacks9, :attacks10, :attacks11, 
    :attacks12, :attacks13, :attacks14, :tmean2_mir, :lnprec]

    binscatter_improved(
        df,
        :drones,
        :gusts,
        controls,
        xlabel = "Wind gusts on day t",
        ylabel = "Drone strikes on day t",
        title_prefix = "Wind gusts in Miran Shah and drone strikes",
        n_bins = 10,
        ylim_range = (0.0, 0.2),
        yticks_step = 0.05,
        output_filename = "figure_2a.pdf"
    )
end

function generate_figure2b(df)
    # Defining the control variables for figures 2(a) to 2(d)
    controls = [:dows2, :dows3, :dows4, :dows5, :dows6, :dows7, :ramadan, :date, 
    :months2, :months3, :months4, :months5, :months6, :months7, :months8, :months9, 
    :months10, :months11, :months12, :mil_act1, :mil_act2, :mil_act3, :mil_act4, 
    :mil_act5, :mil_act6, :mil_act7, :mil_act8, :mil_act9, :mil_act10, :mil_act11, 
    :mil_act12, :mil_act13, :mil_act14, :attacks1, :attacks2, :attacks3, :attacks4, 
    :attacks5, :attacks6, :attacks7, :attacks8, :attacks9, :attacks10, :attacks11, 
    :attacks12, :attacks13, :attacks14, :tmean2_mir, :lnprec]

    # Call the function for figure 2b
    binscatter_improved(
        df,
        :drones,
        :gusts_karachi,
        controls,
        xlabel = "Wind gusts on day t",
        ylabel = "Drone strikes on day t",
        title_prefix = "Wind gusts in Karachi and drone strikes",
        n_bins = 10,
        ylim_range = (0.0, 0.2),
        yticks_step = 0.05,
        output_filename = "figure_2b.pdf"
    )
end

#################################################################################################################################################################################################################################
#                   Figures 2(c) - Binned Scatter Plot of the reduced-form estimation, 
#                                  plotting subsequent terror attacks against wind gusts in Miran Shah
#                   Figure 2(d) - Placebo plot: it illustrates the null relationship between wind gusts 
#                                 in Karachi and subsequent terror attacks throughout Pakistan
#################################################################################################################################################################################################################################

function generate_figure2c(df)
    # Defining the control variables for figures 2(a) to 2(d)
    controls = [:dows2, :dows3, :dows4, :dows5, :dows6, :dows7, :ramadan, :date, 
    :months2, :months3, :months4, :months5, :months6, :months7, :months8, :months9, 
    :months10, :months11, :months12, :mil_act1, :mil_act2, :mil_act3, :mil_act4, 
    :mil_act5, :mil_act6, :mil_act7, :mil_act8, :mil_act9, :mil_act10, :mil_act11, 
    :mil_act12, :mil_act13, :mil_act14, :attacks1, :attacks2, :attacks3, :attacks4, 
    :attacks5, :attacks6, :attacks7, :attacks8, :attacks9, :attacks10, :attacks11, 
    :attacks12, :attacks13, :attacks14, :tmean2_mir, :lnprec]

    # Call the function for the figure 2c
    binscatter_improved(
        df,
        :attacksin7,
        :gusts,
        controls,
        xlabel = "Wind gusts on day t",
        ylabel = "Terror attacks per day on days t+1 to t+7",
        title_prefix = "Wind gusts in Miran Shah and subsequent terror attacks",
        n_bins = 10,
        ylim_range = (2.6, 3.1),
        yticks_step = 0.1,
        output_filename = "figure_2c.pdf"
    )
end

function generate_figure2d(df)
    # Defining the control variables for figures 2(a) to 2(d)
    controls = [:dows2, :dows3, :dows4, :dows5, :dows6, :dows7, :ramadan, :date, 
    :months2, :months3, :months4, :months5, :months6, :months7, :months8, :months9, 
    :months10, :months11, :months12, :mil_act1, :mil_act2, :mil_act3, :mil_act4, 
    :mil_act5, :mil_act6, :mil_act7, :mil_act8, :mil_act9, :mil_act10, :mil_act11, 
    :mil_act12, :mil_act13, :mil_act14, :attacks1, :attacks2, :attacks3, :attacks4, 
    :attacks5, :attacks6, :attacks7, :attacks8, :attacks9, :attacks10, :attacks11, 
    :attacks12, :attacks13, :attacks14, :tmean2_mir, :lnprec]

    # Call the function for the figure 2d
    binscatter_improved(
        df,
        :attacksin7,
        :gusts_karachi,
        controls,
        xlabel = "Wind gusts on day t",
        ylabel = "Terror attacks per day on days t+1 to t+7",
        title_prefix = "Wind gusts in Karachi and and subsequent terror attacks",
        n_bins = 10,
        ylim_range = (2.6, 3.1),
        yticks_step = 0.1,
        output_filename = "figure_2d.pdf"
    )
end

#################################################################################################################################################################################################################################
#                   Figures 2(e) and 2(f) - Two additional placebo estimations, predicting terror
#                   attacks and Pakistani military actions on day t− 1 with wind gusts on day t
#################################################################################################################################################################################################################################

function generate_figure2e(df)
    # Defining the control variables for figure 2(e)
    controls2e = [:dows2, :dows3, :dows4, :dows5, :dows6, :dows7, :ramadan, :date, 
    :months2, :months3, :months4, :months5, :months6, :months7, :months8, :months9, 
    :months10, :months11, :months12, :mil_act1, :mil_act2, :mil_act3, :mil_act4, 
    :mil_act5, :mil_act6, :mil_act7, :mil_act8, :mil_act9, :mil_act10, :mil_act11, 
    :mil_act12, :mil_act13, :mil_act14, :attacks2, :attacks3, :attacks4, 
    :attacks5, :attacks6, :attacks7, :attacks8, :attacks9, :attacks10, :attacks11, 
    :attacks12, :attacks13, :attacks14, :tmean2_mir, :lnprec]

    # Call the function for the figure 2e
    binscatter_improved(
        df,
        :attacks1,
        :gusts,
        controls2e,
        xlabel = "Wind gusts on day t",
        ylabel = "Terror attacks on day t-1",
        title_prefix = "Wind gusts in Miran Shah and past terror attacks",
        n_bins = 10,
        ylim_range = (2.4, 3.2),
        yticks_step = 0.2,
        output_filename = "figure_2e.pdf"
    )
end

function generate_figure2f(df)
    # Defining the control variables for figure 2(f)
    controls2f = [:dows2, :dows3, :dows4, :dows5, :dows6, :dows7, :ramadan, :date, 
    :months2, :months3, :months4, :months5, :months6, :months7, :months8, :months9, 
    :months10, :months11, :months12, :mil_act2, :mil_act3, :mil_act4, 
    :mil_act5, :mil_act6, :mil_act7, :mil_act8, :mil_act9, :mil_act10, :mil_act11, 
    :mil_act12, :mil_act13, :mil_act14, :attacks1, :attacks2, :attacks3, :attacks4, 
    :attacks5, :attacks6, :attacks7, :attacks8, :attacks9, :attacks10, :attacks11, 
    :attacks12, :attacks13, :attacks14, :tmean2_mir, :lnprec]

    # Call the function for the figure 2f
    binscatter_improved(
        df,
        :mil_act1,
        :gusts,
        controls2f,
        xlabel = "Wind gusts on day t",
        ylabel = "Pakistani military actions on day t-1",
        title_prefix = "Wind gusts in Miran Shah and past Pakistani military actions",
        n_bins = 10,
        ylim_range = (0.6, 1.4),
        yticks_step = 0.2,
        output_filename = "figure_2f.pdf"
    )
end