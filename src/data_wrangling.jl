###############################################################################
############################## DATA_WRANGLING.JL ##############################

##### This script defines the functions used to prepare the data for the ######
############ replication of the results in Mahmood & Jetter, 2023 #############
###############################################################################


module MJWrangling

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#---------------# 0. Importing libraries and defining exports #---------------#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

using CSV
using DataFrames

export import_and_merge_datasets

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

end

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#


###############################################################################


###############################################################################


###############################################################################


###############################################################################



###############################################################################



###############################################################################