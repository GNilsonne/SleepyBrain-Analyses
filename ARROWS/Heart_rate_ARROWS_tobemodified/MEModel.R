# Script to analyse effects of sleep deprivation on heart rate in HANDS experiment
# GN 151217
# Adapted for ARROWS 180704

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
setwd("~/Box Sync/Sleepy Brain/Datafiles/HR/PgDataARROWSStimulusCorrected180703/")
Files <- list.files()
Files <- Files[Files != "Reduced_model.csv"] # Do not read output written by this script

IncludedSubjects <-  read_excel("~/Box Sync/Sleepy Brain/Datafiles/SubjectsForARROWS.xlsx")
IncludedSubjects <- as.integer(IncludedSubjects$ARROWSRatings_Intervention)

filenames <- Files
filenames[substr(filenames, 3, 3) == "_"] <- paste(0, filenames[substr(filenames, 3, 3) == "_"], sep = "")

timecoursesMaintainNeutral <- data.frame(time = 1:2201)
timecoursesMaintainNegative <- data.frame(time = 1:2201)
timecoursesDownregulateNegative <- data.frame(time = 1:2201)
timecoursesUpregulateNegative <- data.frame(time = 1:2201)
timecourses_all <- data.frame(time = 1:2201)
MaintainNeutralevents <- data.frame()
MaintainNegativeevents <- data.frame()
DownregulateNegativeevents <- data.frame()
UpregulateNegativeevents <- data.frame()
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
    timecoursesMaintainNeutral <- cbind(timecoursesMaintainNeutral, Data[, grepl("^MaintainNeutral", names)])
    timecoursesMaintainNegative <- cbind(timecoursesMaintainNegative, Data[, grepl("^MaintainNegative", names)])
    timecoursesDownregulateNegative <- cbind(timecoursesDownregulateNegative, Data[, grepl("^DownregulateNegative", names)])
    timecoursesUpregulateNegative <- cbind(timecoursesUpregulateNegative, Data[, grepl("^UpregulateNegative", names)])
    timecourses_all <- cbind(timecourses_all, rowMeans(Data, na.rm = T))
    means <- apply(Data, 2, FUN = function (x) mean(x[601:1100], na.rm = T))
    MaintainNeutralmeans <- means[grepl("^MaintainNeutral", names(means))]
    MaintainNegativemeans <- means[grepl("^MaintainNegative", names(means))]
    DownregulateNegativemeans <- means[grepl("^DownregulateNegative", names(means))]
    UpregulateNegativemeans <- means[grepl("^UpregulateNegative", names(means))]
    MaintainNeutralevents <- rbind(MaintainNeutralevents, MaintainNeutralmeans)
    MaintainNegativeevents <- rbind(MaintainNegativeevents, MaintainNegativemeans)
    DownregulateNegativeevents <- rbind(DownregulateNegativeevents, DownregulateNegativemeans)
    UpregulateNegativeevents <- rbind(UpregulateNegativeevents, UpregulateNegativemeans)
  }
}

# How much data was imputed.
n_na
n_na/(60*2201*length(Files))
n_na2
n_na2/(60*2201*length(Files))

# Plot time courses
meantimecourseMaintainNeutral <- rowMeans(timecoursesMaintainNeutral[, -1], na.rm = T)
meantimecourseMaintainNegative <- rowMeans(timecoursesMaintainNegative[, -1], na.rm = T)
meantimecourseDownregulateNegative <- rowMeans(timecoursesDownregulateNegative[, -1], na.rm = T)
meantimecourseUpregulateNegative <- rowMeans(timecoursesUpregulateNegative[, -1], na.rm = T)
 
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

# # Plot aggregate time courses
# # This is the plot that goes into the data descriptor manuscript
# meantimecourse <- (meantimecoursepain + meantimecoursenopain)/2 # Events are balanced so this should be all right
# pdf(file = "C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/HR/agg_timecourse.pdf")
# plot(meantimecourse, type = "n", frame.plot = F, xlab = "time, s", ylab = "Heart rate, index", xaxt = "n", yaxt = "n")
# polygon(x = c(400, 400, 750, 750), y = c(2, 0, 0, 2), density = NULL, border = NULL, col = "gray", lty = 0)
# abline(v = 950, lty = 2)
# axis(1, at = c(0, 400, 750, 950, 1400), labels = c(-4, 0, 3.5, 5.5, 10))
# axis(2, at = c(0.997, 1, 1.003, 1.006), labels = c(0.997, 1, 1.003, 1.006))
# lines(meantimecourse)
# dev.off()
# #lines(lowess(meantimecourse, f = 1/5), col = "blue", lwd = 2)

# Plot means for events
includedfilenames <- filenames[as.integer(substr(filenames, 1, 3)) %in% IncludedSubjects]
MaintainNeutralevents$subject <- as.integer(substr(includedfilenames, 1, 3))
MaintainNegativeevents$subject <- as.integer(substr(includedfilenames, 1, 3))
DownregulateNegativeevents$subject <- as.integer(substr(includedfilenames, 1, 3))
UpregulateNegativeevents$subject <- as.integer(substr(includedfilenames, 1, 3))
MaintainNeutralevents$session <- as.integer(substr(includedfilenames, 5, 5))
MaintainNegativeevents$session <- as.integer(substr(includedfilenames, 5, 5))
DownregulateNegativeevents$session <- as.integer(substr(includedfilenames, 5, 5))
UpregulateNegativeevents$session <- as.integer(substr(includedfilenames, 5, 5))
MaintainNeutralevents <- melt(MaintainNeutralevents, id.vars = c("subject", "session"))
MaintainNeutralevents$stimulus <- "MaintainNeutral"
MaintainNegativeevents <- melt(MaintainNegativeevents, id.vars = c("subject", "session"))
MaintainNegativeevents$stimulus <- "MaintainNegative"
DownregulateNegativeevents <- melt(DownregulateNegativeevents, id.vars = c("subject", "session"))
DownregulateNegativeevents$stimulus <- "DownregulateNegative"
UpregulateNegativeevents <- melt(UpregulateNegativeevents, id.vars = c("subject", "session"))
UpregulateNegativeevents$stimulus <- "UpregulateNegative"
events <- rbind(MaintainNeutralevents, MaintainNegativeevents, DownregulateNegativeevents, UpregulateNegativeevents)
boxplot(value ~ stimulus, data = events)

