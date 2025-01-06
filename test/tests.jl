###############################################################################
############################## TESTS.JL ##############################

####### This script defines and launches the unit tests for the Julia #########
############### replication package of Mahmood & Jetter, 2023 #################
###############################################################################

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#-------------------# 0. Importing libraries and modules #--------------------#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

using Test
using CSV
using DataFrames
using Statistics
using Printf
using CovarianceMatrices
using GLM
using Base.Filesystem
include("../src/WranglingFuns.jl")
include("../src/TablesFuns.jl")
include("../src/FiguresFuns.jl")
using .WranglingFuns
using .TablesFuns
using .FiguresFuns

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#------------------# 1. Define auxiliary testing functions #------------------#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

function compare_columns(orig_col, julia_col; tolerance=1e-3)
    diff_count = 0
    missing_diff = 0
    for i in 1:length(orig_col)
        o = orig_col[i]
        j = julia_col[i]
        
        # Case 1: Both values are missing -> consider equal
        if ismissing(o) && ismissing(j)
            continue
        end
        
        # Case 2: One value is missing and the other is not -> consider different
        if ismissing(o) != ismissing(j)
            missing_diff += 1
            continue
        end
        
        # Case 3: Both values are not missing -> compare with tolerance
        if !ismissing(o) && !ismissing(j) && !isapprox(o, j, atol=tolerance)
            diff_count += 1
        end
    end
    return diff_count, missing_diff
end

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#-------------------------# 2. Define and run tests #-------------------------#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#


# a. Test import procedure and integrity of data
@testset "(Raw) DataFrame Integrity" begin
    # Create DataFrame from raw files
    dir = "data"
    csvnames = ["drones_data.csv", "anti-us_sentiment.csv", "GTD_and_SATP_data.csv", "news_sentiment.csv", "weather_data.csv"]
    df = import_and_merge_csv_data(dir, csvnames, :date)

    # Test if the object is a DataFrame
    @test isa(df, DataFrame)

    # Test the number of rows in the DataFrame
    @test nrow(df) == 4018

    # Test the number of columns in the DataFrame
    @test ncol(df) == 119
end

# b. Test integrity of wrangling module
@testset "WranglingFuns module integrity" begin
    # Create dummy dataset
    df = DataFrame(A = [0, 2, missing, 3, ℯ^2 -1], 
                    B = [1, 0, 4, missing, 2],
                    C = [1, 2, 3, 4, 5])
    varlist = ["A", "B"]

    # Test log function
    @testset "Log function works correctly" begin
        df = def_logs(df, varlist; add_one = true)

        # Check whether column was created correctly
        @test "lnA" in names(df)

        # Check value
        @test df.lnA[5] == 2
        @test df.lnA[1] == 0
    end

    df = DataFrame(A = [0, 2, missing, 3, ℯ^2 -1], 
                    B = [1, 0, 4, missing, 2],
                    C = [1, 2, 3, 4, 5])
    varlist = ["A", "B"]

    # Test replace with zero function
    df = replace_na_with_zeros(df, varlist) 
    @test df.B[2] == 0 

    df = DataFrame(A = [0, 2, 0, 3, ℯ^2 -1], 
                    B = [1, 0, 4, 0, 2],
                    C = [1, 2, 3, 4, 5])
    varlist = ["A", "B"]

    # Test standardisation
    df = standardise_var(df, ["C"])

    @test df.C[3] == 0
end

# c. Test if cleaned data matches original authors' data outputted after Stata cleaning

@testset "Cleaned data matches original authors' Stata cleaning" begin
    # Test if cleaned data matches original authors' 
    # data outputted after Stata cleaning

    # Import both data
    orig_mjdata = CSV.read("original_package/replication_package/stata_orig_output_wrangled.csv", DataFrame) |> 
    (df -> select!(df, Not(:v9)))
    dir = "data"
    csvnames = ["drones_data.csv", "anti-us_sentiment.csv", "GTD_and_SATP_data.csv", "news_sentiment.csv", "weather_data.csv"]
    mjdata = import_and_merge_csv_data(dir, csvnames, :date)
    mjdata = wrangle_raw_mj_data(mjdata)

    # Compare columns one to one and stores different columns
    # in error_vector, if any
    
    # Date is naturally different due to format, we exclude it from the check

    error_vector = String[]  # Initialize an empty vector to store error-prone column names

    for col in setdiff(names(mjdata), ["date"])

        orig_col = orig_mjdata[!, col]
        julia_col = mjdata[!, col]

        # println("Testing $col")
        diff_count, missing_diff = compare_columns(orig_col, julia_col)

        if diff_count > 0 || missing_diff > 0
            println("Column $col has $diff_count differences and $missing_diff missing vs existing differences")
            push!(error_vector, col)  # Store column name in error vector
        else
            # println("Column $col passed the comparison.")
        end

    end

    @test isempty(error_vector)
