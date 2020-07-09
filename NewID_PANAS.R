# Pseudomise PANAS

Data <- read_csv2("~/Desktop/SleepyBrain-Analyses/Sleepmeasures_emotion/PANAS.csv")
subjectlist <- read.csv("~/Box Sync/Sleepy Brain/Datafiles/Subjects_151215.csv", sep=";")
Data <- merge(Data, subjectlist, by.x = "Subject", by.y = "Subject", all.x =T)
Data <- subset(Data, select = -c(Subject, FulfillsCriteriaAndNoPathologicalFinding, CompletedScanning, MRDataExistFullSleep, 
                                 MRDataexistPSD, MRDataExistBothSessions, SuccessfulIntervention, CanBeIncludedForInterventionEffectsWithMRI))
names(Data)[8] <- "Subject"

Data <- Data[order(Data$Subject), ]
write.csv2(Data, "~/Box Sync/Sleepy Brain/Datafiles/PANAS_newids.csv", row.names = F)
