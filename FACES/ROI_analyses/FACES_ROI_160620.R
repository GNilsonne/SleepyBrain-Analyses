# Script to analyse ROI activation from FACES experiment
# Gustav Nilsonne 2017-05-28

# ROI estimates have been generated using SPM for different contrasts
# This script aims to investigate effects of sleep deprivation, age group, and other covariates

# Require packages
require(chron)
require(nlme)
require(effects)
require(RColorBrewer)
cols <- brewer.pal(3, "Dark2")

# Read data
# Read demographic data 
demdata <- read.csv2("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/demdata_160225_pseudonymized.csv")

# Amygdala and FFA data
setwd("~/Git Sleepy Brain/SleepyBrain-Analyses/FACES/ROI_analyses")

amyg_L_fullsleep <- read.csv("amygdala_ROI_betas_L_fullsleep.csv", sep=";", dec=",")
amyg_R_fullsleep <- read.csv("amygdala_ROI_betas_R_fullsleep.csv", sep=";", dec=",")
amyg_L_sleepdeprived <- read.csv("amygdala_ROI_betas_L_sleepdeprived.csv", sep=";", dec=",")
amyg_R_sleepdeprived <- read.csv("amygdala_ROI_betas_R_sleepdeprived.csv", sep=";", dec=",")

FFA_L_fullsleep <- read.csv("FFA_ROI_betas_L_fullsleep.csv", sep=";", dec=",")
FFA_R_fullsleep <- read.csv("FFA_ROI_betas_R_fullsleep.csv", sep=";", dec=",")
FFA_L_sleepdeprived <- read.csv("FFA_ROI_betas_L_sleepdeprived.csv", sep=";", dec=",")
FFA_R_sleepdeprived <- read.csv("FFA_ROI_betas_R_sleepdeprived.csv", sep=";", dec=",")

# KSS data
setwd("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/Presentation_logfiles")
KSSFiles <- list.files(pattern = "^KSS", recursive = TRUE)
KSSFiles <- KSSFiles[-grep(".log", KSSFiles, fixed=T)]
KSSFiles <- KSSFiles[grep("brief3", KSSFiles, fixed=T)]
KSSData <- data.frame()
for (i in 1:length(KSSFiles)){
  temp <- read.table(KSSFiles[i], header = FALSE, skip = 1)
  names(temp) <- "KSS_Rating"
  temp$File <- KSSFiles[i]
  temp$Logtime <- file.info(KSSFiles[i])$mtime
  KSSData <- rbind(KSSData, temp)
}
KSSData$Subject <- as.integer(substr(KSSData$File, 1, 3))

Subjects <- read.table("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/Subjects_151215.csv", sep=";", header=T)

KSSData <- merge(KSSData, Subjects[, c("Subject", "newid")])

RandomisationList <- read.csv2("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/RandomisationList_140804.csv")

KSSData$Date <- paste(paste(20, substr(KSSData$File, 5, 6), sep = ""), substr(KSSData$File, 7, 8), substr(KSSData$File, 9, 10), sep = "-")
KSSData$Date <- as.Date(as.character(KSSData$Date, "%Y%m%d"))
KSSData$Session <- NA

# Correct logtimes for 3 files which were changed after scanning (see ScanData file for log of changes) and 1 which was mysteriously incorrect
KSSData$Logtime[KSSData$Logtime == "2014-06-26 14:03:05"] <- "2013-11-18 22:48:00"
KSSData$Logtime[KSSData$Logtime == "2014-06-26 14:10:46"] <- "2013-12-04 20:55:00"
KSSData$Logtime[KSSData$Logtime == "2014-03-06 11:23:24"] <- "2013-11-18 20:18:00"
KSSData$Logtime[KSSData$Logtime == "2014-01-21 21:30:14"] <- "2014-01-21 20:06:00" # This is the mysterious one

