# Get data from SPM-files. The files should be those generated with marsbar/matlab scripts.
# Anterior Insula left (mean ROI-activity)
AI_L_131205 <- read.delim("~/Dropbox/Sleepy Brain (1)/Datafiles/fmri_data/Data_AI_L_131205.dat", header=F)
AI_L_131205$Subject <- as.integer(substr(AI_L_131205$V1, 21, 23))
AI_L_131205$Session <- substr(AI_L_131205$V1, 32, 32)
AI_L_131205$AI_L <- AI_L_131205$V2 
AI_L_131205 <- AI_L_131205[ ,3:5]
# Some values are NA (because the search pat contained 1 extra "space"). Those are put in.
AI_L_131205[1,2] <- 1 
AI_L_131205[2,2] <- 2
AI_L_131205[17,2] <- 1
AI_L_131205[21,2] <- 1

# Anterior Insula right (mean ROI-activity)
AI_R_131204 <- read.delim("~/Dropbox/Sleepy Brain (1)/Datafiles/fmri_data/Data_AI_R_131204.dat", header=F)
AI_R_131204$Subject <- as.integer(substr(AI_R_131204$V1, 21, 23))
AI_R_131204$Session <- substr(AI_R_131204$V1, 32, 32)
AI_R_131204$AI_R <- AI_R_131204$V2 
AI_R_131204 <- AI_R_131204[ ,3:5]
# Some values are NA (because the search pat contained 1 extra "space"). Those are put in.
AI_R_131204[1,2] <- 1 
AI_R_131204[2,2] <- 2
AI_R_131204[17,2] <- 1
AI_R_131204[21,2] <- 1

# Medial Cingulate Cortex (mean ROI-activity)
MCC_131205 <- read.delim("~/Dropbox/Sleepy Brain (1)/Datafiles/fmri_data/Data_MCC_131205.dat", header=F)
MCC_131205$Subject <- as.integer(substr(MCC_131205$V1, 21, 23))
MCC_131205$Session <- substr(MCC_131205$V1, 32, 32)
MCC_131205$MCC <- MCC_131205$V2 
MCC_131205 <- MCC_131205[ ,3:5]
# Some values are NA (because the search pat contained 1 extra "space"). Those are put in.
MCC_131205[1,2] <- 1 
MCC_131205[2,2] <- 2
MCC_131205[17,2] <- 1
MCC_131205[21,2] <- 1


# Inferior Parietal Cortex (mean ROI-activity)
IPC_L_131204 <- read.delim("~/Dropbox/Sleepy Brain (1)/Datafiles/fmri_data/Data_IPC_L_LAMM_131204.dat", header=F)
IPC_L_131204$Subject <- as.integer(substr(IPC_L_131204$V1, 21, 23))
IPC_L_131204$Session <- substr(IPC_L_131204$V1, 32, 32)
IPC_L_131204$IPC_L <- IPC_L_131204$V2 
IPC_L_131204 <- IPC_L_131204[ ,3:5]
# Some values are NA (because the search pat contained 1 extra "space"). Those are put in.
IPC_L_131204[1,2] <- 1 
IPC_L_131204[2,2] <- 2
IPC_L_131204[17,2] <- 1
IPC_L_131204[21,2] <- 1



# Get randomisation condition
Randomisationlist <- read.csv("~/Dropbox/Sleepy Brain (1)/Datafiles/RandomisationList_131128.csv", sep=";")
Randomisationlist$PSD <- Randomisationlist$Sl_cond


# Make data frame with data for baseline ratings and full sleep conditions
# Data frame with only full sleep data
FullSleepSessions <- data.frame()
for(i in 1:length(AI_L_131205$Subject)){
  temp <- AI_L_131205$Subject[i]
  Data <- AI_L_131205[i, ]
  Data2 <- AI_R_131204[i, ]
  Data3 <- MCC_131205[i, ]
  Data4 <- IPC_L_131204[i, ]
  Data <- cbind(Data, Data2, Data3, Data4)
  Randomisation <- subset(Randomisationlist, Randomisationlist$Subject == temp)
  if(AI_L_131205[i, 2] == Randomisation[1,2] ){  
  }else{
    FullSleepSessions <- rbind(FullSleepSessions, Data) 
    
  }
}

