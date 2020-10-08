# Read sleep measures
library(readr)
library(corrplot)
library(psycho)
library(tidyverse)
library(Hmisc)

setwd("~/Desktop/SleepyBrain-Analyses/Sleepmeasures_emotion")
source('Utils/SummarisingFunctions.R', chdir = T)

# Read empathy ratings

Data_HANDSRatings <- read.csv("~/Desktop/SleepyBrain_HANDS/Data/Data_HANDS_ratings.csv", sep=";", dec=",")

Data_IRI <- subset(Data_HANDSRatings, select = c("IRI_EC", "IRI_PT", "IRI_PD", "IRI_F", "Subject"))

Ratings <- subset(Data_HANDSRatings, select = c("Condition", "Rated_Unpleasantness", "Subject"))

Ratings <- summarySE(data <- Ratings, measurevar = "Rated_Unpleasantness", 
                  groupvars = c("Condition", "Subject"),
                  na.rm = T) 
        
Ratings_pain <- subset(Ratings, Condition == "Pain")
Ratings_nopain <- subset(Ratings, Condition == "No_Pain")

Ratings_wide <- merge(Ratings_pain, Ratings_nopain, by = "Subject")

Ratings_wide$Mean_unpleasantness <- Ratings_wide$Rated_Unpleasantness.x - Ratings_wide$Rated_Unpleasantness.y

SEM_file <- subset(Ratings_wide, select = c("Subject", "Mean_unpleasantness"))

# Read ROI data HANDS

Data_ROI_HANDS <- read.csv2("~/Desktop/SleepyBrain_HANDS/Data/Data_ROIs.csv")

Data_ROI_HANDS <- subset(Data_ROI_HANDS, select = c("Subject", "ACC", "AI_L", "AI_R", "DeprivationCondition"))

Data_ROI_HANDS$ACC <- as.numeric(as.character(Data_ROI_HANDS$ACC))
Data_ROI_HANDS$AI <- (as.numeric(as.character(Data_ROI_HANDS$AI_L)) + as.numeric(as.character(Data_ROI_HANDS$AI_R)))/2


ROI_SD <- subset(Data_ROI_HANDS, DeprivationCondition == "Sleep Deprived")
ROI_NSD <- subset(Data_ROI_HANDS, DeprivationCondition == "Not Sleep Deprived")

ROIs_wide <- merge(ROI_SD, ROI_NSD, by = "Subject", all = T)

ROIs_wide$Mean_ACC <- rowMeans(ROIs_wide[c('ACC.x', 'ACC.y')], na.rm=TRUE)
ROIs_wide$Mean_AI <- rowMeans(ROIs_wide[c('AI.x', 'AI.y')], na.rm=TRUE)
ROIs_wide <- subset(ROIs_wide, select = c("Subject", "Mean_AI", "Mean_ACC"))

SEM_file <- merge(SEM_file, ROIs_wide)

# Read FACES data

Faces_data <- read_csv("~/Desktop/SleepyBrain-Analyses/FACES/EMG/ratings.csv")

Faces_data <- subset(Faces_data, select = c("Block_type", "Question_type", "Rating", "newid"))

Faces_data <- summarySE(data <- Faces_data, measurevar = "Rating", 
                     groupvars = c("Block_type", "Question_type", "newid"),
                     na.rm = T) 


Faces_angry_angriness <- subset(Faces_data, Question_type == 3 & Block_type == "Angry")
colnames(Faces_angry_angriness)[which(names(Faces_angry_angriness) == "Rating")] <- "Angriness_angry"
Faces_angry_happiness <- subset(Faces_data, Question_type == 2 & Block_type == "Angry")
colnames(Faces_angry_happiness)[which(names(Faces_angry_happiness) == "Rating")] <- "Happiness_angry"
Faces_happy_angriness <- subset(Faces_data, Question_type == 3 & Block_type == "Happy")
colnames(Faces_happy_angriness)[which(names(Faces_happy_angriness) == "Rating")] <- "Angriness_happy"
Faces_happy_happiness <- subset(Faces_data, Question_type == 2 & Block_type == "Happy")
colnames(Faces_happy_happiness)[which(names(Faces_happy_happiness) == "Rating")] <- "Happiness_happy"

