using DataFrames, GLM, CovarianceMatrices, Printf, PrettyTables

#################################################################################################################################################################################################################################
#                Function to create regression tables
#################################################################################################################################################################################################################################

function create_multiple_model_table2(
    models, 
    independent_var::String, 
    column_titles::Vector{String}, 
    bw_fixed::Vector{Int}, 
    bw_variable::Vector{Int}, 
    table_title::String, 
    table_subtitle::String, 
    table_caption::String
)
    # Check that the number of models matches the number of column titles, fixed bandwidths, and variable bandwidths
    if length(models) != length(column_titles) || length(models) != length(bw_fixed) || length(models) != length(bw_variable)
        error("The number of models, column titles, fixed bandwidths, and variable bandwidths must match.")
    end

    # Define the row labels
    row_labels = [independent_var, "HAC SE (Fixed BW)", "HAC SE (Variable BW)"]

    # Initialize an empty array to store table content
    table_content = []

    # Loop through each model and compute the results
    for (i, model) in enumerate(models)
        # Extract statistics
        coef_value = @sprintf("%.4f", coef(model)[2])  # Assuming the second coefficient is the one we need
        hac_se_fixed = @sprintf("(%.4f)", stderror(BartlettKernel(bw_fixed[i]), model, prewhite=false)[2])  # Fixed bandwidth
        hac_se_variable = @sprintf("[%.4f]", stderror(BartlettKernel(bw_variable[i]), model, prewhite=false)[2])  # Variable bandwidth

        # Add the results as a column
        push!(table_content, [coef_value, hac_se_fixed, hac_se_variable])
    end

    # Combine the row labels and the table content into the final table
    final_table = hcat(row_labels, hcat(table_content...))

    # Add the header
    header = vcat(["Data dimensions of dependent variable: terror attacks"], column_titles)

    # Save the LaTeX table to the same directory as this script
    latex_file_path = joinpath(@__DIR__, "$table_subtitle.tex")
    text_file_path = joinpath(@__DIR__, "$table_subtitle.txt")  # Path for the text file

    # Write the LaTeX table to the file with a title, subtitle, and caption
    open(latex_file_path, "w") do io
        # Manually write the LaTeX table content
        write(io, """
        \\textbf{$table_title} \\\\
        \\textit{$table_subtitle} \\\\

        \\caption{$table_caption}
        \\label{tab:regression_results}

        \\resizebox{\\textwidth}{!}{
        \\begin{tabular}{p{3cm}p{2cm}p{2cm}p{2cm}p{2cm}p{2cm}}
        \\hline
        """)
        
        # Write the header row
        write(io, " & " * join(column_titles, " & ") * " \\\\\n")
        write(io, "\\hline\n")

        # Write each row of the table
        for row in eachrow(final_table)
            row_data = join(row, " & ")
            write(io, "$row_data \\\\\n")
        end

        # Close the LaTeX table environment
        write(io, """
        \\hline
        \\end{tabular}
        }
        """)
    end
    println("LaTeX file successfully saved to: $latex_file_path")

    # Write the text table to the file with the title, subtitle, and caption
    open(text_file_path, "w") do io
        # Write the title, subtitle, and caption at the top of the file
        write(io, "$table_title\n")
        write(io, "$table_subtitle\n\n")
        write(io, "Caption: $table_caption\n\n")
        # Use PrettyTables to write the tabular content
        pretty_table(io, final_table, header, backend=Val(:text))  # Save as plain text
    end
    println("Text file successfully saved to: $text_file_path")
end