# Addition 150715: Correct logtimes for 4 files which were incorrect for unknown reasons too, all from subject 173, session 1
KSSData$Logtime[KSSData$Logtime == "2014-06-26 13:59:20"] <- "2013-10-24 20:59:20"
KSSData$Logtime[KSSData$Logtime == "2014-06-26 14:01:20"] <- "2013-10-24 21:01:20"
KSSData$Logtime[KSSData$Logtime == "2014-06-26 14:03:20"] <- "2013-10-24 21:03:20"
KSSData$Logtime[KSSData$Logtime == "2014-06-26 14:05:20"] <- "2013-10-24 21:05:20"

# Convert logtimes to date format
KSSData$Logtime2 <- times(format(KSSData$Logtime, "%H:%M:%S"))

# Add columns for deprivation condition and early/late scan session
VecSession <- vector()
VecDeprived <- vector()
VecTestTimeType <- vector()
for (i in unique(KSSData$Subject)){
  temp <- subset(KSSData, KSSData$Subject == i)
  temp$Session[temp$Date <= mean(temp$Date)] <- 1
  temp$Session[temp$Date > mean(temp$Date)] <- 2
  VecSession <- c(VecSession, temp$Session)
  
  temp$RandomisationCondition <- RandomisationList$Sl_cond[RandomisationList$Subject == i]
  for (j in 1:length(temp$KSS_Rating)){
    if (temp$Session[j] == 1 && temp$RandomisationCondition[j] == 1) {temp$DeprivationCondition[j] <- "Sleep Deprived"} else
      if (temp$Session[j] == 2 && temp$RandomisationCondition[j] == 2) {temp$DeprivationCondition[j] <- "Sleep Deprived"} else
        if (temp$Session[j] == 1 && temp$RandomisationCondition[j] == 2) {temp$DeprivationCondition[j] <- "Not Sleep Deprived"} else
          if (temp$Session[j] == 2 && temp$RandomisationCondition[j] == 1) {temp$DeprivationCondition[j] <- "Not Sleep Deprived"}
  }
  VecDeprived <- c(VecDeprived, temp$DeprivationCondition)
}
KSSData$Session <- VecSession
KSSData$DeprivationCondition <- VecDeprived


# Analyse amygdala correlations between right and left side, see if average is justified (it was)
corr_amyg_fullsleep <- data.frame(condition = character(), variable = character(), estimate = double(), confint_lower = double(), confint_upper = double(), stringsAsFactors=FALSE)
corr_amyg_sleepdeprived <- data.frame(condition = character(), variable = character(), estimate = double(), confint_lower = double(), confint_upper = double(), stringsAsFactors=FALSE)
for(i in 2:length(amyg_L_fullsleep)){
  plot(amyg_L_fullsleep[, i] ~ amyg_R_fullsleep[, i])
  test1 <- cor.test(amyg_L_fullsleep[, i], amyg_R_fullsleep[, i])
  corr_amyg_fullsleep[i-1, ] <- c("fullsleep", names(amyg_L_fullsleep)[i], round(test1$estimate, 2), round(test1$conf.int[1], 2), round(test1$conf.int[2], 2))
  
  plot(amyg_L_sleepdeprived[, i] ~ amyg_R_sleepdeprived[, i])
  test2 <- cor.test(amyg_L_sleepdeprived[, i], amyg_R_sleepdeprived[, i])
  corr_amyg_sleepdeprived[i-1, ] <- c("fullsleep", names(amyg_L_fullsleep)[i], round(test2$estimate, 2), round(test2$conf.int[1], 2), round(test2$conf.int[2], 2))
}

# Merge data between conditions and average over right and left
amyg_joint_fullsleep <- amyg_L_fullsleep
for(i in 2:length(amyg_joint_fullsleep)){
  amyg_joint_fullsleep[, i] <- (amyg_L_fullsleep[, i] + amyg_R_fullsleep[, i])
}
amyg_joint_fullsleep$condition <- "fullsleep"