Faces_data <- cbind(Faces_angry_angriness, Faces_angry_happiness, Faces_happy_angriness, Faces_happy_happiness)
Faces_data <- subset(Faces_data, select = c("newid", "Angriness_angry", "Happiness_angry", "Angriness_happy", "Happiness_happy"))

SEM_file <- merge(SEM_file, Faces_data, by.x = "Subject", by.y = "newid", all = T)

# Read EMG data
EMG_FACES <- read_csv("~/Desktop/SleepyBrain-Analyses/EMG_diff_2.csv")
SEM_file <- merge(SEM_file, EMG_FACES, by.x = "Subject", by.y = "newid", all = T)

# Read ROI data Amygdala
amyg_L_sleepdeprived <- read_delim("~/Desktop/SleepyBrain-Analyses/FACES/ROI_analyses/amygdala_ROI_betas_L_sleepdeprived.csv",
                                                 ";", escape_double = FALSE, trim_ws = TRUE)

amyg_L_fullsleep <- read_delim("~/Desktop/SleepyBrain-Analyses/FACES/ROI_analyses/amygdala_ROI_betas_L_fullsleep.csv",
                                   ";", escape_double = FALSE, trim_ws = TRUE)

amyg_R_sleepdeprived <- read_delim("~/Desktop/SleepyBrain-Analyses/FACES/ROI_analyses/amygdala_ROI_betas_R_sleepdeprived.csv",
                                   ";", escape_double = FALSE, trim_ws = TRUE)

amyg_R_fullsleep <- read_delim("~/Desktop/SleepyBrain-Analyses/FACES/ROI_analyses/amygdala_ROI_betas_R_fullsleep.csv",
                               ";", escape_double = FALSE, trim_ws = TRUE)




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
amyg_joint <- subset(amyg_joint, select = c("ID", "'HA_NE'", "'AN_NE'"))

Amygdala_Happy <- summarySE(data <- amyg_joint, measurevar = "'HA_NE'", 
                     groupvars = c("ID"),
                     na.rm = T) 

colnames(Amygdala_Happy)[which(names(Amygdala_Happy) == "'HA_NE'")] <- "Amygdala_happy"
Amygdala_Happy <- subset(Amygdala_Happy, select = c("ID", "Amygdala_happy"))

Amygdala_Angry <- summarySE(data <- amyg_joint, measurevar = "'AN_NE'", 
                            groupvars = c("ID"),
                            na.rm = T) 

colnames(Amygdala_Angry)[which(names(Amygdala_Angry) == "'AN_NE'")] <- "Amygdala_angry"
Amygdala_Angry <- subset(Amygdala_Angry, select = c("ID", "Amygdala_angry"))


SEM_file <- merge(SEM_file, Amygdala_Happy, by.x = "Subject", by.y = "ID", all = T)
SEM_file <- merge(SEM_file, Amygdala_Angry, by.x = "Subject", by.y = "ID", all = T)


# Read ROI data FFA
FFA_L_sleepdeprived <- read_delim("~/Desktop/SleepyBrain-Analyses/FACES/ROI_analyses/FFA_ROI_betas_L_sleepdeprived.csv",
                                   ";", escape_double = FALSE, trim_ws = TRUE)

FFA_L_fullsleep <- read_delim("~/Desktop/SleepyBrain-Analyses/FACES/ROI_analyses/FFA_ROI_betas_L_fullsleep.csv",
                               ";", escape_double = FALSE, trim_ws = TRUE)

FFA_R_sleepdeprived <- read_delim("~/Desktop/SleepyBrain-Analyses/FACES/ROI_analyses/FFA_ROI_betas_R_sleepdeprived.csv",
                                   ";", escape_double = FALSE, trim_ws = TRUE)

