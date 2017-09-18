# Script to analyse ROI activation from FACES experiment
# Gustav Nilsonne 2017-05-28

# ROI estimates have been generated using SPM for different contrasts
# This script aims to investigate effects of sleep deprivation, age group, and other covariates


# Require packages, define functions, and read data ---------------------------------------------------------------

# Require packages
require(chron)
require(nlme)
require(effects)
require(RColorBrewer)
cols <- brewer.pal(3, "Dark2")

# Define functions
# Function to extract estimates for models without covariates and put them in a table
fun_extractvalues1 <- function(x){ # For main models
  interv <- matrix(unlist(intervals(x, which = "fixed")), ncol = 3)
  tTable <- summary(x)$tTable
  results <- data.frame(intercept_estimate_CI = paste(round(tTable[1, 1], 3), " [", round(interv[1, 1], 3), ", ", round(interv[1, 3], 3), "]", sep = ""), intercept_p = round(tTable[1, 5], 3),
                        intercept_deprivation_CI = paste(round(tTable[2, 1], 3), " [", round(interv[2, 1], 3), ", ", round(interv[2, 3], 3), "]", sep = ""), deprivation_p = round(tTable[2, 5], 3),
                        intercept_older_CI = paste(round(tTable[3, 1], 3), " [", round(interv[3, 1], 3), ", ", round(interv[3, 3], 3), "]", sep = ""), older_p = round(tTable[3, 5], 3),
                        intercept_interaction_CI = paste(round(tTable[4, 1], 3), " [", round(interv[4, 1], 3), ", ", round(interv[4, 3], 3), "]", sep = ""), interaction_p = round(tTable[4, 5], 3))
  return(results)
}
# Same for models with covariates
fun_extractvalues2 <- function(x){ # For models with covariates
  interv <- matrix(unlist(intervals(x, which = "fixed")), ncol = 3)
  tTable <- summary(x)$tTable
  results <- data.frame(estimate_CI = paste(round(tTable[1, 1], 3), " [", round(interv[1, 1], 3), ", ", round(interv[1, 3], 3), "]", sep = ""), p = round(tTable[1, 5], 3))
  return(results)
}

# Read data
# Read demographic data 
demdata <- read.csv2("C:/Users/gusta/Box Sync/Sleepy Brain/Datafiles/demdata_160225_pseudonymized.csv")

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
setwd("C:/Users/gusta/Box Sync/Sleepy Brain/Datafiles/Presentation_logfiles")
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

Subjects <- read.table("C:/Users/gusta/Box Sync/Sleepy Brain/Datafiles/Subjects_151215.csv", sep=";", header=T)
KSSData <- merge(KSSData, Subjects[, c("Subject", "newid")])
RandomisationList <- read.csv2("C:/Users/gusta/Box Sync/Sleepy Brain/Datafiles/RandomisationList_140804.csv")
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
KSSData$condition <- "fullsleep" # Rename for consistency with code below
KSSData$condition[KSSData$DeprivationCondition == "Sleep Deprived"] <- "sleepdeprived"

# PSG data
psg_data <- read.csv2("C:/Users/gusta/Box Sync/Sleepy Brain/Datafiles/PSGdata_160507_pseudonymized.csv") # Manually scored data
siesta_data <- read.csv2("C:/Users/gusta/Box Sync/Sleepy Brain/Datafiles/SIESTAdata_160516_pseudonymized.csv") # Automatically scored data
siesta_data_fullsleep <- siesta_data[, c("id", "tst__00_nsd", "r____00_nsd", "rp___00_nsd", "n3___00_nsd", "n3p__00_nsd")]
names(siesta_data_fullsleep) <- c("id", "tst", "rem", "rem_p", "n3", "n3_p")
siesta_data_sleepdeprived <- siesta_data[, c("id", "tst__00_sd", "r____00_nsd", "rp___00_nsd", "n3___00_sd", "n3p__00_sd")]
names(siesta_data_sleepdeprived) <- c("id", "tst", "rem", "rem_p", "n3", "n3_p")
siesta_data_fullsleep$condition <- "fullsleep"
siesta_data_sleepdeprived$condition <- "sleepdeprived"
siesta_data_long <- rbind(siesta_data_fullsleep, siesta_data_sleepdeprived)


# Analyse amygdata data ---------------------------------------------------

