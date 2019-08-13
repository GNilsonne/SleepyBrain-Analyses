# Script to analyse eye-tracking in the HANDS experiment
# Gustav Nilsonne 2017-05-16
# Acapted for FACES 2018-08-27

# Require packages
require(nlme)
require(effects)

# Import files
demographics <- read.csv("~/Box Sync/Sleepy Brain/Datafiles/150215_Demographic.csv", sep=";", dec=",")
randomisation <- read.csv("~/Box Sync/Sleepy Brain/Datafiles/RandomisationList_140804.csv", sep=";")

setwd("~/Box Sync/Sleepy Brain/Datafiles/Viewpoint_FACES_corrected/")
ViewpointFilesFaces <- list.files(pattern = "FACES")

# Some files were corrupted. In the HANDS experiment, I went through the files and manually deleted the corrupted lines.
# Here I wrote a script in shell that removed all rows that have something non-numerical in it
# for x in $(ls Viewpoint_files | grep FACES); do cat Viewpoint_files/$x | grep -E "^(\\d|\\.|-|\\t| )+$" > Viewpoint_FACES_corrected/$x; done

ViewpointDataFaces <- data.frame()
for (i in 1:length(ViewpointFilesFaces)){
  nlines <- length(readLines(ViewpointFilesFaces[i])) # To enable skipping reading of final line, which is often incomplete
  temp <- read.table(ViewpointFilesFaces[i], skip = 28, nrows = nlines - 29, fill = T) # Skip header lines as well as last line
  temp <- data.frame(apply(temp, 2, as.numeric)) # Using apply function to coerce to numeric
  temp <- temp[complete.cases(temp),] # Remove rows with NA:s
  temp <- temp[, c(2, 7, 8)] # Keep only time + height + width
  temp$File <- ViewpointFilesFaces[i]
  ViewpointDataFaces <- rbind(ViewpointDataFaces, temp)
}
names(ViewpointDataFaces) <- c("time_s", "width", "height", "filename")

# Extract subject
ViewpointDataFaces$Subject <- as.integer(substr(ViewpointDataFaces$filename, 1, 3))

# Extract date
ViewpointDataFaces$Date <- as.Date(as.character(substr(ViewpointDataFaces$filename, 5, 10)), "%y%m%d")

# List included subjects 
IncludedSubjects <- read.table("../Subjects_151215.csv", sep=";", header=T)
IncludedSubjects <- as.integer(IncludedSubjects$CanBeIncludedForInterventionEffects)
#IncludedSubjects <- as.integer(IncludedSubjects$FulfillsCriteriaAndNoPathologicalFinding) # This is for the purpose of quality review.


# Retain only subjects in list
ViewpointDataFaces <- ViewpointDataFaces[ViewpointDataFaces$Subject %in% as.integer(IncludedSubjects), ]

# Plot data to se that all subjects have registrations of approximatly the same length  
plot(ViewpointDataFaces$time_s, type="l", xlab = "Row", ylab = "Time (s)")

IncludedSubjectsViewpointFaces <- unique(ViewpointDataFaces$Subject)
length(unique(ViewpointDataFaces$Subject))


write.csv2(ViewpointDataFaces, file = "../Eyetracking_FACES/ViepointDataFaces.csv", row.names=FALSE)
write.csv2(IncludedSubjectsViewpointFaces, file = "../IncludedSubjectsViewpointFaces.csv", row.names=FALSE)



# Get onset times for stimuli 
setwd("~/Box Sync/Sleepy Brain/Datafiles")
OnsetTimesForAll <- list()
AllOnsetFiles <- list.files("Presentation_logfiles/", pattern = "FACES_sce.log", recursive = T)
AllStimulusFiles <- list.files("Presentation_logfiles/", pattern = "FACES_log.txt", recursive = T)

# Remove times for non-included subjects
getSubjectFromFileName <- function (filename) {
  return(as.integer(substr(filename, 1, 3)))
}