FullSleepSessions <- FullSleepSessions[ ,c(1:3, 6, 9, 12)]
row.names(FullSleepSessions) <- NULL

# Get baseline data
BaselineData <- read.csv("~/Dropbox/Sleepy Brain (1)/Datafiles/Baseline_data/131204_Baselinedata_combined", 
                         sep=";", dec=",")
PPI_R <- read.table("~/Dropbox/Sleepy Brain (1)/Datafiles/PPI_R_131204", sep=";", quote="\"", header=T)
PPI_R$X <- NULL

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


# Get screening data and add to the CorrelationMatrix 
setwd("~/Dropbox/Sleepy Brain (1)/Datafiles/Screening_files_processed")
screeningFiles <- list.files()
screeningData <- data.frame()
for (i in 1:length(screeningFiles)){
  screeningData <- rbind(screeningData, read.csv2(screeningFiles[i], header = TRUE))
}
screeningData$Subject <- as.integer(screeningData$Subject)

ScreeningMatrix <- data.frame()
for(i in 1:length(CorrelationMatrix$Subject)){
  Subj <- CorrelationMatrix$Subject[i]
  Screening_Data <- subset(screeningData, screeningData$Subject == Subj)
  ScreeningMatrix <- rbind(ScreeningMatrix, Screening_Data)       
}

CorrelationMatrix <- cbind(CorrelationMatrix, ScreeningMatrix)

#---------

# Make a correlationmatrix for all sessions (i.e. both sleep conditions) for correlations with DataAtScanner, KSS etc.
AllSessions <- data.frame()
for(i in 1:length(AI_L_131205$Subject)){
  temp <- AI_L_131205$Subject[i]
  Data <- AI_L_131205[i, ]
  Data2 <- AI_R_131204[i, ]
  Data3 <- MCC_131205[i, ]
  Data4 <- IPC_L_131204[i, ]
  Data <- cbind(Data, Data2, Data3, Data4)
  AllSessions <- rbind(AllSessions, Data)  
}

AllSessions <- AllSessions[ ,c(1:3, 6, 9, 12)]

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
for(i in 1:length(AllSessions$Subject)){
  temp <- AllSessions$Subject[i]
  temp2 <- AllSessions[i, 2]
  Data <- subset(Data_KSS4Ratings, Data_KSS4Ratings$Subject == temp & Data_KSS4Ratings$Session == temp2)
  Data2 <- subset(AllSessions[i, ])
  Data <- cbind(Data, Data2)
  AllSessionCorrelationMatrix <- rbind(AllSessionCorrelationMatrix, Data)       
}

row.names(AllSessionCorrelationMatrix) <- NULL
AllSessionCorrelationMatrix <- AllSessionCorrelationMatrix[ ,c(1:3, 6:9)]

# Define Sleep Conditions
for(i in 1:length(AllSessionCorrelationMatrix$Subject)){
  temp <- AllSessionCorrelationMatrix[i,1]
  Session <- AllSessions[i, 2]
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

# Get Data at scanner
DataAtScanner <- read.csv("~/Dropbox/Sleepy Brain (1)/Datafiles/DataAtScanner/131208_DataAtScanner_Processed", sep=";")



#Correlations with IRI
plot(as.numeric(CorrelationMatrix$AI_L) ~ CorrelationMatrix$IRI_EC, xlab ="IRI, empathic concern", ylab= "Anterior Insula, left")
abline(lm(as.numeric(CorrelationMatrix$AI_L) ~ CorrelationMatrix$IRI_EC))
smry <- summary(lm(as.numeric(CorrelationMatrix$AI_L) ~ CorrelationMatrix$IRI_EC))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))

plot(CorrelationMatrix$AI_R ~ CorrelationMatrix$IRI_EC, xlab ="IRI, empathic concern", ylab= "Anterior Insula, right")
abline(lm(as.numeric(CorrelationMatrix$AI_R) ~ CorrelationMatrix$IRI_EC))
smry <- summary(lm(as.numeric(CorrelationMatrix$AI_R) ~ CorrelationMatrix$IRI_EC))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))


plot(CorrelationMatrix$MCC ~ CorrelationMatrix$IRI_EC, xlab ="IRI, empathic concern", ylab= "Medial Cingulate Cortex")
abline(lm(as.numeric(CorrelationMatrix$MCC) ~ CorrelationMatrix$IRI_EC))
smry <- summary(lm(as.numeric(CorrelationMatrix$MCC) ~ CorrelationMatrix$IRI_EC))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))


