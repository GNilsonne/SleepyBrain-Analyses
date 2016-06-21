require(chron)

# Read KSS data
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


# Amygdala
setwd("~/Git Sleepy Brain/SleepyBrain-Analyses/FACES/ROI_analyses")
L_fullsleep <- read.csv("amygdala_ROI_betas_L_fullsleep.csv", sep=";", dec=",")
R_fullsleep <- read.csv("amygdala_ROI_betas_R_fullsleep.csv", sep=";", dec=",")
L_sleepdeprived <- read.csv("amygdala_ROI_betas_L_sleepdeprived.csv", sep=";", dec=",")
R_sleepdeprived <- read.csv("amygdala_ROI_betas_R_sleepdeprived.csv", sep=";", dec=",")

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

# FFA
L_fullsleep <- read.csv("FFA_ROI_betas_L_fullsleep.csv", sep=";", dec=",")
R_fullsleep <- read.csv("FFA_ROI_betas_R_fullsleep.csv", sep=";", dec=",")
L_sleepdeprived <- read.csv("FFA_ROI_betas_L_sleepdeprived.csv", sep=";", dec=",")
R_sleepdeprived <- read.csv("FFA_ROI_betas_R_sleepdeprived.csv", sep=";", dec=",")

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
