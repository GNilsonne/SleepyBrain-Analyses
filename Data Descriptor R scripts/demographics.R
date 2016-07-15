# Script to make table of demographics for data descriptor paper

# Read data
# We use unpseudonymized file as it has age in years
data <- read.csv2("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/150215_Demographic.csv")

data_out <- data.frame(variable = "Age (median, range)", 
                       younger = paste(median(data$Age[data$Age < 40]), " (", min(data$Age[data$Age < 40]), ", ", max(data$Age[data$Age < 40]), ")", sep = ""),
                       older = paste(median(data$Age[data$Age > 40]), " (", min(data$Age[data$Age > 40]), ", ", max(data$Age[data$Age > 40]), ")", sep = ""))
data_out <- rbind(data_out, data.frame(variable = "Sex (male, female)",
                                       younger = paste(sum(data$Sex[data$Age < 40] == "Male"), ", ", sum(data$Sex[data$Age < 40] == "Female"), sep = ""),
                                       older = paste(sum(data$Sex[data$Age > 40] == "Male"), ", ", sum(data$Sex[data$Age > 40] == "Female"), sep = "")))
data_out <- rbind(data_out, data.frame(variable = "BMI at first scanning (mean, SD)",
                                       younger = paste(round(mean(data$BMI1[data$Age < 40], na.rm = T), 1), " (", round(sd(data$BMI1[data$Age < 40], na.rm = T), 1), ")", sep = ""),
                                       older = paste(round(mean(data$BMI1[data$Age > 40]), 1), " (", round(sd(data$BMI1[data$Age > 40]), 1), ")", sep = "")))
data_out$younger <- as.character(data_out$younger)
data_out$older <- as.character(data_out$older)
data_out <- rbind(data_out,
                  data.frame(variable = c("Completed primary education (n)", "Completed secondary education (n)", "Completed tertiary education (n)", "Currently enrolled in tertiary education (n)"),
                             younger = summary(data$EducationLevel[data$Age < 40]),
                             older = summary(data$EducationLevel[data$Age > 40])))
data_out <- rbind(data_out,
                  data.frame(variable = "ISI (mean, SD)",
                             younger = paste(round(mean(data$ISI[data$Age < 40]), 1), " (", round(sd(data$ISI[data$Age < 40]), 1), ")", sep = ""),
                             older = paste(round(mean(data$ISI[data$Age > 40]), 1), " (", round(sd(data$ISI[data$Age > 40]), 1), ")", sep = "")))
data_out <- rbind(data_out,
                  data.frame(variable = "HADS-Depression (mean, SD)",
                             younger = paste(round(mean(data$HADS_Depression[data$Age < 40]), 1), " (", round(sd(data$HADS_Depression[data$Age < 40]), 1), ")", sep = ""),
                             older = paste(round(mean(data$HADS_Depression[data$Age > 40]), 1), " (", round(sd(data$HADS_Depression[data$Age > 40]), 1), ")", sep = "")))