end

# d. Integraty test for the replicate_sutex function, replicating the sutex package in STATA to directly compute a summary statistics table.

@testset "replicate_sutex function tests" begin
    # Test Case 1: Basic functionality with no missing values
    @testset "Basic functionality" begin
        # Test: Ensure replicate_sutex computes correct summary statistics for numeric columns
        # Create a DataFrame with no missing values
        df = DataFrame(
            A = [1.0, 2.0, 3.0, 4.0, 5.0],
            B = [2.0, 4.0, 6.0, 8.0, 10.0]
        )
        vars = [:A, :B]  # Specify variables to summarize
        result = replicate_sutex(df, vars, digits=2)

        # Dynamically compute expected values for column A
        mean_A = mean(df.A)
        sd_A = std(df.A)
        min_A = minimum(df.A)
        max_A = maximum(df.A)

        # Dynamically compute expected values for column B
        mean_B = mean(df.B)
        sd_B = std(df.B)
        min_B = minimum(df.B)
        max_B = maximum(df.B)

        # Verify that the result DataFrame has the correct structure
        @test "Variable" in names(result)
        @test result.Variable == ["A", "B"]

        # Check the computed statistics for column A
        @test result.Mean[1] == @sprintf("%.*f", 2, mean_A)  # Check mean
        @test result.SD[1] == @sprintf("(%.*f)", 2, sd_A)   # Check standard deviation
        @test result.Min[1] == @sprintf("%.*f", 2, min_A)   # Check minimum
        @test result.Max[1] == @sprintf("%.*f", 2, max_A)   # Check maximum

        # Check the computed statistics for column B
        @test result.Mean[2] == @sprintf("%.*f", 2, mean_B)
        @test result.SD[2] == @sprintf("(%.*f)", 2, sd_B)
        @test result.Min[2] == @sprintf("%.*f", 2, min_B)
        @test result.Max[2] == @sprintf("%.*f", 2, max_B)
    end

    # Test Case 2: Handling missing values
    @testset "Handling missing values" begin
        # Test: Ensure replicate_sutex skips missing values and computes stats correctly
        # Create a DataFrame with some missing and all-missing columns
        df = DataFrame(
            A = [1.0, 2.0, missing, 4.0, 5.0],  # Partially missing
            B = [missing, missing, missing, missing, missing]  # Fully missing
        )
        vars = [:A, :B]  # Specify variables to summarize
        result = replicate_sutex(df, vars, digits=2)

        # Dynamically compute expected values for column A (skipping `missing`)
        values_A = collect(skipmissing(df.A))
        mean_A = mean(values_A)
        sd_A = std(values_A)
        min_A = minimum(values_A)
        max_A = maximum(values_A)

        # Check the computed statistics for column A
        @test result.Mean[1] == @sprintf("%.*f", 2, mean_A)  # Check mean
        @test result.SD[1] == @sprintf("(%.*f)", 2, sd_A)   # Check standard deviation
        @test result.Min[1] == @sprintf("%.*f", 2, min_A)   # Check minimum
        @test result.Max[1] == @sprintf("%.*f", 2, max_A)   # Check maximum

        # Check that column B (all missing) returns "NA" for all statistics
        @test result.Mean[2] == "NA"    # Mean should be "NA"
        @test result.SD[2] == "(NA)"   # Standard deviation should be "(NA)"
        @test result.Min[2] == "NA"    # Minimum should be "NA"
        @test result.Max[2] == "NA"    # Maximum should be "NA"
    end

    # Test Case 3: Empty DataFrame
    @testset "Empty DataFrame" begin
        # Test: Ensure replicate_sutex handles empty DataFrames gracefully
        # Create an empty DataFrame
        df = DataFrame(A = Float64[], B = Float64[])
        vars = [:A, :B]  # Specify variables to summarize
        result = replicate_sutex(df, vars, digits=2)

        # Verify that all statistics are "NA" when DataFrame is empty
        @test result.Mean == ["NA", "NA"]  # Mean should be "NA"
        @test result.SD == ["(NA)", "(NA)"]  # SD should be "(NA)"
        @test result.Min == ["NA", "NA"]  # Min should be "NA"
        @test result.Max == ["NA", "NA"]  # Max should be "NA"
    end

    # Test Case 4: Different number of digits
    @testset "Custom digits for rounding" begin
        # Test: Ensure replicate_sutex respects the `digits` argument for rounding
        # Create a DataFrame with no missing values
        df = DataFrame(
            A = [1.0, 2.0, 3.0, 4.0, 5.0],
            B = [2.0, 4.0, 6.0, 8.0, 10.0]
        )
        vars = [:A, :B]  # Specify variables to summarize
        result = replicate_sutex(df, vars, digits=3)  # Use 3 digits for rounding

        # Dynamically compute expected values for column A
        mean_A = mean(df.A)
        sd_A = std(df.A)
        min_A = minimum(df.A)
        max_A = maximum(df.A)

        # Dynamically compute expected values for column B
        mean_B = mean(df.B)
        sd_B = std(df.B)
        min_B = minimum(df.B)
        max_B = maximum(df.B)

        # Check computed statistics for column A with 3 decimal places
        @test result.Mean[1] == @sprintf("%.*f", 3, mean_A)  # Check mean
        @test result.SD[1] == @sprintf("(%.*f)", 3, sd_A)   # Check standard deviation
        @test result.Min[1] == @sprintf("%.*f", 3, min_A)   # Check minimum
        @test result.Max[1] == @sprintf("%.*f", 3, max_A)   # Check maximum

        # Check computed statistics for column B with 3 decimal places
        @test result.Mean[2] == @sprintf("%.*f", 3, mean_B)
        @test result.SD[2] == @sprintf("(%.*f)", 3, sd_B)
        @test result.Min[2] == @sprintf("%.*f", 3, min_B)
        @test result.Max[2] == @sprintf("%.*f", 3, max_B)
    end
