include("ivreg_plots_functions.jl")

function generate_figure3(df_clean)
    # Figure 3a: Subsequent terror attacks per day
    dependent_vars_attacks = "attacks"
    additional_vars_attacks = [
        ("attacks15to21", "e17"),
        ("attacks15to28", "e18"),
        ("attacks15to70", "e19")
    ]
    labels_attacks = [
        "1–2", "1–3", "1–4", "1–5", "1–6", "1–7", "1–8", "1–9", "1–10",
        "1–11", "1–12", "1–13", "1–14", "1–28", "15–21", "15–28", "15–70"
    ]
    title_text_attacks = "Subsequent terror attacks per day"
    x_axis_title_attacks = "Days after drone strikes"
    output_file_attacks = joinpath(@__DIR__, "subsequent_terror_plot.pdf")
    ylim_attacks = (-5, 10)  # Y-axis limits
    yticks_step_attacks = 5  # Step size for y-axis ticks
    xrotation_attacks = 90  # Vertical x-labels

    results_attacks = run_regressions_figure3(dependent_vars_attacks, 7, additional_vars_attacks, df_clean)
    coeffs, errors = extract_coefficients(results_attacks, ["e1", "e2", "e3", "e4", "e5", "e6", "e7", "e8", "e9", "e10", "e11", "e12", "e13", "e14", "e28", "e17", "e18", "e19"])
    create_plot(coeffs, errors, labels_attacks, title_text_attacks, x_axis_title_attacks, ylim_attacks, yticks_step_attacks, xrotation_attacks, output_file_attacks)

    #Figure 3b: Subsequent terror deaths per day
    dependent_vars_deaths = "deaths"
    additional_vars_deaths = [
        ("deaths15to21", "e17"),
        ("deaths15to28", "e18"),
        ("deaths15to70", "e19")
    ]
    labels_deaths = [
        "1–2", "1–3", "1–4", "1–5", "1–6", "1–7", "1–8", "1–9", "1–10",
        "1–11", "1–12", "1–13", "1–14", "1–28", "15–21", "15–28", "15–70"
    ]
    title_text_deaths = "Subsequent terror deaths per day"
    x_axis_title_deaths = "Days after drone strikes"
    output_file_deaths = joinpath(@__DIR__, "subsequent_deaths_plot.pdf")
    ylim_deaths = (-10, 30)  # Y-axis limits
    yticks_step_deaths = 5  # Step size for y-axis ticks
    xrotation_deaths = 90  # Vertical x-labels

    results_deaths = run_regressions_figure3(dependent_vars_deaths, 7, additional_vars_deaths, df_clean)
    coeffs, errors = extract_coefficients(results_deaths, ["e1", "e2", "e3", "e4", "e5", "e6", "e7", "e8", "e9", "e10", "e11", "e12", "e13", "e14", "e28", "e17", "e18", "e19"])
    create_plot(coeffs, errors, labels_deaths, title_text_deaths, x_axis_title_deaths, ylim_deaths, yticks_step_deaths, xrotation_deaths, output_file_deaths)
end

function generate_figure4(df_clean)
    #Figure 4a: Number of Drone Articles (Frequency of TNI Articles)
    dependent_vars = ["numdrone", "numus", "numterror"]
    labels = [
        "# of drone articles", 
        "# of US articles", 
        "# of terror group articles"
    ]
    title_text_drone = "(a) Frequency of TNI articles"
    x_axis_title_drone = " "
    output_file_drone = joinpath(@__DIR__, "frequency_of_tni_articles.pdf")
    ylim_drone = (-1, 10)  # Y-axis limits
    yticks_step_drone = 1  # Step size for y-axis ticks
    xrotation_drone = 0  
    process_analysis(dependent_vars, 7, labels, title_text_drone, x_axis_title_drone, ylim_drone, yticks_step_drone, xrotation_drone, output_file_drone, df_clean)

    #Figure 4b: Sentiment of Drone-Related TNI Articles
    dependent_vars = ["avgdronenegemo", "avgdroneanger", "avgdroneposemo"]
    labels = [
        "Negative emotions", 
        "Anger", 
        "Positive emotions"
    ]
    title_text_sentiment = "(b) Sentiment of drone-related TNI articles"
    x_axis_title_sentiment = ""
    output_file_sentiment = joinpath(@__DIR__, "sentiment_of_tni_articles.pdf")
    ylim_sentiment = (-0.5, 2.3)  # Y-axis limits
    yticks_step_sentiment = 0.5  # Step size for y-axis ticks
    xrotation_sentiment = 0 
    process_analysis(dependent_vars, 7, labels, title_text_sentiment, x_axis_title_sentiment, ylim_sentiment, yticks_step_sentiment, xrotation_sentiment, output_file_sentiment, df_clean)
end

