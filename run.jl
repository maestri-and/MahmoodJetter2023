###############################################################################
#################################### RUN.JL ###################################

########## This script runs unit tests and replicate the results in ###########
########## Mahmood & Jetter (2023) and stores the results in output ###########
###############################################################################

include("src/RunningFuns.jl")
using .RunningFuns
using .TestingFuns

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#-------------# 1. Run tests to check integrity of the package #--------------#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

@elapsed MahmoodJetter2023.TestingFuns.run_tests()

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#-----------# 2. Reproduce all results in Mahmood & Jetter (2023) #-----------#
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

# Run all and store output files in output/
@elapsed MahmoodJetter2023.RunningFuns.run()


