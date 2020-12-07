# A script to read data from all experiments and combine to one file, which is standardised

library(readr)
library(corrplot)
library(psycho)
library(tidyverse)
library(Hmisc)

setwd("~/Desktop/SleepyBrain-Analyses/Sleepmeasures_emotion")
source('Utils/SummarisingFunctions.R', chdir = T)

# Read empathy ratings
Data_HANDSRatings <- read.csv("~/Desktop/SleepyBrain_HANDS/Data/Data_HANDS_ratings.csv", sep=";", dec=",")


Ratings <- subset(Data_HANDSRatings, select = c("Condition", "Rated_Unpleasantness", "Subject", "DeprivationCondition"))

# Calculate mean response per subject and session (for pain and no pain respectively)
Ratings <- summarySE(data <- Ratings, measurevar = "Rated_Unpleasantness", 
                  groupvars = c("Condition", "Subject", "DeprivationCondition"),
                  na.rm = T) 
        

# Change to wide format and subtract no pain from pain
Ratings_pain <- subset(Ratings, Condition == "Pain")
Ratings_nopain <- subset(Ratings, Condition == "No_Pain")

Ratings_wide <- merge(Ratings_pain, Ratings_nopain, by = c("Subject", "DeprivationCondition"))

Ratings_wide$Mean_unpleasantness <- Ratings_wide$Rated_Unpleasantness.x - Ratings_wide$Rated_Unpleasantness.y


#SEM_file will be the main file to use for later
SEM_file <- subset(Ratings_wide, select = c("Subject", "DeprivationCondition", "Mean_unpleasantness"))



# Read ROI data HANDS

Data_ROI_HANDS <- read.csv2("~/Desktop/SleepyBrain_HANDS/Data/Data_ROIs.csv")

Data_ROI_HANDS <- subset(Data_ROI_HANDS, select = c("Subject", "ACC", "AI_L", "AI_R", "DeprivationCondition"))

Data_ROI_HANDS$ACC <- as.numeric(as.character(Data_ROI_HANDS$ACC))
Data_ROI_HANDS$AI <- (as.numeric(as.character(Data_ROI_HANDS$AI_L)) + as.numeric(as.character(Data_ROI_HANDS$AI_R)))/2

# Change name of deprivation condition to be same for all files
levels(Data_ROI_HANDS$DeprivationCondition)[Data_ROI_HANDS$DeprivationCondition == "Sleep Deprived"] <- "SleepRestriction"
levels(Data_ROI_HANDS$DeprivationCondition)[Data_ROI_HANDS$DeprivationCondition == "Not Sleep Deprived"] <- "NormalSleep"

# ROI_SD <- subset(Data_ROI_HANDS, DeprivationCondition == "Sleep Deprived")
# ROI_NSD <- subset(Data_ROI_HANDS, DeprivationCondition == "Not Sleep Deprived")
# 
# ROIs_wide <- merge(ROI_SD, ROI_NSD, by = "Subject", all = T)
# 
# ROIs_wide$Mean_ACC <- rowMeans(ROIs_wide[c('ACC.x', 'ACC.y')], na.rm=TRUE)
# ROIs_wide$Mean_AI <- rowMeans(ROIs_wide[c('AI.x', 'AI.y')], na.rm=TRUE)
# ROIs_wide <- subset(ROIs_wide, select = c("Subject", "Mean_AI", "Mean_ACC"))

Data_ROI_HANDS <- subset(Data_ROI_HANDS, select = c("Subject", "ACC", "DeprivationCondition", "AI"))
SEM_file <- merge(SEM_file, Data_ROI_HANDS, all = TRUE)

# Read FACES data

Faces_data <- read_csv("~/Desktop/SleepyBrain-Analyses/FACES/EMG/ratings.csv")

Faces_data <- subset(Faces_data, select = c("Block_type", "Question_type", "Rating", "newid", "condition"))

Faces_data <- summarySE(data <- Faces_data, measurevar = "Rating", 
                     groupvars = c("Block_type", "Question_type", "newid", "condition"),
                     na.rm = T) 

# Change colnames to be same as in other files
colnames(Faces_data)[colnames(Faces_data) == "condition"] <- "DeprivationCondition"

# Change name of deprivation condition to be same for all files
Faces_data$DeprivationCondition[Faces_data$DeprivationCondition == "sleepdeprived"] <- "SleepRestriction"
Faces_data$DeprivationCondition[Faces_data$DeprivationCondition == "fullsleep"] <- "NormalSleep"
Faces_data$DeprivationCondition <- as.factor(Faces_data$DeprivationCondition)

