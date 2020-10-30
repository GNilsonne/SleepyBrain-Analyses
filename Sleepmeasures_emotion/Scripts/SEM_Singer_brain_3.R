# Script to analyse brain data only
#
library(lavaan);
modelData <- read_csv("~/Desktop/SleepyBrain-Analyses/Sleepmeasures_emotion/Data/SEM_Singer_standardized.csv") ;
# Use only full sleep data
modelData <- subset(modelData, DeprivationCondition == "NormalSleep")


model<-"
! regressions 
Ep=~1.0*ACC
Ep=~1.0*AI
ER=~Amy_down
ER=~lOFC
ER=~dlPFC
EC=~FFA_angry
EC=~FFA_happy
EC=~Amy_angry
EC=~Amy_happy
! residuals, variances and covariances
EC ~~ VAR_EC*EC
Ep ~~ VAR_Ep*Ep
EC ~~ COV_EC_Ep*Ep
AI ~~ VAR_AI*AI
ACC ~~ VAR_ACC*ACC
Amy_happy ~~ VAR_Amy_happy*Amy_happy
Amy_angry ~~ VAR_Amy_angry*Amy_angry
ER ~~ VAR_ER*ER
Ep ~~ COV_Ep_ER*ER
ER ~~ COV_ER_EC*EC
FFA_happy ~~ VAR_FFA_happy*FFA_happy
FFA_angry ~~ VAR_FFA_angry*FFA_angry
Amy_down ~~ VAR_Amy_down*Amy_down
lOFC ~~ VAR_lOFC*lOFC
dlPFC ~~ VAR_dlPFC*dlPFC
! observed means
AI~1;
ACC~1;
Amy_happy~1;
Amy_angry~1;
FFA_happy~1;
FFA_angry~1;
Amy_down~1;
lOFC~1;
dlPFC~1;
";
result<-lavaan(model, data=modelData, fixed.x=FALSE, missing="FIML");

summary(result, fit.measures=T);
sink("~/Desktop/SleepyBrain-Analyses/Sleepmeasures_emotion/Output/Singer_SEM_brain.txt")
summary(result, fit.measures=T);
sink()


# Plot path diagram:

semPaths(result, intercept = F, whatLabel = "est", nCharNodes = 0, nCharEdges =0, sizeMan = 5,
         exoVar = F,
         groups = list(c("Ep", "AI", "ACC"), 
                       c("EC", "Amy_happy", "Amy_angry", "FFA_a", "FFA_happy"),
                       c("ER", "lOFC", "Amy_down", "dlPFC")),
         residuals = F, exoCov = T, layout = "spring", ask = F, as.expression = "edges", fixedStyle = c("black",3),
         pastel = T)

