# Script to plot total sleep time for data descriptor paper
# By Gustav Nilsonne 2016-03-25
# May be updated to work with files as published to openfmri.org

# Require packages
require(nlme)
require(xtable)
require(RColorBrewer)

# Subject list 
Subjects <- read.csv2("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/Subjects_140818.csv")
IncludedSubjects <- as.integer(Subjects$FulfillsCriteriaAndNoPathologicalFinding[!is.na(Subjects$FulfillsCriteriaAndNoPathologicalFinding)])

# Find randomisation condition
RandomisationList <- read.csv2("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/RandomisationList_140804.csv")

# Read PSG data
PSGData <- read.csv2("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/SleepData_140827.csv", header = TRUE)
demdata <- read.csv2("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/150215_Demographic.csv", header = TRUE)

# Keep only included participants
PSGData <- PSGData[PSGData$Subject %in% IncludedSubjects, ]
PSGData <- merge(PSGData, demdata, by = "Subject")

# Check that sleep stages add up
PSGData$AddUp <- PSGData$REM_. + PSGData$St1_.+ PSGData$St2_. + PSGData$St3_.
#plot(PSGData$AddUp)

# Calculate absolute times from percentages and vice versa
PSGData$REM <- PSGData$REM_.*0.01*PSGData$TST
PSGData$St3 <- PSGData$St3_.*0.01*PSGData$TST

PSGData$TST_h <- PSGData$TST/60
PSGData$WASO_. <- 11*PSGData$WASO/PSGData$TST

# Plot sleep times according to PSG
cols <- brewer.pal(n = 3, name = "Dark2")

boxplot(subset(PSGData, Cond == 2)$TST_h, subset(PSGData, Cond == 1)$TST_h,
        ylim = c(0, 10),
        yaxs = "i",
        frame = F,
        main = "",
        ylab = "Time (hours)",
        names = c("Not Sleep Deprived", "Sleep Deprived"))
abline(h = 4, col = cols[1], lty = 2)
for (i in unique(PSGData$Subject[PSGData$AgeGroup == "Old"])){
  temp <- subset(PSGData, Subject == i)
  if (length(temp$Subject) == 2){
    lines(c(1, 2), c(subset(temp, Cond == 2)$TST_h, subset(temp, Cond == 1)$TST_h), col = cols[2])
  }
}
for (i in unique(PSGData$Subject[PSGData$AgeGroup == "Young"])){
  temp <- subset(PSGData, Subject == i)
  lines(c(1, 2), c(subset(temp, Cond == 2)$TST_h, subset(temp, Cond == 1)$TST_h), col = cols[3])
}
legend("topright", legend = c("Younger", "Older"), lty = 1, col = c(cols[2], cols[3]), bty = "n")