amyg_joint_sleepdeprived <- amyg_L_sleepdeprived
for(i in 2:length(amyg_joint_sleepdeprived)){
  amyg_joint_sleepdeprived[, i] <- (amyg_L_sleepdeprived[, i] + amyg_R_sleepdeprived[, i])
}
amyg_joint_sleepdeprived$condition <- "sleepdeprived"
  
amyg_joint <- rbind(amyg_joint_fullsleep, amyg_joint_sleepdeprived)  
amyg_joint <- merge(amyg_joint, demdata, by.x = "ID", by.y = "id")

# Set reference levels and contrast coding
amyg_joint$condition <- as.factor(amyg_joint$condition)
amyg_joint$AgeGroup <- relevel(amyg_joint$AgeGroup, ref = "Young")
contrasts(amyg_joint$condition) <- rbind(-.5, .5)
colnames(contrasts(amyg_joint$condition)) <- levels(amyg_joint$condition)[2]
contrasts(amyg_joint$AgeGroup) <- rbind(-.5, .5)
colnames(contrasts(amyg_joint$AgeGroup)) <- levels(amyg_joint$AgeGroup)[2]

# Analyse effects of sleep deprivation, age group, and covariates
dependent_vars <- names(amyg_joint)[2:9]
covariates <- c("IRI_EC", "PSS14", "PPIR_C" )
# Hypothesis list includes also "SES ratings", but I cannot now match this to an existing variable

# Add also the following, one way or another:
#total sleep time (TST), slow wave sleep (SWS), REM sleep time, and linearly predicted by prefrontal (Fp1 + Fp2) gamma (30-40 Hz) in REM sleep.
#rated happiness/angriness, EMG responses, heart rate responses, pupil responses, and KSS ratings.

lme_nocovariates_list <- list()
lme_covariates_list <- list()
for(i in 1:length(dependent_vars)){
  # Main analyses without covariates
  fml <- as.formula(paste(dependent_vars[i], "~ condition * AgeGroup"))
  this_lm_nocovariate <- lme(fml, data = amyg_joint, random = ~ 1|ID, na.action = na.omit)
  lme_nocovariates_list[[i]] <- this_lm_nocovariate
  
  # Additional analyses with covariates (prespecified)
  for(j in 1:length(covariates)){
    thisindex <- (i-1)*length(covariates) + j
    fml <- as.formula(paste(dependent_vars[i], "~ condition * AgeGroup +", paste(covariates[j])))
    this_lm_covariate <- lme(fml, data = amyg_joint, random = ~ 1|ID, na.action = na.omit)
    lme_covariates_list[[thisindex]] <- this_lm_covariate
  }
}

# Write results to a table
# Define function that extracts the estimates in question
fun_extractvalues1 <- function(x){ # For main models
  interv <- matrix(unlist(intervals(x, which = "fixed")), ncol = 3)
  tTable <- summary(x)$tTable
  results <- data.frame(intercept_estimate_CI = paste(round(tTable[1, 1], 3), "[", round(interv[1, 1], 3), ", ", round(interv[1, 3], 3), "]", sep = ""), intercept_p = round(tTable[1, 5], 3),
                        intercept_deprivation_CI = paste(round(tTable[2, 1], 3), "[", round(interv[2, 1], 3), ", ", round(interv[2, 3], 3), "]", sep = ""), deprivation_p = round(tTable[2, 5], 3),
                        intercept_older_CI = paste(round(tTable[3, 1], 3), "[", round(interv[3, 1], 3), ", ", round(interv[3, 3], 3), "]", sep = ""), older_p = round(tTable[3, 5], 3),
                        intercept_interaction_CI = paste(round(tTable[4, 1], 3), "[", round(interv[4, 1], 3), ", ", round(interv[4, 3], 3), "]", sep = ""), interaction_p = round(tTable[4, 5], 3))
  return(results)
}

