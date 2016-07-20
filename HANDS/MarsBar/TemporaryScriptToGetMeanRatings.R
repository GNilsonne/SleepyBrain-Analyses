# Load packages 
require(nlme)
require(plyr)
require(pwr)

# Read data
setwd("~/Dropbox/Sleepy Brain (1)/Datafiles/Presentation_logfiles")
HANDSFiles <- list.files(pattern = "^HANDS", recursive = TRUE)
HANDSFiles <- HANDSFiles[-grep(".log", HANDSFiles, fixed=T)]
Data_HANDSRatings <- data.frame()
for (i in 1:length(HANDSFiles)){
  temp <- read.table(HANDSFiles[i], header = TRUE)
  temp$File <- HANDSFiles[i]
  temp$Logtime <- file.info(HANDSFiles[i])$mtime
  temp <- subset(temp, temp$Condition == "Pain")
  MeanRating <- mean(temp$Rated_Unpleasantness)
  temp <- temp[1, ]
  temp$mean <- MeanRating
  Data_HANDSRatings <- rbind(Data_HANDSRatings, temp)
}
Data_HANDSRatings$Subject <- as.integer(substr(Data_HANDSRatings$File, 1, 3))

Data_HANDSRatings <- Data_HANDSRatings[ ,c(6, 8:9)]

# Subject list 
IncludedSubjects <- read.csv("~/Dropbox/Sleepy Brain (1)/Datafiles/MARSBAR_140911/IncludedSubjectsfMRIHands.csv")

# Retain only subjects in list
Data_HANDSRatings <- Data_HANDSRatings[Data_HANDSRatings$Subject %in% as.integer(IncludedSubjects[, 1]), ]

# Find randomisation condition
RandomisationList <- read.csv2("~/Dropbox/Sleepy Brain (1)/Datafiles/RandomisationList_140804.csv")
Data_HANDSRatings <- merge(Data_HANDSRatings, RandomisationList, by = "Subject")

# Find sleep deprivation condition
Data_HANDSRatings$Date <- paste(paste(20, substr(Data_HANDSRatings$File, 5, 6), sep = ""), substr(Data_HANDSRatings$File, 7, 8), substr(Data_HANDSRatings$File, 9, 10), sep = "-")
Data_HANDSRatings$Date <- as.Date(as.character(Data_HANDSRatings$Date, "%Y%m%d"))

VecSession <- vector()
VecDeprived <- vector()
for (i in unique(Data_HANDSRatings$Subject)){
  temp <- subset(Data_HANDSRatings, Data_HANDSRatings$Subject == i)
  temp$Session[temp$Date <= mean(temp$Date)] <- 1
  temp$Session[temp$Date > mean(temp$Date)] <- 2
  VecSession <- c(VecSession, temp$Session)
  
  temp$RandomisationCondition <- RandomisationList$Sl_cond[RandomisationList$Subject == i]
  for (j in 1:length(temp$Subject)){
    if (temp$Session[j] == 1 && temp$RandomisationCondition[j] == 1) {temp$DeprivationCondition[j] <- "Sleep Deprived"} else
      if (temp$Session[j] == 2 && temp$RandomisationCondition[j] == 2) {temp$DeprivationCondition[j] <- "Sleep Deprived"} else
        if (temp$Session[j] == 1 && temp$RandomisationCondition[j] == 2) {temp$DeprivationCondition[j] <- "Not Sleep Deprived"} else
          if (temp$Session[j] == 2 && temp$RandomisationCondition[j] == 1) {temp$DeprivationCondition[j] <- "Not Sleep Deprived"}
  }
  VecDeprived <- c(VecDeprived, temp$DeprivationCondition)
}

Data_HANDSRatings$Session <- VecSession
Data_HANDSRatings$DeprivationCondition <- as.factor(VecDeprived)



setwd("~/Dropbox/Sleepy Brain (1)/Datafiles/MARSBAR_140911")
write.csv2(Data_HANDSRatings, file = "MeanRatingsPain.csv", row.names=FALSE)
