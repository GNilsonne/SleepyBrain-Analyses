library(lavaan)
Data <- read.csv("~/Desktop/SleepyBrain-Analyses/Sleepmeasures_emotion/Data/SEM_Singer_standardized.csv")
Data$AgeGroup <- as.numeric(Data$AgeGroup)  
Data$DeprivationCondition <- as.numeric(Data$DeprivationCondition)

model <- "
  level: 1
    Sleep =~ DeprivationCondition
    Empathy =~ Unp
    Emotional_Contagion =~ Happiness + Anger
    Emotional_regulation =~ Upreg + Downr
  level: 2
    Age =~ AgeGroup
"
# Missing values!
fit <- sem(model, Data, cluster = "Subject")
summary(fit, fit.measures=TRUE)
parameterEstimates(fit, standardized = TRUE)


setwd("/Users/santam/Desktop/SleepyBrain-Analyses/Sleepmeasures_emotion/Output")
sink("Multilevel_SEM.txt")
summary(fit, fit.measures=TRUE)
sink()

sink("parameterEstimates_SEM_uns.txt")
parameterEstimates(fit, standardized = FALSE)
sink()

sink("parameterEstimates_SEM_std.txt")
parameterEstimates(fit, standardized = TRUE)
sink()