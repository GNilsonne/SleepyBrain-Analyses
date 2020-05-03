# Pseudomise sleep data, short file

Data <- read_delim("~/Box Sync/Sleepy Brain/Datafiles/sleepdata_short_160731.txt", 
                                     "\t", escape_double = FALSE, trim_ws = TRUE)
subjectlist <- read.csv("~/Box Sync/Sleepy Brain/Datafiles/Subjects_151215.csv", sep=";")
Data <- merge(Data, subjectlist, by.x = "Subject", by.y = "Subject", all.x =T)
Data <- subset(Data, select = -c(Subject))
names(Data)[42] <- "Subject"

Data <- Data[order(Data$Subject), ]
write.csv2(Data, "~/Box Sync/Sleepy Brain/Datafiles/Sleepdata_short_newids.csv", row.names = F)
