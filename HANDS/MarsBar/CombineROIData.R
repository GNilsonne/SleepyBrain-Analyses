setwd("~/Dropbox/Sleepy Brain (1)/Datafiles/MARSBAR_140911")

# Read fMRI-data
AnteriorInsulaLeft <- read.csv("AnteriorInsulaLeft.csv", sep=";", dec=",")
AnteriorInsulaRight <- read.csv("AnteriorInsulaRight.csv", sep=";", dec=",")
MedialCingulum <- read.csv("MedialCingulum.csv", sep=";", dec=",")
InferiorParietalCortex <- read.csv("InferiorParietalCortex.csv", sep=";", dec=",")


# Get randomisation condition
Randomisationlist <- read.csv("~/Dropbox/Sleepy Brain (1)/Datafiles/RandomisationList_140804.csv", sep=";")
Randomisationlist$PSD <- Randomisationlist$Sl_cond


# Data frame with only full sleep data
FullSleepSessions <- data.frame()
for(i in 1:length(AnteriorInsulaLeft$Subject)){
  temp <- AnteriorInsulaLeft$Subject[i]
  Data <- AnteriorInsulaLeft[i, ]
  Data2 <- AnteriorInsulaRight[i, ]
  Data3 <- MedialCingulum[i, ]
  Data4 <- InferiorParietalCortex[i, ]
  Data <- cbind(Data, Data2, Data3, Data4)
  Randomisation <- subset(Randomisationlist, Randomisationlist$Subject == temp)
  if(AnteriorInsulaLeft[i, 2] == Randomisation[1,2] ){  
  }else{
    FullSleepSessions <- rbind(FullSleepSessions, Data) 
    
  }
}

FullSleepSessions <- FullSleepSessions[ ,c(1:3, 6, 9, 12)]
row.names(FullSleepSessions) <- NULL

# Data frame with only PSD data
PSDSessions <- data.frame()
for(i in 1:length(AnteriorInsulaLeft$Subject)){
  temp <- AnteriorInsulaLeft$Subject[i]
  Data <- AnteriorInsulaLeft[i, ]
  Data2 <- AnteriorInsulaRight[i, ]
  Data3 <- MedialCingulum[i, ]
  Data4 <- InferiorParietalCortex[i, ]
  Data <- cbind(Data, Data2, Data3, Data4)
  Randomisation <- subset(Randomisationlist, Randomisationlist$Subject == temp)
  if(AnteriorInsulaLeft[i, 2] != Randomisation[1,2] ){  
  }else{
    PSDSessions <- rbind(PSDSessions, Data)   
  }
}

PSDSessions <- PSDSessions[ ,c(1:3, 6, 9, 12)]
row.names(PSDSessions) <- NULL



# Make a matrix for all sessions (i.e. both sleep conditions) for correlations with DataAtScanner, KSS etc.
AllSessions <- data.frame()
for(i in 1:length(AnteriorInsulaLeft$Subject)){
  temp <- AnteriorInsulaLeft$Subject[i]
  Data <- AnteriorInsulaLeft[i, ]
  Data2 <- AnteriorInsulaRight[i, ]
  Data3 <- MedialCingulum[i, ]
  Data4 <- InferiorParietalCortex[i, ]
  Data <- cbind(Data, Data2, Data3, Data4)
  AllSessions <- rbind(AllSessions, Data)  
}

AllSessions <- AllSessions[ ,c(1:3, 6, 9, 12)]

write.csv2(FullSleepSessions, file = "FullSleepSessions.csv", row.names=FALSE)
write.csv2(PSDSessions, file = "PSDSessions.csv", row.names=FALSE)
write.csv2(AllSessions, file = "AllSleepSessions.csv", row.names=FALSE)
write.csv2(Randomisationlist, file = "Randomisationlist.csv", row.names=FALSE)
