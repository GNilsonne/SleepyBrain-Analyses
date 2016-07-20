# Get fMRI data
setwd("~/Dropbox/Sleepy Brain (1)/Datafiles/MARSBAR_140911")
AllSleepSessions <- read.csv("AllSleepSessions.csv", sep=";", dec=",")

# Get randomisation list
Randomisationlist <- read.csv("Randomisationlist.csv", sep=";")


# Get data for KSS4 ratings (KSS right after HANDS experiment)
setwd("~/Dropbox/Sleepy Brain (1)/Datafiles/Presentation_logfiles")
warnings(KSS4Files <- list.files(pattern = "^KSS_brief4", recursive = TRUE))
KSS4Files <- KSS4Files[-grep(".log", KSS4Files, fixed=T)]
Data_KSS4Ratings <- data.frame()
for (i in 1:length(KSS4Files)){
  temp <- read.table(KSS4Files[i], skip = 1, sep=",")
  temp$File <- KSS4Files[i]
  Data_KSS4Ratings <- rbind(Data_KSS4Ratings, temp)
}
Data_KSS4Ratings$Subject <- as.integer(substr(Data_KSS4Ratings$File, 1, 3))

Data_KSS4Ratings$KSS <- Data_KSS4Ratings$V1 


# Define first rating as session 1 and second as session 2
for(i in 1:length(Data_KSS4Ratings$Subject)){
  if(i == 1) {
    Session <- 1
  } else if(!is.na(Data_KSS4Ratings$Subject[i]) && Data_KSS4Ratings$Subject[i] == Data_KSS4Ratings$Subject[i-1]) {
    Session <- 2
  } else {
    Session <- 1
  } 
  if (i == 1) {
    Sessions <- c(Session)
  } else {
    Sessions <- rbind(Sessions, Session)
  }
}

Data_KSS4Ratings$Session <- Sessions        
Data_KSS4Ratings <- Data_KSS4Ratings[ ,3:5]   

# Add KSS4 to the AllSessionCorelationMatrix
AllSessionCorrelationMatrix <- data.frame()
for(i in 1:length(AllSleepSessions$Subject)){
  temp <- AllSleepSessions$Subject[i]
  temp2 <- AllSleepSessions[i, 2]
  Data <- subset(Data_KSS4Ratings, Data_KSS4Ratings$Subject == temp & Data_KSS4Ratings$Session == temp2)
  Data2 <- subset(AllSleepSessions[i, ])
  Data <- cbind(Data, Data2)
  AllSessionCorrelationMatrix <- rbind(AllSessionCorrelationMatrix, Data)       
}

row.names(AllSessionCorrelationMatrix) <- NULL
AllSessionCorrelationMatrix <- AllSessionCorrelationMatrix[ ,c(1:3, 6:9)]

# Define Sleep Conditions
for(i in 1:length(AllSessionCorrelationMatrix$Subject)){
  temp <- AllSessionCorrelationMatrix[i,1]
  Session <- AllSleepSessions[i, 2]
  Randomisation <- subset(Randomisationlist, Randomisationlist$Subject == temp)  
  if(Randomisation$PSD == Session){
    SleepCondition <- "Sleep Deprived"
  } else {
    SleepCondition <- "Not Sleep Deprived" 
  } 
  if(i == 1){
    SleepConditions <- SleepCondition
  } else {
    SleepConditions <- rbind(SleepConditions, SleepCondition)
  }
}

AllSessionCorrelationMatrix$SleepCondition <- SleepConditions

# Get mean ratings of unpleasantness (pain)
setwd("~/Dropbox/Sleepy Brain (1)/Datafiles/MARSBAR_140911")
MeanRatingsPain <- read.csv("MeanRatingsPain.csv", sep=";")
MeanRatingsPain <- MeanRatingsPain[ ,c(1,3,7)]

AllSessionCorrelationMatrix$Session = as.integer(AllSessionCorrelationMatrix$Session)
AllSessionCorrelationMatrix <- merge(AllSessionCorrelationMatrix, MeanRatingsPain, by=c("Subject", "Session"))

# Get demographic data
Demographic <- read.csv("~/Dropbox/Sleepy Brain (1)/Datafiles/140901_Demographic.csv", sep=";", dec=",")
AllSessionCorrelationMatrix <- merge(AllSessionCorrelationMatrix, Demographic, by = "Subject")



setwd("~/Dropbox/Sleepy Brain (1)/Datafiles/MARSBAR_140911")
write.csv2(AllSessionCorrelationMatrix, file = "AllSessionsKSS_demographics.csv", row.names=FALSE)

# Get PSG data
PSGData <- read.csv("~/Dropbox/Sleepy Brain (1)/Datafiles/SleepData_140901.csv", sep=";", dec=",")
AllSessionCorrelationMatrix2 <- merge(AllSessionCorrelationMatrix, PSGData, by.x = c("Subject", "Session"), by.y = c("Subject", "Session"))

# Make columns for sleep measures as absolute time
AllSessionCorrelationMatrix2$St3_min <- AllSessionCorrelationMatrix2$St3_.*AllSessionCorrelationMatrix2$TST/100
AllSessionCorrelationMatrix2$REM_min <- AllSessionCorrelationMatrix2$REM_.*AllSessionCorrelationMatrix2$TST/100

setwd("~/Dropbox/Sleepy Brain (1)/Datafiles/MARSBAR_140911")
write.csv2(AllSessionCorrelationMatrix2, file = "AllSessions_PSG.csv", row.names=FALSE)

