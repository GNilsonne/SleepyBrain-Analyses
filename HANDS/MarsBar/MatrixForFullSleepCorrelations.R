setwd("~/Dropbox/Sleepy Brain (1)/Datafiles")

# Get fMRI data
FullSleepSessions <- read.csv("MARSBAR_140911/FullSleepSessions.csv", sep=";", dec=",")

# Get baseline data (change later)
BaselineData <- read.csv("Baseline_data/131204_Baselinedata_combined", sep=";", dec=",")

# Get PPI_R data (change later)
PPI_R <- read.table("~/Dropbox/Sleepy Brain (1)/Datafiles/PPI_R_131204", sep=";", quote="\"", header=T)
PPI_R$X <- NULL

# Get screening data (change later)
setwd("Screening_files_processed")
screeningFiles <- list.files()
screeningData <- data.frame()
for (i in 1:length(screeningFiles)){
  screeningData <- rbind(screeningData, read.csv2(screeningFiles[i], header = TRUE))
}
screeningData$Subject <- as.integer(screeningData$Subject)

# Combine full sleep data with baseline data
CorrelationMatrix <- data.frame()
for(i in 1:length(FullSleepSessions$Subject)){
  temp <- FullSleepSessions$Subject[i]
  Data <- subset(BaselineData, BaselineData$Subject == temp)
  CorrelationMatrix <- rbind(CorrelationMatrix, Data)       
}
CorrelationMatrix <- CorrelationMatrix[ ,2:31]

# Add PPI-R
BigMatrix <- data.frame()
for(i in 1:length(CorrelationMatrix$Subject)){
  subj <- CorrelationMatrix$Subject[i]
  PPI_R_Data <- subset(PPI_R, PPI_R$Subject == subj)
  Correlation_Data <- CorrelationMatrix[i, ]
  if(nrow(PPI_R_Data) == 0){
    PPI_R_Data[1, ] = NA
  } 
  AllData <- cbind(Correlation_Data, PPI_R_Data)
  BigMatrix <- rbind(BigMatrix, AllData)       
}

row.names(CorrelationMatrix) <- NULL
CorrelationMatrix <- cbind(FullSleepSessions, BigMatrix)


# Add screening data to the CorrelationMatrix 
ScreeningMatrix <- data.frame()
for(i in 1:length(CorrelationMatrix$Subject)){
  Subj <- CorrelationMatrix$Subject[i]
  Screening_Data <- subset(screeningData, screeningData$Subject == Subj)
  ScreeningMatrix <- rbind(ScreeningMatrix, Screening_Data)       
}

CorrelationMatrix <- cbind(CorrelationMatrix, ScreeningMatrix)

setwd("~/Dropbox/Sleepy Brain (1)/Datafiles/fMRI_HANDS")
write.csv2(CorrelationMatrix, file = "FullSleepBaselineScreening.csv", row.names=FALSE)
