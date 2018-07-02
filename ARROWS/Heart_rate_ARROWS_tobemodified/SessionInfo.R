# Script to process pulse gating data from ARROWS experiment
# By Sandra Tamm
# Modified by Gustav Nilsonne 2015-12-19
# Adapted for the ARROWS experiment 2018-06-26

setwd("~/Box Sync/Sleepy Brain/Datafiles")

# Import pulse gating data
PgDataARROWS <- read.csv("HR/PgDataARROWS.csv", sep=";")

# Import randomisationlist 
RandomisationList <- read.csv("RandomisationList_140804.csv", sep=";")
RandomisationList$PSD <- RandomisationList$Sl_cond

# Temporary object to match condition and pulse data
ReducedData <- PgDataARROWS[!duplicated(PgDataARROWS$File), ]

# Make subject's first file session 1 and second session 2
LengthOf <- length(ReducedData$Subject)-1
SoonSession <- ReducedData$Subject[1:LengthOf]
ReducedData$Prel <- c(0, SoonSession)
ReducedData$Session <- (ReducedData$Prel - ReducedData$Subject)

for(i in 1:length(ReducedData$Session)){
  if(as.integer(ReducedData$Session[i]) == 0){
    ReducedData$Session[i] <- 2
  }else{
    ReducedData$Session[i] <- 1
  }
}

## Need to remove data with txt-extention and check names of files

# Find out sleep condition from randomisationlist and session
SessionCondition <- data.frame()
for(i in 1:length(ReducedData$Session)){
  ThisSubject <- ReducedData$Subject[i]
  Randomisation <- subset(RandomisationList, RandomisationList$Subject == ThisSubject)
  ThisData <- ReducedData[i, ]
  if(ThisData$Session == 1 && Randomisation$Sl_cond == 1){
    ThisData$DeprivationCondition <- "SleepDeprived"
  }else if(ThisData$Session == 2 && Randomisation$Sl_cond == 2){
    ThisData$DeprivationCondition <- "SleepDeprived"
  }else{
    ThisData$DeprivationCondition <- "NotSleepDeprived"
  }
  if(i == 1){
    SessionCondition <- ThisData
  }else{
    SessionCondition <- rbind(SessionCondition, ThisData)
  }
}

SessionConditionEtc <- SessionCondition[ ,c(3:4, 6:7)]

# Check that all subjects seem to be there
plot(PgDataARROWS$Subject)

# Combine pulse data with session info
PgDataARROWS <- merge(PgDataARROWS, SessionConditionEtc, by = c("Subject", "Date"))
PgDataARROWS <- PgDataARROWS[with(PgDataARROWS, order(Subject, Session, V1)),]

# Write file
write.csv2(PgDataARROWS, file = "HR/PgDataARROWSSessionInfo.csv", row.names=FALSE)
