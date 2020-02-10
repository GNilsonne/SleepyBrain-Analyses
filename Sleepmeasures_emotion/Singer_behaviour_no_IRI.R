library("stringr")
library("lavaan")
library("DiagrammeR")
library("dplyr")
library("semPlot")
library("readr")

modelData <- read_csv("~/Desktop/SleepyBrain-Analyses/Sleepmeasures_emotion/SEM_Singer_standardized.csv") ;
model<-"
! regressions 
Emotional_regulation=~1.0*DownregulateNegative
Emotional_regulation=~1.0*UpregulateNegative
Emotional_contagion=~1.0*Happiness_happy
Emotional_contagion=~1.0*Angriness_angry
Empathy =~1.0*Mean_unpleasantness
! residuals, variances and covariances
Emotional_contagion ~~ VAR_Emotional_contagion*Emotional_contagion
Angriness_angry ~~ VAR_Rated_angriness*Angriness_angry
Happiness_happy ~~ VAR_Rated_happiness*Happiness_happy
Mean_unpleasantness ~~ 0*Mean_unpleasantness
Emotional_regulation ~~ VAR_Emotional_regulation*Emotional_regulation
Emotional_regulation ~~ COV_Emotional_regulation_Emotional_contagion*Emotional_contagion
DownregulateNegative ~~ VAR_DownregulateNegative*DownregulateNegative
UpregulateNegative ~~ VAR_UpregulateNegative*UpregulateNegative
Empathy ~~ VAR_Empathy*Empathy
Emotional_regulation ~~ COV_Emotional_regulation_Empathy*Empathy
Empathy ~~ COV_Empathy_Emotional_contagion*Emotional_contagion
! means
Emotional_contagion~0*1;
Angriness_angry~0*1;
Happiness_happy~0*1;
Mean_unpleasantness~0*1;
Emotional_regulation~0*1;
DownregulateNegative~0*1;
UpregulateNegative~0*1;
Empathy~0*1;
";
result<-lavaan(model, data=modelData, fixed.x=FALSE, missing="FIML");
summary(result, fit.measures=TRUE);

# Plot path diagram:
fit <- lavaan:::cfa(model, data = modelData)


semPaths(fit, intercept = F, what = "col", whatLabel = "omit",
         residuals = F, exoCov = T, layout = "tree2")


