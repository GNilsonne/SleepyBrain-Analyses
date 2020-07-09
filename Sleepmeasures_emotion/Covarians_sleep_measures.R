# Use repeated measures here???

# Read sleep measures
library(readr)
library(corrplot)
library(Hmisc)
library(nlme)
require(Gmisc)
setwd("~/Desktop/SleepyBrain-Analyses/Sleepmeasures_emotion/")
source('Utils/SummarisingFunctions.R', chdir = T)

# Read empathy ratings

Data_HANDSRatings <- read.csv("~/Desktop/SleepyBrain_HANDS/Data/Data_HANDS_ratings.csv", sep=";", dec=",")

Demographic <- Data_HANDSRatings[!duplicated(Data_HANDSRatings$Subject),]
Demographic <- subset(Data_HANDSRatings, Picture_no. == 1)

Demographic_tabledata <- Demographic


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

Ratings_ER <- merge(Ratings_DownregulateNegative, Ratings_UpregulateNegative)
Ratings_ER <- merge(Ratings_ER, Ratings_MaintainNegative)
Ratings_ER$DownregulateNegative <- Ratings_ER$DownregulateNegative - (7 - Ratings_ER$MaintainNegative)
Ratings_ER$UpregulateNegative <- Ratings_ER$UpregulateNegative - (7 - Ratings_ER$MaintainNegative)


SEM_file <- merge(SEM_file, Ratings_ER, all = T)
SEM_file <- merge(SEM_file, Ratings_MaintainNeutral, all = T)




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


# Add PANAS

PANAS <- read.csv2("~/Box Sync/Sleepy Brain/Datafiles/PANAS_newids.csv")

PANAS <- subset(PANAS, select=-c(X1))
SEM_file <- merge(SEM_file, PANAS, all.x = TRUE)

colnames(SEM_file) <- c("Subject", "DeprivationCondition", "Sex", "AgeGroup", "Empathic_unpleasantness",
                        "Contagion_angriness", "Contagion_happiness", "Upregulation_success", "Downregulation_success",
                        "TST_fullsleep", "TST_sleepdeprived", "SWS_fullsleep", "SWS_sleepdeprived", "REM_fullsleep",
                        "REM_sleepdeprived", "Sleepiness_KSS", "PANAS_Negative", "PANAS_Negative_fullsleep", 
                        "PANAS_Negative_sleepdeprived", "PANAS_Positive", "PANAS_Positive_fullsleep", "PANAS_Positive_sleepdeprived")


SEM_file_sd <- subset(SEM_file, DeprivationCondition == "SleepRestriction")
SEM_file_sd <- subset(SEM_file_sd, select =-c(TST_fullsleep, SWS_fullsleep, REM_fullsleep))

SEM_file_nsd <- subset(SEM_file, DeprivationCondition == "NormalSleep")
SEM_file_nsd <- subset(SEM_file_nsd, select =-c(TST_sleepdeprived, SWS_sleepdeprived, REM_sleepdeprived))


str(SEM_file_sd)

#Save files
SEM_file_sd_standardized <- SEM_file_sd
SEM_file_sd_standardized[ ,5:13] <- scale(SEM_file_sd_standardized[ ,5:13])
write.csv(SEM_file_sd_standardized, "SEM_file_sd.csv")


SEM_file_nsd_standardized <- SEM_file_nsd
SEM_file_nsd_standardized[ ,5:13] <- scale(SEM_file_nsd_standardized[ ,5:13])
write.csv(SEM_file_nsd_standardized, "SEM_file_nsd.csv")


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