FFA_R_fullsleep <- read_delim("~/Desktop/SleepyBrain-Analyses/FACES/ROI_analyses/FFA_ROI_betas_R_fullsleep.csv",
                               ";", escape_double = FALSE, trim_ws = TRUE)



FFA_joint_fullsleep <- FFA_L_fullsleep
for(i in 2:length(FFA_joint_fullsleep)){ # Loop over columns
  FFA_joint_fullsleep[, i] <- (FFA_L_fullsleep[, i] + FFA_R_fullsleep[, i])/2 #Calculate mean
}
FFA_joint_fullsleep$condition <- "fullsleep"

FFA_joint_sleepdeprived <- FFA_L_sleepdeprived
for(i in 2:length(FFA_joint_sleepdeprived)){
  FFA_joint_sleepdeprived[, i] <- (FFA_L_sleepdeprived[, i] + FFA_R_sleepdeprived[, i])/2
}
FFA_joint_sleepdeprived$condition <- "sleepdeprived"

FFA_joint <- rbind(FFA_joint_fullsleep, FFA_joint_sleepdeprived) 
FFA_joint <- subset(FFA_joint, select = c("ID", "'HA_NE'", "'AN_NE'"))

FFA_Happy <- summarySE(data <- FFA_joint, measurevar = "'HA_NE'", 
                            groupvars = c("ID"),
                            na.rm = T) 

colnames(FFA_Happy)[which(names(FFA_Happy) == "'HA_NE'")] <- "FFA_happy"
FFA_Happy <- subset(FFA_Happy, select = c("ID", "FFA_happy"))

FFA_Angry <- summarySE(data <- FFA_joint, measurevar = "'AN_NE'", 
                            groupvars = c("ID"),
                            na.rm = T) 

colnames(FFA_Angry)[which(names(FFA_Angry) == "'AN_NE'")] <- "FFA_angry"
FFA_Angry <- subset(FFA_Angry, select = c("ID", "FFA_angry"))

SEM_file <- merge(SEM_file, FFA_Happy, by.x = "Subject", by.y = "ID", all = T)
SEM_file <- merge(SEM_file, FFA_Angry, by.x = "Subject", by.y = "ID", all = T)

# Read success ratings ARROWS
Data_ARROWS_ratings <- read_delim("~/Desktop/SleepyBrain-Analyses/ARROWS/Data/Data_ARROWS_ratings.csv", ";", escape_double = FALSE, trim_ws = TRUE)
Data_ARROWS_ratings <- subset(Data_ARROWS_ratings, Definitely_Understood == T)
Data_ARROWS_ratings <- subset(Data_ARROWS_ratings, select = c("Subject", "StimulusType", "RatedSuccessOfRegulation"))


Data_ARROWS_ratings <- summarySE(data <- Data_ARROWS_ratings, measurevar = "RatedSuccessOfRegulation", 
                     groupvars = c("StimulusType", "Subject"),
                     na.rm = T) 

Ratings_DownregulateNegative <- subset(Data_ARROWS_ratings, StimulusType == "DownregulateNegative")
colnames(Ratings_DownregulateNegative)[which(names(Ratings_DownregulateNegative) == "RatedSuccessOfRegulation")] <- "DownregulateNegative"
Ratings_UpregulateNegative <- subset(Data_ARROWS_ratings, StimulusType == "UpregulateNegative")
colnames(Ratings_UpregulateNegative)[which(names(Ratings_UpregulateNegative) == "RatedSuccessOfRegulation")] <- "UpregulateNegative"
Ratings_MaintainNegative <- subset(Data_ARROWS_ratings, StimulusType == "MaintainNegative")
colnames(Ratings_MaintainNegative)[which(names(Ratings_MaintainNegative) == "RatedSuccessOfRegulation")] <- "MaintainNegative"
Ratings_MaintainNeutral <- subset(Data_ARROWS_ratings, StimulusType == "MaintainNeutral")
colnames(Ratings_MaintainNeutral)[which(names(Ratings_MaintainNeutral) == "RatedSuccessOfRegulation")] <- "MaintainNeutral"

