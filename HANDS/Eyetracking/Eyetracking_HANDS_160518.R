# HEAD

# Require packages
require(nlme)
require(effects)

# Import files
demographics <- read.csv("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/150215_Demographic.csv", sep=";", dec=",")
randomisation <- read.csv("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/RandomisationList_140804.csv", sep=";")

setwd("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/Viewpoint_files_corrected")
ViewpointFilesHands <- list.files(pattern = "HANDS")

ViewpointDataHands <- data.frame()
for (i in 1:length(ViewpointFilesHands)){ # Ignore warning
  #for (i in 1:74){
  nlines <- length(readLines(ViewpointFilesHands[i])) # To enable skipping reading of final line, which is often incomplete
  temp <- read.table(ViewpointFilesHands[i], skip = 28, nrows = nlines - 29) # Skip header lines as well as last line
  temp$File <- ViewpointFilesHands[i]
  ViewpointDataHands <- rbind(ViewpointDataHands, temp)
}

# Extract subject
ViewpointDataHands$Subject <- as.integer(substr(ViewpointDataHands$File, 1, 3))

# Extract date
ViewpointDataHands$Date <- as.Date(as.character(substr(ViewpointDataHands$File, 5, 10)), "%y%m%d")

# List included subjects 
IncludedSubjects <- read.table("../Subjects_140818.csv", sep=";", header=T)
#IncludedSubjects <- as.integer(IncludedSubjects$CanBeIncludedForInterventionEffects)
IncludedSubjects <- as.integer(IncludedSubjects$FulfillsCriteriaAndNoPathologicalFinding) # This is for the purpose of quality review.

# May need to be used later to exclude additional subjects
#IncludedSubjects <-IncludedSubjects[IncludedSubjects != 352]

# Retain only subjects in list
ViewpointDataHands <- ViewpointDataHands[ViewpointDataHands$Subject %in% as.integer(IncludedSubjects), ]

# Plot data to se that all subjects have registrations of approximatly the same length  
plot(ViewpointDataHands[ ,2], type="l", xlab = "Row", ylab = "Time (s)")

IncludedSubjectsViewpointHands <- unique(ViewpointDataHands$Subject)
#write.csv2(ViewpointDataHands, file = "../Eyetracking_HANDS/EyeDataHands_86subjects.csv", row.names=FALSE)
#write.csv2(IncludedSubjectsViewpointHands, file = "../Eyetracking_HANDS/IncludedSubjectsEyeHands_86subjects.csv", row.names=FALSE)

setwd("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles")

# Get onset times for stimuli 
OnsetTimesForAll <- list()
AllOnsetFiles <- list.files("Presentation_logfiles/", pattern = "HANDS_sce.log", recursive = T)
AllStimulusFiles <- list.files("Presentation_logfiles/", pattern = "HANDS_log.txt", recursive = T)

# Remove times for non-included subjects
getSubjectFromFileName <- function (filename) {
  return(as.integer(substr(filename, 1, 3)))
}

AllOnsetFiles = AllOnsetFiles[unlist(lapply(AllOnsetFiles, getSubjectFromFileName)) %in% IncludedSubjectsViewpointHands]
AllStimulusFiles = AllStimulusFiles[unlist(lapply(AllStimulusFiles, getSubjectFromFileName)) %in% IncludedSubjectsViewpointHands]