# Change numbers to actual rating types
Faces_angry_angriness <- subset(Faces_data, Question_type == 3 & Block_type == "Angry")
colnames(Faces_angry_angriness)[which(names(Faces_angry_angriness) == "Rating")] <- "Angriness_angry"
Faces_angry_happiness <- subset(Faces_data, Question_type == 2 & Block_type == "Angry")
colnames(Faces_angry_happiness)[which(names(Faces_angry_happiness) == "Rating")] <- "Happiness_angry"
Faces_happy_angriness <- subset(Faces_data, Question_type == 3 & Block_type == "Happy")
colnames(Faces_happy_angriness)[which(names(Faces_happy_angriness) == "Rating")] <- "Angriness_happy"
Faces_happy_happiness <- subset(Faces_data, Question_type == 2 & Block_type == "Happy")
colnames(Faces_happy_happiness)[which(names(Faces_happy_happiness) == "Rating")] <- "Happiness_happy"

Faces_data <- cbind(Faces_angry_angriness, Faces_angry_happiness, Faces_happy_angriness, Faces_happy_happiness)
Faces_data <- subset(Faces_data, select = c("newid", "Angriness_angry", "Happiness_angry", "Angriness_happy", 
                                            "Happiness_happy", "DeprivationCondition"))

SEM_file <- merge(SEM_file, Faces_data, by.x = c("Subject", "DeprivationCondition"), by.y = c("newid", "DeprivationCondition"), all = T)


# Read EMG data. 
data_diff_zyg <- read.csv2("~/Desktop/SleepyBrain-Analyses/Sleepmeasures_emotion/Data/data_diff_zyg.csv")

data_diff_zyg <- subset(data_diff_zyg, select = c("subject", "condition", "diff"))
colnames(data_diff_zyg) <- c("subject", "condition", "Zyg")

data_diff_corr <- read.csv2("~/Desktop/SleepyBrain-Analyses/Sleepmeasures_emotion/Data/data_diff_corr.csv")

data_diff_corr <- subset(data_diff_corr, select = c("subject", "condition", "diff"))
colnames(data_diff_corr) <- c("subject", "condition", "Corr")


# Change name of deprivation condition to be same for all files
levels(data_diff_zyg$condition)[levels(data_diff_zyg$condition) == "sleepdeprived"] <- "SleepRestriction"
levels(data_diff_zyg$condition)[levels(data_diff_zyg$condition) == "fullsleep"] <- "NormalSleep"

levels(data_diff_corr$condition)[levels(data_diff_corr$condition) == "sleepdeprived"] <- "SleepRestriction"
levels(data_diff_corr$condition)[levels(data_diff_corr$condition) == "fullsleep"] <- "NormalSleep"


SEM_file <- merge(SEM_file, data_diff_zyg, by.x = c("Subject", "DeprivationCondition"), by.y = c("subject", "condition"), all = T)
SEM_file <- merge(SEM_file, data_diff_corr, by.x = c("Subject", "DeprivationCondition"), by.y = c("subject", "condition"), all = T)

# Read ROI data Amygdala
amyg_L_sleepdeprived <- read_delim("~/Desktop/SleepyBrain-Analyses/FACES/ROI_analyses/amygdala_ROI_betas_L_sleepdeprived.csv",
                                                 ";", escape_double = FALSE, trim_ws = TRUE)

amyg_L_fullsleep <- read_delim("~/Desktop/SleepyBrain-Analyses/FACES/ROI_analyses/amygdala_ROI_betas_L_fullsleep.csv",
                                   ";", escape_double = FALSE, trim_ws = TRUE)

amyg_R_sleepdeprived <- read_delim("~/Desktop/SleepyBrain-Analyses/FACES/ROI_analyses/amygdala_ROI_betas_R_sleepdeprived.csv",
                                   ";", escape_double = FALSE, trim_ws = TRUE)

amyg_R_fullsleep <- read_delim("~/Desktop/SleepyBrain-Analyses/FACES/ROI_analyses/amygdala_ROI_betas_R_fullsleep.csv",
                               ";", escape_double = FALSE, trim_ws = TRUE)


# Combine right and left amygdala responses

amyg_joint_fullsleep <- amyg_L_fullsleep
for(i in 2:length(amyg_joint_fullsleep)){ # Loop over columns
  amyg_joint_fullsleep[, i] <- (amyg_L_fullsleep[, i] + amyg_R_fullsleep[, i])/2 #Calculate mean
}
amyg_joint_fullsleep$condition <- "fullsleep"

