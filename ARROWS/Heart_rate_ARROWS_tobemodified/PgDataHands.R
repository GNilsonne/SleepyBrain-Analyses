# Script to read pulse gating logfiles from HANDS experiment
# By Sandra Tamm
# Modified by Gustav Nilsonne 2015-12-19

setwd("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/Pulse_gating_files")

# Import files
PgFilesHands <- list.files(pattern = "HANDS")
PgDataHands <- data.frame()
for (i in 1:length(PgFilesHands)){
  temp <- read.table(PgFilesHands[i], quote="\"")
  temp$File <- PgFilesHands[i]
  PgDataHands <- rbind(PgDataHands, temp)
}

# Extract subject
PgDataHands$Subject <- as.integer(substr(PgDataHands$File, 1, 3))

# Extract date
PgDataHands$Date <- as.Date(as.character(substr(PgDataHands$File, 5, 10)), "%y%m%d")

# List included subjects 
IncludedSubjects <- read.table("../Subjects_140818.csv", sep=";", header=T)
#IncludedSubjects <- as.integer(IncludedSubjects$CanBeIncludedForInterventionEffects)
IncludedSubjects <- as.integer(IncludedSubjects$FulfillsCriteriaAndNoPathologicalFinding) # This is for the purpose of quality review.

# May need to be used later. 352 was interupted and therefore data is incomplete
#IncludedSubjects <-IncludedSubjects[IncludedSubjects != 352]
# Subject 115 and 86 only have one full registration, therefore removed  
#IncludedSubjects <-IncludedSubjects[IncludedSubjects != 115]
#IncludedSubjects <-IncludedSubjects[IncludedSubjects != 086]

# Retain only subjects in list
PgDataHands <- PgDataHands[PgDataHands$Subject %in% as.integer(IncludedSubjects), ]

# Plot data to se that all subjects have registrations of approximatly the same length  
plot(PgDataHands[ ,1], type="l", xlab = "Row", ylab = "Time (centiseconds)")

IncludedSubjectsPgHands <- unique(PgDataHands$Subject)

write.csv2(PgDataHands, file = "../HR/PgDataHands_86subjects.csv", row.names=FALSE)
write.csv2(IncludedSubjectsPgHands, file = "../HR/IncludedSubjectsPgHands_86subjects.csv", row.names=FALSE)