# Find onset times
for(i in 1:length(AllOnsetFiles)){
  OnsetTime <- read.table(paste("Presentation_logfiles/",AllOnsetFiles[i], sep = ""), header=F, quote="\"", fill=TRUE, blank.lines.skip=FALSE)
  time_init <- as.numeric(as.character(OnsetTime[6, 5]))
  OnsetTime <- subset(OnsetTime, V1 == "Picture")
  OnsetTime <- OnsetTime[ , c(2,4)]
  OnsetTime$File <- AllOnsetFiles[i]
  OnsetTime$Subject <- as.integer(substr(OnsetTime$File, 1, 3)) 
  OnsetTime$Date <- as.integer(substr(OnsetTime$File, 5, 10))
  OnsetTime <- subset(OnsetTime, V2 == "Pic2")
  OnsetTime$V4 <- (as.numeric(as.character(OnsetTime$V4))-time_init)/10000
  if(i == 92){
    OnsetTime <- rbind(OnsetTime, rep(NA, 5))
    OnsetTime <- rbind(OnsetTime, rep(NA, 5))
  }
  if(i == 113){
    OnsetTime <- rbind(OnsetTime, rep(NA, 5))
    OnsetTime <- rbind(OnsetTime, rep(NA, 5))
    OnsetTime <- rbind(OnsetTime, rep(NA, 5))
    OnsetTime <- rbind(OnsetTime, rep(NA, 5))
  }
  StimulusType <- read.delim(paste("Presentation_logfiles/", AllStimulusFiles[i], sep = ""))
  OnsetTimeAndStimulus <- cbind(OnsetTime, StimulusType) 
  OnsetTimeAndStimulus <- OnsetTimeAndStimulus[ , c("V4", "Condition", "Rated_Unpleasantness", "Subject", "Date")]
  if(!is.na(OnsetTime$Subject[1]) && OnsetTime$Subject[1] %in% as.integer(IncludedSubjects) ){
    OnsetTimesForAll[[length(OnsetTimesForAll)+1]] <- OnsetTimeAndStimulus
  }
}

Vpfiles_df <- data.frame(filenames = ViewpointFilesHands, subject = substr(ViewpointFilesHands, 1, 3), date = substr(ViewpointFilesHands, 5, 10))
Vpfiles_df$subject <- as.integer(as.character(Vpfiles_df$subject))
Vpfiles_df$date <- as.integer(as.character(Vpfiles_df$date))

Vpfiles_df <- with(Vpfiles_df, Vpfiles_df[order(subject, date), ])
Vpfiles_df$session <- NA
for (i in unique(Vpfiles_df$subject)){
  temp <- Vpfiles_df[Vpfiles_df$subject == i, ]
  if (length(temp$date) == 2){
    Vpfiles_df$session[Vpfiles_df$subject == i] <- c(1, 2)
  }
}

# Manually enter session numbers for subjects with only one included session
Vpfiles_df$session[Vpfiles_df$subject == 73] <- 1
Vpfiles_df$session[Vpfiles_df$subject == 75] <- 2
Vpfiles_df$session[Vpfiles_df$subject == 86] <- 2
Vpfiles_df$session[Vpfiles_df$subject == 104] <- 1
Vpfiles_df$session[Vpfiles_df$subject == 115] <- 2
Vpfiles_df$session[Vpfiles_df$subject == 135] <- 1
Vpfiles_df$session[Vpfiles_df$subject == 160] <- 1
Vpfiles_df$session[Vpfiles_df$subject == 165] <- 2
Vpfiles_df$session[Vpfiles_df$subject == 263] <- 1
Vpfiles_df$session[Vpfiles_df$subject == 299] <- 2
Vpfiles_df$session[Vpfiles_df$subject == 324] <- 1
Vpfiles_df$session[Vpfiles_df$subject == 496] <- 1

Vpfiles_df <- Vpfiles_df[Vpfiles_df$subject %in% IncludedSubjectsViewpointHands, ]

