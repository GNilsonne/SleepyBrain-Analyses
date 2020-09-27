# Script to analyse brain data only
#
library(lavaan);
modelData <- read_csv("~/Desktop/SleepyBrain-Analyses/Sleepmeasures_emotion/SEM_Singer_standardized.csv") ;
model<-"
! regressions 
Ep=~1.0*ACC
Ep=~1.0*AI
ER=~1.0*Amy_do
ER=~1.0*lOFC
ER=~1.0*dlPFC
EC=~1.0*FFA_an
EC=~1.0*FFA_ha
EC=~1.0*Amy_an
EC=~1.0*Amy_ha
! residuals, variances and covariances
EC ~~ VAR_EC*EC
Ep ~~ VAR_Ep*Ep
EC ~~ COV_EC_Ep*Ep
AI ~~ VAR_AI*AI
ACC ~~ VAR_ACC*ACC
Amy_ha ~~ VAR_Amy_ha*Amy_ha
Amy_an ~~ VAR_Amy_an*Amy_an
ER ~~ VAR_ER*ER
Ep ~~ COV_Ep_ER*ER
ER ~~ COV_ER_EC*EC
FFA_ha ~~ VAR_FFA_ha*FFA_ha
FFA_an ~~ VAR_FFA_an*FFA_an
Amy_do ~~ VAR_Amy_do*Amy_do
lOFC ~~ VAR_lOFC*lOFC
dlPFC ~~ VAR_dlPFC*dlPFC
! observed means
AI~1;
ACC~1;
Amy_ha~1;
Amy_an~1;
FFA_ha~1;
FFA_an~1;
Amy_do~1;
lOFC~1;
dlPFC~1;
";
result<-lavaan(model, data=modelData, fixed.x=FALSE, missing="FIML");

result<-lavaan(model, data=modelData, fixed.x=FALSE, missing="FIML");
summary(result, fit.measures=T);
sink("Singer_SEM_brain.txt")
summary(result, fit.measures=T);
sink()


fit <- lavaan:::cfa(model, data = modelData, std.lv = TRUE)

# Plot path diagram:

semPaths(fit, intercept = F, whatLabel = "omit", nCharNodes = 0, nCharEdges =0, sizeMan = 5,
         exoVar = F,
         groups = list(c("Ep", "AI", "ACC"), 
                       c("EC", "Amy_ha", "Amy_an", "FFA_a", "FFA_ha"),
                       c("ER", "lOFC", "Amy_do", "dlPFC")),
         residuals = F, exoCov = T, layout = "spring", ask = F, as.expression = "edges", fixedStyle = c("black",3),
         pastel = T)


# Parameter estimates
parameterEstimates(result)
# Standardized estimates
standardizedSolution(result)