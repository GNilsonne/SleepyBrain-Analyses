# Script to plot total sleep time for data descriptor paper
# By Gustav Nilsonne 2016-03-25
# May be updated to work with files as published to openfmri.org

# Require packages
require(nlme)
require(xtable)
require(RColorBrewer)

# Subject list 
Subjects <- read.csv2("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/Subjects_151215.csv")
IncludedSubjects <- Subjects$newid[!is.na(Subjects$FulfillsCriteriaAndNoPathologicalFinding)]

# Find randomisation condition
RandomisationList <- read.csv2("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/RandomisationList_140804.csv")

# Read PSG data
#PSGData <- read.csv2("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/SleepData_140827.csv", header = TRUE)
SIESTA <- read.csv2("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/SIESTAdata_160516_pseudonymized.csv", header = TRUE)
#demdata <- read.csv2("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/150215_Demographic.csv", header = TRUE)

# Keep only included participants
SIESTA <- SIESTA[SIESTA$id %in% IncludedSubjects, ]
#SIESTA <- merge(SIESTA, demdata, by = "Subject")

cols <- brewer.pal(n = 3, name = "Dark2")
boxplot(SIESTA$tst__00_nsd/60 - SIESTA$tst__00_sd/60, ylim = c(0, 8), frame.plot = F, main = "Difference between sessions, Siesta data", ylab = "TST (h)")
abline(h = 2, lty = 2)
stripchart(SIESTA$tst__00_nsd[SIESTA$old == 1]/60 - SIESTA$tst__00_sd[SIESTA$old == 1]/60, add = T, vertical = T, method = "jitter", col = cols[2], pch = 1)
stripchart(SIESTA$tst__00_nsd[SIESTA$old == 0]/60 - SIESTA$tst__00_sd[SIESTA$old == 0]/60, add = T, vertical = T, method = "jitter", col = cols[3], pch = 1)
legend("topleft", legend = c("Younger", "Older"), pch = 1, col = c(cols[2], cols[3]), bty = "n")
excludednow <- SIESTA$id[(SIESTA$tst__00_nsd/60 - SIESTA$tst__00_sd/60) < 2]
excludednow <- excludednow[!is.na(excludednow)]

# Plot sleep times according to PSG
boxplot(SIESTA$tst__00_nsd/60, SIESTA$tst__00_sd/60,
        ylim = c(0, 11),
        yaxs = "i",
        frame = F,
        main = "",
        ylab = "Time (hours)",
        names = c("Not Sleep Deprived", "Sleep Deprived"))
abline(h = 4, col = cols[1], lty = 2)
for (i in unique(SIESTA$id[SIESTA$old == 1])){
  temp <- subset(SIESTA, id == i)
  lines(c(1, 2), c(temp$tst__00_nsd/60, temp$tst__00_sd/60), col = cols[2])
}
for (i in unique(SIESTA$id[SIESTA$old == 0])){
  temp <- subset(SIESTA, id == i)
  lines(c(1, 2), c(temp$tst__00_nsd/60, temp$tst__00_sd/60), col = cols[3])
}
legend("topright", legend = c("Younger", "Older"), lty = 1, col = c(cols[2], cols[3]), bty = "n")

PSGData$Subject[PSGData$Cond == 2 & PSGData$TST_h < 4]
