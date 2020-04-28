# Script to write new subject no to file for Uri

Eye_tracker_Uri <- read_excel("~/Box Sync/Sleepy Brain/Datafiles/Eye_tracker_Uri.xlsx")

subjectlist <- read.csv("~/Box Sync/Sleepy Brain/Datafiles/Subjects_151215.csv", sep=";")

Data <- merge(Eye_tracker_Uri, subjectlist, by.x = "Subject no.", by.y = "Subject", all.x =T)
Data <- subset(Data, select = c(1:3,11))

SD_file <- read_delim("~/Box Sync/Sleepy Brain/Datafiles/150715_KSSData.csv", ";", escape_double = FALSE, trim_ws = TRUE)
SD_file <- subset(SD_file, select = c("Subject", "Date", "DeprivationCondition"))
SD_file <- unique(SD_file)  

Data$Date <- as.Date(paste("20", substr(Data$Date, 1,2), "-", substr(Data$Date, 3,4), "-", substr(Data$Date, 5,6), sep = ""))

Data <- merge(Data, SD_file, by.x = c("Subject no.", "Date"), by.y = c("Subject", "Date"), all = T)
Data <- subset(Data, !is.na(Data$Comment))


write.csv2(Data, "~/Desktop/Uri_eye_tracker.csv", row.names = F)
