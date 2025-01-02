###############################################################################
############################## WRANGLING_FUNCTIONS.JL ##############################

##### This script defines the functions used to prepare the data for the ######
############ replication of the results in Mahmood & Jetter, 2023 #############
###############################################################################


module Wrangling_funs

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#---------------# 0. Importing libraries and defining exports #---------------#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

using CSV
using DataFrames

export import_and_merge_datasets, def_logs

    function import_and_merge_datasets()
        # Import raw data 
        drones_df = CSV.read("data/drones_data.csv", DataFrame)
        anti_us_df = CSV.read("data/anti-us_sentiment.csv", DataFrame)
        gtd_df = CSV.read("data/GTD_and_SATP_data.csv", DataFrame)
        news_df = CSV.read("data/news_sentiment.csv", DataFrame)
        weather_df = CSV.read("data/weather_data.csv", DataFrame)

        # Merge using "date" column
        mjdata = drones_df

        for df in [anti_us_df, gtd_df, news_df, weather_df]
            mjdata = leftjoin(mjdata, df, on = :date)
        end

        # Return dataset
        return mjdata
    end

    function def_augmented_logs(df, col_array)
        # Function to generate logs of selected variables
        # Corrected with a +1 for zero values
        for var in col_array
            # Define new column name
            new_col = string("ln", var)

            # Get column position
            idx = findfirst(isequal(var), names(df))

            # Insert log column after the original column
            df = insertcols(df, idx + 1, 
                            Symbol(new_col) => log.(df[:, idx]) .+ 1)
        end

        return df
    end

    function ()
        
    end

            
        
end

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#


###############################################################################


###############################################################################


###############################################################################


###############################################################################



###############################################################################



###############################################################################