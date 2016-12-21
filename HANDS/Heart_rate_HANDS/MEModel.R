# Script to analyse effects of sleep deprivation on heart rate in HANDS experiment
# GN 151217

# Initialise
# Require packages
require(nlme)
require(reshape2)

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
setwd("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/HR/PgDataHandsStimulusCorrected151219")
Files <- list.files()

IncludedSubjects <- read.table("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/Subjects_140818.csv", sep=";", header=T)
IncludedSubjects <- as.integer(IncludedSubjects$CanBeIncludedForInterventionEffects)

filenames <- Files
filenames[substr(filenames, 3, 3) == "_"] <- paste(0, filenames[substr(filenames, 3, 3) == "_"], sep = "")

timecoursespain <- data.frame(time = 1:1401)
timecoursesnopain <- data.frame(time = 1:1401)
timecourses_all <- data.frame(time = 1:1401)
painevents <- data.frame()
nopainevents <- data.frame()
n_na <- 0
n_na2 <- 0
for(i in 1:length(Files)){
  subject <- as.integer(substr(filenames[i], 1, 3))
  if(subject %in% IncludedSubjects){ # Skip or modify as needed to change sample
    Data <- read.csv(Files[i])
    names <- names(Data)
    Data <- apply(Data, 2, FUN = function (x) x/mean(x[1:400], na.rm = T))
    n_na <- n_na + sum(is.na(Data))
    Data <- apply(Data, 2, locf.sfear)
    n_na2 <- n_na2 + sum(is.na(Data)) # Data that cannot be imputed at this stage because the vector begins with NA.
    timecoursespain <- cbind(timecoursespain, Data[, grepl("^Pain", names)])
    timecoursesnopain <- cbind(timecoursesnopain, Data[, grepl("^No_Pain", names)])
    timecourses_all <- cbind(timecourses_all, rowMeans(Data, na.rm = T))
    means <- apply(Data, 2, FUN = function (x) mean(x[751:950], na.rm = T))
    painmeans <- means[grepl("^Pain", names(means))]
    nopainmeans <- means[grepl("^No_Pain", names(means))]
    painevents <- rbind(painevents, painmeans)
    nopainevents <- rbind(nopainevents, nopainmeans)
  }
}

# How much data was imputed
n_na
n_na/(40*1401*length(Files))
n_na2
n_na2/(40*1401*length(Files))

# Plot time courses
meantimecoursepain <- rowMeans(timecoursespain[, -1], na.rm = T)
meantimecoursenopain <- rowMeans(timecoursesnopain[, -1], na.rm = T)
plot(meantimecoursepain, type = "n", frame.plot = F, xlab = "time, s", ylab = "Heart rate, index", xaxt = "n")
polygon(x = c(400, 400, 750, 750), y = c(2, 0, 0, 2), density = NULL, border = NULL, col = "gray", lty = 0)
abline(v = 950, lty = 2)
axis(1, at = c(0, 400, 750, 950, 1400), labels = c(-4, 0, 3.5, 5.5, 10))
lines(meantimecoursenopain, col = "blue")
lines(meantimecoursepain, col = "red")
#lines(lowess(meantimecoursenopain, f = 1/5), col = "blue", lwd = 2)
#lines(lowess(meantimecoursepain, f = 1/5), col = "red", lwd = 2)
legend("topleft", lty = 1, lwd = 2, col = c("blue", "red"), legend = c("No pain", "Pain"), bty = "n")

# Take out time courses for pain/no pain stimuli
sessions <- data.frame(subject = as.integer(substr(filenames, 1, 3)), session = substr(filenames, 5, 5))
sessions <- sessions[sessions$subject %in% IncludedSubjects, ]
sessions$rowno <- 1:nrow(sessions)
randomisation <- read.csv("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/RandomisationList_140804.csv", sep=";")
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

# Plot aggregate time courses
# This is the plot that goes into the data descriptor manuscript
meantimecourse <- (meantimecoursepain + meantimecoursenopain)/2 # Events are balanced so this should be all right
pdf(file = "C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/HR/agg_timecourse.pdf")
plot(meantimecourse, type = "n", frame.plot = F, xlab = "time, s", ylab = "Heart rate, index", xaxt = "n", yaxt = "n")
polygon(x = c(400, 400, 750, 750), y = c(2, 0, 0, 2), density = NULL, border = NULL, col = "gray", lty = 0)
abline(v = 950, lty = 2)
axis(1, at = c(0, 400, 750, 950, 1400), labels = c(-4, 0, 3.5, 5.5, 10))
axis(2, at = c(0.997, 1, 1.003, 1.006), labels = c(0.997, 1, 1.003, 1.006))
lines(meantimecourse)
dev.off()
#lines(lowess(meantimecourse, f = 1/5), col = "blue", lwd = 2)

