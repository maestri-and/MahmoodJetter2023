using DataFrames
using FixedEffectModels
using Plots

#################################################################################################################################################################################################################################
#   Creating functions to automate the production of plots of 2SLS regression coefficients across different sets of variables
#  
#   Description: Compute mean, standard deviation (in parentheses), min, and max for each column in `vars`, returning a new DataFrame. Round to `digits` decimals
#################################################################################################################################################################################################################################

# Function to run regressions
function run_regressions(dependent_vars, time_window, df_clean)
    results = Dict()
    for dep_var in dependent_vars
        # Construct the dependent variable name
        dep_var_time = Symbol("$(dep_var)in$time_window")
        
        # Construct lagged variables dynamically as symbols
        lagged_vars = [Symbol("$(dep_var)$i") for i in 1:14]

        # Dynamically construct the formula
        formula = @eval @formula($dep_var_time ~ (drones ~ gusts) + attacks + $(Symbol("attacksin$time_window")) + 
                            dows1 + dows2 + dows3 + dows4 + dows5 + dows6 + ramadan + date + 
                            months1 + months2 + months3 + months4 + months5 + months6 + months7 + 
                            months8 + months9 + months10 + months11 + mil_act1 + mil_act2 + mil_act3 + 
                            mil_act4 + mil_act5 + mil_act6 + mil_act7 + mil_act8 + mil_act9 + 
                            mil_act10 + mil_act11 + mil_act12 + mil_act13 + mil_act14 + $(lagged_vars...) + 
                            tmean2_mir + lnprec)

        # Run regression and store results
        println("Running regression for $dep_var_time")
        try
            result = reg(df_clean, formula, Vcov.robust())
            results[dep_var] = result
        catch e
            println("Error running regression for $dep_var_time: $e")
        end
    end
    return results
end

# Function to extract coefficients and errors
function extract_coefficients(results, dependent_vars)
    coeffs = []
    errors = []
    for dep_var in dependent_vars
        if haskey(results, dep_var)
            result = results[dep_var]
            ct = coeftable(result)
            df = DataFrame(ct)

            # Find the row corresponding to "drones"
            row = filter(row -> row[1] == "drones", eachrow(df)) |> first

            # Extract coefficient and standard error
            coef = row[2]
            se = row[3]

            # Append to lists
            push!(coeffs, coef)
            push!(errors, 1.96 * se)  # 95% confidence interval
        else
            println("No result found for $dep_var")
        end
    end
    return coeffs, errors
end

# Function to create the plot
function create_plot(coeffs, errors, labels, title_text, x_axis_title, ylim_values, yticks_step, xrotation_angle, output_path)
    # Create the plot
    plt = scatter(1:length(coeffs), coeffs, ylim=ylim_values, yerr=errors, label="", marker=:diamond, color=:navy)

    # Set x-axis ticks with labels
    xticks = (1:length(labels), labels)

    # Add horizontal line at 0
    hline!([0], color=:red, linestyle=:dash, label="")

    # Add axis labels and title
    xlabel!(x_axis_title, guidefont=font(10))  # Customizable x-axis title
    ylabel!("Coefficient of drone strikes", guidefont=font(10))
    title!(title_text, titlefont=font(12))

    # Generate y-axis ticks based on the range and step
    yticks = collect(ylim_values[1]:yticks_step:ylim_values[2])
    plot!(xticks=xticks, yticks=yticks, xrotation=xrotation_angle, xlims=(0.5, length(labels) + 0.5))

    # Display the plot
    display(plt)

    # Save the plot
    savefig(output_path)
    println("Plot saved at: $output_path")
end

# Main function to automate the workflow
function process_analysis(dependent_vars, time_window, labels, title_text, x_axis_title, ylim_values, yticks_step, xrotation_angle, output_file, df_clean)
    results = run_regressions(dependent_vars, time_window, df_clean)
    coeffs, errors = extract_coefficients(results, dependent_vars)
    create_plot(coeffs, errors, labels, title_text, x_axis_title, ylim_values, yticks_step, xrotation_angle, output_file)
