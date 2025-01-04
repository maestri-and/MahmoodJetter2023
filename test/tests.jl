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
include("../src/WranglingFuns.jl")
using .WranglingFuns


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
@testset "DataFrame Integrity" begin
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
@testset "WranglingFuns integrity" begin
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

@testset "Cleaned data matches original authors' Stata cleaning" begin
    # Test if cleaned data matches original authors' 
    # data outputted after Stata cleaning

    # Import both data
    orig_mjdata = CSV.read("original_package/stata_orig_output_wrangled.csv", DataFrame) |> 
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








