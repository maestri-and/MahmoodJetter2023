include("replicate_sutex_function.jl")

#################################################################################################################################################################################################################################
#   Table 1. Summary Statistics of Main Variables for all 4,018 Days from January 1, 2006 until December 31, 2016. All Variables are Measured at the Daily Level.
#################################################################################################################################################################################################################################

function generate_table1(df)
    # Specify the variables to summarize
    vars = [:drones, :attacks, :gusts, :wind, :mil_act, :ramadan, :tmean2_mir, :prec_mir]

    # Using the replicate_sutex function
    summary_table = replicate_sutex(df, vars, digits=2)

    # SHowing it as a DataFrame:
    display(summary_table)

    # Save the LaTeX table to the same directory as this script
    file_path = joinpath(@__DIR__, "summary_table.tex")

    # Define the table title
    table_title = "Table 1. Summary Statistics of Main Variables for all 4,018 Days from January 1, 2006 until December 31, 2016. All Variables are Measured at the Daily Level."

    # Write the LaTeX table to the file with a caption
    open(file_path, "w") do io
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
    println("LaTeX file successfully saved to: $file_path")
end