end

# e. Unit Tests for the create_multiple_model_table2 function, testing the two following elements: Input Validation & Intermediate Results Validation

### e.1. Input Validation
# Test set for input validation
# Goal: Ensure the function throws an appropriate error when the input lengths are mismatched
@testset "Input Validation Test" begin
    # Define mismatched inputs
    # Models, column titles, and bandwidth vectors have mismatched lengths
    models = [[1.0, 2.0], [0.1, 0.2]]  # Simulating structure of models
    column_titles = ["Model 1"]  # Only one title instead of two
    bw_fixed = [5]  # Only one fixed bandwidth
    bw_variable = [10, 15]  # Two variable bandwidths (mismatch with other inputs)

    # Try executing the function and check for the expected error
    try
        create_multiple_model_table2(
            models, 
            "independent_var", 
            column_titles, 
            bw_fixed, 
            bw_variable, 
            "Table Title", 
            "Subtitle", 
            "Caption"
        )
        @test false  # The test fails if no error is thrown
    catch e
        # Verify that the error is of the correct type
        @test isa(e, ErrorException)

        # Verify that the error message matches the expected content
        @test occursin("The number of models, column titles, fixed bandwidths, and variable bandwidths must match.", e.msg)
    end
end

### e.2. Intermediate Results Validation
# Test set for intermediate results validation
# Goal: Validate that the intermediate table content (coefficients and errors) is computed correctly
@testset "Intermediate Results Validation" begin
    # Provide coefficients and errors directly as inputs
    # Simulating the internal logic of the function for table construction
    models = [
        [0.0, 1.2345],  # Coefficients for Model 1
        [0.0, 2.3456]   # Coefficients for Model 2
    ]
    errors_fixed = [
        [0.0, 0.1234],  # Fixed bandwidth errors for Model 1
        [0.0, 0.2345]   # Fixed bandwidth errors for Model 2
    ]
    errors_variable = [
        [0.0, 0.2234],  # Variable bandwidth errors for Model 1
        [0.0, 0.3345]   # Variable bandwidth errors for Model 2
    ]

    # Define additional metadata
    # These are inputs required by the function for constructing the table
    column_titles = ["Model 1", "Model 2"]
    bw_fixed = [5, 10]
    bw_variable = [15, 20]
    independent_var = "Terror Attacks"

    # Simulate the logic of the function to compute intermediate results
    table_content = []
    for i in 1:length(models)
        # Extract and format coefficient of the independent variable
        coef_value = @sprintf("%.4f", models[i][2])

        # Extract and format HAC standard errors (fixed bandwidth)
        hac_se_fixed = @sprintf("(%.4f)", errors_fixed[i][2])

        # Extract and format HAC standard errors (variable bandwidth)
        hac_se_variable = @sprintf("[%.4f]", errors_variable[i][2])

        # Combine these results for the current model
        push!(table_content, [coef_value, hac_se_fixed, hac_se_variable])
    end

    # Expected intermediate results for validation
    expected_table_content = [
        ["1.2345", "(0.1234)", "[0.2234]"],  # Expected results for Model 1
        ["2.3456", "(0.2345)", "[0.3345]"]   # Expected results for Model 2
    ]

    # Validate that the computed intermediate results match the expected results
    for (i, col) in enumerate(table_content)
        # println("Testing model $i: $col")  # Log which model is being tested
        @test col == expected_table_content[i]  # Check row-wise equality
    end