amyg_joint_sleepdeprived <- amyg_L_sleepdeprived
for(i in 2:length(amyg_joint_sleepdeprived)){
  amyg_joint_sleepdeprived[, i] <- (amyg_L_sleepdeprived[, i] + amyg_R_sleepdeprived[, i])/2
}
amyg_joint_sleepdeprived$condition <- "sleepdeprived"

amyg_joint <- rbind(amyg_joint_fullsleep, amyg_joint_sleepdeprived) 
amyg_joint <- subset(amyg_joint, select = c("ID", "'HA_NE'", "'AN_NE'", "condition"))

# Calculate mean responses 
Amygdala_Happy <- summarySE(data <- amyg_joint, measurevar = "'HA_NE'", 
                     groupvars = c("ID", "condition"),
                     na.rm = T) 

colnames(Amygdala_Happy)[which(names(Amygdala_Happy) == "'HA_NE'")] <- "Amygdala_happy"
Amygdala_Happy <- subset(Amygdala_Happy, select = c("ID", "Amygdala_happy", "condition"))

Amygdala_Angry <- summarySE(data <- amyg_joint, measurevar = "'AN_NE'", 
                            groupvars = c("ID", "condition"),
                            na.rm = T) 

colnames(Amygdala_Angry)[which(names(Amygdala_Angry) == "'AN_NE'")] <- "Amygdala_angry"
Amygdala_Angry <- subset(Amygdala_Angry, select = c("ID", "Amygdala_angry", "condition"))



# Change name of deprivation condition to be same for all files
Amygdala_Happy$condition[Amygdala_Happy$condition == "sleepdeprived"] <- "SleepRestriction"
Amygdala_Happy$condition[Amygdala_Happy$condition == "fullsleep"] <- "NormalSleep"
Amygdala_Happy$condition <- as.factor(Amygdala_Happy$condition)

Amygdala_Angry$condition[Amygdala_Angry$condition == "sleepdeprived"] <- "SleepRestriction"
Amygdala_Angry$condition[Amygdala_Angry$condition == "fullsleep"] <- "NormalSleep"
Amygdala_Angry$condition <- as.factor(Amygdala_Angry$condition)


SEM_file <- merge(SEM_file, Amygdala_Happy, by.x = c("Subject", "DeprivationCondition"), by.y = c("ID", "condition"), all = T)
SEM_file <- merge(SEM_file, Amygdala_Angry, by.x = c("Subject", "DeprivationCondition"), by.y = c("ID", "condition"), all = T)



# Read ROI data FFA
FFA_L_sleepdeprived <- read_delim("~/Desktop/SleepyBrain-Analyses/FACES/ROI_analyses/FFA_ROI_betas_L_sleepdeprived.csv",
                                   ";", escape_double = FALSE, trim_ws = TRUE)

FFA_L_fullsleep <- read_delim("~/Desktop/SleepyBrain-Analyses/FACES/ROI_analyses/FFA_ROI_betas_L_fullsleep.csv",
                               ";", escape_double = FALSE, trim_ws = TRUE)

FFA_R_sleepdeprived <- read_delim("~/Desktop/SleepyBrain-Analyses/FACES/ROI_analyses/FFA_ROI_betas_R_sleepdeprived.csv",
                                   ";", escape_double = FALSE, trim_ws = TRUE)

FFA_R_fullsleep <- read_delim("~/Desktop/SleepyBrain-Analyses/FACES/ROI_analyses/FFA_ROI_betas_R_fullsleep.csv",
                               ";", escape_double = FALSE, trim_ws = TRUE)

# Combine right and left FFA responses

FFA_joint_fullsleep <- FFA_L_fullsleep
for(i in 2:length(FFA_joint_fullsleep)){ # Loop over columns
  FFA_joint_fullsleep[, i] <- (FFA_L_fullsleep[, i] + FFA_R_fullsleep[, i])/2 #Calculate mean
}
FFA_joint_fullsleep$DeprivationCondition <- "NormalSleep"

FFA_joint_sleepdeprived <- FFA_L_sleepdeprived
for(i in 2:length(FFA_joint_sleepdeprived)){
  FFA_joint_sleepdeprived[, i] <- (FFA_L_sleepdeprived[, i] + FFA_R_sleepdeprived[, i])/2
}
FFA_joint_sleepdeprived$DeprivationCondition <- "SleepRestriction"

FFA_joint <- rbind(FFA_joint_fullsleep, FFA_joint_sleepdeprived) 
FFA_joint <- subset(FFA_joint, select = c("ID", "'HA_NE'", "'AN_NE'", "DeprivationCondition"))

colnames(FFA_joint)[which(names(FFA_joint) == "'HA_NE'")] <- "FFA_happy"
colnames(FFA_joint)[which(names(FFA_joint) == "'AN_NE'")] <- "FFA_angry"


