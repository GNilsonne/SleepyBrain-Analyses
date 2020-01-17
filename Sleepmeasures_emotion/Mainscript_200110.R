# Read sleep measures
source('Utils/SummarisingFunctions.R', chdir = T)

# Read empathy ratings

Data_HANDSRatings <- read.csv("~/Desktop/SleepyBrain_HANDS/Data/Data_HANDS_ratings.csv", sep=";", dec=",")

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

# Read emotion regulation success ratings