# Analyse data
demographics <- read.csv("~/Box Sync/Sleepy Brain/Datafiles/150215_Demographic.csv", sep=";", dec=",")
events <- merge(events, subset(demographics, select = c(Subject, AgeGroup)), by.x = "subject", by.y = "Subject")
randomisation <- read.csv("~/Box Sync/Sleepy Brain/Datafiles/RandomisationList_140804.csv", sep=";")
events <- merge(events, randomisation, by.x = "subject", by.y = "Subject")
events$condition <- "fullsleep"
events$condition[events$Sl_cond == 1 & events$session == 1] <- "psd"
events$condition[events$Sl_cond == 2 & events$session == 2] <- "psd"
events$condition <- as.factor(events$condition)
events$AgeGroup <- relevel(events$AgeGroup, ref = "Young")
events$condition <- relevel(events$condition, ref = "fullsleep")


# Model for purpose of hypothesis testing
events$stimulus <- as.factor(events$stimulus)
events$stimulus <- relevel(events$stimulus, ref = "MaintainNeutral")
lme2 <- lme(value ~ stimulus*condition*AgeGroup, data = events, random = ~ 1|subject/session, na.action = na.omit)
summary(lme2)
intervals(lme2)
setwd("/Users/santam/Box Sync/Sleepy Brain/Datafiles/HR")
write.csv2(summary(lme2)$tTable, file = "Full_model.csv")
write.csv2(intervals(lme2)$fixed, file = "Full_model_intervals.csv")


# Model without maintain neutral
eventsNegative <- subset(events, stimulus != "MaintainNeutral")
eventsNegative$stimulus <- droplevels(eventsNegative)$stimulus
eventsNegative$stimulus <- relevel(eventsNegative$stimulus, ref = "MaintainNegative")
lme2 <- lme(value ~ stimulus*condition*AgeGroup, data = eventsNegative, random = ~ 1|subject/session, na.action = na.omit)
summary(lme2)
intervals(lme2)

# Plot time courses for event
plot(meantimecourseUpregulateNegative, type = "n", frame.plot = F, xlab = "time", ylab = "Heart rate, index", xaxt = "n", ylim = c(0.97,1.02))
polygon(x = c(400, 400, 600, 600), y = c(2, 0, 0, 2), density = NULL, border = NULL, col = "#EEEEEE", lty = 0)
polygon(x = c(600, 600, 1100, 1100), y = c(2, 0, 0, 2), density = NULL, border = NULL, col = "#FFEEEE", lty = 0)
abline(v = 1300, lty = 2)
axis(1, at = c(0, 400, 600, 1100, 1300, 1600), labels = c(" ", "Arrow", "Picture", "Blank", "Rating", " "))
#lines(meantimecourseMaintainNegative, col = "#256EFF")
#lines(meantimecourseMaintainNeutral, col = "#46237A")
#lines(meantimecourseDownregulateNegative, col = "#3DDC97")
#lines(meantimecourseUpregulateNegative, col = "#FF495C")
lines(lowess(meantimecourseMaintainNegative, f = 1/5), col = "#256EFF", lwd = 2)
lines(lowess(meantimecourseMaintainNeutral, f = 1/5), col = "#46237A", lwd = 2)
lines(lowess(meantimecourseDownregulateNegative, f = 1/5), col = "#3DDC97", lwd = 2)
lines(lowess(meantimecourseUpregulateNegative, f = 1/5), col = "#FF495C", lwd = 2)
legend("topleft", lty = 1, lwd = 2, col = c("#256EFF", "#46237A", "#3DDC97", "#FF495C"), 
       legend = c("Maintain Negative", "Maintain Neutral", "Downregulate Negative", "Upregulate Negative"), bty = "n")


# Plots for effect of sleep restriction
plot(meantimecoursefullsleep, type = "n", frame.plot = F, xlab = "time", ylab = "Heart rate, index", xaxt = "n", ylim = c(0.98, 1.02))
polygon(x = c(400, 400, 600, 600), y = c(2, 0, 0, 2), density = NULL, border = NULL, col = "gray", lty = 0)
polygon(x = c(600, 600, 1100, 1100), y = c(2, 0, 0, 2), density = NULL, border = NULL, col = "#FFCCCC", lty = 0)
abline(v = 1300, lty = 2)
axis(1, at = c(0, 400, 600, 1100, 1300, 1600), labels = c(" ", "Arrow", "Picture", "Blank", "Rating", " "))
lines(lowess(meantimecoursefullsleep, f = 2/5), col = "blue", lwd = 2)
lines(lowess(meantimecoursepsd, f = 2/5), col = "red", lwd = 2, lty = 2)
legend("topleft", lty = c(1, 2), lwd = 2, col = c("blue", "red"), legend = c("Full sleep", "Sleep deprived"), bty = "n")