for(i in 1:length(dependent_vars)){
  if (i == 1){
    lme_results_amyg_nocovariates <- fun_extractvalues1(lme_nocovariates_list[[i]])
  } else {
    lme_results_amyg_nocovariates <- rbind(lme_results_amyg_nocovariates, fun_extractvalues1(lme_nocovariates_list[[i]]))
  }
}

rownames(lme_results_amyg_nocovariates) <- c("Happy_vs_Angry", "Happy_vs_Neutral", "Angry_vs_Neutral", "Happy_vs_Baseline", "Angry_vs_Baseline", "Neutral_vs_Baseline", "Happy_and_Angry_vs_Baseline", "All_vs_Baseline")
# Note: Effects of sleep deprivation on Angry vs neutral should be one-sided p on account of directional hypothesis
write.csv(lme_results_amyg_nocovariates, "~/Git Sleepy Brain/SleepyBrain-Analyses/FACES/ROI_analyses/results_amyg_nocovariates.csv")

fun_extractvalues2 <- function(x){ # For models with covariates
  interv <- matrix(unlist(intervals(x, which = "fixed")), ncol = 3)
  tTable <- summary(x)$tTable
  results <- data.frame(estimate_CI = paste(round(tTable[1, 1], 3), " [", round(interv[1, 1], 3), ", ", round(interv[1, 3], 3), "]", sep = ""), p = round(tTable[1, 5], 3))
  return(results)
}

for(i in 1:length(lme_covariates_list)){
  if (i == 1){
    lme_results_amyg_covariates <- fun_extractvalues2(lme_covariates_list[[i]])
  } else {
    lme_results_amyg_covariates <- rbind(lme_results_amyg_covariates, fun_extractvalues2(lme_covariates_list[[i]]))
  }
}

lme_results_amyg_covariates$dependent_var <- rep(c("Happy_vs_Angry", "Happy_vs_Neutral", "Angry_vs_Neutral", "Happy_vs_Baseline", "Angry_vs_Baseline", "Neutral_vs_Baseline", "Happy_and_Angry_vs_Baseline", "All_vs_Baseline"), each = length(lme_results_amyg_covariates$estimate_CI)/8)
lme_results_amyg_covariates$covariate <- covariates
lme_results_amyg_covariates <- reshape(lme_results_amyg_covariates, direction = "wide", v.names = c("estimate_CI", "p"), timevar = "covariate", idvar = "dependent_var")
write.csv(lme_results_amyg_covariates, "~/Git Sleepy Brain/SleepyBrain-Analyses/FACES/ROI_analyses/results_amyg_covariates.csv", row.names = F)

# TODO: Plot results
# This snippet is pasted from elsewhere and requires considerable adaptation
pdf("ROI1.pdf", height = 5, width = 5) 
par(mar = c(4, 5, 1, 2))
plot(1, frame.plot = F, xlim = c(0, 1), ylim = c(-0.4, 0.2), xlab = "", ylab = "microV, mean residual difference", xaxt = "n", type = "n", main = "Corrugator mimicry")
axis(1, at = c(0.05, 0.95), labels = c("Full sleep", "Sleep deprived"))
lines(x = c(0, 0.9), y = effect("condition*AgeGroup", lme2d)$fit[1:2]*1000, pch = 16, col = cols[3], type = "b", lwd = 1.5)
lines(x = c(0.1, 1), y = effect("condition*AgeGroup", lme2d)$fit[3:4]*1000, pch = 16, col = cols[2], type = "b", lwd = 1.5)
lines(x = c(0, 0), y = c(effect("condition*AgeGroup", lme2d)$lower[1]*1000, effect("condition*AgeGroup", lme2d)$upper[1]*1000), col = cols[3], lwd = 1.5)
lines(x = c(0.9, 0.9), y = c(effect("condition*AgeGroup", lme2d)$lower[2]*1000, effect("condition*AgeGroup", lme2d)$upper[2]*1000), col = cols[3], lwd = 1.5)
lines(x = c(0.1, 0.1), y = c(effect("condition*AgeGroup", lme2d)$lower[3]*1000, effect("condition*AgeGroup", lme2d)$upper[3]*1000), col = cols[2], lwd = 1.5)
lines(x = c(1, 1), y = c(effect("condition*AgeGroup", lme2d)$lower[4]*1000, effect("condition*AgeGroup", lme2d)$upper[4]*1000), col = cols[2], lwd = 1.5)
#legend("top", lty = 1, lwd = 1.5, pch = 16, col = cols[3:2], legend = c("Younger", "Older"), bty = "n")
dev.off()

