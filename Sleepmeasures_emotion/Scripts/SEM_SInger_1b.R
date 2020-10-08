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
EMG_EC=~1.0*Zyg
EMG_EC=~1.0*Corr
R_EC=~1.0*Anger
R_EC=~1.0*Happiness
B_EC=~1.0*FFA_angry
B_EC=~1.0*FFA_happy
B_EC=~1.0*Amy_angry
B_EC=~1.0*Amy_happy
B_Ep=~1.0*AI
B_Ep=~1.0*ACC
R_Ep=~1.0*Unp
B_ER=~1.0*Amy_down
B_ER=~1.0*lOFC
B_ER=~1.0*dlPFC
R_ER=~1.0*Downr
R_ER=~1.0*Upreg
EC=~1.0*EMG_EC
EC=~1.0*R_EC
EC=~1.0*B_EC
Ep=~1.0*B_Ep
ER=~1.0*B_ER
ER=~1.0*R_ER
Ep=~1.0*R_Ep
! residuals, variances and covariances
EC ~~ VAR_EC*EC
Ep ~~ VAR_Ep*Ep
Anger ~~ VAR_Anger*Anger
EC ~~ COV_EC_Ep*Ep
Happiness ~~ VAR_Happiness*Happiness
Corr ~~ VAR_Corr*Corr
Zyg ~~ VAR_Zyg*Zyg
Unp ~~ 0*Unp
AI ~~ VAR_AI*AI
ACC ~~ VAR_ACC*ACC
Amy_happy ~~ VAR_Amy_happy*Amy_happy
Amy_angry ~~ VAR_Amy_angry*Amy_angry
ER ~~ VAR_ER*ER
Ep ~~ COV_Ep_ER*ER
ER ~~ COV_ER_EC*EC
FFA_happy ~~ VAR_FFA_happy*FFA_happy
FFA_angry ~~ VAR_FFA_a*FFA_angry
EMG_EC ~~ VAR_EMG_EC*EMG_EC
R_EC ~~ VAR_R_EC*R_EC
B_EC ~~ VAR_B_EC*B_EC
B_Ep ~~ VAR_B_Ep*B_Ep
B_ER ~~ VAR_B_Ep*B_ER
Amy_down ~~ VAR_Amy_down*Amy_down
lOFC ~~ VAR_lOFC*lOFC
dlPFC ~~ VAR_dlPFC*dlPFC
R_ER ~~ VAR_R_ER*R_ER
Downr ~~ VAR_Downr*Downr
Upreg ~~ VAR_Upreg*Upreg
R_Ep ~~ VAR_R_Ep*R_Ep

! observed means
Anger~1;
Happiness~1;
Corr~1;
Zyg~1;
Unp~1;
AI~1;
ACC~1;
Amy_happy~1;
Amy_angry~1;
FFA_happy~1;
FFA_angry~1;
Amy_down~1;
lOFC~1;
dlPFC~1;
Downr~1;
Upreg~1;
";


result<-lavaan(model, data=modelData, fixed.x=FALSE, missing="FIML");
summary(result, fit.measures=T);
sink("Output/Singer_SEM_all_variables.txt")
summary(result, fit.measures=T);
sink()


fit <- lavaan:::cfa(model, data = modelData, std.lv = TRUE)

# Plot path diagram:

semPaths(fit, intercept = F, whatLabel = "omit", nCharNodes = 0, nCharEdges =0, sizeMan = 8, sizeLat = 6,
         exoVar = F,
         groups = list(c("Ep", "R_Ep", "B_Ep", "AI", "ACC", "Unp"), 
         c("EC", "Amy_happy", "Amy_angry", "Anger", "Happiness", "FFA_angry", "FFA_happy", "EMG_EC", "Corr", "Zyg"),
         c("ER", "B_ER", "lOFC", "Amy_down", "dlPFC", "R_ER", "Downr", "Upreg")),
         residuals = F, exoCov = T, layout = "circle", ask = F, as.expression = "edges", fixedStyle = c("grey",5),
         pastel = T, rotation = 3)