# Cut out data for all included files
setwd("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/Viewpoint_files_corrected")
data_out <- NULL
onsets <- vector()
indices <- 1:length(OnsetTimesForAll)
indices <- indices[c(-20, -28, -35, -36, -54, -67, -69, -71, -92, -97, -103, -113, -114, -121, -124, -125, -131, -150, -154)] # Do not read when file is nonexistent or cannot be processed
for(i in indices){
  temp <- OnsetTimesForAll[[i]]
  subject <- temp$Subject[1]
  date <- temp$Date[1]
  session <- Vpfiles_df$session[Vpfiles_df$subject == subject & Vpfiles_df$date == date]
  
  thisVpfile <- as.character(Vpfiles_df$filenames[Vpfiles_df$subject == subject & Vpfiles_df$date == date])
  nlines <- length(readLines(thisVpfile)) # To enable skipping reading of final line, which is often incomplete
  data <- read.table(thisVpfile, skip = 28, nrows = nlines - 29) # Skip header lines as well as last line
  
  data$V7full <- data$V7
  data$V8full <- data$V8
  
  data$diff_width <- c(diff(data$V7)/diff(data$V2), NA)
  data$diff_height <- c(diff(data$V8)/diff(data$V2), NA)
  
  indexforrejection <- (data$diff_width < - 3) | (data$diff_width > 3) | (data$diff_height < - 3) | (data$diff_height > 3)
  neighbouringindices <- unique(which(indexforrejection), which(indexforrejection)-1, which(indexforrejection)+1)
  indexforrejection[neighbouringindices] <- TRUE
  
  data$V7[indexforrejection] <- NA
  data$V8[indexforrejection] <- NA
  
  data$V7[data$V7 < 0.1] <- NA
  data$V8[data$V8 < 0.1] <- NA
  data$V7[data$V7 > 0.3] <- NA
  data$V8[data$V8 > 0.3] <- NA
  width_lo001 <- loess(data$V7 ~ data$V2, span = 0.01)
  height_lo001 <- loess(data$V8 ~ data$V2, span = 0.01)
  data$width_lo001 <- predict(width_lo001, data$V2)
  data$height_lo001 <- predict(height_lo001, data$V2)
  
  # Cut pieces of data that start 4 seconds before onset of every stimulus and end 10 seconds after
  # 4 seconds is chosen because that was the shortest possible duration of the jittered fixation cross
  # 10 seconds extends into the rating event and we are unlikely to be interested in anything going on later than that
  
  for(j in 1:length(temp$V4)){
    thisonset <- temp$V4[j]
    cutout_start <- which(abs(data$V2 - (thisonset - 4)) == min(abs(data$V2 - (thisonset- 4)))) # Sampling was at 60 Hz
    cutout_end <- which(abs(data$V2 - (thisonset + 10)) == min(abs(data$V2 - (thisonset + 10))))
    if(length(cutout_start) > 1){cutout_start <- cutout_start[1]} # Fix case where cutout_start has lenght 2
    if(length(cutout_end) > 1){cutout_end <- cutout_end[1]}
    cutout <- data.frame(subject = subject, date = date, session = NA, event_no = j, stimulus = temp$Condition[j], width = data$width_lo001[seq(cutout_start, cutout_end, 6)], height = data$height_lo001[seq(cutout_start, cutout_end, 6)])
    rejected <- FALSE
    flag <- ""
    if(sum(is.na(data$V7[cutout_start:cutout_end])) > 0.5*length(data$V7[cutout_start:cutout_end]) | sum(is.na(data$V8[cutout_start:cutout_end])) > 0.5*length(data$V8[cutout_start:cutout_end])){
      rejected <- TRUE
      flag <- "REJECTED"
    }
    
    #pdf(file = paste("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/Eyetracking_QC/Eyetracking_HANDS_QC_", i, "_", j, ".pdf", sep = ""))
    #plot(data$V7full[cutout_start:cutout_end], type = "l", frame.plot = F, xaxt = "n", main = paste("Width, subject", subject, "session", session, "event", j, flag), ylim = c(0.1, 0.3), xlab = "Time, s", ylab = "Diameter, cm", col = "gray")
    #axis(1, at = c(0, 240, 840), labels = c(-4, 0, 10))
    #lines(data$V7[cutout_start:cutout_end])
    #lines(data$width_lo001[cutout_start:cutout_end], type = "l", col = "red")
    #lines(data$diameter, col = "blue")
    #plot(data$V8full[cutout_start:cutout_end], type = "l", frame.plot = F, xaxt = "n", main = paste("Height, subject", subject, "session", session, "event", j, flag), ylim = c(0.1, 0.3), xlab = "Time, s", ylab = "Diameter, cm", col = "gray")
    #axis(1, at = c(0, 240, 840), labels = c(-4, 0, 10))
    #lines(data$V8[cutout_start:cutout_end])
    #lines(data$height_lo001[cutout_start:cutout_end], type = "l", col = "red")
    #lines(data$diameter, col = "blue")
    #dev.off()
    
    cutout$index <- 1:length(cutout$subject)
    
    if(exists("data_out") == FALSE & rejected == FALSE){
      data_out <- cutout
    } else if (rejected == FALSE){
      data_out <- rbind(data_out, cutout)
    }
    onsets <- c(onsets, thisonset)
  }
}