# This bit works if models with the these names are created again or accessed from list objects
with(amyg_joint, {
interaction.plot(condition, ID, X.HA.AN.NE., legend = F, frame.plot = F, lty = 1, col = "gray", ylab = "Beta estimate", main = "All faces vs baseline")
})
segments(x0 = 1, x1 = 1, y0 = intervals(lm1)$fixed[1, 1], y1 = intervals(lm1)$fixed[1, 3], lwd = 2)
segments(x0 = 2, x1 = 2, y0 = intervals(lm1)$fixed[1, 2] + intervals(lm1)$fixed[2, 1], y1 = intervals(lm1)$fixed[1, 2] + intervals(lm1)$fixed[2, 3], lwd = 2)
segments(x0 = 1, x1 = 2, y0 = intervals(lm1)$fixed[1, 2], y1 = intervals(lm1)$fixed[1, 2] + intervals(lm1)$fixed[2, 2], lwd = 2)

lm2 <- lme(X.AN_NE. ~ condition * AgeGroup, data = amyg_joint, random =  ~1|ID, na.action = na.omit)
summary(lm2)
with(amyg_joint, {
  interaction.plot(condition, ID, X.AN_NE., legend = F, frame.plot = F, lty = 1, col = "gray", ylab = "Beta estimate", main = "Happy vs neutral")
})
segments(x0 = 1, x1 = 1, y0 = intervals(lm2)$fixed[1, 1], y1 = intervals(lm2)$fixed[1, 3], lwd = 2)
segments(x0 = 2, x1 = 2, y0 = intervals(lm2)$fixed[1, 2] + intervals(lm2)$fixed[2, 1], y1 = intervals(lm2)$fixed[1, 2] + intervals(lm2)$fixed[2, 3], lwd = 2)
segments(x0 = 1, x1 = 2, y0 = intervals(lm2)$fixed[1, 2], y1 = intervals(lm2)$fixed[1, 2] + intervals(lm2)$fixed[2, 2], lwd = 2)

lm3 <- lme(X.HA_NE. ~ condition, data = amyg_joint, random =  ~1|ID, na.action = na.omit)
summary(lm3)




# FFA

# Analyse amygdala correlations between right and left side, see if average is justified (it was)
corr_FFA_fullsleep <- data.frame(condition = character(), variable = character(), estimate = double(), confint_lower = double(), confint_upper = double(), stringsAsFactors=FALSE)
corr_FFA_sleepdeprived <- data.frame(condition = character(), variable = character(), estimate = double(), confint_lower = double(), confint_upper = double(), stringsAsFactors=FALSE)
for(i in 2:length(FFA_L_fullsleep)){
  plot(FFA_L_fullsleep[, i] ~ FFA_R_fullsleep[, i])
  test1 <- cor.test(FFA_L_fullsleep[, i], FFA_R_fullsleep[, i])
  corr_FFA_fullsleep[i-1, ] <- c("fullsleep", names(FFA_L_fullsleep)[i], round(test1$estimate, 2), round(test1$conf.int[1], 2), round(test1$conf.int[2], 2))
  
  plot(FFA_L_sleepdeprived[, i] ~ FFA_R_sleepdeprived[, i])
  test2 <- cor.test(FFA_L_sleepdeprived[, i], FFA_R_sleepdeprived[, i])
  corr_FFA_sleepdeprived[i-1, ] <- c("fullsleep", names(FFA_L_fullsleep)[i], round(test2$estimate, 2), round(test2$conf.int[1], 2), round(test2$conf.int[2], 2))
}