summariseRow <- function(measurevar, predictorvar, Data) {
  
  f_sleep_unadj <- reformulate(paste(predictorvar), measurevar)
  model_sleep_predictor_unadj <- lme(f_sleep_unadj, data = Data,
                  random = ~1|Subject, na.action = na.exclude)
  
  estimate_sleep_predictor_unadj <- intervals(model_sleep_predictor_unadj, which = "fixed")
  RoundEstimates_sleep_predictor_unadj <- round(estimate_sleep_predictor_unadj$fixed, digits = 3)
  pval_sleep_predictor_unadj <- anova(model_sleep_predictor_unadj, type = "marginal")
  
  f_sleep_adj <- reformulate(paste(predictorvar, "+ AgeGroup + Sex"), measurevar)
  model_sleep_predictor_adj <- lme(f_sleep_adj, data = Data,
                                     random = ~1|Subject, na.action = na.exclude)
  
  estimate_sleep_predictor_adj <- intervals(model_sleep_predictor_adj, which = "fixed")
  RoundEstimates_sleep_predictor_adj <- round(estimate_sleep_predictor_adj$fixed, digits = 3)
  pval_sleep_predictor_adj <- anova(model_sleep_predictor_adj, type = "marginal")
  
  result <- c(measurevar, predictorvar,
              "Unadjusted_model",  
              paste(RoundEstimates_sleep_predictor_unadj[2,2], " (", RoundEstimates_sleep_predictor_unadj[2,1],
                    "-",  RoundEstimates_sleep_predictor_unadj[2,3], ")",
                    sep = ""),
              paste(round(pval_sleep_predictor_unadj[2,4], digits = 3), sep = ""),
              "Adjusted_model",  
              paste(RoundEstimates_sleep_predictor_adj[2,2], " (", RoundEstimates_sleep_predictor_adj[2,1],
                    "-",  RoundEstimates_sleep_predictor_adj[2,3], ")",
                    sep = ""),
              paste(round(pval_sleep_predictor_adj[2,4], digits = 3), sep = "")
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

# Data frames separate for tables
SEM_file_nsd_2 <- subset(SEM_file, DeprivationCondition == "NormalSleep")
SEM_file_sd_2 <- subset(SEM_file, DeprivationCondition == "SleepRestriction")

# Loop to obtain results full sleep condition
for(i in 5:9){
  measurevar <- names(SEM_file_nsd_2)[i]
  for(j in 10:13){
    predictorvar <- names(SEM_file_nsd_2)[j]
    x <- as.data.frame(as.list(summariseRow(measurevar, predictorvar, SEM_file_nsd_2)))
    x <- setNames(x, c("Measurevar", "Predictorvar", "Model",
                       "CI", "p", "Model",
                       "CI_adj", "p_adj"))
    if(j == 10){
      results <- x
    }else{
      results <- rbind(results, x)
    }
  }
  if(i == 5){
    results_nsd <- results
  }else{
    results_nsd <- rbind(results_nsd, results)
  }
}


write.csv2(results_nsd, "Predictors_nsd.csv")

# Loop to obtain results sleep restriction condition
for(i in 5:9){
  measurevar <- names(SEM_file_sd_2)[i]
  for(j in 10:13){
    predictorvar <- names(SEM_file_sd_2)[j]
    x <- as.data.frame(as.list(summariseRow(measurevar, predictorvar, SEM_file_sd_2)))
    x <- setNames(x, c("Measurevar", "Predictorvar", "Model",
                       "CI", "p", "Model",
                       "CI_adj", "p_adj"))
    if(j == 10){
      results <- x
    }else{
      results <- rbind(results, x)
    }
  }
  if(i == 5){
    results_sd <- results
  }else{
    results_sd <- rbind(results_sd, results)
  }
}


write.csv2(results_sd, "Predictors_sd.csv")


write.csv(SEM_file, "~/Desktop/SleepyBrain-Analyses/Sleepmeasures_emotion/SEM_Sleep.csv")


Demographic_tabledata <- subset(Demographic_tabledata, DeprivationCondition == "NormalSleep")
# Add mean KSS
Demographic <- subset(Demographic, select = -KSS_Rating) 
Demographic <- merge(Demographic, KSS_data)

Count_data <- summary(Demographic_tabledata$AgeGroup)
Age_data <- getDescriptionStatsBy(Demographic_tabledata$Age, Demographic_tabledata$AgeGroup, html=TRUE, 
                                  continuous_fn = describeMedian)
Sex_data <- getDescriptionStatsBy(Demographic_tabledata$Sex, Demographic_tabledata$AgeGroup, html=TRUE)
BMI_data <- getDescriptionStatsBy(Demographic_tabledata$BMI1, Demographic_tabledata$AgeGroup, html=TRUE)
Edu_data <- getDescriptionStatsBy(Demographic_tabledata$EducationLevel, Demographic_tabledata$AgeGroup, html=TRUE)
Depression_data <- getDescriptionStatsBy(Demographic_tabledata$HADS_Depression, Demographic_tabledata$AgeGroup, html=TRUE)
Anxiety_data <- getDescriptionStatsBy(Demographic_tabledata$HADS_Anxiety, Demographic_tabledata$AgeGroup, html=TRUE)
ISI_data <- getDescriptionStatsBy(Demographic_tabledata$ISI, Demographic_tabledata$AgeGroup, html=TRUE)
TST_fullsleep <- getDescriptionStatsBy(subset(Demographic, DeprivationCondition == "NormalSleep")$tst__00_nsd, 
                                       subset(Demographic, DeprivationCondition == "NormalSleep")$AgeGroup, useNA = c("no"), html=TRUE)
TST_sleeprestriction <- getDescriptionStatsBy(subset(Demographic, DeprivationCondition == "SleepRestriction")$tst__00_sd, 
                                              subset(Demographic, DeprivationCondition == "SleepRestriction")$AgeGroup, useNA = c("no"), html=TRUE)
REM_fullsleep <- getDescriptionStatsBy(subset(Demographic, DeprivationCondition == "NormalSleep")$r____00_nsd, 
                                       subset(Demographic, DeprivationCondition == "NormalSleep")$AgeGroup, useNA = c("no"), html=TRUE)
REM_sleeprestriction <- getDescriptionStatsBy(subset(Demographic, DeprivationCondition == "SleepRestriction")$r____00_sd, 
                                              subset(Demographic, DeprivationCondition == "SleepRestriction")$AgeGroup, useNA = c("no"), html=TRUE)
SWS_fullsleep <- getDescriptionStatsBy(subset(Demographic, DeprivationCondition == "NormalSleep")$n3___00_nsd, 
                                       subset(Demographic, DeprivationCondition == "NormalSleep")$AgeGroup, useNA = c("no"), html=TRUE)
SWS_sleeprestriction <- getDescriptionStatsBy(subset(Demographic, DeprivationCondition == "SleepRestriction")$n3___00_sd, 
                                              subset(Demographic, DeprivationCondition == "SleepRestriction")$AgeGroup, useNA = c("no"), html=TRUE)
Sleepiness_fullsleep <- getDescriptionStatsBy(subset(Demographic, DeprivationCondition == "NormalSleep")$KSS_Rating, 
                                       subset(Demographic, DeprivationCondition == "NormalSleep")$AgeGroup, useNA = c("no"), html=TRUE)
Sleepiness_sleeprestriction <- getDescriptionStatsBy(subset(Demographic, DeprivationCondition == "SleepRestriction")$KSS_Rating, 
                                              subset(Demographic, DeprivationCondition == "SleepRestriction")$AgeGroup, useNA = c("no"), html=TRUE)


# Make table with demographics
htmlTable(
  x        = rbind(Count_data, Age_data, Sex_data, BMI_data, Edu_data, 
                   Depression_data, Anxiety_data, 
                   ISI_data,
                   TST_fullsleep, TST_sleeprestriction,
                   REM_fullsleep, REM_sleeprestriction,
                   SWS_fullsleep, SWS_sleeprestriction,
                   Sleepiness_fullsleep, Sleepiness_sleeprestriction),
  caption  = paste("Table 1. Continuous values are reported as",
                   "means with standard deviations, unless otherwise indicated). Categorical data",
                   "are reported with percentages. Sleep measures are reported in minutes"),
  label    = "Table1",
  rowlabel = "Variables",
  rnames = c("Number of subjects", "Age (median, interquartile range)", "Sex (females)", "BMI", "Elementary school", "High school", 
             "University degree", "University student", "Depression", "Anxiety", 
             "Insomnia severity index", "Total sleep time (min), full sleep",
             "Total sleep time (min), sleep restriction", "REM sleep (min), full sleep",
             "REM sleep (min), sleep restriction", "Slow wave sleep (min), full sleep",
             "Slow wave sleep (min), sleep restriction", "Mean KSS, full sleep", "Mean KSS, sleep restriction"),
  rgroup   = c("Sample", 
               "Demographics",
               "Education",
               "Questionnaires",
               "Sleep",
               "Sleepiness"),
  n.rgroup = c(1,
               3,
               NROW(Edu_data),
               3,
               6,
               2),
  ctable   = TRUE)

