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
using Main.Wrangling_funs

# Temp
# include("../src/data_wrangling.jl")

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#-----------------------# 0. Define testing functions #-----------------------#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#



# a. Test import procedure and integrity of data
@testset "DataFrame Integrity" begin
    # Create a DataFrame
    df = MJWrangling.import_and_merge_datasets()

    # Test if the object is a DataFrame
    @test isa(df, DataFrame)

    # Test the number of rows in the DataFrame
    @test nrow(df) == 4018

    # Test the number of columns in the DataFrame
    @test ncol(df) == 119
end

