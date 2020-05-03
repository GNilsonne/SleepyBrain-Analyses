
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
                        intercept_deprivation_CI = paste(round(tTable[2, 1], 3), " [", round(interv[2, 1], 3), ", ", round(interv[2, 3], 3), "]", sep = ""), deprivation_p = round(tTable[2, 5], 3))
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
demdata <- read.csv2("~/Box Sync/Sleepy Brain/Datafiles/demdata_160225_pseudonymized.csv")

# Amygdala and FFA data
setwd("~/Desktop/SleepyBrain-Analyses/FACES/ROI_analyses")
amyg_L_fullsleep <- read.csv2("amygdala_ROI_betas_L_fullsleep.csv", sep=";", dec=".")
colnames(amyg_L_fullsleep)[1] <- 'ID'
amyg_R_fullsleep <- read.csv("amygdala_ROI_betas_R_fullsleep.csv", sep=";", dec=".")
colnames(amyg_R_fullsleep)[1] <- 'ID'
amyg_L_sleepdeprived <- read.csv("amygdala_ROI_betas_L_sleepdeprived.csv", sep=";", dec=".")
colnames(amyg_L_sleepdeprived)[1] <- 'ID'
amyg_R_sleepdeprived <- read.csv("amygdala_ROI_betas_R_sleepdeprived.csv", sep=";", dec=".")
colnames(amyg_R_sleepdeprived)[1] <- 'ID'
FFA_L_fullsleep <- read.csv("FFA_ROI_betas_L_fullsleep.csv", sep=";", dec=".")
colnames(FFA_L_fullsleep)[1] <- 'ID'
FFA_R_fullsleep <- read.csv("FFA_ROI_betas_R_fullsleep.csv", sep=";", dec=".")
colnames(FFA_R_fullsleep)[1] <- 'ID'
FFA_L_sleepdeprived <- read.csv("FFA_ROI_betas_L_sleepdeprived.csv", sep=";", dec=".")
colnames(FFA_L_sleepdeprived)[1] <- 'ID'
FFA_R_sleepdeprived <- read.csv("FFA_ROI_betas_R_sleepdeprived.csv", sep=";", dec=".")
colnames(FFA_R_sleepdeprived)[1] <- 'ID'

# KSS data
setwd("~/Box Sync/Sleepy Brain/Datafiles/Presentation_logfiles")
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

Subjects <- read.table("~/Box Sync/Sleepy Brain/Datafiles/Subjects_151215.csv", sep=";", header=T)
KSSData <- merge(KSSData, Subjects[, c("Subject", "newid")])
RandomisationList <- read.csv2("~/Box Sync/Sleepy Brain/Datafiles/RandomisationList_140804.csv")
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
psg_data <- read.csv2("~/Box Sync/Sleepy Brain/Datafiles/PSGdata_160507_pseudonymized.csv") # Manually scored data
siesta_data <- read.csv2("~/Box Sync/Sleepy Brain/Datafiles/SIESTAdata_160516_pseudonymized.csv") # Automatically scored data
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
  
  plot(amyg_L_sleepdeprived[, i] ~ amyg_R_sleepdeprived[, i])
  test2 <- cor.test(amyg_L_sleepdeprived[, i], amyg_R_sleepdeprived[, i])
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

# Analyse effects of sleep deprivation, age group, and covariates
# Initialise output objects
lme_nocovariates_list <- list()

# Young
# Loop over dependent variables (SPM contrasts)
amyg_joint_young <- subset(amyg_joint, AgeGroup == "Young")

for(i in 1:length(dependent_vars)){
  # Main analyses without covariates
  fml <- as.formula(paste(dependent_vars[i], "~ condition"))
  this_lm_nocovariate <- lme(fml, data = amyg_joint_young, random = ~ 1|ID, na.action = na.omit)
  lme_nocovariates_list[[i]] <- this_lm_nocovariate
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
write.csv2(lme_results_amyg_nocovariates, "~/Desktop/SleepyBrain-Analyses/FACES/ROI_analyses/results_amyg_nocovariates_young.csv")
# p-values for prespecified directional analyses should be changed manually to one-sided

# Old
# Loop over dependent variables (SPM contrasts)
amyg_joint_old <- subset(amyg_joint, AgeGroup == "Old")

for(i in 1:length(dependent_vars)){
  # Main analyses without covariates
  fml <- as.formula(paste(dependent_vars[i], "~ condition"))
  this_lm_nocovariate <- lme(fml, data = amyg_joint_old, random = ~ 1|ID, na.action = na.omit)
  lme_nocovariates_list[[i]] <- this_lm_nocovariate
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
write.csv2(lme_results_amyg_nocovariates, "~/Desktop/SleepyBrain-Analyses/FACES/ROI_analyses/results_amyg_nocovariates_old.csv")
# p-values for prespecified directional analyses should be changed manually to one-sided