# Analyse amygdala correlations between right and left side, see if average is justified (it was)
corr_amyg_fullsleep <- data.frame(condition = character(), variable = character(), estimate = double(), confint_lower = double(), confint_upper = double(), stringsAsFactors=FALSE)
corr_amyg_sleepdeprived <- data.frame(condition = character(), variable = character(), estimate = double(), confint_lower = double(), confint_upper = double(), stringsAsFactors=FALSE)
for(i in 2:length(amyg_L_fullsleep)){
  plot(amyg_L_fullsleep[, i] ~ amyg_R_fullsleep[, i])
  test1 <- cor.test(amyg_L_fullsleep[, i], amyg_R_fullsleep[, i])
  corr_amyg_fullsleep[i-1, ] <- c("fullsleep", names(amyg_L_fullsleep)[i], round(test1$estimate, 2), round(test1$conf.int[1], 2), round(test1$conf.int[2], 2))
  
  plot(amyg_L_fullsleep[, i] ~ amyg_R_fullsleep[, i])
  test2 <- cor.test(amyg_L_fullsleep[, i], amyg_R_fullsleep[, i])
  corr_amyg_sleepdeprived[i-1, ] <- c("fullsleep", names(amyg_L_fullsleep)[i], round(test2$estimate, 2), round(test2$conf.int[1], 2), round(test2$conf.int[2], 2))
}

plot(amyg_L_fullsleep$X.HA.AN.NE. ~ amyg_R_fullsleep$X.HA.AN.NE.)
cor.test(amyg_L_fullsleep$X.HA.AN.NE., amyg_R_fullsleep$X.HA.AN.NE.)
plot(amyg_L_sleepdeprived$X.HA.AN.NE. ~ amyg_R_sleepdeprived$X.HA.AN.NE.)
cor.test(amyg_L_sleepdeprived$X.HA.AN.NE., amyg_R_sleepdeprived$X.HA.AN.NE.)

# Merge data between conditions and average over right and left
amyg_joint_fullsleep <- amyg_L_fullsleep
for(i in 2:length(amyg_joint_fullsleep)){ # Loop over columns
  amyg_joint_fullsleep[, i] <- (amyg_L_fullsleep[, i] + amyg_R_fullsleep[, i])/2 #Calculate mean
}
amyg_joint_fullsleep$condition <- "fullsleep"

amyg_joint_sleepdeprived <- amyg_L_sleepdeprived
for(i in 2:length(amyg_joint_sleepdeprived)){
  amyg_joint_sleepdeprived[, i] <- (amyg_L_sleepdeprived[, i] + amyg_R_sleepdeprived[, i])/2
}
amyg_joint_sleepdeprived$condition <- "sleepdeprived"
  
amyg_joint <- rbind(amyg_joint_fullsleep, amyg_joint_sleepdeprived) 

# Merge in other data
amyg_joint <- merge(amyg_joint, demdata[, c("id", "AgeGroup", "IRI_EC", "PSS14", "PPIR_C", "ESS", "ECS")], by.x = "ID", by.y = "id")
amyg_joint <- merge(amyg_joint, KSSData[, c("newid", "KSS_Rating", "condition")], by.x = c("ID", "condition"), by.y = c("newid", "condition"), all.x = T)
amyg_joint <- merge(amyg_joint, siesta_data_long, by.x = c("ID", "condition"), by.y = c("id", "condition") )

# Set reference levels and contrast coding
amyg_joint$condition <- as.factor(amyg_joint$condition)
amyg_joint$AgeGroup <- relevel(amyg_joint$AgeGroup, ref = "Young")
contrasts(amyg_joint$condition) <- rbind(-.5, .5)
colnames(contrasts(amyg_joint$condition)) <- levels(amyg_joint$condition)[2]
contrasts(amyg_joint$AgeGroup) <- rbind(-.5, .5)
colnames(contrasts(amyg_joint$AgeGroup)) <- levels(amyg_joint$AgeGroup)[2]

# Define covariates
dependent_vars <- names(amyg_joint)[3:10]
covariates_across <- c("IRI_EC", "PSS14", "PPIR_C", "ESS", "ECS") # Trait measures in participants, wchich should be investigated across conditions
# Hypothesis list includes "SES ratings", which I think should be "ESS ratings"
# ECS ratings were added post hoc

