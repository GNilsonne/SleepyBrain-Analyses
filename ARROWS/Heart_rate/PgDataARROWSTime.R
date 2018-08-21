# Script to process pulse gating data from HANDS experiment
# By Sandra Tamm
# Modified by Gustav Nilsonne 2015-12-19
# Adapted for the ARROWS experiment 2018-06-25

setwd("~/Box Sync/Sleepy Brain/Datafiles")

# Import pulse gating data
PgDataARROWS <- read.csv("HR/PgDataARROWSSessionInfo.csv", sep=";")

#Generate a column for time between two pulse registrations
PgDataARROWS$DeltaTimePulse <- PgDataARROWS$V1
PgDataARROWS$DeltaTimePulse <- (c(PgDataARROWS$V1, 0)-c(0, PgDataARROWS$V1))[1:length(PgDataARROWS$Subject)]

# Check registrations
plot(PgDataARROWS$DeltaTimePulse)

# Clean up false values (<0) and check again. 
PgDataARROWS$DeltaTimePulse[PgDataARROWS$DeltaTimePulse<0] <- NA 
plot(PgDataARROWS$DeltaTimePulse ~ PgDataARROWS$Subject)

# Generate a column for subjects' heart rate
PgDataARROWS$HR <- 6000/PgDataARROWS$DeltaTimePulse

# Remove first value for first subject (not a full registration) and check data
PgDataARROWS$HR[1] <- NA
plot(PgDataARROWS$HR ~ PgDataARROWS$Subject)
hist(PgDataARROWS$HR)

# Remove non-physiological values. This should probably be done somehow else
# Comment by GN 151219: These cutoffs are reasonable on a first pass
PgDataARROWS$HR[PgDataARROWS$HR<40] <- NA
PgDataARROWS$HR[PgDataARROWS$HR>200] <- NA

plot(PgDataARROWS$HR ~ PgDataARROWS$Subject)
hist(PgDataARROWS$HR)

# Make list with time factor
LatestPulseTime = max(PgDataARROWS$V1)
PgDataARROWSTime <- matrix(1:LatestPulseTime)
Iteration = 1
for (i in unique(PgDataARROWS$Subject)) {
  for (j in unique(PgDataARROWS$Session[PgDataARROWS$Subject == i])) {
    # Create a column for Subject i with Session j
    CurrentSessionColumn <- matrix(1:LatestPulseTime)
    
    CurrentSessionPulses <- subset(PgDataARROWS$HR, PgDataARROWS$Subject == i & PgDataARROWS$Session == j)
    CurrentSessionPulseRegistrations <- subset(PgDataARROWS$V1, PgDataARROWS$Subject == i & PgDataARROWS$Session == j)
    
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
    PgDataARROWSTime <- cbind(PgDataARROWSTime, CurrentSessionColumn)
  }
}

# Make a list of subjects to name the columns
ListOfSubjects <- vector()
ListOfSubjects <- cbind("Time", ListOfSubjects)
for (Subject in unique(PgDataARROWS$Subject)) {
  for (Session in unique(PgDataARROWS$Session[PgDataARROWS$Subject == Subject])) {
    NameOfSubjectAndSession <- paste(Subject, ":", Session)
    ListOfSubjects <- cbind(ListOfSubjects, NameOfSubjectAndSession )
  }
}

colnames(PgDataARROWSTime) <- ListOfSubjects

write.csv2(PgDataARROWSTime, file = "HR/PgDataARROWSTime.csv", row.names=FALSE)