SEM_file <- merge(SEM_file, FFA_joint, by.x = c("Subject", "DeprivationCondition"), by.y = c("ID", "DeprivationCondition"), all = T)


# Read success ratings ARROWS
Data_ARROWS_ratings <- read_delim("~/Desktop/SleepyBrain-Analyses/ARROWS/Data/Data_ARROWS_ratings.csv", ";", escape_double = FALSE, trim_ws = TRUE)
Data_ARROWS_ratings <- subset(Data_ARROWS_ratings, Definitely_Understood == T)
Data_ARROWS_ratings <- subset(Data_ARROWS_ratings, select = c("Subject", "StimulusType", "RatedSuccessOfRegulation", "DeprivationCondition"))


Data_ARROWS_ratings <- summarySE(data <- Data_ARROWS_ratings, measurevar = "RatedSuccessOfRegulation", 
                     groupvars = c("StimulusType", "Subject", "DeprivationCondition"),
                     na.rm = T) 

# New columns with each rating type
Ratings_DownregulateNegative <- subset(Data_ARROWS_ratings, StimulusType == "DownregulateNegative")
colnames(Ratings_DownregulateNegative)[which(names(Ratings_DownregulateNegative) == "RatedSuccessOfRegulation")] <- "DownregulateNegative"
Ratings_UpregulateNegative <- subset(Data_ARROWS_ratings, StimulusType == "UpregulateNegative")
colnames(Ratings_UpregulateNegative)[which(names(Ratings_UpregulateNegative) == "RatedSuccessOfRegulation")] <- "UpregulateNegative"
Ratings_MaintainNegative <- subset(Data_ARROWS_ratings, StimulusType == "MaintainNegative")
colnames(Ratings_MaintainNegative)[which(names(Ratings_MaintainNegative) == "RatedSuccessOfRegulation")] <- "MaintainNegative"
Ratings_MaintainNeutral <- subset(Data_ARROWS_ratings, StimulusType == "MaintainNeutral")
colnames(Ratings_MaintainNeutral)[which(names(Ratings_MaintainNeutral) == "RatedSuccessOfRegulation")] <- "MaintainNeutral"

Ratings_DownregulateNegative <- subset(Ratings_DownregulateNegative, select = c("Subject", "DownregulateNegative", "DeprivationCondition"))
Ratings_UpregulateNegative <- subset(Ratings_UpregulateNegative, select = c("Subject", "UpregulateNegative", "DeprivationCondition")) 
Ratings_MaintainNegative <- subset(Ratings_MaintainNegative, select = c("Subject", "MaintainNegative", "DeprivationCondition"))
Ratings_MaintainNeutral <- subset(Ratings_MaintainNeutral, select = c("Subject", "MaintainNeutral", "DeprivationCondition"))
Ratings_ER <- merge(Ratings_DownregulateNegative, Ratings_UpregulateNegative)
Ratings_ER <- merge(Ratings_ER, Ratings_MaintainNegative)

# Standaradise to maintain negative
Ratings_ER$DownregulateNegative <- Ratings_ER$DownregulateNegative - (7 - Ratings_ER$MaintainNegative)
Ratings_ER$UpregulateNegative <- Ratings_ER$UpregulateNegative - (7 - Ratings_ER$MaintainNegative)


# Change name of deprivation condition to be same for all files
Ratings_ER$DeprivationCondition[Ratings_ER$DeprivationCondition == "Sleep Deprived"] <- "SleepRestriction"
Ratings_ER$DeprivationCondition[Ratings_ER$DeprivationCondition == "Not Sleep Deprived"] <- "NormalSleep"
Ratings_ER$DeprivationCondition <- as.factor(Ratings_ER$DeprivationCondition)


SEM_file <- merge(SEM_file, Ratings_ER, all = T)
#SEM_file <- merge(SEM_file, Ratings_MaintainNeutral, all = T)


# Read ROI data ARROWS

Data_ROIs_ARROWS <- read_csv("~/Desktop/SleepyBrain_ARROWS/Data/Data_ROIs_all.csv")

#Data_ROIs_ARROWS$Mean_amygdala_negative <- (Data_ROIs_ARROWS$Amygdala_L_negneu_full + Data_ROIs_ARROWS$Amygdala_R_negneu_full +
#                                            Data_ROIs_ARROWS$Amygdala_R_negneu_0s + Data_ROIs_ARROWS$Amygdala_L_negneu_0s)/4

