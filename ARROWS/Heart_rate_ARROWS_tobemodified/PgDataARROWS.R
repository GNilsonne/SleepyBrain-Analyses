# Script to read pulse gating logfiles from ARROWS experiment
# By Sandra Tamm
# Modified by Gustav Nilsonne 2015-12-19

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

# List included subjects ### To be changed!
IncludedSubjects <- read.table("../Subjects_140818.csv", sep=";", header=T)
#IncludedSubjects <- as.integer(IncludedSubjects$CanBeIncludedForInterventionEffects)
IncludedSubjects <- as.integer(IncludedSubjects$FulfillsCriteriaAndNoPathologicalFinding) # This is for the purpose of quality review.

# May need to be used later. 352 was interupted and therefore data is incomplete
#IncludedSubjects <-IncludedSubjects[IncludedSubjects != 352]
# Subject 115 and 86 only have one full registration, therefore removed  
#IncludedSubjects <-IncludedSubjects[IncludedSubjects != 115]
#IncludedSubjects <-IncludedSubjects[IncludedSubjects != 086]

# Retain only subjects in list
PgDataARROWS <- PgDataARROWS[PgDataARROWS$Subject %in% as.integer(IncludedSubjects), ]

# Plot data to se that all subjects have registrations of approximatly the same length  
plot(PgDataARROWS[ ,1], type="l", xlab = "Row", ylab = "Time (centiseconds)")

# Check later that the correct participants are here!
IncludedSubjectsPgARROWS <- unique(PgDataARROWS$Subject)

write.csv2(PgDataARROWS, file = "../HR/PgDataARROWS_86subjects.csv", row.names=FALSE)
write.csv2(IncludedSubjectsPgARROWS, file = "../HR/IncludedSubjectsPgARROWS_86subjects.csv", row.names=FALSE)