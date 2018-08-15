# Script to analyse eye-tracking in the HANDS experiment
# Gustav Nilsonne 2016-06-01
# Adapted for ARROWS 180630

# Require packages
require(nlme)
require(effects)
require(RColorBrewer)
cols <- brewer.pal(n = 5, name = "Dark2")

# Import files
demographics <- read.csv("~/Box Sync/Sleepy Brain/Datafiles/150215_Demographic.csv", sep=";", dec=",")
randomisation <- read.csv("~/Box Sync/Sleepy Brain/Datafiles/RandomisationList_140804.csv", sep=";")

setwd("~/Box Sync/Sleepy Brain/Datafiles/Viewpoint_files_corrected")
ViewpointFilesARROWS <- list.files(pattern = "ARROWS")


# List included subjects
IncludedSubjects <- read.table("../SubjectsForARROWS.csv", sep=";", header=T)
IncludedSubjects <- as.integer(IncludedSubjects$AnyARROWSRatings) 
IncludedSubjectsViewpointARROWS <- IncludedSubjects


setwd("~/Box Sync/Sleepy Brain/Datafiles")

# Get onset times for stimuli 
OnsetTimesForAll <- list()
AllOnsetFiles <- list.files("Presentation_logfiles/", pattern = "ARROWS_sce.log", recursive = T)
AllStimulusFiles <- list.files("Presentation_logfiles/", pattern = "ARROWS_log.txt", recursive = T)

# Remove times for non-included subjects
getSubjectFromFileName <- function (filename) {
  return(as.integer(substr(filename, 1, 3)))
}

AllOnsetFiles = AllOnsetFiles[unlist(lapply(AllOnsetFiles, getSubjectFromFileName)) %in% IncludedSubjectsViewpointARROWS]
AllStimulusFiles = AllStimulusFiles[unlist(lapply(AllStimulusFiles, getSubjectFromFileName)) %in% IncludedSubjectsViewpointARROWS]

# Find onset times
for(i in 1:length(AllOnsetFiles)){
  OnsetTime <- read.table(paste("Presentation_logfiles/", AllOnsetFiles[i], sep = ""), header=F, quote="\"", fill=TRUE, blank.lines.skip=FALSE)
  OnsetTime <- subset(OnsetTime, V1 == "Picture")
  OnsetTime <- OnsetTime[ , c(2,4)]
  OnsetTime$File <- AllOnsetFiles[i]
  OnsetTime$Subject <- as.integer(substr(OnsetTime$File, 1, 3)) 
  OnsetTime$Date <- as.integer(substr(OnsetTime$File, 5, 10))
  OnsetTime <- subset(OnsetTime, V2 == "Pic")
  OnsetTime$V4 <- as.numeric(as.character(OnsetTime$V4))/10000
  if(i == 62){ # Ugly hack (credit to GN) to handle sessions with fewer than 60 events recorded
     for(i in 1:44){
       OnsetTime <- rbind(OnsetTime, rep(NA, 5))
     }
    }
  if(i == 132){
    for(i in 1:18){
      OnsetTime <- rbind(OnsetTime, rep(NA, 5))
    }
  }
  StimulusType <- read.delim(paste("Presentation_logfiles/", AllStimulusFiles[i], sep = ""))
  OnsetTimeAndStimulus <- cbind(OnsetTime, StimulusType) 
  OnsetTimeAndStimulus <- OnsetTimeAndStimulus[ , c("V4", "StimulusType", "RatedSuccessOfRegulation", "Subject", "Date")]
  OnsetTimeAndStimulus$StimulusType[OnsetTimeAndStimulus$StimulusType == 1] <- "MaintainNegative"
  OnsetTimeAndStimulus$StimulusType[OnsetTimeAndStimulus$StimulusType == 2] <- "UpregulateNegative"
  OnsetTimeAndStimulus$StimulusType[OnsetTimeAndStimulus$StimulusType == 3] <- "DownregulateNegative"
  OnsetTimeAndStimulus$StimulusType[OnsetTimeAndStimulus$StimulusType == 4] <- "MaintainNeutral"
  if(!is.na(OnsetTime$Subject[1]) && OnsetTime$Subject[1] %in% as.integer(IncludedSubjects) ){
    OnsetTimesForAll[[length(OnsetTimesForAll)+1]] <- OnsetTimeAndStimulus
  }
}

