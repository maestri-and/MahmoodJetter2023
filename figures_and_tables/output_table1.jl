include("replicate_sutex_function.jl")

#################################################################################################################################################################################################################################
#   Table 1. Summary Statistics of Main Variables for all 4,018 Days from January 1, 2006 until December 31, 2016. All Variables are Measured at the Daily Level.
#################################################################################################################################################################################################################################

function generate_table1(df)
    # Specify the variables to summarize
    vars = [:drones, :attacks, :gusts, :wind, :mil_act, :ramadan, :tmean2_mir, :prec_mir]

    # Using the replicate_sutex function
    summary_table = replicate_sutex(df, vars, digits=2)

    # Displaying the table as a DataFrame
    display(summary_table)

    # Save the LaTeX table to the same directory as this script
    latex_file_path = joinpath(@__DIR__, "summary_table.tex")
    text_file_path = joinpath(@__DIR__, "summary_table.txt")  # Path for the text file

    # Define the table title
    table_title = "Table 1. Summary Statistics of Main Variables for all 4,018 Days from January 1, 2006 until December 31, 2016. All Variables are Measured at the Daily Level."

    # Write the LaTeX table to the file with a caption
    open(latex_file_path, "w") do io
        # Write the LaTeX table environment opening
        write(io, """
        \\begin{table}[ht]
        \\centering
        \\caption{$table_title}
        \\label{tab:summary_statistics}
        """)
        
        # Use PrettyTables to write the tabular content
        pretty_table(
            io,
            summary_table;
            backend=Val(:latex)
        )
        
        # Write the LaTeX table environment closing
        write(io, """
        \\end{table}
        """)
    end
    println("LaTeX file successfully saved to: $latex_file_path")

    # Write the text table to the file with the title
    open(text_file_path, "w") do io
        # Write the title at the top of the file
        write(io, "$table_title\n\n")
        # Use PrettyTables to write the tabular content
        pretty_table(io, summary_table; backend=Val(:text))  # Save as plain text
    end
    println("Text file successfully saved to: $text_file_path")
end