Ratings_DownregulateNegative <- subset(Ratings_DownregulateNegative, select = c("Subject", "DownregulateNegative"))
Ratings_UpregulateNegative <- subset(Ratings_UpregulateNegative, select = c("Subject", "UpregulateNegative")) 
Ratings_MaintainNegative <- subset(Ratings_MaintainNegative, select = c("Subject", "MaintainNegative"))
Ratings_MaintainNeutral <- subset(Ratings_MaintainNeutral, select = c("Subject", "MaintainNeutral"))
Ratings_ER <- merge(Ratings_DownregulateNegative, Ratings_UpregulateNegative)
Ratings_ER <- merge(Ratings_ER, Ratings_MaintainNegative)
Ratings_ER$DownregulateNegative <- Ratings_ER$DownregulateNegative - (7 - Ratings_ER$MaintainNegative)
Ratings_ER$UpregulateNegative <- Ratings_ER$UpregulateNegative - (7 - Ratings_ER$MaintainNegative)


SEM_file <- merge(SEM_file, Ratings_ER, all = T)
SEM_file <- merge(SEM_file, Ratings_MaintainNeutral, all = T)




# Read image ratings
Image_data <- read_delim("~/Desktop/SleepyBrain-Analyses/ARROWS/Data/Data_Image_ratings.csv", ";", escape_double = FALSE, trim_ws = TRUE)
Image_data <- subset(Image_data, select = c("Subject", "Valence", "RatedUnpleasantness"))

Image_data <- summarySE(Image_data, measurevar = "RatedUnpleasantness", 
          groupvars = c("Valence", "Subject"),
          na.rm = T) 

Image_data_negative <- subset(Image_data, Valence == "Negative")
Image_data_negative <- subset(Image_data_negative, select = c("Subject", "RatedUnpleasantness"))
Image_data_neutral <- subset(Image_data, Valence == "Neutral")
Image_data_neutral <- subset(Image_data_neutral, select = c("Subject", "RatedUnpleasantness"))

Image_data <- merge(Image_data_negative, Image_data_neutral, by = "Subject")
Image_data$Image_unpleasantness <- Image_data$RatedUnpleasantness.x - Image_data$RatedUnpleasantness.y

Image_data <- subset(Image_data, select = c("Subject", "Image_unpleasantness"))
SEM_file <- merge(SEM_file, Image_data, all = T)

# Read ROI data ARROWS

Data_ROIs_ARROWS <- read_csv("~/Desktop/SleepyBrain_ARROWS/Data/Data_ROIs_all.csv")

Data_ROIs_ARROWS$Mean_amygdala_negative <- (Data_ROIs_ARROWS$Amygdala_L_negneu_full + Data_ROIs_ARROWS$Amygdala_R_negneu_full +
                                            Data_ROIs_ARROWS$Amygdala_R_negneu_0s + Data_ROIs_ARROWS$Amygdala_L_negneu_0s)/4


Data_ROIs_ARROWS$Mean_lOFC <- (Data_ROIs_ARROWS$lOFC_L_Down + Data_ROIs_ARROWS$lOFC_R_Down)/2
Data_ROIs_ARROWS$Mean_dlPFC <- (Data_ROIs_ARROWS$dlPFC_L_Down + Data_ROIs_ARROWS$dlPFC_R_Down)/2
Data_ROIs_ARROWS$Mean_amygdala_down <- (Data_ROIs_ARROWS$Amygdala_L_Down + Data_ROIs_ARROWS$Amygdala_R_Down)/2

Data_ROIs_ARROWS <- subset(Data_ROIs_ARROWS, select = c("DeprivationCondition", "Subject", "Mean_amygdala_negative",
                                                        "Mean_lOFC", "Mean_dlPFC", "Mean_amygdala_down"))


Data_ROIs_Amygdala_neg <- summarySE(Data_ROIs_ARROWS, measurevar = "Mean_amygdala_negative", 
                                 groupvars = c("Subject"),
                                 na.rm = T) 
