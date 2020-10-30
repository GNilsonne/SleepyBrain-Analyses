library("stringr")
library("lavaan")
library("DiagrammeR")
library("dplyr")
library("semPlot")
library("readr")

modelData <- read_csv("~/Desktop/SleepyBrain-Analyses/Sleepmeasures_emotion/Data/SEM_Singer_standardized.csv") ;
# Use only full sleep data
modelData <- subset(modelData, DeprivationCondition == "NormalSleep")

# Build model with following constraints: Where only 2 indicator variables, these are set to factor loading 1
model<-"
! regressions 
Emotional Regulation=~1.0*Downr
Emotional Regulation=~1.0*Upreg
Emotional Contagion=~1.0*Happiness
Emotional Contagion=~1.0*Anger
Empathy =~1.0*Unp
! residuals, variances and covariances
Emotional Contagion ~~ VAR_Emotional Contagion*Emotional Contagion
Anger ~~ VAR_Anger*Anger
Happiness ~~ VAR_Happiness*Happiness
Unp ~~ 0*Unp
Emotional Regulation ~~ VAR_Emotional Regulation*Emotional Regulation
Emotional Regulation ~~ COV_Emotional Regulation_Emotional Contagion*Emotional Contagion
Downr ~~ VAR_Downr*Downr
Upreg ~~ VAR_Upreg*Upreg
Empathy ~~ VAR_Empathy*Empathy
Emotional Regulation ~~ COV_Emotional Regulation_Empathy*Empathy
Empathy ~~ COV_Empathy_Emotional Contagion*Emotional Contagion
! means
Emotional Contagion~0*1;
Anger~0*1;
Happiness~0*1;
Unp~0*1;
Emotional Regulation~0*1;
Downr~0*1;
Upreg~0*1;
Empathy~0*1;
";
result<-lavaan(model, data=modelData, missing="FIML");

summary(result, fit.measures=TRUE);
sink("~/Desktop/SleepyBrain-Analyses/Sleepmeasures_emotion/Output/Singer_SEM_ratings.txt")
summary(result, fit.measures=T);
sink()

# Plot path diagram:

semPaths(result, intercept = F, whatLabel = "est", nCharNodes = 0, nCharEdges =0, sizeMan = 10, sizeLat = 14,
         exoVar = F,
         groups = list(c("Empathy", "Unp"), 
                      c("EmotionalContagion", "Anger", "Happiness"),
                      c("EmotionalRegulation", "Downr", "Upreg")),
         residuals = T, exoCov = T, layout = "circle", ask = F, fixedStyle = c("black",3),
         edge.label.cex = 1,
         pastel = T)