covariates_within <- c("KSS_Rating", "tst", "rem", "rem_p", "n3", "n3_p") # TODO: check variable selection
# TODO: Add also the following: rated happiness/angriness, EMG responses, heart rate responses, pupil responses
# Prefrontal (Fp1 + Fp2) gamma (30-40 Hz) in REM sleep was also specified but this variable does not exist


# Analyse effects of sleep deprivation, age group, and covariates
# Initialise output objects
lme_nocovariates_list <- list()
lme_covariates_across_list <- list()
lme_covariates_within_fullsleep_list <- list()
lme_covariates_within_sleepdeprived_list <- list()
# Loop over dependent variables (SPM contrasts)
for(i in 1:length(dependent_vars)){
  # Main analyses without covariates
  fml <- as.formula(paste(dependent_vars[i], "~ condition * AgeGroup"))
  this_lm_nocovariate <- lme(fml, data = amyg_joint, random = ~ 1|ID, na.action = na.omit)
  lme_nocovariates_list[[i]] <- this_lm_nocovariate
  
  # Loop over covariates across conditions
  for(j in 1:length(covariates_across)){
    thisindex <- (i-1)*length(covariates_across) + j
    fml <- as.formula(paste(dependent_vars[i], "~ condition * AgeGroup +", paste(covariates_across[j])))
    this_lm_covariate <- lme(fml, data = amyg_joint, random = ~ 1|ID, na.action = na.omit)
    lme_covariates_across_list[[thisindex]] <- this_lm_covariate
  }

  # Loop over covariates within conditions
  for(j in 1:length(covariates_within)){
    thisindex2 <- (i-1)*length(covariates_within) + j
    fml <- as.formula(paste(dependent_vars[i], "~ AgeGroup +", paste(covariates_within[j])))
    this_lm_covariate <- lme(fml, data = amyg_joint[amyg_joint$condition == "fullsleep", ], random = ~ 1|ID, na.action = na.omit)
    lme_covariates_within_fullsleep_list[[thisindex2]] <- this_lm_covariate
    
    fml2 <- as.formula(paste(dependent_vars[i], "~ AgeGroup +", paste(covariates_within[j])))
    this_lm_covariate2 <- lme(fml2, data = amyg_joint[amyg_joint$condition == "sleepdeprived", ], random = ~ 1|ID, na.action = na.omit)
    lme_covariates_within_sleepdeprived_list[[thisindex2]] <- this_lm_covariate2
  }
}

# Write results to a table
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

for(i in 1:length(lme_covariates_across_list)){
  if (i == 1){
    lme_results_amyg_covariates_across <- fun_extractvalues2(lme_covariates_across_list[[i]])
  } else {
    lme_results_amyg_covariates_across <- rbind(lme_results_amyg_covariates_across, fun_extractvalues2(lme_covariates_across_list[[i]]))
  }
}

lme_results_amyg_covariates_across$dependent_var <- rep(c("Happy_vs_Angry", "Happy_vs_Neutral", "Angry_vs_Neutral", "Happy_vs_Baseline", "Angry_vs_Baseline", "Neutral_vs_Baseline", "Happy_and_Angry_vs_Baseline", "All_vs_Baseline"), each = length(lme_results_amyg_covariates_across$estimate_CI)/8)
lme_results_amyg_covariates_across$covariate <- covariates
lme_results_amyg_covariates_across <- reshape(lme_results_amyg_covariates_across, direction = "wide", v.names = c("estimate_CI", "p"), timevar = "covariate", idvar = "dependent_var")
write.csv(lme_results_amyg_covariates_across, "~/Git Sleepy Brain/SleepyBrain-Analyses/FACES/ROI_analyses/results_amyg_covariates_across.csv", row.names = F)

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


# Analyse FFA data --------------------------------------------------------

# Analyse FFA correlations between right and left side, see if average is justified (it was not)
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

# Merge data between conditions
FFA_L_fullsleep$condition <- "fullsleep"
FFA_L_sleepdeprived$condition <- "sleepdeprived"
FFA_R_fullsleep$condition <- "fullsleep"
FFA_R_sleepdeprived$condition <- "sleepdeprived"

FFA_L <- rbind(FFA_L_fullsleep, FFA_L_sleepdeprived) 
FFA_L <- merge(FFA_L, demdata, by.x = "ID", by.y = "id")
FFA_R <- rbind(FFA_R_fullsleep, FFA_R_sleepdeprived) 
FFA_R <- merge(FFA_R, demdata, by.x = "ID", by.y = "id")