# Merge data between conditions and average over right and left
amyg_joint_fullsleep <- amyg_L_fullsleep
for(i in 2:length(amyg_joint_fullsleep)){
  amyg_joint_fullsleep[, i] <- (amyg_L_fullsleep[, i] + amyg_R_fullsleep[, i])
}
amyg_joint_fullsleep$condition <- "fullsleep"

amyg_joint_sleepdeprived <- amyg_L_sleepdeprived
for(i in 2:length(amyg_joint_sleepdeprived)){
  amyg_joint_sleepdeprived[, i] <- (amyg_L_sleepdeprived[, i] + amyg_R_sleepdeprived[, i])
}
amyg_joint_sleepdeprived$condition <- "sleepdeprived"

amyg_joint <- rbind(amyg_joint_fullsleep, amyg_joint_sleepdeprived)  
amyg_joint <- merge(amyg_joint, demdata, by.x = "ID", by.y = "id")

# Set reference levels and contrast coding
amyg_joint$condition <- as.factor(amyg_joint$condition)
amyg_joint$AgeGroup <- relevel(amyg_joint$AgeGroup, ref = "Young")
contrasts(amyg_joint$condition) <- rbind(-.5, .5)
colnames(contrasts(amyg_joint$condition)) <- levels(amyg_joint$condition)[2]
contrasts(amyg_joint$AgeGroup) <- rbind(-.5, .5)
colnames(contrasts(amyg_joint$AgeGroup)) <- levels(amyg_joint$AgeGroup)[2]




L_fullsleep_KSS <- merge(L_fullsleep, KSSData[KSSData$DeprivationCondition == "Not Sleep Deprived", ], by.x = "ID", by.y = "newid")
plot(X.HA.AN.NE. ~ KSS_Rating, data = L_fullsleep_KSS, frame.plot = F, xlab = "KSS", ylab = "Estimate")
mod <- lm(X.HA.AN.NE. ~ KSS_Rating, data = L_fullsleep_KSS)
abline(mod, col = "red")
summary(mod)

L_sleepdeprived_KSS <- merge(L_sleepdeprived, KSSData[KSSData$DeprivationCondition == "Sleep Deprived", ], by.x = "ID", by.y = "newid")
plot(X.HA.AN.NE. ~ KSS_Rating, data = L_sleepdeprived_KSS, frame.plot = F, xlab = "KSS", ylab = "Estimate")
mod <- lm(X.HA.AN.NE. ~ KSS_Rating, data = L_sleepdeprived_KSS)
abline(mod, col = "red")
summary(mod)

R_fullsleep_KSS <- merge(R_fullsleep, KSSData[KSSData$DeprivationCondition == "Not Sleep Deprived", ], by.x = "ID", by.y = "newid")
plot(X.HA.AN.NE. ~ KSS_Rating, data = R_fullsleep_KSS, frame.plot = F, xlab = "KSS", ylab = "Estimate")
mod <- lm(X.HA.AN.NE. ~ KSS_Rating, data = R_fullsleep_KSS)
abline(mod, col = "red")
summary(mod)

R_sleepdeprived_KSS <- merge(R_sleepdeprived, KSSData[KSSData$DeprivationCondition == "Sleep Deprived", ], by.x = "ID", by.y = "newid")
plot(X.HA.AN.NE. ~ KSS_Rating, data = R_sleepdeprived_KSS, frame.plot = F, xlab = "KSS", ylab = "Estimate")
mod <- lm(X.HA.AN.NE. ~ KSS_Rating, data = R_sleepdeprived_KSS)
abline(mod, col = "red")
summary(mod)

# FFA


