# Script to analyse effects of sleep deprivation on heart rate in HANDS experiment
# GN 151217
# Adapted for FACES 180820

# Initialise
# Require packages
require(nlme)
require(reshape2)
require(RColorBrewer)
require(readxl)
cols <- brewer.pal(n = 5, name = "Dark2")

# Define function for imputation of time series
locf.sfear = function(x) { 
  assign("stored.value", x[1], envir=.GlobalEnv) 
  sapply(x, function(x) { 
    if(is.na(x)) 
      stored.value 
    else { 
      assign("stored.value", x, envir=.GlobalEnv) 
      x 
    }}) 
} 

# Analyse data
# Read files, normalise data, impute consored values, generate new data file with summary measures for each event
setwd("~/Box Sync/Sleepy Brain/Datafiles/HR/PgDataFACESStimulusCorrected180820/")
Files <- list.files()
Files <- Files[Files != "Reduced_model.csv"] # Do not read output written by this script

IncludedSubjects <-  read.csv2("~/Box Sync/Sleepy Brain/Datafiles/Subjects_151215.csv")
# Check wth Gustav later
IncludedSubjects <- as.integer(IncludedSubjects$SuccessfulIntervention)

filenames <- Files
filenames[substr(filenames, 3, 3) == "_"] <- paste(0, filenames[substr(filenames, 3, 3) == "_"], sep = "")



timecoursesNeutral <- data.frame(time = 1:2401)
timecoursesHappy <- data.frame(time = 1:2401)
timecoursesAngry <- data.frame(time = 1:2401)
timecourses_all <- data.frame(time = 1:2401)
NeutralBlocks <- data.frame()
HappyBlocks <- data.frame()
AngryBlocks <- data.frame()
n_na <- 0
n_na2 <- 0
for(i in 1:length(Files)){
  subject <- as.integer(substr(filenames[i], 1, 3))
  if(subject %in% IncludedSubjects){ # Skip or modify as needed to change sample
    Data <- read.csv(Files[i])
    names <- names(Data)
    #Data <- apply(Data, 2, FUN = function (x) x/mean(x[1:400], na.rm = T))
    n_na <- n_na + sum(is.na(Data))
    Data <- apply(Data, 2, locf.sfear)
    n_na2 <- n_na2 + sum(is.na(Data)) # Data that cannot be imputed at this stage because the vector begins with NA.
    timecoursesNeutral <- cbind(timecoursesNeutral, Data[, grepl("^neutral", names)])
    timecoursesHappy <- cbind(timecoursesHappy, Data[, grepl("^happy", names)])
    timecoursesAngry <- cbind(timecoursesAngry, Data[, grepl("^angry", names)])
    timecourses_all <- cbind(timecourses_all, rowMeans(Data, na.rm = T))
    means <- apply(Data, 2, FUN = function (x) mean(x[201:2201], na.rm = T))
    Neutralmeans <- means[grepl("^neutral", names(means))]
    Happymeans <- means[grepl("^happy", names(means))]
    Angrymeans <- means[grepl("^angry", names(means))]
    NeutralBlocks <- rbind(NeutralBlocks, Neutralmeans)
    HappyBlocks <- rbind(HappyBlocks, Happymeans)
    AngryBlocks <- rbind(AngryBlocks, Angrymeans)
  }
}

# How much data was imputed. Check for FACES!
n_na
n_na/(60*2401*length(Files))
n_na2
n_na2/(60*2401*length(Files))

# Plot time courses
meantimecourseNeutral <- rowMeans(timecoursesNeutral[, -1], na.rm = T)
meantimecourseHappy <- rowMeans(timecoursesHappy[, -1], na.rm = T)
meantimecourseAngry <- rowMeans(timecoursesAngry[, -1], na.rm = T)

setwd("~/Desktop/SleepyBrain-Analyses/FACES/Heart_rate_Faces")
pdf("heart_rate.pdf")
plot(meantimecourseNeutral, type = "n", frame.plot = F, xlab = "time", ylab = "Heart rate", xaxt = "n", ylim = c(66, 70))
polygon(x = c(200, 200, 600, 600), y = c(2, 0, 0, 2), density = NULL, border = NULL, col = "gray", lty = 4)
axis(1, at = c(0, 200, 2200, 2400), labels = c(" ","start", "end", ""))
lines(lowess(meantimecourseNeutral, f = 2/5), col = "blue", lwd = 2)
lines(lowess(meantimecourseAngry, f = 2/5), col = "red", lwd = 2, lty = 2)
lines(lowess(meantimecourseHappy, f = 2/5), col = "green", lwd = 2, lty = 3)
legend("topright", lty = c(1, 2), lwd = 2, col = c("blue", "red", "green"), 
       legend = c("Neutral", "Angry", "Happy"), bty = "n")


