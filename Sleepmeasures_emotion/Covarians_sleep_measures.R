# Read sleep measures
library(readr)
library(corrplot)
library(Hmisc)
setwd("~/Desktop/SleepyBrain-Analyses/Sleepmeasures_emotion/")
source('Utils/SummarisingFunctions.R', chdir = T)

# Read empathy ratings

Data_HANDSRatings <- read.csv("~/Desktop/SleepyBrain_HANDS/Data/Data_HANDS_ratings.csv", sep=";", dec=",")

Demographic <- Data_HANDSRatings[!duplicated(Data_HANDSRatings$Subject),]
Demographic <- subset(Data_HANDSRatings, Picture_no. == 1)


Ratings <- subset(Data_HANDSRatings, select = c("Condition", "Rated_Unpleasantness", "Subject", "DeprivationCondition"))

Ratings <- summarySE(data <- Ratings, measurevar = "Rated_Unpleasantness", 
                     groupvars = c("Condition", "Subject", "DeprivationCondition"),
                     na.rm = T) 

Ratings_pain <- subset(Ratings, Condition == "Pain")
Ratings_nopain <- subset(Ratings, Condition == "No_Pain")

Ratings_wide <- merge(Ratings_pain, Ratings_nopain, by = c("Subject", "DeprivationCondition"))

Ratings_wide$Mean_unpleasantness <- Ratings_wide$Rated_Unpleasantness.x - Ratings_wide$Rated_Unpleasantness.y

SEM_file <- subset(Ratings_wide, select = c("Subject", "Mean_unpleasantness", "DeprivationCondition"))


# Read FACES data

Faces_data <- read_csv("~/Desktop/SleepyBrain-Analyses/FACES/EMG/ratings.csv")

Faces_data <- subset(Faces_data, select = c("Block_type", "Question_type", "Rating", "newid", "condition"))