plot(CorrelationMatrix$IPC_L ~ CorrelationMatrix$IRI_EC, xlab ="IRI, empathic concern", ylab= "IPC (Supramarginal Gyrus), left")
abline(lm(as.numeric(CorrelationMatrix$IPC_L) ~ CorrelationMatrix$IRI_EC))
smry <- summary(lm(as.numeric(CorrelationMatrix$IPC_L) ~ CorrelationMatrix$IRI_EC))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))


#Correlations with Coldheartedness
plot(CorrelationMatrix$AI_L ~ CorrelationMatrix$C, xlab ="PPI_R, coldheartedness", ylab= "Anterior Insula, left")
abline(lm(CorrelationMatrix$AI_L ~ CorrelationMatrix$C))
smry <- summary(lm(as.numeric(CorrelationMatrix$AI_L) ~ CorrelationMatrix$C))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))

plot(CorrelationMatrix$AI_R ~ CorrelationMatrix$C, xlab ="PPI_R, coldheartedness", ylab= "Anterior Insula, right")
abline(lm(CorrelationMatrix$AI_L ~ CorrelationMatrix$C))
smry <- summary(lm(as.numeric(CorrelationMatrix$AI_R) ~ CorrelationMatrix$C))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))

plot(CorrelationMatrix$MCC ~ CorrelationMatrix$C, xlab ="PPI_R, coldheartedness", ylab= "Medial Cingulate Cortex")
abline(lm(CorrelationMatrix$MCC ~ CorrelationMatrix$C))
smry <- summary(lm(as.numeric(CorrelationMatrix$MCC) ~ CorrelationMatrix$C))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))

plot(CorrelationMatrix$IPC ~ CorrelationMatrix$C, xlab ="PPI_R, coldheartedness", ylab= "IPC (Supramarginal Gyrus), left")
abline(lm(CorrelationMatrix$IPC ~ CorrelationMatrix$C))
smry <- summary(lm(as.numeric(CorrelationMatrix$IPC) ~ CorrelationMatrix$C))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))

#Correlations with KSQ_SleepSymptomIndex
plot(CorrelationMatrix$AI_L ~ CorrelationMatrix$KSQ_SleepSymptomIndex, xlab ="KSQ_SleepSymptomIndex", ylab= "Anterior Insula, left")
abline(lm(CorrelationMatrix$AI_L ~ CorrelationMatrix$KSQ_SleepSymptomIndex))
smry <- summary(lm(as.numeric(CorrelationMatrix$AI_L) ~ CorrelationMatrix$KSQ_SleepSymptomIndex))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))

plot(CorrelationMatrix$AI_R ~ CorrelationMatrix$KSQ_SleepSymptomIndex, xlab ="KSQ_SleepSymptomIndex", ylab= "Anterior Insula, right")
abline(lm(CorrelationMatrix$AI_L ~ CorrelationMatrix$KSQ_SleepSymptomIndex))
smry <- summary(lm(as.numeric(CorrelationMatrix$AI_R) ~ CorrelationMatrix$KSQ_SleepSymptomIndex))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))

plot(CorrelationMatrix$MCC ~ CorrelationMatrix$KSQ_SleepSymptomIndex, xlab ="KSQ_SleepSymptomIndex", ylab= "Medial Cingulate Cortex")
abline(lm(CorrelationMatrix$MCC ~ CorrelationMatrix$KSQ_SleepSymptomIndex))
smry <- summary(lm(as.numeric(CorrelationMatrix$MCC) ~ CorrelationMatrix$KSQ_SleepSymptomIndex))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))

plot(CorrelationMatrix$IPC ~ CorrelationMatrix$KSQ_SleepSymptomIndex, xlab ="KSQ_SleepSymptomIndex", ylab= "IPC (Supramarginal Gyrus), left")
abline(lm(CorrelationMatrix$IPC ~ CorrelationMatrix$KSQ_SleepSymptomIndex))
smry <- summary(lm(as.numeric(CorrelationMatrix$IPC) ~ CorrelationMatrix$KSQ_SleepSymptomIndex))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))

