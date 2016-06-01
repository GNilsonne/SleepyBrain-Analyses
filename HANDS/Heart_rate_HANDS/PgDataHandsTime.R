# Script to process pulse gating data from HANDS experiment
# By Sandra Tamm
# Modified by Gustav Nilsonne 2015-12-19

setwd("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles")

# Import pulse gating data
PgDataHands <- read.csv("HR/PgDataHandsSessionInfo_86subjects.csv", sep=";")

#Generate a column for time between two pulse registrations
PgDataHands$DeltaTimePulse <- PgDataHands$V1
PgDataHands$DeltaTimePulse <- (c(PgDataHands$V1, 0)-c(0, PgDataHands$V1))[1:length(PgDataHands$Subject)]

# Check registrations
plot(PgDataHands$DeltaTimePulse)

# Clean up false values (<0) and check again
PgDataHands$DeltaTimePulse[PgDataHands$DeltaTimePulse<0] <- NA 
plot(PgDataHands$DeltaTimePulse ~ PgDataHands$Subject)

# Generate a column for subjects' heart rate
PgDataHands$HR <- 6000/PgDataHands$DeltaTimePulse

# Remove first value for first subject (not a full registration) and check data
PgDataHands$HR[1] <- NA
plot(PgDataHands$HR ~ PgDataHands$Subject)
hist(PgDataHands$HR)

# Remove non-physiological values. This should probably be done somehow else
# Comment by GN 151219: These cutoffs are reasonable on a first pass
PgDataHands$HR[PgDataHands$HR<40] <- NA
PgDataHands$HR[PgDataHands$HR>200] <- NA

plot(PgDataHands$HR ~ PgDataHands$Subject)
hist(PgDataHands$HR)

# Make list with time factor
LatestPulseTime = max(PgDataHands$V1)
PgDataHandsTime <- matrix(1:LatestPulseTime)
Iteration = 1
for (i in unique(PgDataHands$Subject)) {
  for (j in unique(PgDataHands$Session[PgDataHands$Subject == i])) {
    # Create a column for Subject i with Session j
    CurrentSessionColumn <- matrix(1:LatestPulseTime)
    
    CurrentSessionPulses <- subset(PgDataHands$HR, PgDataHands$Subject == i & PgDataHands$Session == j)
    CurrentSessionPulseRegistrations <- subset(PgDataHands$V1, PgDataHands$Subject == i & PgDataHands$Session == j)
    
    # Clean up pulse up to first registration. Set NA for times before first registration
    for (k in 1:CurrentSessionPulseRegistrations[1]) {
      CurrentSessionColumn[k] = NA
    }
    
    # Clean up pulse after last registration
    TimeAtLastRegistration <- CurrentSessionPulseRegistrations[length(CurrentSessionPulseRegistrations)]
    for (k in TimeAtLastRegistration:length(CurrentSessionColumn)) {
      CurrentSessionColumn[k] = NA
    }
    
    for (k in 1:(length(CurrentSessionPulseRegistrations)-1)) {
      # Figure out the pulse that Subject i had between time at k and k+1
      # Example: Between hundred of second 43 and 150
      Iteration <- Iteration + 1
      PulseRegA <- CurrentSessionPulseRegistrations[k]
      PulseRegB <- CurrentSessionPulseRegistrations[k + 1]
      PulseBetweenAAndB = CurrentSessionPulses[k]
      
      # Set the pulse for all times between time at k and k+1 to the pulse at time k
      CurrentSessionColumn[PulseRegA:PulseRegB] <- PulseBetweenAAndB
    }
    
    # Add this column to the big matrix
    PgDataHandsTime <- cbind(PgDataHandsTime, CurrentSessionColumn)
  }
}

# Make a list of subjects to name the columns
ListOfSubjects <- vector()
ListOfSubjects <- cbind("Time", ListOfSubjects)
for (Subject in unique(PgDataHands$Subject)) {
  for (Session in unique(PgDataHands$Session[PgDataHands$Subject == Subject])) {
    NameOfSubjectAndSession <- paste(Subject, ":", Session)
    ListOfSubjects <- cbind(ListOfSubjects, NameOfSubjectAndSession )
  }
}

colnames(PgDataHandsTime) <- ListOfSubjects

write.csv2(PgDataHandsTime, file = "HR/PgDataHandsTime_86subjects.csv", row.names=FALSE)
