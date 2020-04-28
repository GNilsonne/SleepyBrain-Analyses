# Script to only analyse sleep restriction condition

library("stringr")
library("lavaan")
library("DiagrammeR")
library("dplyr")
library("semPlot")
library("readr")

modelData <- read_csv("~/Desktop/SleepyBrain-Analyses/Sleepmeasures_emotion/SEM_file_sd.csv") ;
colnames(modelData) <- c("X1", "Subject", "DeprivationCondition", "Sex", "AgeGroup",
                         "Unp", "C_ang", "C_hap", "Upreg", "Downr", "TST_fullsleep",
                         "SWS_fullsleep", "REM_fullsleep", "Sleepiness_KSS")


model<-"
! regressions 
ER=~1.0*Downr
ER=~1.0*Upreg
EC=~1.0*C_hap
EC=~1.0*C_ang
Ep =~1.0*Unp
! residuals, variances and covariances
EC ~~ VAR_EC*EC
C_ang ~~ VAR_C_ang*C_ang
C_hap ~~ VAR_C_hap*C_hap
Unp ~~ 0*Unp
ER ~~ VAR_ER*ER
ER ~~ COV_ER_EC*EC
Downr ~~ VAR_Downr*Downr
Upreg ~~ VAR_Upreg*Upreg
Ep ~~ VAR_Ep*Ep
ER ~~ COV_ER_Ep*Ep
Ep ~~ COV_Ep_EC*EC
! means
EC~0*1;
C_ang~0*1;
C_hap~0*1;
Unp~0*1;
ER~0*1;
Downr~0*1;
Upreg~0*1;
Ep~0*1;
";
result<-lavaan(model, data=modelData, missing="FIML");

summary(result, fit.measures=TRUE);
sink("Singer_SEM_sd_ratings.txt")
summary(result, fit.measures=T);
sink()

# Plot path diagram:
fit <- lavaan:::cfa(model, data = modelData, missing="FIML")

semPaths(fit, intercept = F, whatLabel = "est", nCharNodes = 0, nCharEdges =0, sizeMan = 5,
         exoVar = F,
         #groups = list(c("Ep", "Unp"), 
         #               c("EC", "C_Ang", "C_hap"),
         #              c("ER", "Downr", "Upreg")),
         residuals = T, exoCov = T, layout = "tree", ask = F, as.expression = "edges", fixedStyle = c("black",3),
         pastel = T)

# Parameter estimates
parameterEstimates(result)
# Standardized estimates
standardizedSolution(result)