# Plot means for events
includedfilenames <- filenames[as.integer(substr(filenames, 1, 3)) %in% IncludedSubjects]
painevents$subject <- as.integer(substr(includedfilenames, 1, 3))
nopainevents$subject <- as.integer(substr(includedfilenames, 1, 3))
painevents$session <- as.integer(substr(includedfilenames, 5, 5))
nopainevents$session <- as.integer(substr(includedfilenames, 5, 5))
painevents <- melt(painevents, id.vars = c("subject", "session"))
painevents$stimulus <- "pain"
nopainevents <- melt(nopainevents, id.vars = c("subject", "session"))
nopainevents$stimulus <- "nopain"
events <- rbind(painevents, nopainevents)
boxplot(value ~ stimulus, data = events)

# Analyse data
demographics <- read.csv("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/150215_Demographic.csv", sep=";", dec=",")
events <- merge(events, subset(demographics, select = c(Subject, AgeGroup)), by.x = "subject", by.y = "Subject")
randomisation <- read.csv("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/RandomisationList_140804.csv", sep=";")
events <- merge(events, randomisation, by.x = "subject", by.y = "Subject")
events$condition <- "fullsleep"
events$condition[events$Sl_cond == 1 & events$session == 1] <- "psd"
events$condition[events$Sl_cond == 2 & events$session == 2] <- "psd"
events$condition <- as.factor(events$condition)
events$AgeGroup <- relevel(events$AgeGroup, ref = "Young")
events$condition <- relevel(events$condition, ref = "fullsleep")

# Build models
# First model is without pain/no pain stimulus and sleep condition for purpose of technical validation
lme1 <- lme(value ~ 1, data = events, random = ~ 1|subject/session, na.action = na.omit)
summary(lme1)
intervals(lme1)

# Second model is for purpose of hypothesis testing
lme2 <- lme(value ~ stimulus*condition*AgeGroup, data = events, random = ~ 1|subject/session, na.action = na.omit)
summary(lme2)
intervals(lme2)

# Reduced models are explorative
lme3 <- lme(value ~ stimulus*condition, data = events, random = ~ 1|subject/session, na.action = na.omit)
summary(lme3)
intervals(lme3)

lme3b <- lme(value ~ stimulus, data = events, random = ~ 1|subject/session, na.action = na.omit)
summary(lme3b)
intervals(lme3b)

# Make plots for publication
pdf(file = "C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/HR/agg_timecourse2.pdf")
plot(meantimecoursepain, type = "n", frame.plot = F, xlab = "time, s", ylab = "Heart rate, index", xaxt = "n", ylim = c(0.996, 1.006))
polygon(x = c(400, 400, 750, 750), y = c(2, 0, 0, 2), density = NULL, border = NULL, col = "gray", lty = 0)
abline(v = 950, lty = 2)
axis(1, at = c(0, 400, 750, 950, 1400), labels = c(-4, 0, 3.5, 5.5, 10))
lines(lowess(meantimecoursenopain, f = 2/5), col = "blue", lwd = 2)
lines(lowess(meantimecoursepain, f = 2/5), col = "red", lwd = 2, lty = 2)
legend("topleft", lty = c(1, 2), lwd = 2, col = c("blue", "red"), legend = c("No pain", "Pain"), bty = "n")

plot(meantimecoursefullsleep, type = "n", frame.plot = F, xlab = "time, s", ylab = "Heart rate, index", xaxt = "n", ylim = c(0.996, 1.006))
polygon(x = c(400, 400, 750, 750), y = c(2, 0, 0, 2), density = NULL, border = NULL, col = "gray", lty = 0)
abline(v = 950, lty = 2)
axis(1, at = c(0, 400, 750, 950, 1400), labels = c(-4, 0, 3.5, 5.5, 10))
lines(lowess(meantimecoursefullsleep, f = 2/5), col = "blue", lwd = 2)
lines(lowess(meantimecoursepsd, f = 2/5), col = "red", lwd = 2, lty = 2)
legend("topleft", lty = c(1, 2), lwd = 2, col = c("blue", "red"), legend = c("Full sleep", "Sleep deprived"), bty = "n")
dev.off()