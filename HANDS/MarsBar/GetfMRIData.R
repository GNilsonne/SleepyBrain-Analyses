setwd("~/Dropbox/Sleepy Brain (1)/Datafiles/MARSBAR_140911")

# Get data from SPM-files. The files should be those generated with marsbar/matlab scripts.
# Anterior Insula left (mean ROI-activity)
AI_L <- read.delim("~/Dropbox/Sleepy Brain (1)/Datafiles/MARSBAR_140911/Data_AI_L_140911.dat", header=F)
AI_L$Subject <- as.integer(substr(AI_L$V1, 29, 31))
AI_L$Session <- substr(AI_L$V1, 33, 33)
AI_L$AI_L <- AI_L$V2 
AI_L <- AI_L[ ,3:5]


# Anterior Insula right (mean ROI-activity)
AI_R <- read.delim("~/Dropbox/Sleepy Brain (1)/Datafiles/MARSBAR_140911/Data_AI_R_140911.dat", header=F)
AI_R$Subject <- as.integer(substr(AI_R$V1, 29, 31))
AI_R$Session <- substr(AI_R$V1, 33, 33)
AI_R$AI_R <- AI_R$V2 
AI_R <- AI_R[ ,3:5]

# Medial Cingulate Cortex (mean ROI-activity)
MCC <- read.delim("~/Dropbox/Sleepy Brain (1)/Datafiles/MARSBAR_140911/Data_MCC_140911.dat", header=F)
MCC$Subject <- as.integer(substr(MCC$V1, 29, 31))
MCC$Session <- substr(MCC$V1, 33, 33)
MCC$MCC <- MCC$V2 
MCC <- MCC[ ,3:5]

# Inferior Parietal Cortex (mean functional ROI-activity)
IPC_L <- read.delim("~/Dropbox/Sleepy Brain (1)/Datafiles/MARSBAR_140911/Data_IPC_L_140911.dat", header=F)
IPC_L$Subject <- as.integer(substr(IPC_L$V1, 29, 31))
IPC_L$Session <- substr(IPC_L$V1, 33, 33)
IPC_L$IPC_L <- IPC_L$V2 
IPC_L <- IPC_L[ ,3:5]


# Write separate files for each region
write.csv2(AI_L, file = "AnteriorInsulaLeft.csv", row.names=FALSE)
write.csv2(AI_R, file = "AnteriorInsulaRight.csv", row.names=FALSE)
write.csv2(MCC, file = "MedialCingulum.csv", row.names=FALSE)
write.csv2(IPC_L, file = "InferiorParietalCortex.csv", row.names=FALSE)

# Write a file with included subjects in this analys (should be modified later)

IncludedSubjectsfMRIHands <- unique(AI_L$Subject)
write.csv2(IncludedSubjectsfMRIHands, file = "IncludedSubjectsfMRIHands.csv", row.names=FALSE)