Vpfiles_df <- data.frame(filenames = ViewpointFilesARROWS, subject = substr(ViewpointFilesARROWS, 1, 3), date = substr(ViewpointFilesARROWS, 5, 10))
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

# Manually enter session numbers for subjects with only one included session. 


Vpfiles_df$session[Vpfiles_df$subject == 86] <- 2
Vpfiles_df$session[Vpfiles_df$subject == 104] <- 1
Vpfiles_df$session[Vpfiles_df$subject == 115] <- 2
Vpfiles_df$session[Vpfiles_df$subject == 135] <- 1
Vpfiles_df$session[Vpfiles_df$subject == 160] <- 1
Vpfiles_df$session[Vpfiles_df$subject == 263] <- 1
Vpfiles_df$session[Vpfiles_df$subject == 299] <- 2
Vpfiles_df$session[Vpfiles_df$subject == 324] <- 1
Vpfiles_df$session[Vpfiles_df$subject == 389] <- 2
Vpfiles_df$session[Vpfiles_df$subject == 460] <- 2
Vpfiles_df$session[Vpfiles_df$subject == 496] <- 1

Vpfiles_df <- Vpfiles_df[Vpfiles_df$subject %in% IncludedSubjectsViewpointARROWS, ]

# Cut out data for all included files
setwd("~/Box Sync/Sleepy Brain/Datafiles/Viewpoint_files_corrected")
data_out <- NULL
onsets <- vector()
indices <- 1:length(OnsetTimesForAll)
# Subject 197_131128 removed, since height and width have the same value all the way
# Subject 276_140127 removed, to many values excluded
# Subject 352_140120 removed, to many values excluded
# Subject 376_140128 removed, to many values excluded
indices <- indices[c(-27, -34, -35, -62, -68, -95, -101, -111, -120, -121, -125, -132)] # Do not read when file is nonexistent or cannot be processed
for(i in indices){
  temp <- OnsetTimesForAll[[i]]
  subject <- temp$Subject[1]
  date <- temp$Date[1]
  session <- Vpfiles_df$session[Vpfiles_df$subject == subject & Vpfiles_df$date == date]
  
  thisVpfile <- as.character(Vpfiles_df$filenames[Vpfiles_df$subject == subject & Vpfiles_df$date == date])
  nlines <- length(readLines(thisVpfile)) # To enable skipping reading of final line, which is often incomplete
  data <- read.table(thisVpfile, skip = 28, nrows = nlines - 29) # Skip header lines as well as last line
  
  data <- data.frame(apply(data, 2, as.numeric)) # Using apply function to coerce to numeric
  data <- data[complete.cases(data),] # Remove cases with NA
  if(length(data) > 11){ # Sometimes logfiles have things that cause an additional column to appear. This removes it.
    data <- data[, c(1:11)]
  }
  data <- data[complete.cases(data),] # Remove rows with NA:s
  data <- data[, c(2, 7, 8)] # Keep only time + height + width
  names(data) <- c("time", "width", "height")
  
  data$width_full <- data$width
  data$height_full <- data$height
  
  data$diff_width <- c(diff(data$width)/diff(data$time), NA)
  data$diff_height <- c(diff(data$height)/diff(data$time), NA)
  
  indexforrejection <- (data$diff_width < - 3) | (data$diff_width > 3) | (data$diff_height < - 3) | (data$diff_height > 3)
  neighbouringindices <- unique(which(indexforrejection), which(indexforrejection)-1, which(indexforrejection)+1)
  indexforrejection[neighbouringindices] <- TRUE
  
  data$width[indexforrejection] <- NA
  data$height[indexforrejection] <- NA
  
  data$width[data$width < 0.1] <- NA
  data$height[data$height < 0.1] <- NA
  data$width[data$width > 0.3] <- NA
  data$height[data$height > 0.3] <- NA
  width_lo001 <- loess(data$width ~ data$time, span = 0.01)
  height_lo001 <- loess(data$height ~ data$time, span = 0.01)
  data$width_lo001 <- predict(width_lo001, data$time)
  data$height_lo001 <- predict(height_lo001, data$time)
  
  # Cut pieces of data that start 6 seconds before stimulus (4 s before arrows) and ends 16 s after
  
  for(j in 1:length(temp$V4)){
    thisonset <- temp$V4[j]
    cutout_start <- which(abs(data$time - (thisonset - 6)) == min(abs(data$time - (thisonset- 6)))) # Sampling was at 60 Hz
    cutout_end <- which(abs(data$time - (thisonset + 16)) == min(abs(data$time - (thisonset + 16))))
    if(length(cutout_start) > 1){cutout_start <- cutout_start[1]} # Fix case where cutout_start has lenght 2
    if(length(cutout_end) > 1){cutout_end <- cutout_end[1]}
    cutout <- data.frame(subject = subject, date = date, session = NA, event_no = j, stimulus = 
                           temp$StimulusType[j], width = data$width_lo001[seq(cutout_start, cutout_end, 6)], height = data$height_lo001[seq(cutout_start, cutout_end, 6)])
    rejected <- FALSE
    flag <- ""
    if(sum(is.na(data$width[cutout_start:cutout_end])) > 0.5*length(data$width[cutout_start:cutout_end]) | sum(is.na(data$height[cutout_start:cutout_end])) > 0.5*length(data$height[cutout_start:cutout_end])){
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

write.csv2(data_out, file = "../Eyetracking_ARROWS/data_out.csv", row.names=FALSE)
write.csv2(onsets, file = "../Eyetracking_ARROWS/onsets.csv", row.names=FALSE)

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
plot(width ~ index, data = dataout_agg_agg, type = "l", frame.plot = F, xaxt = "n", main = paste("Width"), ylim = c(0.15, 0.2), xlab = "", ylab = "Diameter, cm")
axis(1, at = c(0, 40, 60, 110, 130, 220), labels = c("", "Arrow", "Picture", "Blank", "Rating", ""))
plot(height ~ index, data = dataout_agg_agg, type = "l", frame.plot = F, xaxt = "n", main = paste("Height"), ylim = c(0.15, 0.2), xlab = "", ylab = "Diameter, cm")
axis(1, at = c(0, 40, 60, 110, 130, 220), labels = c("", "Arrow", "Picture", "Blank", "Rating", ""))
plot(diameter ~ index, data = dataout_agg_agg, type = "l", frame.plot = F, xaxt = "n", main = paste("Diameter"), ylim = c(0.16, 0.19), xlab = "", ylab = "Diameter, cm")
axis(1, at = c(0, 40, 60, 110, 130, 220), labels = c("", "Arrow", "Picture", "Blank", "Rating", ""))


#pdf(file = "C:/Users/gusta/Box Sync/Sleepy Brain/Datafiles/Eyetracking/agg_timecourse.pdf")
plot(diameter ~ index, data = dataout_agg_agg, type = "n", frame.plot = F, xaxt = "n", yaxt = "n", main = "", ylim = c(0.16, 0.19), xlab = "", ylab = "Diameter, cm")
polygon(x = c(40, 40, 60, 60), y = c(2, 0, 0, 2), density = NULL, border = NULL, col = "gray", lty = 0)
polygon(x = c(60, 60, 110, 110), y = c(2, 0, 0, 2), density = NULL, border = NULL, col = "#FFCCCC", lty = 0)
abline(v = 130, lty = 2)
axis(1, at = c(0, 40, 60, 110, 130, 220), labels = c("", "Arrow", "Picture", "Blank", "Rating", ""))
axis(2, at = c(0.16, 0.17, 0.18, 0.19))
lines(diameter ~ index, data = dataout_agg_agg)
#dev.off()

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

dataout_MaintainNeutral_agg <- aggregate(cbind(height, width) ~ index, data = dataout_agg_stimulus[dataout_agg_stimulus$stimulus == "MaintainNeutral", ], FUN = "mean")
dataout_MaintainNeutral_agg$diameter <- (dataout_MaintainNeutral_agg$width + dataout_MaintainNeutral_agg$height)/2

dataout_MaintainNegative_agg <- aggregate(cbind(height, width) ~ index, data = dataout_agg_stimulus[dataout_agg_stimulus$stimulus == "MaintainNegative", ], FUN = "mean")
dataout_MaintainNegative_agg$diameter <- (dataout_MaintainNegative_agg$width + dataout_MaintainNegative_agg$height)/2

dataout_DownregulateNegative_agg <- aggregate(cbind(height, width) ~ index, data = dataout_agg_stimulus[dataout_agg_stimulus$stimulus == "DownregulateNegative", ], FUN = "mean")
dataout_DownregulateNegative_agg$diameter <- (dataout_DownregulateNegative_agg$width + dataout_DownregulateNegative_agg$height)/2

dataout_UpregulateNegative_agg <- aggregate(cbind(height, width) ~ index, data = dataout_agg_stimulus[dataout_agg_stimulus$stimulus == "UpregulateNegative", ], FUN = "mean")
dataout_UpregulateNegative_agg$diameter <- (dataout_UpregulateNegative_agg$width + dataout_UpregulateNegative_agg$height)/2


plot(diameter ~ index, data = dataout_MaintainNeutral_agg, type = "l", frame.plot = F, xaxt = "n", 
     ylim = c(0.17, 0.19), xlab = "", ylab = "Pupil diameter, cm", col = "#46237A",
     lwd = 2)
axis(1, at = c(0, 40, 60, 110, 130, 220), labels = c("", "Arrow", "Picture", "Blank", "Rating", ""))
polygon(x = c(40, 40, 60, 60), y = c(2, 0, 0, 2), density = NULL, border = NULL, col = "#EEEEEE", lty = 0)
polygon(x = c(60, 60, 110, 110), y = c(2, 0, 0, 2), density = NULL, border = NULL, col = "#FFEEEE", lty = 0)
abline(v = 130, lty = 2)
lines(diameter ~ index, data = dataout_MaintainNeutral_agg, col = "#46237A", lwd = 2)
lines(diameter ~ index, data = dataout_MaintainNegative_agg, col = "#256EFF", lwd = 2)
lines(diameter ~ index, data = dataout_DownregulateNegative_agg, col = "#3DDC97", lwd = 2)
lines(diameter ~ index, data = dataout_UpregulateNegative_agg, col = "#FF495C", lwd = 2)
legend("topleft", lty = 1, legend = c("MaintainNeutral", "MaintainNegative", "DownregulateNegative", "UpregulateNegative"), 
       col = c("#46237A", "#256EFF", "#3DDC97", "#FF495C"), bty = "n")


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

plot(diameter ~ index, data = dataout_agg_fullsleep, type = "l", frame.plot = F, xaxt = "n", 
     main = paste("Pupil diameter"), ylim = c(0.15, 0.19), 
     xlab = "Time", ylab = "Diameter, cm", col = "blue", lwd = 2)
axis(1, at = c(0, 40, 60, 110, 130, 220), labels = c("", "Arrow", "Picture", "Blank", "Rating", ""))
polygon(x = c(40, 40, 60, 60), y = c(2, 0, 0, 2), density = NULL, border = NULL, col = "gray", lty = 0)
polygon(x = c(60, 60, 110, 110), y = c(2, 0, 0, 2), density = NULL, border = NULL, col = "#FFCCCC", lty = 0)
abline(v = 130, lty = 2)
lines(diameter ~ index, data = dataout_agg_fullsleep, col = "blue", lwd = 2)
lines(diameter ~ index, data = dataout_agg_sleepdeprived, col = "red", lwd = 2)
legend("topleft", lty = 1, legend = c("Full sleep", "Sleep deprived"), col = c("blue", "red"), bty = "n", lwd = 2)



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

# Removesubject 436 that only has 1 observation 
data_delta <- subset(data_delta, subject != "436")
data_delta <- subset(data_delta, subject != "446")
                              
# Check plot. Does not work for 436?
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
plot(delta_diameter ~ index, data = data_delta_agg_agg, type = "l", frame.plot = F, xaxt = "n", main = paste("Diameter"), xlab = "Time", ylab = "Delta diameter, cm")
axis(1, at = c(0, 40, 60, 110, 130, 220), labels = c("", "Arrow", "Picture", "Blank", "Rating", ""))

# Make data frame with mean responses for each event
data_eventmeans <- NULL
for (i in unique(data_delta$subject)){
  for (j in unique(data_delta$event_no[data_delta$subject == i])){
    cutout5 <- data_delta[data_delta$subject == i & data_delta$event_no == j, ]
    eventmeans <- data.frame(subject = cutout5$subject[1], date = cutout5$date[1], 
                             event_no <- cutout5$event_no[1], stimulus <- cutout5$stimulus[1],
                             mean_event <- mean(cutout5$delta_diameter[61:110]), mean_postevent <- mean(cutout5$delta_diameter[111:130]))
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
anyNA(data_eventmeans2) # Should evaluate to FALSE. Does not
data_eventmeans2$condition <- NA
data_eventmeans2$condition[data_eventmeans2$session == 1 & data_eventmeans2$Sl_cond == 1] <- "SleepDeprived"
data_eventmeans2$condition[data_eventmeans2$session == 1 & data_eventmeans2$Sl_cond == 2] <- "FullSleep"
data_eventmeans2$condition[data_eventmeans2$session == 2 & data_eventmeans2$Sl_cond == 2] <- "SleepDeprived"
data_eventmeans2$condition[data_eventmeans2$session == 2 & data_eventmeans2$Sl_cond == 1] <- "FullSleep"
anyNA(data_eventmeans2)
data_eventmeans2$condition <- relevel(as.factor(data_eventmeans2$condition), ref = "FullSleep")
data_eventmeans2$AgeGroup <- relevel(as.factor(data_eventmeans2$AgeGroup), ref = "Young")



# Contrast coding
contrasts(data_eventmeans2$AgeGroup) <- rbind(-.5, .5)
colnames(contrasts(data_eventmeans2$AgeGroup)) <- levels(data_eventmeans2$AgeGroup)[2]
contrasts(data_eventmeans2$condition) <- rbind(-.5, .5)
colnames(contrasts(data_eventmeans2$condition)) <- levels(data_eventmeans2$condition)[2]

# Build models
# First model is without stimulus type and sleep condition for purpose of technical validation
lme1 <- lme(mean_event ~ 1, data = data_eventmeans2, random = ~ 1|subject/session, na.action = na.omit)
summary(lme1)
intervals(lme1, which = "fixed")

lme2 <- lme(mean_event ~ stimulus*condition, data = data_eventmeans2, random = ~ 1|subject, na.action = na.omit)
summary(lme2)
intervals_lme2 <- intervals(lme2)
plot(effect("stimulus*condition", lme2))
setwd("~/Box Sync/Sleepy Brain/Datafiles/Eyetracking_ARROWS/")
write.csv2(summary(lme2)$tTable, file = "Reduced_model.csv")
write.csv2(intervals_lme2$fixed, file = "Reduced_model_intervals.csv")

lme3 <- lme(mean_postevent ~ stimulus*condition*AgeGroup, data = data_eventmeans2, random = ~ 1|subject,
            na.action = na.omit)
summary(lme3)
intervals_lme3 <- intervals(lme3)
plot(effect("stimulus*condition*AgeGroup", lme3), main = "", ylab = "Mean pupil diameter change")
write.csv2(summary(lme3)$tTable, file = "Full_model.csv")
write.csv2(intervals_lme3$fixed, file = "Full_model_intervals.csv")