# Aggregate data for plotting
# First make an average for each participant and then for whole group
dataout_agg <- NULL
for (i in unique(data_out$subject)){
  cutout2 <- data_out[data_out$subject == i, ]
  cutout2_agg <- aggregate(cbind(height, width) ~ index, data = cutout2, FUN = "mean")
  if(exists("dataout_agg") == FALSE){
    dataout_agg <- cutout2_agg
  } else {
    dataout_agg <- rbind(dataout_agg, cutout2_agg)
  }
}

dataout_agg_agg <- aggregate(cbind(height, width) ~ index, data = dataout_agg, FUN = "mean")
dataout_agg_agg$diameter <- (dataout_agg_agg$width + dataout_agg_agg$height)/2

# Plot aggregate results
plot(width ~ index, data = dataout_agg_agg, type = "l", frame.plot = F, xaxt = "n", main = paste("Width"), ylim = c(0.1, 0.3), xlab = "Time, s", ylab = "Diameter, cm")
axis(1, at = c(0, 40, 140), labels = c(-4, 0, 10))
plot(height ~ index, data = dataout_agg_agg, type = "l", frame.plot = F, xaxt = "n", main = paste("Height"), ylim = c(0.1, 0.3), xlab = "Time, s", ylab = "Diameter, cm")
axis(1, at = c(0, 40, 140), labels = c(-4, 0, 10))
plot(diameter ~ index, data = dataout_agg_agg, type = "l", frame.plot = F, xaxt = "n", main = paste("Diameter"), ylim = c(0.1, 0.3), xlab = "Time, s", ylab = "Diameter, cm")
axis(1, at = c(0, 40, 140), labels = c(-4, 0, 10))

# This is the plot that goes into the data descriptor manuscript
pdf(file = "C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/Eyetracking/agg_timecourse.pdf")
plot(diameter ~ index, data = dataout_agg_agg, type = "n", frame.plot = F, xaxt = "n", yaxt = "n", main = "", ylim = c(0.16, 0.19), xlab = "Time, s", ylab = "Diameter, cm")
abline(v = 95, lty = 2)
polygon(x = c(40, 40, 75, 75), y = c(1, 0, 0, 1), col = "gray", border = "gray")
axis(1, at = c(0, 40, 75, 95, 140), labels = c(-4, 0, 3.5, 5.5, 10))
axis(2, at = c(0.16, 0.17, 0.18, 0.19))
lines(diameter ~ index, data = dataout_agg_agg)
dev.off()

# Aggregate by stimulus type
dataout_agg_stimulus <- NULL
for (i in unique(data_out$subject)){
  cutout2 <- data_out[data_out$subject == i, ]
  cutout2_agg_stimulus <- aggregate(cbind(height, width) ~ index + stimulus, data = cutout2, FUN = "mean")
  if(exists("dataout_agg_stimulus") == FALSE){
    dataout_agg_stimulus <- cutout2_agg_stimulus
  } else {
    dataout_agg_stimulus <- rbind(dataout_agg_stimulus, cutout2_agg_stimulus)
  }
}

dataout_nopain_agg <- aggregate(cbind(height, width) ~ index, data = dataout_agg_stimulus[dataout_agg_stimulus$stimulus == "No_Pain", ], FUN = "mean")
dataout_nopain_agg$diameter <- (dataout_nopain_agg$width + dataout_nopain_agg$height)/2
dataout_pain_agg <- aggregate(cbind(height, width) ~ index, data = dataout_agg_stimulus[dataout_agg_stimulus$stimulus == "Pain", ], FUN = "mean")
dataout_pain_agg$diameter <- (dataout_pain_agg$width + dataout_pain_agg$height)/2

plot(diameter ~ index, data = dataout_nopain_agg, type = "l", frame.plot = F, xaxt = "n", main = paste("Diameter"), ylim = c(0.1, 0.3), xlab = "Time, s", ylab = "Diameter, cm", col = "blue")
axis(1, at = c(0, 40, 75, 95, 140), labels = c(-4, 0, 3.5, 5.5, 10))
lines(diameter ~ index, data = dataout_pain_agg, col = "red")
legend("topleft", lty = 1, legend = c("No pain", "Pain"), col = c("blue", "red"), bty = "n")

