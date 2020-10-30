#
# Build a model with 3 latent constructs built on all available predictors, grouped by type of measurement
#
library(lavaan);
library(semPlot);
modelData <- read_csv("~/Desktop/SleepyBrain-Analyses/Sleepmeasures_emotion/Data/SEM_Singer_standardized.csv") ;

# Use only full sleep data
modelData <- subset(modelData, DeprivationCondition == "NormalSleep")

model<-"
! regressions 
EMG_EC=~Zyg + Corr 
R_EC=~Anger + Happiness
B_EC=~FFA_angry + FFA_happy + Amy_angry + Amy_happy
B_Ep=~ AI + ACC
R_Ep =~ Unp
B_ER=~ Amy_down + lOFC + dlPFC
R_ER=~ Downr + Upreg
EC=~ R_EC + B_EC + EMG_EC 
Ep=~ R_Ep + B_Ep
ER=~ R_ER + B_ER 
";


result<-cfa(model, data=modelData, fixed.x=FALSE, missing="FIML");
summary(result, fit.measures=T);
sink("~/Desktop/SleepyBrain-Analyses/Sleepmeasures_emotion/Output/Singer_SEM_all_variables_results.txt")
summary(result, fit.measures=T);
sink()


# Plot path diagram:

semPaths(result, intercept = F, whatLabel = "est", 
         nDigits = 2,
         nCharNodes =0, 
         sizeMan = 4, sizeLat = 6, 
         nCharEdges = 2,
         exoVar = F,
         groups = list(c("Ep", "R_Ep", "B_Ep", "AI", "ACC", "Unp"), 
         c("EC", "Amy_happy", "Amy_angry", "Anger", "Happiness", "FFA_angry", "FFA_happy", "EMG_EC", "Corr", "Zyg"),
         c("ER", "B_ER", "lOFC", "Amy_down", "dlPFC", "R_ER", "Downr", "Upreg")),
         residuals = F, exoCov = T, layout = "tree", ask = F, 
         #as.expression = "edges", 
         fixedStyle = c("grey",5),
         pastel = T, rotation = 1)

