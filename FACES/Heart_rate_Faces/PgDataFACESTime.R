# Script to process pulse gating data from HANDS experiment
# By Sandra Tamm
# Modified by Gustav Nilsonne 2015-12-19
# Adapted for the FACES experiment 2018-08-06

setwd("~/Box Sync/Sleepy Brain/Datafiles")

# Import pulse gating data
PgDataFACES <- read.csv("HR/PgDataFACESSessionInfo.csv", sep=";")

#Generate a column for time between two pulse registrations
PgDataFACES$DeltaTimePulse <- PgDataFACES$V1
PgDataFACES$DeltaTimePulse <- (c(PgDataFACES$V1, 0)-c(0, PgDataFACES$V1))[1:length(PgDataFACES$Subject)]

# Check registrations
plot(PgDataFACES$DeltaTimePulse)

# Clean up false values (<0) and check again. 
PgDataFACES$DeltaTimePulse[PgDataFACES$DeltaTimePulse<0] <- NA 
plot(PgDataFACES$DeltaTimePulse ~ PgDataFACES$Subject)

# Generate a column for subjects' heart rate
PgDataFACES$HR <- 6000/PgDataFACES$DeltaTimePulse

# Remove first value for first subject (not a full registration) and check data
PgDataFACES$HR[1] <- NA
plot(PgDataFACES$HR ~ PgDataFACES$Subject)
hist(PgDataFACES$HR)

# Remove non-physiological values. This should probably be done somehow else
# Comment by GN 151219: These cutoffs are reasonable on a first pass
PgDataFACES$HR[PgDataFACES$HR<40] <- NA
PgDataFACES$HR[PgDataFACES$HR>200] <- NA

plot(PgDataFACES$HR ~ PgDataFACES$Subject)
hist(PgDataFACES$HR)

# Make list with time factor
LatestPulseTime = max(PgDataFACES$V1)
PgDataFACESTime <- matrix(1:LatestPulseTime)
Iteration = 1
for (i in unique(PgDataFACES$Subject)) {
  for (j in unique(PgDataFACES$Session[PgDataFACES$Subject == i])) {
    # Create a column for Subject i with Session j
    CurrentSessionColumn <- matrix(1:LatestPulseTime)
    
    CurrentSessionPulses <- subset(PgDataFACES$HR, PgDataFACES$Subject == i & PgDataFACES$Session == j)
    CurrentSessionPulseRegistrations <- subset(PgDataFACES$V1, PgDataFACES$Subject == i & PgDataFACES$Session == j)
    
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
    PgDataFACESTime <- cbind(PgDataFACESTime, CurrentSessionColumn)
  }
}

# Make a list of subjects to name the columns
ListOfSubjects <- vector()
ListOfSubjects <- cbind("Time", ListOfSubjects)
for (Subject in unique(PgDataFACES$Subject)) {
  for (Session in unique(PgDataFACES$Session[PgDataFACES$Subject == Subject])) {
    NameOfSubjectAndSession <- paste(Subject, ":", Session)
    ListOfSubjects <- cbind(ListOfSubjects, NameOfSubjectAndSession )
  }
}

colnames(PgDataFACESTime) <- ListOfSubjects

write.csv2(PgDataFACESTime, file = "HR/PgDataFACESTime.csv", row.names=FALSE)