# Combine left and right ROIs
Data_ROIs_ARROWS$Mean_lOFC <- (Data_ROIs_ARROWS$lOFC_L_Down + Data_ROIs_ARROWS$lOFC_R_Down)/2
Data_ROIs_ARROWS$Mean_dlPFC <- (Data_ROIs_ARROWS$dlPFC_L_Down + Data_ROIs_ARROWS$dlPFC_R_Down)/2
Data_ROIs_ARROWS$Mean_amygdala_down <- (Data_ROIs_ARROWS$Amygdala_L_Down + Data_ROIs_ARROWS$Amygdala_R_Down)/2

Data_ROIs_ARROWS <- subset(Data_ROIs_ARROWS, select = c("DeprivationCondition", "Subject",
                                                        "Mean_lOFC", "Mean_dlPFC", "Mean_amygdala_down"))


# Data_ROIs_Amygdala_neg <- summarySE(Data_ROIs_ARROWS, measurevar = "Mean_amygdala_negative", 
#                                  groupvars = c("Subject"),
#                                  na.rm = T) 
# Data_ROIs_Amygdala_neg <- subset(Data_ROIs_Amygdala_neg, select = c("Subject", "Mean_amygdala_negative"))
# 
# Data_ROIs_Amygdala_down <- summarySE(Data_ROIs_ARROWS, measurevar = "Mean_amygdala_down", 
#                                     groupvars = c("Subject"),
#                                     na.rm = T) 
# Data_ROIs_Amygdala_down <- subset(Data_ROIs_Amygdala_down, select = c("Subject", "Mean_amygdala_down"))

# Reverse amygdala value 
Data_ROIs_ARROWS$Mean_amygdala_down <- Data_ROIs_ARROWS$Mean_amygdala_down*-1


# Data_ROIs_lOFC <- summarySE(Data_ROIs_ARROWS, measurevar = "Mean_lOFC", 
#                                      groupvars = c("Subject"),
#                                      na.rm = T) 
# Data_ROIs_lOFC <- subset(Data_ROIs_lOFC, select = c("Subject", "Mean_lOFC"))
# 
# Data_ROIs_dlPFC <- summarySE(Data_ROIs_ARROWS, measurevar = "Mean_dlPFC", 
#                             groupvars = c("Subject"),
#                             na.rm = T) 
# Data_ROIs_dlPFC <- subset(Data_ROIs_dlPFC, select = c("Subject", "Mean_dlPFC"))

# Change name of deprivation condition to be same for all files
Data_ROIs_ARROWS$DeprivationCondition[Data_ROIs_ARROWS$DeprivationCondition == "Sleep Deprived"] <- "SleepRestriction"
Data_ROIs_ARROWS$DeprivationCondition[Data_ROIs_ARROWS$DeprivationCondition == "Not Sleep Deprived"] <- "NormalSleep"
Data_ROIs_ARROWS$DeprivationCondition <- as.factor(Data_ROIs_ARROWS$DeprivationCondition)


SEM_file <- merge(SEM_file, Data_ROIs_ARROWS, all = T)



#SEM_file_no_subject <- subset(SEM_file, select =-Subject)



colnames(SEM_file) <- c("Subject", "DeprivationCondition", "Unp", "ACC", "AI", "Anger", "Happiness_angry",
                        "Angriness_happy", "Happiness", "Zyg", "Corr", "Amy_happy", "Amy_angry",
                        "FFA_happy", "FFA_angry", "Downr", "Upreg", "MaintainNegative",
                        "lOFC", "dlPFC", "Amy_down")

# Add variable for young and old
AgeGroup <- unique(subset(Data_HANDSRatings, select = c("Subject", "AgeGroup", "Sex")))
SEM_file <- merge(SEM_file, AgeGroup, all = T)

SEM_file_sd <- subset(SEM_file, DeprivationCondition == "SleepRestriction")
SEM_file_nsd <- subset(SEM_file, DeprivationCondition == "NormalSleep")

# Standardize 
SEM_file_sd_standardized <- SEM_file_sd
SEM_file_sd_standardized[ ,3:21] <- scale(SEM_file_sd_standardized[ ,3:21])

SEM_file_nsd_standardized <- SEM_file_nsd
SEM_file_nsd_standardized[ ,3:21] <- scale(SEM_file_nsd_standardized[ ,3:21])

SEM_file_standardized <- rbind(SEM_file_nsd_standardized, SEM_file_sd_standardized)

write.csv(SEM_file, "~/Desktop/SleepyBrain-Analyses/Sleepmeasures_emotion/Data/SEM_Singer.csv")
write.csv(SEM_file_standardized, "~/Desktop/SleepyBrain-Analyses/Sleepmeasures_emotion/Data/SEM_Singer_standardized.csv")





