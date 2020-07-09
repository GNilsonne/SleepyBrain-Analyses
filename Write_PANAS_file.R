# Read data
demdata <- read.csv2("~/Box Sync/Sleepy Brain/Datafiles/150215_Demographic.csv")
subjects <- read.csv2("~/Box Sync/Sleepy Brain/Datafiles/Subjects_151215.csv")
demdata <- merge(demdata, subjects[, c("Subject", "CanBeIncludedForInterventionEffectsWithMRI", "newid")], by = "Subject")
randlist <- read.csv("~/Box Sync/Sleepy Brain/Datafiles/RandomisationList_140804.csv", sep=";")
demdata <- merge(demdata, randlist, by = "Subject")



# Analyse PANAS
demdata$PANAS_Positive_fullsleep <- NA
demdata$PANAS_Positive_fullsleep[demdata$Sl_cond == 1] <- demdata$PANAS_Positive_byScanner.y[demdata$Sl_cond == 1]
demdata$PANAS_Positive_fullsleep[demdata$Sl_cond == 2] <- demdata$PANAS_Positive_byScanner.x[demdata$Sl_cond == 2]
demdata$PANAS_Positive_sleepdeprived <- NA
demdata$PANAS_Positive_sleepdeprived[demdata$Sl_cond == 1] <- demdata$PANAS_Positive_byScanner.x[demdata$Sl_cond == 1]
demdata$PANAS_Positive_sleepdeprived[demdata$Sl_cond == 2] <- demdata$PANAS_Positive_byScanner.y[demdata$Sl_cond == 2]

demdata$PANAS_Negative_fullsleep <- NA
demdata$PANAS_Negative_fullsleep[demdata$Sl_cond == 1] <- demdata$PANAS_Negative_byScanner.y[demdata$Sl_cond == 1]
demdata$PANAS_Negative_fullsleep[demdata$Sl_cond == 2] <- demdata$PANAS_Negative_byScanner.x[demdata$Sl_cond == 2]
demdata$PANAS_Negative_sleepdeprived <- NA
demdata$PANAS_Negative_sleepdeprived[demdata$Sl_cond == 1] <- demdata$PANAS_Negative_byScanner.x[demdata$Sl_cond == 1]
demdata$PANAS_Negative_sleepdeprived[demdata$Sl_cond == 2] <- demdata$PANAS_Negative_byScanner.y[demdata$Sl_cond == 2]

boxplot(demdata$PANAS_Positive, demdata$PANAS_Positive_fullsleep, demdata$PANAS_Positive_sleepdeprived, frame.plot = F, names = c("Baseline", "Full sleep", "Sleep deprived"), main = "PANAS positive")
t.test(demdata$PANAS_Positive_fullsleep, demdata$PANAS_Positive_sleepdeprived, paired = T)

boxplot(demdata$PANAS_Negative, demdata$PANAS_Negative_fullsleep, demdata$PANAS_Negative_sleepdeprived, frame.plot = F, names = c("Baseline", "Full sleep", "Sleep deprived"), main = "PANAS negative")
t.test(demdata$PANAS_Negative_fullsleep, demdata$PANAS_Negative_sleepdeprived, paired = T)


# Save PANAS data for use in other context
PANAS <- subset(demdata, select = c("Subject", "PANAS_Negative", "PANAS_Negative_fullsleep", "PANAS_Negative_sleepdeprived",
                                    "PANAS_Positive", "PANAS_Positive_fullsleep", "PANAS_Positive_sleepdeprived"))

write.csv2(PANAS, file="/Users/santam/Desktop/SleepyBrain-Analyses/Sleepmeasures_emotion/PANAS.csv")