Data_ROIs_Amygdala_neg <- subset(Data_ROIs_Amygdala_neg, select = c("Subject", "Mean_amygdala_negative"))

Data_ROIs_Amygdala_down <- summarySE(Data_ROIs_ARROWS, measurevar = "Mean_amygdala_down", 
                                    groupvars = c("Subject"),
                                    na.rm = T) 
Data_ROIs_Amygdala_down <- subset(Data_ROIs_Amygdala_down, select = c("Subject", "Mean_amygdala_down"))

# Reverse amygdala value 
Data_ROIs_Amygdala_down$Mean_amygdala_down <- (-0.61959)+(0.66170)-Data_ROIs_Amygdala_down$Mean_amygdala_down


Data_ROIs_lOFC <- summarySE(Data_ROIs_ARROWS, measurevar = "Mean_lOFC", 
                                     groupvars = c("Subject"),
                                     na.rm = T) 
Data_ROIs_lOFC <- subset(Data_ROIs_lOFC, select = c("Subject", "Mean_lOFC"))

Data_ROIs_dlPFC <- summarySE(Data_ROIs_ARROWS, measurevar = "Mean_dlPFC", 
                            groupvars = c("Subject"),
                            na.rm = T) 
Data_ROIs_dlPFC <- subset(Data_ROIs_dlPFC, select = c("Subject", "Mean_dlPFC"))

SEM_file <- merge(SEM_file, Data_ROIs_Amygdala_neg, all = T)
SEM_file <- merge(SEM_file, Data_ROIs_Amygdala_down, all = T)
SEM_file <- merge(SEM_file, Data_ROIs_lOFC, all = T)
SEM_file <- merge(SEM_file, Data_ROIs_dlPFC, all = T)


SEM_file_no_subject <- subset(SEM_file, select =-Subject)



#Add IRI

Data_IRI <- unique(Data_IRI)

SEM_file <- merge(SEM_file, Data_IRI)

colnames(SEM_file) <- c("Subject", "Unp", "AI", "ACC", "Anger", "Happiness_angry",
                        "Angriness_happy", "Happiness", "Zyg", "Corr", "Amy_happy", "Amy_angry",
                        "FFA_happy", "FFA_angry", "Downr", "Upreg", "MaintainNegative", "MaintainNeutral",
                         "Image_unpleasantness", "Amy_neg", "Amy_down",
                        "lOFC", "dlPFC", "IRI_EC", "IRI_PT", "IRI_PD", "IRI_F")


# Standardize 

SEM_file_standardized <- scale(SEM_file)


write.csv(SEM_file, "~/Desktop/SleepyBrain-Analyses/Sleepmeasures_emotion/Data/SEM_Singer.csv")
write.csv(SEM_file_standardized, "~/Desktop/SleepyBrain-Analyses/Sleepmeasures_emotion/Data/SEM_Singer_standardized.csv")


# Write separate files for young and old
AgeGroup <- unique(subset(Data_HANDSRatings, select = c("Subject", "AgeGroup")))

SEM_file_age <- merge(SEM_file, AgeGroup)
SEM_file_young <- subset(SEM_file_age, AgeGroup == "Young")
SEM_file_young <- subset(SEM_file_young, select = -AgeGroup)
SEM_file_young_standardized <- scale(SEM_file_young)
write.csv(SEM_file_young_standardized, "~/Desktop/SleepyBrain-Analyses/Sleepmeasures_emotion/Data/SEM_young_Singer_standardized.csv")

SEM_file_old <- subset(SEM_file_age, AgeGroup == "Old")
SEM_file_old <- subset(SEM_file_old, select = -AgeGroup)
SEM_file_old_standardized <- scale(SEM_file_old)
write.csv(SEM_file_old_standardized, "~/Desktop/SleepyBrain-Analyses/Sleepmeasures_emotion/Data/SEM_old_Singer_standardized.csv")



# 2 = rated happiness
# 3 = rated angriness



