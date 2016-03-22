# Code used to parse ratings made before MRI scanning and generate summary measures for rating scales
# The code is taken out of context and is not functional with the pseudonymized data that have been published
# Nonetheless it shows transparently how the summary measures have been generated
# If three dummy columns are added at beginning of data frame ("RatingsAtScanner_160322_pseudonymized.csv"), the code ought in principle to work again

for (i in 4:15){
  levels(DataOut[, i]) <- 1:4
}
DataOut[, 16:35] <- apply(DataOut[, 16:35], 2, function(x) substring(as.character(x), 1, 1))

DataOut[, 16:35] <- lapply(DataOut[, 16:35], function(x){replace(x, x == 0, NA)})

DataOut$PANAS_Positive_byScanner <- as.integer(DataOut$PANAS1) + 
  as.integer(DataOut$PANAS7) + 
  as.integer(DataOut$PANAS8) + 
  as.integer(DataOut$PANAS10) + 
  as.integer(DataOut$PANAS12) + 
  as.integer(DataOut$PANAS14) + 
  as.integer(DataOut$PANAS15) + 
  as.integer(DataOut$PANAS17) + 
  as.integer(DataOut$PANAS19) + 
  as.integer(DataOut$PANAS20)

DataOut$PANAS_Negative_byScanner <- as.integer(DataOut$PANAS2) + 
  as.integer(DataOut$PANAS3) + 
  as.integer(DataOut$PANAS4) + 
  as.integer(DataOut$PANAS5) + 
  as.integer(DataOut$PANAS6) + 
  as.integer(DataOut$PANAS9) + 
  as.integer(DataOut$PANAS11) + 
  as.integer(DataOut$PANAS13) + 
  as.integer(DataOut$PANAS16) + 
  as.integer(DataOut$PANAS18)

DataOut$SicknessQ_Emotion_byScanner <- (as.integer(DataOut$SicknessQ4) + 
                                          as.integer(DataOut$SicknessQ6) + 
                                          as.integer(DataOut$SicknessQ7))
DataOut$SicknessQ_Emotion_byScanner_reduced <- (as.integer(DataOut$SicknessQ4) + 
                                                  as.integer(DataOut$SicknessQ7))
DataOut$SicknessQ_Fatigue_byScanner <- (5 - as.integer(DataOut$SicknessQ1) + 
                                          as.integer(DataOut$SicknessQ3) +
                                          5 - as.integer(DataOut$SicknessQ8) + 
                                          5 - as.integer(DataOut$SicknessQ9) +
                                          5 - as.integer(DataOut$SicknessQ12))
DataOut$SicknessQ_Pain_byScanner <- (as.integer(DataOut$SicknessQ2) + 
                                       as.integer(DataOut$SicknessQ5) + 
                                       as.integer(DataOut$SicknessQ10) + 
                                       as.integer(DataOut$SicknessQ11))
DataOut$SicknessQ_Total_byScanner <- DataOut$SicknessQ_Emotion_byScanner + 
  DataOut$SicknessQ_Fatigue_byScanner + 
  DataOut$SicknessQ_Pain_byScanner
DataOut$SicknessQ_Total_byScanner_reduced <- DataOut$SicknessQ_Emotion_byScanner_reduced + 
  DataOut$SicknessQ_Fatigue_byScanner + 
  DataOut$SicknessQ_Pain_byScanner