#Correlations with KSQ_SleepQualityIndex
plot(CorrelationMatrix$AI_L ~ CorrelationMatrix$KSQ_SleepQualityIndex, xlab ="KSQ_SleepQualityIndex", ylab= "Anterior Insula, left")
abline(lm(CorrelationMatrix$AI_L ~ CorrelationMatrix$KSQ_SleepQualityIndex))
smry <- summary(lm(as.numeric(CorrelationMatrix$AI_L) ~ CorrelationMatrix$KSQ_SleepQualityIndex))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))

plot(CorrelationMatrix$AI_R ~ CorrelationMatrix$KSQ_SleepQualityIndex, xlab ="KSQ_SleepQualityIndex", ylab= "Anterior Insula, right")
abline(lm(CorrelationMatrix$AI_L ~ CorrelationMatrix$KSQ_SleepQualityIndex))
smry <- summary(lm(as.numeric(CorrelationMatrix$AI_R) ~ CorrelationMatrix$KSQ_SleepQualityIndex))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))

plot(CorrelationMatrix$MCC ~ CorrelationMatrix$KSQ_SleepQualityIndex, xlab ="KSQ_SleepQualityIndex", ylab= "Medial Cingulate Cortex")
abline(lm(CorrelationMatrix$MCC ~ CorrelationMatrix$KSQ_SleepQualityIndex))
smry <- summary(lm(as.numeric(CorrelationMatrix$MCC) ~ CorrelationMatrix$KSQ_SleepQualityIndex))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))

plot(CorrelationMatrix$IPC ~ CorrelationMatrix$KSQ_SleepQualityIndex, xlab ="KSQ_SleepQualityIndex", ylab= "IPC (Supramarginal Gyrus), left")
abline(lm(CorrelationMatrix$IPC ~ CorrelationMatrix$KSQ_SleepQualityIndex))
smry <- summary(lm(as.numeric(CorrelationMatrix$IPC) ~ CorrelationMatrix$KSQ_SleepQualityIndex))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))

#Correlations with STAI-T
plot(CorrelationMatrix$AI_L ~ CorrelationMatrix$STAI_T, xlab ="STAI-T", ylab= "Anterior Insula, left")
abline(lm(as.numeric(CorrelationMatrix$AI_L) ~ CorrelationMatrix$STAI_T))
smry <- summary(lm(as.numeric(CorrelationMatrix$AI_L) ~ CorrelationMatrix$STAI_T))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))


plot(CorrelationMatrix$AI_R ~ CorrelationMatrix$STAI_T, xlab ="STAI-T", ylab= "Anterior Insula, right")
abline(lm(as.numeric(CorrelationMatrix$AI_R) ~ CorrelationMatrix$STAI_T))
smry <- summary(lm(as.numeric(CorrelationMatrix$AI_R) ~ CorrelationMatrix$STAI_T))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))

plot(CorrelationMatrix$MCC ~ CorrelationMatrix$STAI_T, xlab ="STAI-T", ylab= "Medial Cingulate Cortex")
abline(lm(as.numeric(CorrelationMatrix$MCC) ~ CorrelationMatrix$STAI_T))
smry <- summary(lm(as.numeric(CorrelationMatrix$MCC) ~ CorrelationMatrix$STAI_T))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))

plot(CorrelationMatrix$IPC_L ~ CorrelationMatrix$STAI_T, xlab ="STAI-T", ylab= "IPC (Supramarginal Gyrus), left")
abline(lm(as.numeric(CorrelationMatrix$IPC_L) ~ CorrelationMatrix$STAI_T))
smry <- summary(lm(as.numeric(CorrelationMatrix$IPC_L) ~ CorrelationMatrix$STAI_T))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))

#Correlations with TAS-20
plot(CorrelationMatrix$AI_L ~ CorrelationMatrix$TAS20_Total, xlab ="TAS-20 (total)", ylab= "Anterior Insula, left")
abline(lm(as.numeric(CorrelationMatrix$AI_L) ~ CorrelationMatrix$TAS20_Total))
smry <- summary(lm(as.numeric(CorrelationMatrix$AI_L) ~ CorrelationMatrix$TAS20_Total))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))


plot(CorrelationMatrix$AI_R ~ CorrelationMatrix$TAS20_Total, xlab ="TAS-20 (total)", ylab= "Anterior Insula, right")
abline(lm(as.numeric(CorrelationMatrix$AI_R) ~ CorrelationMatrix$TAS20_Total))
smry <- summary(lm(as.numeric(CorrelationMatrix$AI_R) ~ CorrelationMatrix$TAS20_Total))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))

