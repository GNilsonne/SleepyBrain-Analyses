#
# Buil model 1a for the paper
#
library(lavaan);
library(semPlot);
library(readr)
modelData <- read_csv("~/Desktop/SleepyBrain-Analyses/Sleepmeasures_emotion/Data/SEM_Singer_standardized.csv") ;

# Use only full sleep data
modelData <- subset(modelData, DeprivationCondition == "NormalSleep")

# Build a model. Measures of same type are constrained to have the same factor loading and variance, since model does not converge otherwise

model<-"
#! regressions 
Emotional Contagion=~A*Anger + A*Happiness + B*FFA_angry + B*FFA_happy + B*Amy_angry + B*Amy_happy + C*Zyg + C*Corr
Empathy=~D*Unp + E*AI + E*ACC
Emotional Regulation=~F*Downr + F*Upreg + G*Amy_down + G*lOFC + G*dlPFC
";


result<-cfa(model, data=modelData, fixed.x=FALSE, missing="FIML");
summary(result, fit.measures=T);
sink("~/Desktop/SleepyBrain-Analyses/Sleepmeasures_emotion/Output/Singer_SEM_all_variables_together_results.txt")
summary(result, fit.measures=T);
sink()


# Plot path diagram:

semPaths(result, nDigits = 2, intercept = F, whatLabel = "est", nCharNodes = 0, nCharEdges =0, sizeMan = 8, sizeLat = 10, label.prop = 1, 
         exoVar = F,
         groups = list(c("Empathy", "R_Empathy", "B_Empathy", "AI", "ACC", "Unp"), 
                       c("EmotionalContagion", "Amy_happy", "Amy_angry", "Anger", "Happiness", "FFA_angry", "FFA_happy", "EMG_Emotional Contagion", "Corr", "Zyg"),
                       c("EmotionalRegulation", "B_Emotional Regulation", "lOFC", "Amy_down", "dlPFC", "R_Emotional Regulation", "Downr", "Upreg")),
         residuals = T, exoCov = T, layout = "circle", ask = F, fixedStyle = c("black",3),
         pastel = T, rotation = 1)

sink("~/Desktop/SleepyBrain-Analyses/Sleepmeasures_emotion/Output/Singer_SEM_all_variables_together_parameter_estimates_std.txt")
parameterEstimates(result, standardized = TRUE)
sink()