# Take out time courses for full sleep/psd
sessions <- data.frame(subject = as.integer(substr(filenames, 1, 3)), session = substr(filenames, 5, 5))
sessions <- sessions[sessions$subject %in% IncludedSubjects, ]
sessions$rowno <- 1:nrow(sessions)
randomisation <- read.csv("~/Box Sync/Sleepy Brain/Datafiles/RandomisationList_140804.csv", sep=";")
sessions <- merge(sessions, randomisation, by.x = "subject", by.y = "Subject")
sessions$condition <- "fullsleep"
sessions$condition[sessions$Sl_cond == 1 & sessions$session == 1] <- "psd"
sessions$condition[sessions$Sl_cond == 2 & sessions$session == 2] <- "psd"
sessions$condition <- as.factor(sessions$condition)
sessions <- sessions[order(sessions$rowno), ]
fullsleep_index <- which(sessions$condition == "fullsleep") + 1
psd_index <- which(sessions$condition == "psd") + 1
timecourses_fullsleep <- timecourses_all[, fullsleep_index]
timecourses_psd <- timecourses_all[, psd_index]
meantimecoursefullsleep <- rowMeans(timecourses_fullsleep, na.rm = T)
meantimecoursepsd <- rowMeans(timecourses_psd, na.rm = T)

plot(meantimecoursefullsleep, type = "n", frame.plot = F, xlab = "time", ylab = "Heart rate", xaxt = "n", ylim = c(66, 70))
axis(1, at = c(0, 200, 2200, 2400), labels = c(" ","start", "end", ""))
lines(lowess(meantimecoursefullsleep, f = 2/5), col = "blue", lwd = 2)
lines(lowess(meantimecoursepsd, f = 2/5), col = "red", lwd = 2, lty = 2)
legend("topright", lty = c(1, 2), lwd = 2, col = c("blue", "red"), legend = c("Full sleep", "Sleep deprived"), bty = "n")



# Plot means for events
includedfilenames <- filenames[as.integer(substr(filenames, 1, 3)) %in% IncludedSubjects]
NeutralBlocks$subject <- as.integer(substr(includedfilenames, 1, 3))
AngryBlocks$subject <- as.integer(substr(includedfilenames, 1, 3))
HappyBlocks$subject <- as.integer(substr(includedfilenames, 1, 3))
NeutralBlocks$session <- as.integer(substr(includedfilenames, 5, 5))
AngryBlocks$session <- as.integer(substr(includedfilenames, 5, 5))
HappyBlocks$session <- as.integer(substr(includedfilenames, 5, 5))
NeutralBlocks <- melt(NeutralBlocks, id.vars = c("subject", "session"))
NeutralBlocks$stimulus <- "Neutral"
AngryBlocks <- melt(AngryBlocks, id.vars = c("subject", "session"))
AngryBlocks$stimulus <- "Angry"
HappyBlocks <- melt(HappyBlocks, id.vars = c("subject", "session"))
HappyBlocks$stimulus <- "Happy"
blocks <- rbind(NeutralBlocks, AngryBlocks, HappyBlocks)
boxplot(value ~ stimulus, data = blocks)
dev.off()

# Analyse data
demographics <- read.csv("~/Box Sync/Sleepy Brain/Datafiles/150215_Demographic.csv", sep=";", dec=",")
blocks <- merge(blocks, subset(demographics, select = c(Subject, AgeGroup)), by.x = "subject", by.y = "Subject")
randomisation <- read.csv("~/Box Sync/Sleepy Brain/Datafiles/RandomisationList_140804.csv", sep=";")
blocks <- merge(blocks, randomisation, by.x = "subject", by.y = "Subject")
blocks$condition <- "fullsleep"
blocks$condition[blocks$Sl_cond == 1 & blocks$session == 1] <- "psd"
blocks$condition[blocks$Sl_cond == 2 & blocks$session == 2] <- "psd"
blocks$condition <- as.factor(blocks$condition)
blocks$AgeGroup <- relevel(blocks$AgeGroup, ref = "Young")
blocks$condition <- relevel(blocks$condition, ref = "fullsleep")


# Model for purpose of hypothesis testing
blocks$stimulus <- as.factor(blocks$stimulus)
blocks$stimulus <- relevel(blocks$stimulus, ref = "Neutral")
blocks$AgeGroup <- relevel(blocks$AgeGroup, ref = "Young")
lme2 <- lme(value ~ stimulus*condition*AgeGroup, data = blocks, random = ~ 1|subject/session, na.action = na.omit)
summary(lme2)
intervals(lme2)
setwd("/Users/santam/Desktop/SleepyBrain-Analyses/FACES/Heart_rate_Faces/")
write.csv2(summary(lme2)$tTable, file = "Full_model.csv")
write.csv2(intervals(lme2)$fixed, file = "Full_model_intervals.csv")



