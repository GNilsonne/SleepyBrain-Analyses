# Script to read pulse gating logfiles from FACES experiment
# By Sandra Tamm
# Modified by Gustav Nilsonne 2015-12-19
# Adapted for FACES 2018-08-17

setwd("~/Box Sync/Sleepy Brain/Datafiles/Pulse_gating_files")

# Import files
PgFilesFACES <- list.files(pattern = "FACES")
PgDataFACES <- data.frame()
for (i in 1:length(PgFilesFACES)){
  temp <- read.table(PgFilesFACES[i], quote="\"")
  temp$File <- PgFilesFACES[i]
  PgDataFACES <- rbind(PgDataFACES, temp)
}

# Extract subject
PgDataFACES$Subject <- as.integer(substr(PgDataFACES$File, 1, 3))

# Extract date
PgDataFACES$Date <- as.Date(as.character(substr(PgDataFACES$File, 5, 10)), "%y%m%d")

# List included subjects
IncludedSubjects <- read.table("../Subjects_151215.csv", sep=";", header=T)

IncludedSubjects <- as.integer(IncludedSubjects$CompletedScanning) # This is for the purpose of quality review.


# Retain only subjects in list
PgDataFACES <- PgDataFACES[PgDataFACES$Subject %in% as.integer(IncludedSubjects), ]

# Plot data to se that all subjects have registrations of approximatly the same length  
plot(PgDataFACES[ ,1], type="l", xlab = "Row", ylab = "Time (centiseconds)")


IncludedSubjectsPgFACES <- unique(PgDataFACES$Subject)

write.csv2(PgDataFACES, file = "../HR/PgDataFACES.csv", row.names=FALSE)
write.csv2(IncludedSubjectsPgFACES, file = "../HR/IncludedSubjectsPgFACES.csv", row.names=FALSE)