boxplot(L_fullsleep$X.HA.AN.NE., L_sleepdeprived$X.HA.AN.NE., frame.plot = F, names = c("full sleep", "sleep deprived"), main = "All faces")
t.test(L_fullsleep$X.HA.AN.NE., L_sleepdeprived$X.HA.AN.NE., paired = T)
boxplot(R_fullsleep$X.HA.AN.NE., R_sleepdeprived$X.HA.AN.NE., frame.plot = F, names = c("full sleep", "sleep deprived"), main = "All faces")
t.test(R_fullsleep$X.HA.AN.NE., R_sleepdeprived$X.HA.AN.NE., paired = T)

boxplot(L_fullsleep$X.HA_NE., L_sleepdeprived$X.HA_NE., frame.plot = F, names = c("full sleep", "sleep deprived"), main = "Happy vs neutral")
t.test(L_fullsleep$X.HA_NE., L_sleepdeprived$X.HA_NE., paired = T)
boxplot(R_fullsleep$X.HA_NE., R_sleepdeprived$X.HA_NE., frame.plot = F, names = c("full sleep", "sleep deprived"), main = "Happy vs neutral")
t.test(R_fullsleep$X.HA_NE., R_sleepdeprived$X.HA_NE., paired = T)

boxplot(L_fullsleep$X.AN_NE., L_sleepdeprived$X.AN_NE., frame.plot = F, names = c("full sleep", "sleep deprived"), main = "Angry vs neutral")
t.test(L_fullsleep$X.AN_NE., L_sleepdeprived$X.AN_NE., paired = T)
boxplot(R_fullsleep$X.AN_NE., R_sleepdeprived$X.AN_NE., frame.plot = F, names = c("full sleep", "sleep deprived"), main = "Angry vs neutral")
t.test(R_fullsleep$X.AN_NE., R_sleepdeprived$X.AN_NE., paired = T)

L_fullsleep_KSS <- merge(L_fullsleep, KSSData[KSSData$DeprivationCondition == "Not Sleep Deprived", ], by.x = "ID", by.y = "newid")
plot(X.HA.AN.NE. ~ KSS_Rating, data = L_fullsleep_KSS, frame.plot = F, xlab = "KSS", ylab = "Estimate")
mod <- lm(X.HA.AN.NE. ~ KSS_Rating, data = L_fullsleep_KSS)
abline(mod, col = "red")
summary(mod)

L_sleepdeprived_KSS <- merge(L_sleepdeprived, KSSData[KSSData$DeprivationCondition == "Sleep Deprived", ], by.x = "ID", by.y = "newid")
plot(X.HA.AN.NE. ~ KSS_Rating, data = L_sleepdeprived_KSS, frame.plot = F, xlab = "KSS", ylab = "Estimate")
mod <- lm(X.HA.AN.NE. ~ KSS_Rating, data = L_sleepdeprived_KSS)
abline(mod, col = "red")
summary(mod)

R_fullsleep_KSS <- merge(R_fullsleep, KSSData[KSSData$DeprivationCondition == "Not Sleep Deprived", ], by.x = "ID", by.y = "newid")
plot(X.HA.AN.NE. ~ KSS_Rating, data = R_fullsleep_KSS, frame.plot = F, xlab = "KSS", ylab = "Estimate")
mod <- lm(X.HA.AN.NE. ~ KSS_Rating, data = R_fullsleep_KSS)
abline(mod, col = "red")
summary(mod)

R_sleepdeprived_KSS <- merge(R_sleepdeprived, KSSData[KSSData$DeprivationCondition == "Sleep Deprived", ], by.x = "ID", by.y = "newid")
plot(X.HA.AN.NE. ~ KSS_Rating, data = R_sleepdeprived_KSS, frame.plot = F, xlab = "KSS", ylab = "Estimate")
mod <- lm(X.HA.AN.NE. ~ KSS_Rating, data = R_sleepdeprived_KSS)
abline(mod, col = "red")
summary(mod)

  