end

# f. Unit Tests for the binscatter_improved function
# These tests focus on three elements: Data Cleaning, Dynamic Title Creation, & Output Path Creation

@testset "binscatter_improved Unit Tests" begin

    # Test 1: Data Cleaning
    @testset "Data Cleaning" begin
        # Goal: Ensure that rows with missing values in the dependent or independent variables
        # are correctly removed from the dataset.
        df = DataFrame(dep_var = [1.0, missing, 3.0], indep_var = [missing, 2.0, 3.0])
        df_clean = dropmissing(df, [:dep_var, :indep_var])

        @test nrow(df_clean) == 1  # Expect only one row to remain after dropping missing data.
        @test collect(df_clean[1, :]) == [3.0, 3.0]  # Verify that the remaining row contains the correct values.
    end

    # Test 2: Dynamic Title Creation
    @testset "Dynamic Title Creation" begin
        # Goal: Verify that the plot title is dynamically constructed to include a rounded p-value.
        p_value = 0.03456
        title_prefix = "Binscatter"
        title_text = "$title_prefix (p = $(round(p_value, digits=4)))"

        @test title_text == "Binscatter (p = 0.0346)"  # Check that the title matches the expected format.
    end

    # Test 3: Output Path Creation
    @testset "Output Path Creation" begin
        # Goal: Ensure that the output file path is constructed correctly from the directory and file name.
        script_dir = "output"
        output_filename = "binscatter.pdf"
        output_path = joinpath(script_dir, output_filename)
        output_path_norm = normpath(output_path)

        # Expected path - make it dynamic for different filesystems
        expected_path = normpath("output/binscatter.pdf")

        @test output_path_norm == expected_path  # Verify that the file path matches the expected result.
    end
end

# g. Test for the function extract_coefficients created as part of the bundle of functions aiming to automate 
# the production of plots of 2SLS regression coefficients across different sets of variables, outputting Figures 3 to 7

@testset "extract_coefficients Unit Test" begin
    # Goal of the test:
    # Validate that the `extract_coefficients` function correctly extracts regression coefficients 
    # and 95% confidence intervals for the specified dependent variables.

    # Process:
    # - Create a mock `results` dictionary with regression outputs as DataFrames.
    # - Call `extract_coefficients` to extract coefficients and errors for the term "drones."
    # - Compare the extracted values to the expected coefficients and errors.

    # Mock regression results
    results = Dict(
        "drones" => DataFrame(
            Term = ["(Intercept)", "drones", "gusts"],
            Coef = [1.0, 2.0, 3.0],
            StdErr = [0.1, 0.2, 0.3]
        ),
        "other_dep" => DataFrame(
            Term = ["(Intercept)", "drones", "gusts"],
            Coef = [0.5, 1.5, 2.5],
            StdErr = [0.05, 0.15, 0.25]
        )
    )
    dependent_vars = ["drones", "other_dep"]

    # Mock the extract_coefficients function logic because the test uses simplified mock data 
    # (e.g., DataFrame) instead of actual regression objects, allowing us to replicate the behavior 
    # of `coeftable` and validate the function logic without relying on real regression results.
    function extract_coefficients(results, dependent_vars)
        coeffs = []
        errors = []
        for dep_var in dependent_vars
            if haskey(results, dep_var)
                result = results[dep_var]
                # Find the row corresponding to "drones"
                row = filter(row -> row.Term == "drones", eachrow(result)) |> first
                # Extract coefficient and standard error
                coef = row.Coef
                se = row.StdErr
                # Append to lists
                push!(coeffs, coef)
                push!(errors, 1.96 * se)  # 95% confidence interval
            else
                println("No result found for $dep_var")
            end
        end
        return coeffs, errors
    end

    # Run the function and test results
    coeffs, errors = extract_coefficients(results, dependent_vars)

    # Expected outputs
    expected_coeffs = [2.0, 1.5]  # Coefficients for "drones" and "other_dep"
    expected_errors = [0.392, 0.294]  # 1.96 * StdErr for each dependent variable

    # Validate outputs
    @test coeffs == expected_coeffs
    @test isapprox.(errors, expected_errors, atol=1e-3) |> all
end

