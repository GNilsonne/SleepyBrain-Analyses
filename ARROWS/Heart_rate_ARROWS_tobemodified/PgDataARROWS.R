# Script to read pulse gating logfiles from ARROWS experiment
# By Sandra Tamm
# Modified by Gustav Nilsonne 2015-12-19
# Adapted for ARROWS 2018-06-27

setwd("~/Box Sync/Sleepy Brain/Datafiles/Pulse_gating_files")

# Import files
PgFilesARROWS <- list.files(pattern = "ARROWS")
PgDataARROWS <- data.frame()
for (i in 1:length(PgFilesARROWS)){
  temp <- read.table(PgFilesARROWS[i], quote="\"")
  temp$File <- PgFilesARROWS[i]
  PgDataARROWS <- rbind(PgDataARROWS, temp)
}

# Extract subject
PgDataARROWS$Subject <- as.integer(substr(PgDataARROWS$File, 1, 3))

# Extract date
PgDataARROWS$Date <- as.Date(as.character(substr(PgDataARROWS$File, 5, 10)), "%y%m%d")

# List included subjects
IncludedSubjects <- read.table("../SubjectsForARROWS.csv", sep=";", header=T)

IncludedSubjects <- as.integer(IncludedSubjects$CompletedScanning) # This is for the purpose of quality review.


# Retain only subjects in list
PgDataARROWS <- PgDataARROWS[PgDataARROWS$Subject %in% as.integer(IncludedSubjects), ]

# Plot data to se that all subjects have registrations of approximatly the same length  
plot(PgDataARROWS[ ,1], type="l", xlab = "Row", ylab = "Time (centiseconds)")

# Check later that the correct participants are here!
IncludedSubjectsPgARROWS <- unique(PgDataARROWS$Subject)

write.csv2(PgDataARROWS, file = "../HR/PgDataARROWS.csv", row.names=FALSE)
write.csv2(IncludedSubjectsPgARROWS, file = "../HR/IncludedSubjectsPgARROWS.csv", row.names=FALSE)