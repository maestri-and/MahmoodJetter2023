###############################################################################
############################### RUNNINGFUNS.JL ################################

########### This script defines the running functions to replicate ############
############### all the main results in Mahmood & Jetter, 2023 ################
###############################################################################

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#----------------------# 1. Define basic run functions #-----------------------#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

module RunningFuns

"""
# RunningFuns Module

This module provides the primary functionality to clean raw data, replicate the main results from Mahmood & Jetter (2023), and define and execute unit tests for the replication package. It includes high-level functions that execute the core replication tasks and ensure that the replication pipeline performs as expected and produces consistent results.

## Exports
- `run`: Executes the main script to perform data cleaning and result replication.
- `run_tests`: Runs the complete suite of unit tests.

## Usage
```julia
using RunningFuns
run()
run_tests()
```
"""

export run, run_tests

    """
    run()

Executes the main replication script for Mahmood & Jetter (2023) by running the script main.jl.

This function performs the following tasks:
1. Cleans and processes raw data.
2. Replicates the main results from the paper, ensuring consistency with the original methodology.
3. Generates outputs in line with the findings of Mahmood & Jetter (2023).

# Usage
```julia
using RunningFuns
run()
```
"""

    function run()
        include("src/main.jl")
    end

end

export run_tests

"""
    run_tests()

Executes the unit tests for the replication package of Mahmood & Jetter (2023) by running the script tests.jl.

This function runs a comprehensive suite of tests to validate:
1. The correctness of the data cleaning and processing pipeline.
2. The accuracy of the replication results compared to the original paper.
3. The overall robustness of the implemented functions.

# Usage
```julia
using RunningFuns
run_tests()
```
"""

    function run_tests()
        include("test/tests.jl")
    end

end