plot(diameter ~ index, data = dataout_nopain_agg, type = "l", frame.plot = F, xaxt = "n", main = paste("Pupil diameter"), ylim = c(0.15, 0.19), xlab = "Time, s", ylab = "Diameter, cm", col = "blue")
axis(1, at = c(0, 40, 75, 95, 140), labels = c(-4, 0, 3.5, 5.5, 10))
lines(diameter ~ index, data = dataout_pain_agg, col = "red")
legend("topleft", lty = 1, legend = c("No pain", "Pain"), col = c("blue", "red"), bty = "n")

# Aggregate by sleep condition
dataout_agg_session <- NULL
for (i in unique(data_out$subject)){
  cutout5 <- data_out[data_out$subject == i, ]
  cutout5_agg_session <- aggregate(cbind(height, width) ~ subject + date + index, data = cutout5, FUN = "mean")
  if(exists("dataout_agg_session") == FALSE){
    dataout_agg_session <- cutout5_agg_session
  } else {
    dataout_agg_session <- rbind(dataout_agg_session, cutout5_agg_session)
  }
}
dataout_agg_session$diameter <- (dataout_agg_session$width + dataout_agg_session$height)/2
dataout_agg_session <- merge(dataout_agg_session, demographics[, c("Subject", "AgeGroup", "Sex", "DateSession1", "DateSession2")], by.x = "subject", by.y = "Subject")
dataout_agg_session <- merge(dataout_agg_session, randomisation[, c("Subject", "Sl_cond")], by.x = "subject", by.y = "Subject")
dataout_agg_session$session <- NA
dataout_agg_session$session[dataout_agg_session$date == dataout_agg_session$DateSession1] <- 1
dataout_agg_session$session[dataout_agg_session$date == dataout_agg_session$DateSession2] <- 2
anyNA(dataout_agg_session) # Should evaluate to FALSE
dataout_agg_session$condition <- NA
dataout_agg_session$condition[dataout_agg_session$session == 1 & dataout_agg_session$Sl_cond == 1] <- "SleepDeprived"
dataout_agg_session$condition[dataout_agg_session$session == 1 & dataout_agg_session$Sl_cond == 2] <- "FullSleep"
dataout_agg_session$condition[dataout_agg_session$session == 2 & dataout_agg_session$Sl_cond == 2] <- "SleepDeprived"
dataout_agg_session$condition[dataout_agg_session$session == 2 & dataout_agg_session$Sl_cond == 1] <- "FullSleep"
anyNA(dataout_agg_session)
dataout_agg_fullsleep <- aggregate(diameter ~ index, data = dataout_agg_session[dataout_agg_session$condition == "FullSleep", ], FUN = "mean")
dataout_agg_sleepdeprived <- aggregate(diameter ~ index, data = dataout_agg_session[dataout_agg_session$condition == "SleepDeprived", ], FUN = "mean")

plot(diameter ~ index, data = dataout_agg_fullsleep, type = "l", frame.plot = F, xaxt = "n", main = paste("Pupil diameter"), ylim = c(0.15, 0.19), xlab = "Time, s", ylab = "Diameter, cm", col = "darkgreen")
axis(1, at = c(0, 40, 75, 95, 140), labels = c(-4, 0, 3.5, 5.5, 10))
lines(diameter ~ index, data = dataout_agg_sleepdeprived, col = "orange")
legend("topleft", lty = 1, legend = c("Full sleep", "Sleep deprived"), col = c("darkgreen", "orange"), bty = "n")

# Index data by mean diameter during anticipation for each response
while(anyNA(data_out$height)){ # Impute missing values by last known value
  impute_height <- which(is.na(data_out$height))
  data_out$height[impute_height] <- data_out$height[impute_height - 1]
}
while(anyNA(data_out$width)){
  impute_width <- which(is.na(data_out$width))
  data_out$width[impute_width] <- data_out$width[impute_width - 1]
}
data_out$diameter <- (data_out$height + data_out$width)/2
data_delta <- NULL
for (i in unique(data_out$subject)){
  for (j in unique(data_out$event_no[data_out$subject == i])){
    cutout3 <- data_out[data_out$subject == i & data_out$event_no == j, ]
    cutout3$delta_diameter <- cutout3$diameter - mean(cutout3$diameter[1:40])
    if(exists("data_delta") == FALSE){
      data_delta <- cutout3
    } else {
      data_delta <- rbind(data_delta, cutout3)
    }
  }
}