# Set reference levels and contrast coding
FFA_L$condition <- as.factor(FFA_L$condition)
FFA_L$AgeGroup <- relevel(FFA_L$AgeGroup, ref = "Young")
contrasts(FFA_L$condition) <- rbind(-.5, .5)
colnames(contrasts(FFA_L$condition)) <- levels(FFA_L$condition)[2]
contrasts(FFA_L$AgeGroup) <- rbind(-.5, .5)
colnames(contrasts(FFA_L$AgeGroup)) <- levels(FFA_L$AgeGroup)[2]

FFA_R$condition <- as.factor(FFA_R$condition)
FFA_R$AgeGroup <- relevel(FFA_R$AgeGroup, ref = "Young")
contrasts(FFA_R$condition) <- rbind(-.5, .5)
colnames(contrasts(FFA_R$condition)) <- levels(FFA_R$condition)[2]
contrasts(FFA_R$AgeGroup) <- rbind(-.5, .5)
colnames(contrasts(FFA_R$AgeGroup)) <- levels(FFA_R$AgeGroup)[2]

# Perform analyses
# First FFA left side

# Analyse effects of sleep deprivation, age group, and covariates
dependent_vars <- names(FFA_L)[2:9]
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
  this_lm_nocovariate <- lme(fml, data = FFA_L, random = ~ 1|ID, na.action = na.omit)
  lme_nocovariates_list[[i]] <- this_lm_nocovariate
  
  # Additional analyses with covariates (prespecified)
  for(j in 1:length(covariates)){
    thisindex <- (i-1)*length(covariates) + j
    fml <- as.formula(paste(dependent_vars[i], "~ condition * AgeGroup +", paste(covariates[j])))
    this_lm_covariate <- lme(fml, data = FFA_L, random = ~ 1|ID, na.action = na.omit)
    lme_covariates_list[[thisindex]] <- this_lm_covariate
  }
}

# Write results to a table
for(i in 1:length(dependent_vars)){
  if (i == 1){
    lme_results_FFA_L_nocovariates <- fun_extractvalues1(lme_nocovariates_list[[i]])
  } else {
    lme_results_FFA_L_nocovariates <- rbind(lme_results_FFA_L_nocovariates, fun_extractvalues1(lme_nocovariates_list[[i]]))
  }
}

rownames(lme_results_FFA_L_nocovariates) <- c("Happy_vs_Angry", "Happy_vs_Neutral", "Angry_vs_Neutral", "Happy_vs_Baseline", "Angry_vs_Baseline", "Neutral_vs_Baseline", "Happy_and_Angry_vs_Baseline", "All_vs_Baseline")
# CHECK? Effects of sleep deprivation on Angry vs neutral should be one-sided p on account of directional hypothesis
write.csv(lme_results_FFA_L_nocovariates, "~/Git Sleepy Brain/SleepyBrain-Analyses/FACES/ROI_analyses/results_FFA_L_nocovariates.csv")

for(i in 1:length(lme_covariates_list)){
  if (i == 1){
    lme_results_FFA_L_covariates <- fun_extractvalues2(lme_covariates_list[[i]])
  } else {
    lme_results_FFA_L_covariates <- rbind(lme_results_FFA_L_covariates, fun_extractvalues2(lme_covariates_list[[i]]))
  }
}

lme_results_FFA_L_covariates$dependent_var <- rep(c("Happy_vs_Angry", "Happy_vs_Neutral", "Angry_vs_Neutral", "Happy_vs_Baseline", "Angry_vs_Baseline", "Neutral_vs_Baseline", "Happy_and_Angry_vs_Baseline", "All_vs_Baseline"), each = length(lme_results_FFA_L_covariates$estimate_CI)/8)
lme_results_FFA_L_covariates$covariate <- covariates
lme_results_FFA_L_covariates <- reshape(lme_results_FFA_L_covariates, direction = "wide", v.names = c("estimate_CI", "p"), timevar = "covariate", idvar = "dependent_var")
write.csv(lme_results_FFA_L_covariates, "~/Git Sleepy Brain/SleepyBrain-Analyses/FACES/ROI_analyses/results_FFA_L_covariates.csv", row.names = F)