AllOnsetFiles = AllOnsetFiles[unlist(lapply(AllOnsetFiles, getSubjectFromFileName)) %in% IncludedSubjectsViewpointFaces]
# AllStimulusFiles = AllStimulusFiles[unlist(lapply(AllStimulusFiles, getSubjectFromFileName)) %in% IncludedSubjectsViewpointFaces]

# Find onset times
for(i in 1:length(AllOnsetFiles)){
  OnsetTime <- read.table(paste("Presentation_logfiles/",AllOnsetFiles[i], sep = ""), header=F, quote="\"", fill=TRUE, blank.lines.skip=FALSE)
  OnsetTime <- subset(OnsetTime, V1 == "Picture")
  OnsetTime <- OnsetTime[ , c(2,4)]
  OnsetTime$File <- AllOnsetFiles[i]
  OnsetTime$Subject <- as.integer(substr(OnsetTime$File, 1, 3)) 
  OnsetTime$Date <- as.integer(substr(OnsetTime$File, 5, 10))
  OnsetTime <- subset(OnsetTime, V2 == "happy" | V2 == "neutral" | V2 == "angry")
  OnsetTime$V4 <- as.numeric(as.character(OnsetTime$V4))/10000
  OnsetTime$temp <- c("x", as.character(OnsetTime$V2[1:239])) 
  OnsetTime$temp2 <- ifelse(OnsetTime$temp == OnsetTime$V2, 1, 2)
  OnsetTime <- subset(OnsetTime, OnsetTime$temp2 == 2)
  OnsetTime <- OnsetTime[ , 1:5]
  #OnsetTime$BlockType <- OnsetTime$V2
  if(!is.na(OnsetTime$Subject[1]) && OnsetTime$Subject[1] %in% as.integer(IncludedSubjects) ){
    OnsetTimesForAll[[length(OnsetTimesForAll)+1]] <- OnsetTime
  }
}


# Add session to onset time matrix
FunGetSubject <- function(x){return(x$Subject[1])}
DoubleSubjects <- unlist(lapply(OnsetTimesForAll, FunGetSubject))
DoubleSubjectsTemp <- c(NA, DoubleSubjects)
DoubleSubjects <- c(DoubleSubjects, NA)
Session2 <- DoubleSubjects == DoubleSubjectsTemp 

for(i in 1:length(OnsetTimesForAll)){
  if(isTRUE(Session2[i])){
    OnsetTimesForAll[[i]]$Session <- 2
  }else{
    OnsetTimesForAll[[i]]$Session <- 1     
  }
}

# Define session numbers
Vpfiles_df <- data.frame(filenames = ViewpointFilesFaces, subject = substr(ViewpointFilesFaces, 1, 3), date = substr(ViewpointFilesFaces, 5, 10))
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
Vpfiles_df$session[Vpfiles_df$subject == 86] <- 2
Vpfiles_df$session[Vpfiles_df$subject == 104] <- 1
Vpfiles_df$session[Vpfiles_df$subject == 115] <- 2
Vpfiles_df$session[Vpfiles_df$subject == 135] <- 1
Vpfiles_df$session[Vpfiles_df$subject == 160] <- 1
Vpfiles_df$session[Vpfiles_df$subject == 165] <- 2
Vpfiles_df$session[Vpfiles_df$subject == 188] <- 2
Vpfiles_df$session[Vpfiles_df$subject == 263] <- 1
Vpfiles_df$session[Vpfiles_df$subject == 299] <- 2
Vpfiles_df$session[Vpfiles_df$subject == 324] <- 1
Vpfiles_df$session[Vpfiles_df$subject == 496] <- 1

Vpfiles_df <- Vpfiles_df[Vpfiles_df$subject %in% IncludedSubjectsViewpointFaces, ]