# Check plot
data_delta_agg <- NULL
for (i in unique(data_delta$subject)){
  cutout4 <- data_delta[data_delta$subject == i, ]
  cutout4_agg <- aggregate(delta_diameter ~ index, data = cutout4, FUN = "mean")
  if(exists("data_delta_agg") == FALSE){
    data_delta_agg <- cutout4_agg
  } else {
    data_delta_agg <- rbind(data_delta_agg, cutout4_agg)
  }
}
data_delta_agg_agg <- aggregate(delta_diameter ~ index, data = data_delta_agg, FUN = "mean")
plot(delta_diameter ~ index, data = data_delta_agg_agg, type = "l", frame.plot = F, xaxt = "n", main = paste("Diameter"), xlab = "Time, s", ylab = "Delta diameter, cm")
axis(1, at = c(0, 40, 140), labels = c(-4, 0, 10))

# Make data frame with mean responses for each event
data_eventmeans <- NULL
for (i in unique(data_delta$subject)){
  for (j in unique(data_delta$event_no[data_delta$subject == i])){
    cutout5 <- data_delta[data_delta$subject == i & data_delta$event_no == j, ]
    eventmeans <- data.frame(subject = cutout5$subject[1], date = cutout5$date[1], 
                             event_no <- cutout5$event_no[1], stimulus <- cutout5$stimulus[1],
                             mean_event <- mean(cutout5$delta_diameter[41:75]), mean_postevent <- mean(cutout5$delta_diameter[76:95]))
    if(exists("data_eventmeans") == FALSE){
      data_eventmeans <- eventmeans
    } else {
      data_eventmeans <- rbind(data_eventmeans, eventmeans)
    }
  }
}
names(data_eventmeans) <- c("subject", "date", "event_no", "stimulus", "mean_event", "mean_postevent")

data_eventmeans2 <- merge(data_eventmeans, demographics[, c("Subject", "AgeGroup", "Sex", "DateSession1", "DateSession2")], by.x = "subject", by.y = "Subject")
data_eventmeans2 <- merge(data_eventmeans2, randomisation[, c("Subject", "Sl_cond")], by.x = "subject", by.y = "Subject")
data_eventmeans2$session <- NA
data_eventmeans2$session[data_eventmeans2$date == data_eventmeans2$DateSession1] <- 1
data_eventmeans2$session[data_eventmeans2$date == data_eventmeans2$DateSession2] <- 2
anyNA(data_eventmeans2) # Should evaluate to FALSE
data_eventmeans2$condition <- NA
data_eventmeans2$condition[data_eventmeans2$session == 1 & data_eventmeans2$Sl_cond == 1] <- "SleepDeprived"
data_eventmeans2$condition[data_eventmeans2$session == 1 & data_eventmeans2$Sl_cond == 2] <- "FullSleep"
data_eventmeans2$condition[data_eventmeans2$session == 2 & data_eventmeans2$Sl_cond == 2] <- "SleepDeprived"
data_eventmeans2$condition[data_eventmeans2$session == 2 & data_eventmeans2$Sl_cond == 1] <- "FullSleep"
anyNA(data_eventmeans2)
data_eventmeans2$condition <- relevel(as.factor(data_eventmeans2$condition), ref = "FullSleep")

# Build models
# First model is without pain/no pain stimulus and sleep condition for purpose of technical validation
lme1 <- lme(mean_event ~ 1, data = data_eventmeans2, random = ~ 1|subject/session, na.action = na.omit)
summary(lme1)
intervals(lme1)

lme2 <- lme(mean_event ~ stimulus*condition, data = data_eventmeans2, random = ~ 1|subject)
summary(lme2)
intervals(lme2)
plot(effect("stimulus*condition", lme2))

lme3 <- lme(mean_postevent ~ stimulus*condition*AgeGroup, data = data_eventmeans2, random = ~ 1|subject)
summary(lme3)
plot(effect("stimulus*condition*AgeGroup", lme3))

# Determine variability
data_eventsd <- aggregate(mean_event ~ subject + stimulus + condition, data = data_eventmeans2, FUN = sd)
lme3 <- lme(mean_event ~ stimulus*condition, data = data_eventsd, random = ~1|subject, na.action = na.omit)
summary(lme3)