function generate_figure5(df_clean)
    #Figure 5a: TNI Articles Mentioning US-Related Keyword
    dependent_vars = [
    "avgusnegemo", "avgusanger", "avgusposemo",
    "avgusnoterrornegemo", "avgusnoterroranger", "avgusnoterrorposemo",
    "avgusnodronenegemo", "avgusnodroneanger", "avgusnodroneposemo"
    ]
    labels = [
        "Negative\nemotions", 
        "Anger", 
        "Positive\nemotions",
        "Negative\nemotions\n(no terror)", 
        "Anger\n(no terror)", 
        "Positive\nemotions\n(no terror)",
        "Negative\nemotions\n(no drone)", 
        "Anger\n(no drone)", 
        "Positive\nemotions\n(no drone)"
    ]
    title_text_us = "(a) TNI articles mentioning US-related keyword"
    x_axis_title_us = " "
    output_file_us = joinpath(@__DIR__, "tni_articles_us_keywords.pdf")
    ylim_us = (-1.5, 2.5)  # Y-axis limits
    yticks_step_us = 0.5  # Step size for y-axis ticks
    xrotation_us = 0
    process_analysis(dependent_vars, 7, labels, title_text_us, x_axis_title_us, ylim_us, yticks_step_us, xrotation_us, output_file_us, df_clean)

    #Figure 5b: TNI Articles Mentioning Terror-Group-Related Keyword
    dependent_vars = [
    "avgterrornegemo", "avgterroranger", "avgterrorposemo",
    "avgterrornousnegemo", "avgterrornousanger", "avgterrornousposemo",
    "avgterrornodronenegemo", "avgterrornodroneanger", "avgterrornodroneposemo"
    ]
    labels = [
        "Negative\nemotions", 
        "Anger", 
        "Positive\nemotions",
        "Negative\nemotions\n(no US)", 
        "Anger\n(no US)", 
        "Positive\nemotions\n(no US)",
        "Negative\nemotions\n(no drone)", 
        "Anger\n(no drone)", 
        "Positive\nemotions\n(no drone)"
    ]
    title_text_terror = "(b) TNI articles mentioning terror-group-related keyword"
    x_axis_title_terror = " "
    output_file_terror = joinpath(@__DIR__, "tni_articles_terror_keywords.pdf")
    ylim_terror = (-3, 1)  # Y-axis limits
    yticks_step_terror = 0.5  # Step size for y-axis ticks
    xrotation_terror = 0
    process_analysis(dependent_vars, 7, labels, title_text_terror, x_axis_title_terror, ylim_terror, yticks_step_terror, xrotation_terror, output_file_terror, df_clean)
end

function generate_figure6(df_clean)
    #Figure 6a: Protests on Days t + 1 to t + 7
    dependent_vars = ["prot_us", "prot_usdum", "prot_ter", "prot_terdum"]
    labels = [
        "Anti-US protests", 
        "Anti-US protests\n(binary)", 
        "Anti-terror protests", 
        "Anti-terror protests\n(binary)"
    ]
    title_text_7 = "(a) Protests on days t + 1 until t + 7"
    x_axis_title_7 = " "
    output_file_7 = joinpath(@__DIR__, "protests_on_days_t_plus_1_to_t_plus_7.pdf")
    ylim_7 = (-2, 5)  # Specify the y-axis limits
    yticks_step_7 = 1  # Specify the step size for y-axis ticks
    xrotation_7 = 0
    process_analysis(dependent_vars, 7, labels, title_text_7, x_axis_title_7, ylim_7, yticks_step_7, xrotation_7, output_file_7, df_clean)

    #Figure 6b: Protests on Days t + 1 to t + 7
    title_text_14 = "(b) Protests on days t + 1 until t + 14"
    x_axis_title_14 = " "
    output_file_14 = joinpath(@__DIR__, "protests_on_days_t_plus_1_to_t_plus_14.pdf")
    ylim_14 = (-2, 5)  # Specify the y-axis limits
    yticks_step_14 = 1  # Specify the step size for y-axis ticks
    xrotation_14 = 0
    process_analysis(dependent_vars, 14, labels, title_text_14, x_axis_title_14, ylim_14, yticks_step_14, xrotation_14, output_file_14, df_clean)
end

function generate_figure7(df_clean)
    #Figure 7a: Google searches on days t + 1 until t + 7
    dependent_vars = ["jihad", "tvideo", "zarb", "ghazwa", "usaid", "usimmi", "usefp"]
    labels = [
        "Jihad", 
        "Taliban\nvideo", 
        "Zarb-e-\nMomin", 
        "Ghazwa e \nHind", 
        "USAID", 
        "US\nimmigration", 
        "USEFP"
    ]
    title_text_7 = "Google searches on days t + 1 until t + 7"
    x_axis_title_7 = " "
    output_file_7 = joinpath(@__DIR__, "google_searches_days_t_plus_1_to_t_plus_7.pdf")
    ylim_7 = (-1, 2)  # Specify the y-axis limits
    yticks_step_7 = 0.5
    xrotation_7 = 0
    process_analysis(dependent_vars, 7, labels, title_text_7, x_axis_title_7, ylim_7, yticks_step_7, xrotation_7, output_file_7, df_clean)

    #Figure 7b: Google searches on days t + 1 until t + 14
    title_text_14 = "Google searches on days t + 1 until t + 14"
    x_axis_title_14 = " "
    output_file_14 = joinpath(@__DIR__, "google_searches_days_t_plus_1_to_t_plus_14.pdf")
    ylim_14 = (-1, 2)  # Specify the y-axis limits
    yticks_step_14 = 0.5
    xrotation_14 = 0
    process_analysis(dependent_vars, 14, labels, title_text_14, x_axis_title_14, ylim_14, yticks_step_14, xrotation_14, output_file_14, df_clean)
end