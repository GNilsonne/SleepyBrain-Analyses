modelData <- read.csv2("~/Desktop/SleepyBrain-Analyses/Sleepmeasures_emotion/Data/SEM_file_wide.csv")

library(lavaan);

model<-"
! regressions 
Vicarious_unpleasantness=~1.0*Unp.nsd
Vicarious_unpleasantness=~1.0*Unp.sd
Upregulation=~1.0*Upreg.nsd
Upregulation=~1.0*Upreg.sd
Downregulation=~1.0*Downr.nsd
Downregulation=~1.0*Downr.sd
Happiness=~1.0*C_hap.nsd
Happiness=~1.0*C_hap.sd
Anger=~1.0*C_ang.sd
Anger=~1.0*C_ang.nsd
Empathy=~1.0*Vicarious_unpleasantness
Emotional_regulation=~1.0*Upregulation
Emotional_regulation=~1.0*Downregulation
Emotional_Contagion=~1.0*Happiness
Emotional_Contagion=~1.0*Anger
! residuals, variances and covariances
Empathy ~~ VAR_Empathy*Empathy
Emotional_regulation ~~ VAR_Emotional_regulation*Emotional_regulation
Emotional_Contagion ~~ VAR_Emotional_Contagion*Emotional_Contagion
Emotional_Contagion ~~ 1.0*Emotional_regulation
Empathy ~~ 1.0*Emotional_regulation
Empathy ~~ 1.0*Emotional_Contagion
Unp.sd ~~ VAR_Unp_sd*Unp.sd
Unp.nsd ~~ VAR_Unp_nsd*Unp.nsd
Upreg.sd ~~ VAR_Upreg_sd*Upreg.sd
Downr.sd ~~ VAR_Downr_sd*Downr.sd
Upreg.nsd ~~ VAR_Upreg_nsd*Upreg.nsd
Downr.nsd ~~ VAR_Downr_nsd*Downr.nsd
C_ang.nsd ~~ VAR_C_ang_nsd*C_ang.nsd
C_hap.nsd ~~ VAR_C_hap_nsd*C_hap.nsd
C_ang.sd ~~ VAR_C_ang_sd*C_ang.sd
C_hap.sd ~~ VAR_C_hap_sd*C_hap.sd
Vicarious_unpleasantness ~~ VAR_Vicarious_unpleasantness*Vicarious_unpleasantness
Upregulation ~~ VAR_Upregulation*Upregulation
Downregulation ~~ VAR_Downregulation*Downregulation
Happiness ~~ VAR_Happiness*Happiness
Anger ~~ VAR_Anger*Anger
Empathy ~~ 0.0*Upregulation
Empathy ~~ 0.0*Downregulation
Empathy ~~ 0.0*Happiness
Empathy ~~ 0.0*Anger
Emotional_regulation ~~ 0.0*Vicarious_unpleasantness
Emotional_regulation ~~ 0.0*Happiness
Emotional_regulation ~~ 0.0*Anger
Emotional_Contagion ~~ 0.0*Vicarious_unpleasantness
Emotional_Contagion ~~ 0.0*Upregulation
Emotional_Contagion ~~ 0.0*Downregulation
Vicarious_unpleasantness ~~ 0.0*Upregulation
Vicarious_unpleasantness ~~ 0.0*Downregulation
Vicarious_unpleasantness ~~ 0.0*Happiness
Vicarious_unpleasantness ~~ 0.0*Anger
Upregulation ~~ 0.0*Downregulation
Upregulation ~~ 0.0*Happiness
Upregulation ~~ 0.0*Anger
Downregulation ~~ 0.0*Happiness
Downregulation ~~ 0.0*Anger
Happiness ~~ 0.0*Anger
! observed means
Unp.sd~1;
Unp.nsd~1;
Upreg.sd~1;
Downr.sd~1;
Upreg.nsd~1;
Downr.nsd~1;
C_ang.nsd~1;
C_hap.nsd~1;
C_ang.sd~1;
C_hap.sd~1;
";
result<-lavaan(model, data=modelData, fixed.x=FALSE, missing="FIML");
summary(result, fit.measures=TRUE);

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
