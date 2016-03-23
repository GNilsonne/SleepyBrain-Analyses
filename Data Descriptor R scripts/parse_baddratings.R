# Code used to parse BADD ratings and generate subscale results
# The code ought to work with published file ("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/badddata_160323_pseudonymized.csv")

BADDData$BADD_Total <- rowSums(BADDData[, 2:41])
BADDData$BADD_Activation <- with(BADDData, X2 + X3 + X10 + X11 + X13 + X19 + X21 + X27 + X39)
BADDData$BADD_Attention <- with(BADDData, X1 + X4 + X5 + X6 + X8 + X23 + X26 + X32 + X36)
BADDData$BADD_Effort <- with(BADDData, X12 + X14 + X16 + X17 + X22 + X25 + X34 + X37 + X40)
BADDData$BADD_Affect <- with(BADDData, X9 + X18 + X20 + X24 + X29 + X30 + X31)
BADDData$BADD_Memory <- with(BADDData, X7 + X15 + X28 + X33 + X35 + X38)
BADDData$BADD_Total_check <- with(BADDData, BADD_Activation + BADD_Attention + BADD_Effort + BADD_Affect + BADD_Memory)