end

#################################################################################################################################################################################################################################
#   Specific function for regression 3
#################################################################################################################################################################################################################################

function run_regressions_figure3(dependent_vars, time_window, additional_vars, df_clean)
    results = Dict()
    
    # First loop: "attacksin1", "attacksin2", ..., "attacksin14"
    for x in [1:14; 21; 28]
        dep_var = Symbol("$(dependent_vars)in$x")  # Construct the dependent variable name
        
        # Dynamically construct the formula
        formula = @eval @formula($dep_var ~ (drones ~ gusts) + dows1 + dows2 + dows3 + dows4 + dows5 + dows6 +
                                 ramadan + date + months1 + months2 + months3 + months4 + months5 + months6 +
                                 months7 + months8 + months9 + months10 + months11 +
                                 mil_act1 + mil_act2 + mil_act3 + mil_act4 + mil_act5 + mil_act6 + mil_act7 + mil_act8 +
                                 mil_act9 + mil_act10 + mil_act11 + mil_act12 + mil_act13 + mil_act14 +
                                 $(Symbol("$(dependent_vars)1")) + $(Symbol("$(dependent_vars)2")) + 
                                 $(Symbol("$(dependent_vars)3")) + $(Symbol("$(dependent_vars)4")) +
                                 $(Symbol("$(dependent_vars)5")) + $(Symbol("$(dependent_vars)6")) +
                                 $(Symbol("$(dependent_vars)7")) + $(Symbol("$(dependent_vars)8")) +
                                 $(Symbol("$(dependent_vars)9")) + $(Symbol("$(dependent_vars)10")) +
                                 $(Symbol("$(dependent_vars)11")) + $(Symbol("$(dependent_vars)12")) +
                                 $(Symbol("$(dependent_vars)13")) + $(Symbol("$(dependent_vars)14")) +
                                 tmean2_mir + lnprec)

        # Run regression and store results
        println("Running regression for $dep_var")
        try
            result = reg(df_clean, formula, Vcov.robust())
            results["e$x"] = result
        catch e
            println("Error running regression for $dep_var: $e")
        end
    end
    
    # Second loop: Additional variables ("attacks15to21", "attacks15to28", etc.)
    for (outcome, label) in additional_vars
        outcome_var = Symbol(outcome)  # Construct the dependent variable name
        
        # Dynamically construct the formula
        formula = @eval @formula($outcome_var ~ (drones ~ gusts) + dows1 + dows2 + dows3 + dows4 + dows5 + dows6 +
                                 ramadan + date + months1 + months2 + months3 + months4 + months5 + months6 +
                                 months7 + months8 + months9 + months10 + months11 +
                                 mil_act1 + mil_act2 + mil_act3 + mil_act4 + mil_act5 + mil_act6 + mil_act7 + mil_act8 +
                                 mil_act9 + mil_act10 + mil_act11 + mil_act12 + mil_act13 + mil_act14 +
                                 $(Symbol("$(dependent_vars)1")) + $(Symbol("$(dependent_vars)2")) +
                                 $(Symbol("$(dependent_vars)3")) + $(Symbol("$(dependent_vars)4")) +
                                 $(Symbol("$(dependent_vars)5")) + $(Symbol("$(dependent_vars)6")) +
                                 $(Symbol("$(dependent_vars)7")) + $(Symbol("$(dependent_vars)8")) +
                                 $(Symbol("$(dependent_vars)9")) + $(Symbol("$(dependent_vars)10")) +
                                 $(Symbol("$(dependent_vars)11")) + $(Symbol("$(dependent_vars)12")) +
                                 $(Symbol("$(dependent_vars)13")) + $(Symbol("$(dependent_vars)14")) +
                                 tmean2_mir + lnprec)
        
        # Run regression and store results
        println("Running regression for $outcome_var")
        try
            result = reg(df_clean, formula, Vcov.robust())
            results[label] = result
        catch e
            println("Error running regression for $outcome_var: $e")
        end
    end

    return results
end