Faces_data <- summarySE(data <- Faces_data, measurevar = "Rating", 
                        groupvars = c("Block_type", "Question_type", "newid", "condition"),
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
Faces_data <- subset(Faces_data, select = c("newid", "Angriness_angry", "Happiness_angry", "Angriness_happy", "Happiness_happy", "condition"))
Faces_data$condition <- as.factor(Faces_data$condition)

levels(Faces_data$condition)[levels(Faces_data$condition) == "sleepdeprived"] <- "SleepRestriction"
levels(Faces_data$condition)[levels(Faces_data$condition) == "fullsleep"] <- "NormalSleep"


SEM_file <- merge(SEM_file, Faces_data, by.x = c("Subject", "DeprivationCondition"), by.y = c("newid", "condition"), all = T)

# Read success ratings ARROWS
Data_ARROWS_ratings <- read_delim("~/Desktop/SleepyBrain-Analyses/ARROWS/Data/Data_ARROWS_ratings.csv", ";", escape_double = FALSE, trim_ws = TRUE)
Data_ARROWS_ratings <- subset(Data_ARROWS_ratings, Definitely_Understood == T)
Data_ARROWS_ratings <- subset(Data_ARROWS_ratings, select = c("Subject", "StimulusType", "RatedSuccessOfRegulation", "DeprivationCondition"))


Data_ARROWS_ratings <- summarySE(data <- Data_ARROWS_ratings, measurevar = "RatedSuccessOfRegulation", 
                                 groupvars = c("StimulusType", "Subject", "DeprivationCondition"),
                                 na.rm = T) 


Data_ARROWS_ratings$DeprivationCondition <- as.factor(Data_ARROWS_ratings$DeprivationCondition)

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

levels(Ratings_DownregulateNegative$DeprivationCondition)[levels(Ratings_DownregulateNegative$DeprivationCondition) == "Sleep Deprived"] <- "SleepRestriction"
levels(Ratings_DownregulateNegative$DeprivationCondition)[levels(Ratings_DownregulateNegative$DeprivationCondition) == "Not Sleep Deprived"] <- "NormalSleep"
levels(Ratings_UpregulateNegative$DeprivationCondition)[levels(Ratings_UpregulateNegative$DeprivationCondition) == "Sleep Deprived"] <- "SleepRestriction"
levels(Ratings_UpregulateNegative$DeprivationCondition)[levels(Ratings_UpregulateNegative$DeprivationCondition) == "Not Sleep Deprived"] <- "NormalSleep"
levels(Ratings_MaintainNegative$DeprivationCondition)[levels(Ratings_MaintainNegative$DeprivationCondition) == "Sleep Deprived"] <- "SleepRestriction"
levels(Ratings_MaintainNegative$DeprivationCondition)[levels(Ratings_MaintainNegative$DeprivationCondition) == "Not Sleep Deprived"] <- "NormalSleep"
levels(Ratings_MaintainNeutral$DeprivationCondition)[levels(Ratings_MaintainNeutral$DeprivationCondition) == "Sleep Deprived"] <- "SleepRestriction"
levels(Ratings_MaintainNeutral$DeprivationCondition)[levels(Ratings_MaintainNeutral$DeprivationCondition) == "Not Sleep Deprived"] <- "NormalSleep"



SEM_file <- merge(SEM_file, Ratings_MaintainNeutral, all = T)
SEM_file <- merge(SEM_file, Ratings_MaintainNegative, all = T)
SEM_file <- merge(SEM_file, Ratings_UpregulateNegative, all = T)
SEM_file <- merge(SEM_file, Ratings_DownregulateNegative, all = T)

# Read image ratings
Image_data <- read_delim("~/Desktop/SleepyBrain-Analyses/ARROWS/Data/Data_Image_ratings.csv", ";", escape_double = FALSE, trim_ws = TRUE)
Image_data <- subset(Image_data, select = c("Subject", "Valence", "RatedUnpleasantness", "DeprivationCondition"))

Image_data <- summarySE(Image_data, measurevar = "RatedUnpleasantness", 
                        groupvars = c("Valence", "Subject", "DeprivationCondition"),
                        na.rm = T) 

Image_data_negative <- subset(Image_data, Valence == "Negative")
Image_data_negative <- subset(Image_data_negative, select = c("Subject", "RatedUnpleasantness", "DeprivationCondition"))
Image_data_neutral <- subset(Image_data, Valence == "Neutral")
Image_data_neutral <- subset(Image_data_neutral, select = c("Subject", "RatedUnpleasantness", "DeprivationCondition"))

Image_data <- merge(Image_data_negative, Image_data_neutral, by = c("Subject", "DeprivationCondition"))
Image_data$Image_unpleasantness <- Image_data$RatedUnpleasantness.x - Image_data$RatedUnpleasantness.y

Image_data <- subset(Image_data, select = c("Subject", "Image_unpleasantness", "DeprivationCondition"))
Image_data$DeprivationCondition <- as.factor(Image_data$DeprivationCondition)

levels(Image_data$DeprivationCondition)[levels(Image_data$DeprivationCondition) == "Sleep Deprived"] <- "SleepRestriction"
levels(Image_data$DeprivationCondition)[levels(Image_data$DeprivationCondition) == "Not Sleep Deprived"] <- "NormalSleep"


SEM_file <- merge(SEM_file, Image_data, all = T)

# Add sleep
Demographic <- subset(Demographic, select = c("Subject", "DeprivationCondition", "Sex", "AgeGroup", "KSS_Rating", "ISI", "tst__00_nsd",
                                              "tst__00_sd", "n3___00_nsd", "n3___00_sd", "r____00_nsd", "r____00_sd"))


#Demographic <- subset(Demographic, select = c("Subject", "DeprivationCondition", "KSS_Rating", "ISI", "tst__00_nsd", "tst__00_sd", 
                                             # "n3___00_nsd", "n3___00_sd", "r____00_nsd", "r____00_sd"))

SEM_file <- merge(SEM_file, Demographic, all = T)

SEM_file <- subset(SEM_file, select = c("Subject", "DeprivationCondition",  "Sex", "AgeGroup", "Mean_unpleasantness", "Angriness_angry", 
                                        "Happiness_happy", "UpregulateNegative", "DownregulateNegative", "tst__00_nsd", "tst__00_sd",
                                        "n3___00_nsd", "n3___00_sd", "r____00_nsd", "r____00_sd"))




# Add KSS
KSS_data <- read_delim("~/Box Sync/Sleepy Brain/Datafiles/150715_KSSData.csv", ";", escape_double = FALSE, trim_ws = TRUE)
KSS_data <- subset(KSS_data, select = c("Subject", "KSS_Rating", "DeprivationCondition"))

KSS_data <- summarySEwithin(data = KSS_data, measurevar = "KSS_Rating", withinvars = c("Subject", "DeprivationCondition"))
subjectlist <- read.csv("~/Box Sync/Sleepy Brain/Datafiles/Subjects_151215.csv", sep=";")

KSS_data <- merge(KSS_data, subjectlist[, c("Subject", "newid")])
KSS_data <- subset(KSS_data, select = -c(Subject))
KSS_data <- subset(KSS_data, select = c("newid", "DeprivationCondition", "KSS_Rating"))
names(KSS_data)[1] <- "Subject"

levels(KSS_data$DeprivationCondition)[levels(KSS_data$DeprivationCondition) == "Sleep Deprived"] <- "SleepRestriction"
levels(KSS_data$DeprivationCondition)[levels(KSS_data$DeprivationCondition) == "Not Sleep Deprived"] <- "NormalSleep"



SEM_file <- merge(SEM_file, KSS_data, all = T)

colnames(SEM_file) <- c("Subject", "DeprivationCondition", "Sex", "AgeGroup", "Empathic_unpleasantness",
                        "Contagion_angriness", "Contagion_happiness", "Upregulation_success", "Downregulation_success",
                        "TST_fullsleep", "TST_sleepdeprived", "SWS_fullsleep", "SWS_sleepdeprived", "REM_fullsleep",
                        "REM_sleepdeprived", "Sleepiness_KSS")


SEM_file_sd <- subset(SEM_file, DeprivationCondition == "SleepRestriction")
SEM_file_sd <- subset(SEM_file_sd, select =-c(TST_fullsleep, SWS_fullsleep, REM_sleepdeprived))

SEM_file_nsd <- subset(SEM_file, DeprivationCondition == "NormalSleep")
SEM_file_nsd <- subset(SEM_file_nsd, select =-c(TST_sleepdeprived, SWS_sleepdeprived, REM_sleepdeprived))


#SEM_file_diff <- merge(SEM_file_nsd, SEM_file_sd, by = "Subject")
#SEM_file_diff <- SEM_file_diff[ ,3:11] - SEM_file_diff[ ,13:21]

#names(SEM_file_diff) <- c("Mean_unpleasantness", "Angriness_angry", "Happiness_happy", "UpregulateNegative", "DownregulateNegative",
#                     "tst_diff", "n3_diff", "REM_diff", "KSS_diff")


SEM_file_nsd <- subset(SEM_file_nsd, select = -c(DeprivationCondition, Subject, Sex, AgeGroup))
SEM_file_sd <- subset(SEM_file_sd, select = -c(DeprivationCondition, Subject, Sex, AgeGroup))


Correlation_matrix_nsd <- rcorr(as.matrix(SEM_file_nsd))
Correlation_matrix_sd <- rcorr(as.matrix(SEM_file_sd))
#Correlation_matrix_diff <- rcorr(as.matrix(SEM_file_diff))

res1 <- cor.mtest(SEM_file_nsd, conf.level = .95)

## specialized the insignificant value according to the significant level
corrplot(Correlation_matrix_nsd$r, p.mat = res1$p, insig = "label_sig",
         sig.level = c(.001, .01, .05), pch.cex = .7, pch.col = "black")

res2 <- cor.mtest(SEM_file_sd, conf.level = .95)

## specialized the insignificant value according to the significant level
corrplot(Correlation_matrix_sd$r, p.mat = res2$p, insig = "label_sig",
         sig.level = c(.001, .01, .05), pch.cex = .7, pch.col = "black")



# Make youth reference level
SEM_file$AgeGroup <- relevel(SEM_file$AgeGroup, ref = "Young")


# Make function to summarise effects of predictors

summariseRow <- function(measurevar, predictorvar) {
  
  f_sleep_unadj <- reformulate(paste(predictorvar, "*DeprivationCondition"), measurevar)
  model_sleep_predictor_unadj <- lme(f_sleep_unadj, data = SEM_file,
                  random = ~1|Subject, na.action = na.exclude)
  
  estimate_sleep_predictor_unadj <- intervals(model_sleep_predictor_unadj, which = "fixed")
  RoundEstimates_sleep_predictor_unadj <- round(estimate_sleep_predictor_unadj$fixed, digits = 3)
  pval_sleep_predictor_unadj <- anova(model_sleep_predictor_unadj, type = "marginal")
  
  f_sleep_reduced <- reformulate(paste(predictorvar), measurevar)
  model_sleep_predictor_reduced <- lme(f_sleep_reduced, data = SEM_file,
                                     random = ~1|Subject, na.action = na.exclude)
  
  estimate_sleep_predictor_reduced <- intervals(model_sleep_predictor_reduced, which = "fixed")
  RoundEstimates_sleep_predictor_reduced <- round(estimate_sleep_predictor_reduced$fixed, digits = 3)
  pval_sleep_predictor_reduced <- anova(model_sleep_predictor_reduced, type = "marginal")
  
  f_sleep_adj <- reformulate(paste(predictorvar, "*DeprivationCondition + AgeGroup + Sex"), measurevar)
  model_sleep_predictor_adj <- lme(f_sleep_adj, data = SEM_file,
                                     random = ~1|Subject, na.action = na.exclude)
  
  estimate_sleep_predictor_adj <- intervals(model_sleep_predictor_adj, which = "fixed")
  RoundEstimates_sleep_predictor_adj <- round(estimate_sleep_predictor_adj$fixed, digits = 3)
  pval_sleep_predictor_adj <- anova(model_sleep_predictor_adj, type = "marginal")
  
  result <- c(measurevar, predictorvar,
              "Reduced_model",  
              paste(RoundEstimates_sleep_predictor_reduced[2,2], " (", RoundEstimates_sleep_predictor_reduced[2,1],
              "-",  RoundEstimates_sleep_predictor_reduced[2,3], ")",
              sep = ""),
              paste(round(pval_sleep_predictor_reduced[2,4], digits = 3), sep = ""),          
              "Unadjusted_model",  
              paste(RoundEstimates_sleep_predictor_unadj[2,2], " (", RoundEstimates_sleep_predictor_unadj[2,1],
                    "-",  RoundEstimates_sleep_predictor_unadj[2,3], ")",
                    sep = ""),
              paste(round(pval_sleep_predictor_unadj[2,4], digits = 3), sep = ""),
              "Predictor*SleepCondition",
              paste(RoundEstimates_sleep_predictor_unadj[4,2], " (", RoundEstimates_sleep_predictor_unadj[4,1],
                    "-",  RoundEstimates_sleep_predictor_unadj[4,3], ")",
                    sep = ""),
              paste(round(pval_sleep_predictor_unadj[4,4], digits = 3), sep = ""),
              "Adjusted_model",  
              paste(RoundEstimates_sleep_predictor_adj[2,2], " (", RoundEstimates_sleep_predictor_adj[2,1],
                    "-",  RoundEstimates_sleep_predictor_adj[2,3], ")",
                    sep = ""),
              paste(round(pval_sleep_predictor_adj[2,4], digits = 3), sep = ""),
              "Predictor*SleepCondition_Adj",
              paste(RoundEstimates_sleep_predictor_adj[4,2], " (", RoundEstimates_sleep_predictor_adj[4,1],
                    "-",  RoundEstimates_sleep_predictor_adj[4,3], ")",
                    sep = ""),
              paste(round(pval_sleep_predictor_adj[4,4], digits = 3), sep = "")
              )
  
  return(result)
}


# Only keep sleep measures for relevant session
SEM_file$TST <- NA
SEM_file$SWS <- NA
SEM_file$REM <- NA
for(i in 1:length(SEM_file$DeprivationCondition)){
  if(SEM_file$DeprivationCondition[i] == "SleepRestriction"){
    SEM_file$TST[i] <- SEM_file$TST_sleepdeprived[i]
    SEM_file$SWS[i] <- SEM_file$SWS_sleepdeprived[i]
    SEM_file$REM[i] <- SEM_file$REM_sleepdeprived[i]
  }else if(SEM_file$DeprivationCondition[i] == "NormalSleep"){
    SEM_file$TST[i] <- SEM_file$TST_fullsleep[i]
    SEM_file$SWS[i] <- SEM_file$SWS_fullsleep[i]
    SEM_file$REM[i] <- SEM_file$REM_fullsleep[i]
  }
}

SEM_file <- subset(SEM_file, select =-c(TST_sleepdeprived, SWS_sleepdeprived, REM_sleepdeprived, 
                                        TST_fullsleep, SWS_fullsleep, REM_fullsleep))

SEM_file[ ,5:13] <- scale(SEM_file[ ,5:13])


# Loop to obtain results for reduced model
for(i in 5:9){
  measurevar <- names(SEM_file)[i]
  for(j in 10:13){
    predictorvar <- names(SEM_file)[j]
    x <- as.data.frame(as.list(summariseRow(measurevar, predictorvar)))
    x <- x[ ,c(1:2,4:5)]
    x <- setNames(x, c("Measurevar", "Predictorvar", 
                       "CI_red", "p_red"))
    if(j == 10){
      results <- x
    }else{
      results <- rbind(results, x)
    }
  }
  if(i == 5){
    results_reduced <- results
  }else{
    results_reduced <- rbind(results_reduced, results)
    
  }
}
results_reduced <- reshape(results_reduced, idvar = "Measurevar", v.names = c("CI_red", "p_red"), timevar = "Predictorvar", direction = "wide")
#write.csv2(results_reduced, "Predictors_reduced_model.csv")

# Loop to obtain results for unadjusted model
for(i in 5:9){
  measurevar <- names(SEM_file)[i]
  for(j in 10:13){
    predictorvar <- names(SEM_file)[j]
    x <- as.data.frame(as.list(summariseRow(measurevar, predictorvar)))
    x <- x[ ,c(1:2,7:8,10:11)]
    x <- setNames(x, c("Measurevar", "Predictorvar", "CI_unadj",
                  "p_unadj",  "Predictor*SleepCondition_CI", "Predictor*SleepCondition_p"))
    if(j == 10){
      results <- x
    }else{
      results <- rbind(results, x)
    }
  }
  if(i == 5){
    results_unadjusted <- results
  }else{
    results_unadjusted <- rbind(results_unadjusted, results)
  }
}
results_unadjusted <- reshape(results_unadjusted, idvar = "Measurevar", 
                           v.names = c("CI_unadj", "p_unadj", "Predictor*SleepCondition_CI", "Predictor*SleepCondition_p"), 
                           timevar = "Predictorvar", direction = "wide")


#write.csv2(results_unadjusted, "Predictors_unadjsted_model.csv")


# Loop to obtain results for adjusted model
for(i in 5:9){
  measurevar <- names(SEM_file)[i]
  for(j in 10:13){
    predictorvar <- names(SEM_file)[j]
    x <- as.data.frame(as.list(summariseRow(measurevar, predictorvar)))
    x <- x[ ,c(1:2,13:14,16:17)]
    x <- setNames(x, c("Measurevar", "Predictorvar", "CI_adj",
                       "p_adj",  "Predictor*SleepCondition_CI", "Predictor*SleepCondition_p"))
    if(j == 10){
      results <- x
    }else{
      results <- rbind(results, x)
    }
  }
  if(i == 5){
    results_adjusted <- results
  }else{
    results_adjusted <- rbind(results_adjusted, results)
  }
}
results_adjusted <- reshape(results_adjusted, idvar = "Measurevar", 
                              v.names = c("CI_adj", "p_adj", "Predictor*SleepCondition_CI", "Predictor*SleepCondition_p"), 
                              timevar = "Predictorvar", direction = "wide")


#write.csv2(results_adjusted, "Predictors_adjusted_model.csv")




write.csv(SEM_file, "~/Desktop/SleepyBrain-Analyses/Sleepmeasures_emotion/SEM_Sleep.csv")