plot(CorrelationMatrix$MCC ~ CorrelationMatrix$TAS20_Total, xlab ="TAS-20 (total)", ylab= "Medial Cingulate Cortex")
abline(lm(as.numeric(CorrelationMatrix$MCC) ~ CorrelationMatrix$TAS20_Total))
smry <- summary(lm(as.numeric(CorrelationMatrix$MCC) ~ CorrelationMatrix$TAS20_Total))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))

plot(CorrelationMatrix$IPC_L ~ CorrelationMatrix$TAS20_Total, xlab ="TAS-20 (total)", ylab= "IPC (Supramarginal Gyrus), left")
abline(lm(as.numeric(CorrelationMatrix$IPC_L) ~ CorrelationMatrix$TAS20_Total))
smry <- summary(lm(as.numeric(CorrelationMatrix$IPC_L) ~ CorrelationMatrix$TAS20_Total))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))


#Correlation with KSS
plot(as.numeric(AllSessionCorrelationMatrix$AI_L) ~ AllSessionCorrelationMatrix$KSS, xlab ="KSS after HANDS", ylab= "Anterior Insula, left")
abline(lm(as.numeric(AllSessionCorrelationMatrix$AI_L) ~ AllSessionCorrelationMatrix$KSS))
smry <- summary(lm(as.numeric(AllSessionCorrelationMatrix$AI_L) ~ AllSessionCorrelationMatrix$KSS))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))

plot(as.numeric(AllSessionCorrelationMatrix$AI_R) ~ AllSessionCorrelationMatrix$KSS, xlab ="KSS after HANDS", ylab= "Anterior Insula, right")
abline(lm(as.numeric(AllSessionCorrelationMatrix$AI_R) ~ AllSessionCorrelationMatrix$KSS))
smry <- summary(lm(as.numeric(AllSessionCorrelationMatrix$AI_R) ~ AllSessionCorrelationMatrix$KSS))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))

plot(as.numeric(AllSessionCorrelationMatrix$MCC) ~ AllSessionCorrelationMatrix$KSS, xlab ="KSS after HANDS", ylab= "Medial Cingulate Cortex")
abline(lm(as.numeric(AllSessionCorrelationMatrix$MCC) ~ AllSessionCorrelationMatrix$KSS))
smry <- summary(lm(as.numeric(AllSessionCorrelationMatrix$MCC) ~ AllSessionCorrelationMatrix$KSS))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))

plot(as.numeric(AllSessionCorrelationMatrix$IPC_L) ~ AllSessionCorrelationMatrix$KSS, xlab ="KSS after HANDS", ylab= "IPC (Supramarginal Gyrus), left")
abline(lm(as.numeric(AllSessionCorrelationMatrix$IPC_L) ~ AllSessionCorrelationMatrix$KSS))
smry <- summary(lm(as.numeric(AllSessionCorrelationMatrix$IPC_L) ~ AllSessionCorrelationMatrix$KSS))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))

#KSSexp
plot(as.numeric(AllSessionCorrelationMatrix$AI_L) ~ AllSessionCorrelationMatrix$KSSexp, xlab ="KSSexp after HANDS", ylab= "Anterior Insula, left")
abline(lm(as.numeric(AllSessionCorrelationMatrix$AI_L) ~ AllSessionCorrelationMatrix$KSSexp))
smry <- summary(lm(as.numeric(AllSessionCorrelationMatrix$AI_L) ~ AllSessionCorrelationMatrix$KSSexp))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))

plot(as.numeric(AllSessionCorrelationMatrix$MCC) ~ AllSessionCorrelationMatrix$KSSexp, xlab ="KSSexp after HANDS", ylab= "Medial Cingulate Cortex")
abline(lm(as.numeric(AllSessionCorrelationMatrix$MCC) ~ AllSessionCorrelationMatrix$KSSexp))
smry <- summary(lm(as.numeric(AllSessionCorrelationMatrix$MCC) ~ AllSessionCorrelationMatrix$KSSexp))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))


