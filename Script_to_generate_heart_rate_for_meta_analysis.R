# Script to generate heart rate files for the meta-analysis by König et al

# Hands

setwd("~/Box Sync/Sleepy Brain/Datafiles")

# Import pulse gating data
PgDataHands <- read.csv("HR/PgDataHandsSessionInfo_86subjects.csv", sep=";")

#Generate a column for time between two pulse registrations
PgDataHands$DeltaTimePulse <- PgDataHands$V1
PgDataHands$DeltaTimePulse <- (c(PgDataHands$V1, 0)-c(0, PgDataHands$V1))[1:length(PgDataHands$Subject)]

# Check registrations
plot(PgDataHands$DeltaTimePulse)

# Clean up false values (<0) and check again
PgDataHands$DeltaTimePulse[PgDataHands$DeltaTimePulse<0] <- NA 
plot(PgDataHands$DeltaTimePulse ~ PgDataHands$Subject)

# Generate a column for subjects' heart rate
PgDataHands$HR <- 6000/PgDataHands$DeltaTimePulse

PgDataHands <- subset(PgDataHands, DeprivationCondition == "NotSleepDeprived")
PgDataHands <- PgDataHands[ ,c(1:3, 5, 7:8)]


subjectlist <- read.csv("~/Box Sync/Sleepy Brain/Datafiles/Subjects_151215.csv", sep=";")
Data <- merge(PgDataHands, subjectlist[, c("Subject", "newid")])
Data <- subset(Data, select = -c(Subject))
names(Data)[6] <- "Subject"
Data <- Data[order(Data$Subject), ]
write.csv2(Data, "~/Desktop/Pulse_empathy.csv", row.names = F)

# Script to generate heart rate files for the meta-analysis by König et al

# FACES

setwd("~/Box Sync/Sleepy Brain/Datafiles")

# Import pulse gating data
PgDataFACES <- read.csv("HR/PgDataFACESSessionInfo.csv", sep=";")

#Generate a column for time between two pulse registrations
PgDataFACES$DeltaTimePulse <- PgDataFACES$V1
PgDataFACES$DeltaTimePulse <- (c(PgDataFACES$V1, 0)-c(0, PgDataFACES$V1))[1:length(PgDataFACES$Subject)]

# Check registrations
plot(PgDataFACES$DeltaTimePulse)

# Clean up false values (<0) and check again
PgDataFACES$DeltaTimePulse[PgDataFACES$DeltaTimePulse<0] <- NA 
plot(PgDataFACES$DeltaTimePulse ~ PgDataFACES$Subject)

# Generate a column for subjects' heart rate
PgDataFACES$HR <- 6000/PgDataFACES$DeltaTimePulse

PgDataFACES <- subset(PgDataFACES, DeprivationCondition == "NotSleepDeprived")
PgDataFACES <- PgDataFACES[ ,c(1:3, 5, 7:8)]


Data <- merge(PgDataFACES, subjectlist[, c("Subject", "newid")])
Data <- subset(Data, select = -c(Subject))
names(Data)[6] <- "Subject"
Data <- Data[order(Data$Subject), ]
write.csv2(Data, "~/Desktop/Pulse_mimicry.csv", row.names = F)

# ARROWS

setwd("~/Box Sync/Sleepy Brain/Datafiles")

# Import pulse gating data
PgDataARROWS <- read.csv("HR/PgDataARROWSSessionInfo.csv", sep=";")

#Generate a column for time between two pulse registrations
PgDataARROWS$DeltaTimePulse <- PgDataARROWS$V1
PgDataARROWS$DeltaTimePulse <- (c(PgDataARROWS$V1, 0)-c(0, PgDataARROWS$V1))[1:length(PgDataARROWS$Subject)]

# Check registrations
plot(PgDataARROWS$DeltaTimePulse)

# Clean up false values (<0) and check again
PgDataARROWS$DeltaTimePulse[PgDataARROWS$DeltaTimePulse<0] <- NA 
plot(PgDataARROWS$DeltaTimePulse ~ PgDataARROWS$Subject)

# Generate a column for subjects' heart rate
PgDataARROWS$HR <- 6000/PgDataARROWS$DeltaTimePulse

PgDataARROWS <- subset(PgDataARROWS, DeprivationCondition == "NotSleepDeprived")
PgDataARROWS <- PgDataARROWS[ ,c(1:3, 5, 7:8)]


Data <- merge(PgDataARROWS, subjectlist[, c("Subject", "newid")])
Data <- subset(Data, select = -c(Subject))
names(Data)[6] <- "Subject"
Data <- Data[order(Data$Subject), ]
write.csv2(Data, "~/Desktop/Pulse_reappraisal.csv", row.names = F)
