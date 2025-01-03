using StatFiles
using DataFrames

function prepare_data(file_path::String, variables_to_check::Vector{Symbol})
    # Load the dataset
    println("Loading data from $file_path...")
    df = DataFrame(load(file_path))

    # Convert Float32 variables to Float64 for compatibility with GLM and other packages
    println("Converting Float32 to Float64...")
    for col in names(df)
        if eltype(df[!, col]) <: Union{Missing, Float32}
            df[!, col] = Float64.(coalesce.(df[!, col], NaN))  # Replace `missing` with `NaN` and convert to Float64
        end
    end

    # Replace NaN values with `missing`
    println("Replacing NaN with missing values...")
    for col in names(df)
        if eltype(df[!, col]) <: AbstractFloat
            df[!, col] = replace(df[!, col], NaN => missing)  # Replace NaN with missing
        end
    end

    # Drop rows with missing values for the specified variables
    println("Dropping rows with missing values in specified variables...")
    df_clean = dropmissing(df, variables_to_check)

    println("Data preparation complete!")
    return df, df_clean
end