# Cut out data for all included files
setwd("~/Box Sync/Sleepy Brain/Datafiles/Viewpoint_FACES_corrected/")
data_out <- NULL
onsets <- vector()
indices <- 1:length(OnsetTimesForAll)
# Some of these files exist, but I can't see why they don't work
indices <- indices[c(-19, -24, -25, -39, -43, -52, -54, -60, -64, -83, -84, -97, -100, 
                     -107)] 

for(i in indices){
  temp <- OnsetTimesForAll[[i]]
  subject <- temp$Subject[1]
  date <- temp$Date[1]
  session <- Vpfiles_df$session[Vpfiles_df$subject == subject & Vpfiles_df$date == date]
  
  thisVpfile <- as.character(Vpfiles_df$filenames[Vpfiles_df$subject == subject & Vpfiles_df$date == date])
  #nlines <- length(readLines(thisVpfile)) # To enable skipping reading of final line, which is often incomplete
  data <- read.table(thisVpfile, skip = 3) # Skip header lines as well as last line
  
  data <- data.frame(apply(data, 2, as.numeric)) # Using apply function to coerce to numeric
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

  # Remove participants weith less data than 50 %
  if(sum(is.na(data$width)) > 0.5*length(data$width) | sum(is.na(data$height)) > 0.5*length(data$height)){
    
  }else{
    width_lo001 <- loess(data$width ~ data$time, span = 0.01)
    height_lo001 <- loess(data$height ~ data$time, span = 0.01)
    data$width_lo001 <- predict(width_lo001, data$time)
    data$height_lo001 <- predict(height_lo001, data$time)
    width_lo005 <- loess(data$width ~ data$time, span = 0.05)
    height_lo005 <- loess(data$height ~ data$time, span = 0.05)
    data$width_lo005 <- predict(width_lo005, data$time)
    data$height_lo005 <- predict(height_lo005, data$time)
  

    # Plot 
    plot(data$width ~ data$time, type = "l", main = paste(c(subject, session)))
    lines(data$width_lo001 ~ data$time, type = "l", col = "red", lwd = 2)
    lines(data$width_lo005 ~ data$time, type = "l", col = "blue", lwd = 2)
    legend("topleft", lty = 1, legend = c("span = 0.05", "span = 0.01"), col = c("blue", "red"), bty = "n")
    
    plot(data$height ~ data$time, type = "l", main = paste(c(subject, session)))
    lines(data$height_lo001 ~ data$time, type = "l", col = "red", lwd = 2)
    lines(data$height_lo005 ~ data$time, type = "l", col = "blue", lwd = 2)
    legend("topleft", lty = 1, legend = c("span = 0.05", "span = 0.01"), col = c("blue", "red"), bty = "n")
    
    
    # Cut pieces of data that start 2 s before onset of every block and ends 2 seconds after the block
    
    for(j in 1:length(temp$V4)){
      thisonset <- temp$V4[j]
      cutout_start <- which(abs(data$time - (thisonset - 2)) == min(abs(data$time - (thisonset- 2)))) # Sampling was at 60 Hz
      cutout_end <- which(abs(data$time - (thisonset + 22)) == min(abs(data$time - (thisonset + 22))))
      if(length(cutout_start) > 1){cutout_start <- cutout_start[1]} # Fix case where cutout_start has lenght 2
      if(length(cutout_end) > 1){cutout_end <- cutout_end[1]}
      cutout <- data.frame(subject = subject, date = date, session = NA, event_no = j, stimulus = temp$V2[j], width = data$width_lo001[seq(cutout_start, cutout_end, 6)], height = data$height_lo001[seq(cutout_start, cutout_end, 6)])
      rejected <- FALSE
      flag <- ""
      if(sum(is.na(data$width_lo001[cutout_start:cutout_end])) > 0.5*length(data$width_lo001[cutout_start:cutout_end]) | sum(is.na(data$height_lo001[cutout_start:cutout_end])) > 0.5*length(data$height_lo001[cutout_start:cutout_end])){
        rejected <- TRUE
        flag <- "REJECTED"
      }
      
      
      cutout$index <- 1:length(cutout$subject)
      
      if(exists("data_out") == FALSE & rejected == FALSE){
        data_out <- cutout
      } else if (rejected == FALSE){
        data_out <- rbind(data_out, cutout)
      }
      onsets <- c(onsets, thisonset)
    }
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
axis(1, at = c(0, 20, 220), labels = c("", "", ""))
plot(height ~ index, data = dataout_agg_agg, type = "l", frame.plot = F, xaxt = "n", main = paste("Height"), ylim = c(0.1, 0.3), xlab = "Time, s", ylab = "Diameter, cm")
axis(1, at = c(0, 20, 220), labels = c("", "", ""))
plot(diameter ~ index, data = dataout_agg_agg, type = "l", frame.plot = F, xaxt = "n", main = paste("Diameter"), ylim = c(0.1, 0.3), xlab = "Time, s", ylab = "Diameter, cm")
axis(1, at = c(0, 20, 220), labels = c("", "", ""))



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

dataout_neutral_agg <- aggregate(cbind(height, width) ~ index, data = dataout_agg_stimulus[dataout_agg_stimulus$stimulus == "neutral", ], FUN = "mean")
dataout_neutral_agg$diameter <- (dataout_neutral_agg$width + dataout_neutral_agg$height)/2
dataout_angry_agg <- aggregate(cbind(height, width) ~ index, data = dataout_agg_stimulus[dataout_agg_stimulus$stimulus == "angry", ], FUN = "mean")
dataout_angry_agg$diameter <- (dataout_angry_agg$width + dataout_angry_agg$height)/2
dataout_happy_agg <- aggregate(cbind(height, width) ~ index, data = dataout_agg_stimulus[dataout_agg_stimulus$stimulus == "happy", ], FUN = "mean")
dataout_happy_agg$diameter <- (dataout_happy_agg$width + dataout_happy_agg$height)/2


plot(diameter ~ index, data = dataout_neutral_agg, type = "l", frame.plot = F, xaxt = "n", main = paste("Diameter"), ylim = c(0.15, 0.23), xlab = "20 s block", ylab = "Diameter, cm", col = "blue")
axis(1, at = c(0, 20, 220, 240), labels = c("", "start", "end", ""))
lines(diameter ~ index, data = dataout_angry_agg, col = "red")
lines(diameter ~ index, data = dataout_happy_agg, col = "green")
legend("topleft", lty = 1, legend = c("neutral", "angry", "happy"), col = c("blue", "red", "green"), bty = "n")


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

plot(diameter ~ index, data = dataout_agg_fullsleep, type = "l", frame.plot = F, xaxt = "n", main = paste("Pupil diameter"), ylim = c(0.15, 0.23), xlab = "20 s block", ylab = "Diameter, cm", col = "darkgreen")
axis(1, at = c(0, 20, 220, 240), labels = c("", "start", "end", ""))
lines(diameter ~ index, data = dataout_agg_sleepdeprived, col = "orange")
legend("topleft", lty = 1, legend = c("Full sleep", "Sleep deprived"), col = c("darkgreen", "orange"), bty = "n")



# Index data by mean diameter to 2 s before each block
while(anyNA(data_out$height)){ # Impute missing values by last known value
  impute_height <- which(is.na(data_out$height))
  data_out$height[impute_height] <- data_out$height[impute_height - 1]
}
while(anyNA(data_out$width)){
  impute_width <- which(is.na(data_out$width))
  data_out$width[impute_width] <- data_out$width[impute_width - 1]
}
data_out$diameter <- (data_out$height + data_out$width)/2
#data_delta <- NULL
# for (i in unique(data_out$subject)){
#   for (j in unique(data_out$event_no[data_out$subject == i])){
#     cutout3 <- data_out[data_out$subject == i & data_out$event_no == j, ]
#     #???
#     cutout3$delta_diameter <- cutout3$diameter #- mean(cutout3$diameter[1:20])
#     if(exists("data_delta") == FALSE){
#       data_delta <- cutout3
#     } else {
#       data_delta <- rbind(data_delta, cutout3)
#     }
#   }
# }

# # Check plot
# data_delta_agg <- NULL
# for (i in unique(data_delta$subject)){
#   cutout4 <- data_delta[data_delta$subject == i, ]
#   cutout4_agg <- aggregate(delta_diameter ~ index, data = cutout4, FUN = "mean")
#   if(exists("data_delta_agg") == FALSE){
#     data_delta_agg <- cutout4_agg
#   } else {
#     data_delta_agg <- rbind(data_delta_agg, cutout4_agg)
#   }
# }
# data_delta_agg_agg <- aggregate(delta_diameter ~ index, data = data_delta_agg, FUN = "mean")
# plot(delta_diameter ~ index, data = data_delta_agg_agg, type = "l", frame.plot = F, xaxt = "n", main = paste("Diameter"), xlab = "Time, s", ylab = "Delta diameter, cm")
# axis(1, at = c(0, 20, 220, 240), labels = c("", "start", "end", ""))
# 

# Make data frame with mean responses for each event
data_eventmeans <- NULL
for (i in unique(data_out$subject)){
  data_subject <- subset(data_out, subject == i)
  for (k in unique(data_subject$date)){
    for (j in unique(data_out$event_no[data_out$subject == i])){
      cutout5 <- data_subject[data_subject$date == k & data_subject$event_no == j, ]
      eventmeans <- data.frame(subject = cutout5$subject[1], date = cutout5$date[1], 
                               event_no <- cutout5$event_no[1], stimulus <- cutout5$stimulus[1],
                               mean_event <- mean(cutout5$diameter[21:60]))
      if(exists("data_eventmeans") == FALSE){
        data_eventmeans <- eventmeans
      } else {
        data_eventmeans <- rbind(data_eventmeans, eventmeans)
      }
    }
  }
}

names(data_eventmeans) <- c("subject", "date", "event_no", "stimulus", "mean_event")
# Removes NA caused by last registrations that are not complete
data_eventmeans <- subset(data_eventmeans, !is.na(mean_event))

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
data_eventmeans2$AgeGroup <- relevel(as.factor(data_eventmeans2$AgeGroup), ref = "Young")


# Contrast coding
contrasts(data_eventmeans2$AgeGroup) <- rbind(-.5, .5)
colnames(contrasts(data_eventmeans2$AgeGroup)) <- levels(data_eventmeans2$AgeGroup)[2]
contrasts(data_eventmeans2$condition) <- rbind(-.5, .5)
colnames(contrasts(data_eventmeans2$condition)) <- levels(data_eventmeans2$condition)[2]

# Relevel data
data_eventmeans2$stimulus <- droplevels(data_eventmeans2$stimulus)
data_eventmeans2$stimulus <- relevel(data_eventmeans2$stimulus, ref = "neutral")


lme2 <- lme(mean_event ~ stimulus*condition, data = data_eventmeans2, random = ~ 1|subject, na.action = na.omit)
summary(lme2)
intervals_lme2 <- intervals(lme2)
plot(effect("stimulus*condition", lme2))
setwd("~/Desktop/SleepyBrain-Analyses/FACES/Eyetracking/")
write.csv2(summary(lme2)$tTable, file = "Reduced_model.csv")
write.csv2(intervals_lme2$fixed, file = "Reduced_model_intervals.csv")

lme3 <- lme(mean_event ~ stimulus*condition*AgeGroup, data = data_eventmeans2, random = ~ 1|subject, na.action = na.omit)
summary(lme3)
intervals_lme3 <- intervals(lme3)
plot(effect("stimulus*condition*AgeGroup", lme3))
write.csv2(summary(lme3)$tTable, file = "Full_model.csv")
write.csv2(intervals_lme3$fixed, file = "Full_model_intervals.csv")