#Check for normality
plot(AllSessionCorrelationMatrix$KSS ~ AllSessionCorrelationMatrix$Subject, xlab ="Subject", ylab= "KSS")
SleepDeprived <- subset(AllSessionCorrelationMatrix, AllSessionCorrelationMatrix$SleepCondition == "Sleep Deprived")
NotSleepDeprived <- subset(AllSessionCorrelationMatrix, AllSessionCorrelationMatrix$SleepCondition == "Not Sleep Deprived")
boxplot(SleepDeprived$KSS, NotSleepDeprived$KSS)

#Compare sleepy and not sleepy
Sleepy <- subset(AllSessionCorrelationMatrix, AllSessionCorrelationMatrix$KSS > 7)
NotSleepy <- subset(AllSessionCorrelationMatrix, AllSessionCorrelationMatrix$KSS < 7)
SleepySeven <- subset(AllSessionCorrelationMatrix, AllSessionCorrelationMatrix$KSS == 7)



boxplot(NotSleepy$AI_L, SleepySeven$AI_L, Sleepy$AI_L, names = c("KSS < 7", "KSS = 7", "KSS > 7"), ylab = "Anterior Insula, left")
t.test(Sleepy$AI_L, NotSleepy$AI_L)
AllSessionCorrelationMatrix$KSSexp <- exp(AllSessionCorrelationMatrix$KSS)

boxplot(NotSleepy$AI_R, SleepySeven$AI_R, Sleepy$AI_R, names = c("KSS < 7", "KSS = 7", "KSS > 7)"), ylab = "Anterior Insula, rightt")
t.test(Sleepy$AI_R, NotSleepy$AI_R)

boxplot(NotSleepy$MCC, SleepySeven$MCC, Sleepy$MCC, names = c("KSS < 7", "KSS = 7", "KSS > 7"), ylab = "Medial Cingulate Cortex")
t.test(Sleepy$MCC, NotSleepy$MCC)

AllSessionCorrelationMatrix$SleepCondition <- as.factor(AllSessionCorrelationMatrix$SleepCondition)

ModelAI_L <- lme(AI_L ~ KSS + Session, data = AllSessionCorrelationMatrix, random = ~ 1|Subject)
plot(ModelAI_L)
summary(ModelAI_L)

out<-capture.output(summary(ModelAI_L))
cat(out,file="~/Dropbox/Resultat_131216/AI_L_KSS.txt",sep="\n",append=F)

ModelAI_R <- lme(AI_R ~ KSS + Session, data = AllSessionCorrelationMatrix, random = ~ 1|Subject)
plot(ModelAI_R)
summary(ModelAI_R)

out<-capture.output(summary(ModelAI_R))
cat(out,file="~/Dropbox/Resultat_131216/AI_R_KSS.txt",sep="\n",append=F)

ModelMCC <- lme(MCC ~ KSS + Session, data = AllSessionCorrelationMatrix, random = ~ 1|Subject)
plot(ModelMCC)
summary(ModelMCC)

out<-capture.output(summary(ModelMCC))
cat(out,file="~/Dropbox/Resultat_131216/MCC_KSS.txt",sep="\n",append=F)

ModelAI_L <- lme(AI_L ~ SleepCondition + Session, data = AllSessionCorrelationMatrix, random = ~ 1|Subject)
plot(ModelAI_L)
summary(ModelAI_L)

out<-capture.output(summary(ModelAI_L))
cat(out,file="~/Dropbox/Resultat_131216/AI_L_SC.txt",sep="\n",append=F)

ModelAI_R <- lme(AI_R ~ SleepCondition + Session, data = AllSessionCorrelationMatrix, random = ~ 1|Subject)
plot(ModelAI_R)
summary(ModelAI_R)

out<-capture.output(summary(ModelAI_R))
cat(out,file="~/Dropbox/Resultat_131216/AI_R_SC.txt",sep="\n",append=F)

ModelMCC <- lme(MCC ~ SleepCondition + Session, data = AllSessionCorrelationMatrix, random = ~ 1|Subject)
plot(ModelMCC)
summary(ModelMCC)

out<-capture.output(summary(ModelMCC))
cat(out,file="~/Dropbox/Resultat_131216/MCC_SC.txt",sep="\n",append=F)

age <- mean(as.numeric(CorrelationMatrix$Age))
ageSD <- sd(as.numeric(CorrelationMatrix$Age))
IncludedSubjects <- AllSessionCorrelationMatrix$Subject
IncludedSubjects <- unique(IncludedSubjects)
