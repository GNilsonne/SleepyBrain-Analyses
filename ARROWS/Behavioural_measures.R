
# Inclusion of participants
# 8 participants misunderstood/did not follow instructions at session 1. 
# Of those 4 participants did not either follow the instructions at session 2. 
# All together 12 sessions will be removed from all analyses. This applies for both behavioural and imaging outcomes. 
# Dubject X, session 2 is already removed

# For additionally 7 participants it was unclear whether they really understood 
# the instructions completely at session 1. For 5 of those the same was true at session 2. 
# Therefore all analyses will be performed also removing those participants (in all 13 sessions). 
# In descriptives plots these 8 participants are still there.
# 

# Script to analyse behavior in the ARROWS experiment
# Sandra Tamm, 150929

# Make sure to be in SleepyBrain_ARROWS.Rproj so that current working directory is where this script is stored 

# Load packages 
require(nlme)
require(ggplot2)
require(doBy)
require(multcomp)
require(reshape2)
require(gridExtra)
require(effects)
require(Gmisc)




# # Change if other system
 source('Utils/SummarisingFunctions.R', chdir = T)
# source('Utils/Multiplot.R', chdir = T)
# 
# # Read colour palette to be used for plots
cbPalette <- c("#ffffcc", "#a1dab4", "#41b6c4", "#225ea8")

#col1 <- "#5899DA"
#col2 <- "#E8743B"
#col3 <- "#19A979"
#col4 <- "#ED4A7B"

col1 <- "#F49390"
col3 <- "#F45866"
col2 <- "#C45AB3"
col4 <- "#631A86"

# Read data
Data_ARROWSRatings <- read.csv2("Data/Data_ARROWS_ratings.csv", sep=";", dec=",")
Data_ImageRatings <- read.csv2("Data/Data_Image_ratings.csv")

Data_ARROWSRatings$StimulusType <- factor(Data_ARROWSRatings$StimulusType, 
                                          levels = c("MaintainNeutral", "MaintainNegative", "UpregulateNegative", "DownregulateNegative"))
Data_ImageRatings$Valence <- factor(Data_ImageRatings$Valence, 
                                          levels = c("Neutral", "Negative"))


Data_ARROWSRatings$AgeGroup <- factor(Data_ARROWSRatings$AgeGroup, 
                                          levels = c("Young", "Old"))
Data_ImageRatings$AgeGroup <- factor(Data_ImageRatings$AgeGroup, 
                                      levels = c("Young", "Old"))


Data_ARROWSRatings_intervention <- subset(Data_ARROWSRatings, ARROWSRatings_Intervention == TRUE)
Data_ImageRatings_intervention <- subset(Data_ImageRatings, ImageRatings_Intervention == TRUE)

Data_ARROWSRatings_subject <- summaryBy(RatedSuccessOfRegulation ~ Subject + StimulusType + AgeGroup, 
                                        data=Data_ARROWSRatings, FUN=mean
                                        )

Data_ARROWSRatings_subject <- reshape(Data_ARROWSRatings_subject, 
        timevar = "StimulusType",
        idvar = c("Subject", "AgeGroup"),
        direction = "wide")

Data_ImageRatings_subject <- summaryBy(RatedUnpleasantness ~ Subject + Valence + AgeGroup, 
                                        data=Data_ImageRatings, FUN=mean
)

Data_ImageRatings_subject <- reshape(Data_ImageRatings_subject, 
                                      timevar = "Valence",
                                      idvar = c("Subject", "AgeGroup"),
                                      direction = "wide")

summary_data <- summarySEwithin(Data_ARROWSRatings_intervention, 
                                "RatedSuccessOfRegulation", 
                                idvar = "Subject",
                                withinvars = c("StimulusType", "DeprivationCondition"), 
                                betweenvars = c("AgeGroup")
 )

summary_data_image <- summarySEwithin(Data_ImageRatings_intervention, 
                                "RatedUnpleasantness", 
                                idvar = "Subject",
                                withinvars = c("Valence", "DeprivationCondition"), 
                                betweenvars = c("AgeGroup")
)

summary_data$group <- paste(summary_data$AgeGroup, ": ", summary_data$DeprivationCondition, sep = "")
  



Data_ARROWSRatings_young <- subset(Data_ARROWSRatings, AgeGroup == "Young")
Data_ARROWSRatings_old <- subset(Data_ARROWSRatings, AgeGroup == "Old")


# Effect of instruction
mean(subset(Data_ARROWSRatings_young, StimulusType == "MaintainNeutral")$RatedSuccessOfRegulation)

Lme_instruction_young <- lme(RatedSuccessOfRegulation ~ StimulusType, random = ~ 1|Subject,
                             data = Data_ARROWSRatings_young)
anova(Lme_instruction_young, type = "marginal")
intervals(Lme_instruction_young)
summary(glht(Lme_instruction_young, linfct=mcp(StimulusType = "Tukey")), 
        test = adjusted(type = "bonferroni"))

mean(subset(Data_ARROWSRatings_old, StimulusType == "MaintainNeutral")$RatedSuccessOfRegulation)

Lme_instruction_old <- lme(RatedSuccessOfRegulation ~ StimulusType, random = ~ 1|Subject,
                             data = Data_ARROWSRatings_old)
anova(Lme_instruction_old, type = "marginal")
intervals(Lme_instruction_old)
summary(glht(Lme_instruction_old, linfct=mcp(StimulusType = "Tukey")), 
        test = adjusted(type = "bonferroni"))


# Investigate age effects
Lme_age_success <- lme(RatedSuccessOfRegulation ~ StimulusType*AgeGroup, random = ~ 1|Subject,
                       data = Data_ARROWSRatings)
anova(Lme_age_success, type = "marginal")
intervals(Lme_age_success)

t.test(subset(Data_ARROWSRatings_subject, AgeGroup == "Young")$RatedSuccessOfRegulation.mean.MaintainNegative,
       subset(Data_ARROWSRatings_subject, AgeGroup == "Old")$RatedSuccessOfRegulation.mean.MaintainNegative)

t.test(subset(Data_ARROWSRatings_subject, AgeGroup == "Young")$RatedSuccessOfRegulation.mean.DownregulateNegative,
       subset(Data_ARROWSRatings_subject, AgeGroup == "Old")$RatedSuccessOfRegulation.mean.DownregulateNegative)

t.test(subset(Data_ARROWSRatings_subject, AgeGroup == "Young")$RatedSuccessOfRegulation.mean.UpregulateNegative,
       subset(Data_ARROWSRatings_subject, AgeGroup == "Old")$RatedSuccessOfRegulation.mean.UpregulateNegative)

t.test(subset(Data_ARROWSRatings_subject, AgeGroup == "Young")$RatedSuccessOfRegulation.mean.MaintainNeutral,
       subset(Data_ARROWSRatings_subject, AgeGroup == "Old")$RatedSuccessOfRegulation.mean.MaintainNeutral)

# Investigate effect of sleep restriction
Data_ARROWSRatings_young_intervention <- subset(Data_ARROWSRatings_intervention, AgeGroup == "Young")
Data_ARROWSRatings_old_intervention <- subset(Data_ARROWSRatings_intervention, AgeGroup == "Old")

Data_ARROWSRatings_subject_intervention <- summaryBy(RatedSuccessOfRegulation ~ Subject + DeprivationCondition + StimulusType + AgeGroup, 
                                        data=Data_ARROWSRatings_intervention, FUN=mean
)

Data_ARROWSRatings_subject_intervention <- reshape(Data_ARROWSRatings_subject_intervention, 
                                      timevar = "StimulusType",
                                      idvar = c("Subject", "DeprivationCondition", "AgeGroup"),
                                      direction = "wide")

Data_ARROWS_subject_intervention_young <- subset(Data_ARROWSRatings_subject_intervention, AgeGroup == "Young")
Data_ARROWS_subject_intervention_old <- subset(Data_ARROWSRatings_subject_intervention, AgeGroup == "Old")

Lme_sleep_young_success <- lme(RatedSuccessOfRegulation ~ StimulusType*DeprivationCondition, random = ~ 1|Subject,
                               data = Data_ARROWSRatings_young_intervention)
anova(Lme_sleep_young_success, type = "marginal")
intervals(Lme_sleep_young_success)

t.test(subset(Data_ARROWS_subject_intervention_young, DeprivationCondition == "Sleep Deprived")$RatedSuccessOfRegulation.mean.MaintainNeutral,
       subset(Data_ARROWS_subject_intervention_young, DeprivationCondition == "Not Sleep Deprived")$RatedSuccessOfRegulation.mean.MaintainNeutral,
       paired = T)

t.test(subset(Data_ARROWS_subject_intervention_young, DeprivationCondition == "Sleep Deprived")$RatedSuccessOfRegulation.mean.MaintainNegative,
       subset(Data_ARROWS_subject_intervention_young, DeprivationCondition == "Not Sleep Deprived")$RatedSuccessOfRegulation.mean.MaintainNegative,
       paired = T)

t.test(subset(Data_ARROWS_subject_intervention_young, DeprivationCondition == "Sleep Deprived")$RatedSuccessOfRegulation.mean.UpregulateNegative,
       subset(Data_ARROWS_subject_intervention_young, DeprivationCondition == "Not Sleep Deprived")$RatedSuccessOfRegulation.mean.UpregulateNegative,
       paired = T)

t.test(subset(Data_ARROWS_subject_intervention_young, DeprivationCondition == "Sleep Deprived")$RatedSuccessOfRegulation.mean.DownregulateNegative,
       subset(Data_ARROWS_subject_intervention_young, DeprivationCondition == "Not Sleep Deprived")$RatedSuccessOfRegulation.mean.DownregulateNegative,
       paired = T)

Lme_sleep_old_success <- lme(RatedSuccessOfRegulation ~ StimulusType*DeprivationCondition, random = ~ 1|Subject,
                               data = Data_ARROWSRatings_old_intervention)
anova(Lme_sleep_old_success, type = "marginal")
intervals(Lme_sleep_old_success)

#Plot!
Lme_All_success <- lme(RatedSuccessOfRegulation ~ StimulusType*DeprivationCondition*AgeGroup, random = ~ 1|Subject,
                       data = Data_ARROWSRatings_intervention)

eff1 <- effect("StimulusType*DeprivationCondition*AgeGroup", Lme_All_success)

plot(c(eff1$fit[1], eff1$fit[2], eff1$fit[3], eff1$fit[4]),
     type = "b",
     lwd =2,
     frame.plot = F,
     main = "Self-rated success, Young",
     ylab = "Self-rated success in following instruction",
     xlab = "Condition",
     xaxt = "n",
     xlim = c(1, 4.5),
     ylim = c(0, 7),
     col = col1,
)
lines(c(1.1, 2.1, 3.1, 4.1), c(eff1$fit[5], eff1$fit[6], eff1$fit[7], eff1$fit[8]), type = "b", col = col2, pch = 16, lty = 2, lwd=2)
lines(c(1, 1), c(eff1$upper[1], eff1$lower[1]), col = col1)
lines(c(2, 2), c(eff1$upper[2], eff1$lower[2]), col = col1)
lines(c(3, 3), c(eff1$upper[3], eff1$lower[3]), col = col1)
lines(c(4, 4), c(eff1$upper[4], eff1$lower[4]), col = col1)
lines(c(1.1, 1.1), c(eff1$upper[5], eff1$lower[5]), col = col2)
lines(c(2.1, 2.1), c(eff1$upper[6], eff1$lower[6]), col = col2)
lines(c(3.1, 3.1), c(eff1$upper[7], eff1$lower[7]), col = col2)
lines(c(4.1, 4.1), c(eff1$upper[8], eff1$lower[8]), col = col2)
axis(1, at = c(1.05, 2.05, 3.05, 4.05), 
     labels = c("Maintain \nneutral", "Maintain \nnegative", "Upregulate \nnegative", "Downregulate \nnegative"), 
     cex.axis=0.75)
legend("topright", col = c(col1, col2), pch = c(1, 16), legend = c("Normal sleep", "Sleep restriction"), bty = "n", lty = c(1,2))


plot(c(eff1$fit[9], eff1$fit[10], eff1$fit[11], eff1$fit[12]),
     type = "b",
     frame.plot = F,
     lwd = 2,
     main = "Self-rated success, Old",
     ylab = "Self-rated success in following instruction",
     xlab = "Condition",
     xaxt = "n",
     xlim = c(1, 4.5),
     ylim = c(0, 7),
     col = col3,
)
lines(c(1.1, 2.1, 3.1, 4.1), c(eff1$fit[13], eff1$fit[14], eff1$fit[15], eff1$fit[16]), type = "b", col = col4, pch = 16, lty = 2, lwd=2)
lines(c(1, 1), c(eff1$upper[9], eff1$lower[9]), col = col3)
lines(c(2, 2), c(eff1$upper[10], eff1$lower[10]), col = col3)
lines(c(3, 3), c(eff1$upper[11], eff1$lower[11]), col = col3)
lines(c(4, 4), c(eff1$upper[12], eff1$lower[12]), col = col3)
lines(c(1.1, 1.1), c(eff1$upper[13], eff1$lower[13]), col = col4)
lines(c(2.1, 2.1), c(eff1$upper[14], eff1$lower[14]), col = col4)
lines(c(3.1, 3.1), c(eff1$upper[15], eff1$lower[15]), col = col4)
lines(c(4.1, 4.1), c(eff1$upper[16], eff1$lower[16]), col = col4)
axis(1, at = c(1.05, 2.05, 3.05, 4.05), 
     labels = c("Maintain \nneutral", "Maintain \nnegative", "Upregulate \nnegative", "Downregulate \nnegative"), 
     cex.axis=0.75)
legend("topright", col = c(col3, col4), pch = c(1, 16), legend = c("Normal sleep", "Sleep restriction"), bty = "n", lty = c(1,2))


# Investigate ratings of unpleasantness
# Effect of valence
Data_ImageRatings_young <- subset(Data_ImageRatings, AgeGroup == "Young")
Data_ImageRatings_old <- subset(Data_ImageRatings, AgeGroup == "Old")

mean(subset(Data_ImageRatings_young, Valence == "Neutral")$RatedUnpleasantness)

Lme_valence_young <- lme(RatedUnpleasantness ~ Valence, random = ~ 1|Subject,
                             data = Data_ImageRatings_young)
anova(Lme_valence_young, type = "marginal")
intervals(Lme_valence_young)

mean(subset(Data_ImageRatings_old, Valence == "Neutral")$RatedUnpleasantness)

Lme_valence_old <- lme(RatedUnpleasantness ~ Valence, random = ~ 1|Subject,
                             data = Data_ImageRatings_old)
anova(Lme_valence_old, type = "marginal")
intervals(Lme_valence_old)

# Investigate age effects on ratings of unpleasantness
Lme_age_unpleasantness <- lme(RatedUnpleasantness ~ StimulusType*AgeGroup, random = ~ 1|Subject,
                       data = Data_ImageRatings)
anova(Lme_age_unpleasantness, type = "marginal")
intervals(Lme_age_unpleasantness)

t.test(subset(Data_ImageRatings_subject, AgeGroup == "Young")$RatedUnpleasantness.mean.Neutral,
       subset(Data_ImageRatings_subject, AgeGroup == "Old")$RatedUnpleasantness.mean.Neutral)

t.test(subset(Data_ImageRatings_subject, AgeGroup == "Young")$RatedUnpleasantness.mean.Negative,
       subset(Data_ImageRatings_subject, AgeGroup == "Old")$RatedUnpleasantness.mean.Negative)



# Effect of sleep restriction on rated unpleasantness
Lme_sleep_young_unpleasantness <- lme(RatedUnpleasantness ~ StimulusType*DeprivationCondition, random = ~ 1|Subject,
                                      data = subset(Data_ImageRatings, AgeGroup == "Young"))
anova(Lme_sleep_young_unpleasantness)
intervals(Lme_sleep_young_unpleasantness)

Lme_sleep_old_unpleasantness <- lme(RatedUnpleasantness ~ StimulusType*DeprivationCondition, random = ~ 1|Subject,
                                      data = subset(Data_ImageRatings, AgeGroup == "Old"))
anova(Lme_sleep_old_unpleasantness)
intervals(Lme_sleep_old_unpleasantness)

# Plot!
Lme_All_unpleasantness <- lme(RatedUnpleasantness ~ Valence*DeprivationCondition*AgeGroup, random = ~ 1|Subject,
                              data = Data_ImageRatings_intervention)
anova(Lme_All_unpleasantness, type = "marginal")
intervals(Lme_All_unpleasantness)

eff2 <- effect("Valence*DeprivationCondition*AgeGroup", Lme_All_unpleasantness)


plot(c(eff2$fit[1], eff2$fit[2]),
     type = "b",
     frame.plot = F,
     lwd = 2,
     main = "Self-rated unpleasantness, outside scanner, Young",
     ylab = "Perceived unpleasantness",
     xlab = "Condition",
     xaxt = "n",
     xlim = c(1, 2.1),
     ylim = c(0, 7),
     col = col1,
)
lines(c(1.05, 2.05), c(eff2$fit[3], eff2$fit[4]), type = "b", col = col2, pch = 16, lty = 2, lwd=2)
lines(c(1, 1), c(eff2$upper[1], eff2$lower[1]), col = col1)
lines(c(2, 2), c(eff2$upper[2], eff2$lower[2]), col = col1)
lines(c(1.05, 1.05), c(eff2$upper[3], eff2$lower[3]), col = col2)
lines(c(2.05, 2.05), c(eff2$upper[4], eff2$lower[4]), col = col2)
axis(1, at = c(1.05, 2.05), 
     labels = c("Neutral", "Negative"), 
     cex.axis=0.75)
legend("topright", col = c(col1, col2), pch = c(1, 16), legend = c("Normal sleep", "Sleep restriction"), bty = "n", lty = c(1,2))


plot(c(eff2$fit[5], eff2$fit[6]),
     type = "b",
     frame.plot = F,
     lwd = 2,
     main = "Self-rated unpleasantness, outside scanner, Old",
     ylab = "Perceived unpleasantness",
     xlab = "Condition",
     xaxt = "n",
     xlim = c(1, 2.1),
     ylim = c(0, 7),
     col = col3,
)
lines(c(1.05, 2.05), c(eff2$fit[7], eff2$fit[8]), type = "b", col = col4, pch = 16, lty = 2, lwd=2)
lines(c(1, 1), c(eff2$upper[5], eff2$lower[5]), col = col3)
lines(c(2, 2), c(eff2$upper[6], eff2$lower[6]), col = col3)
lines(c(1.05, 1.05), c(eff2$upper[7], eff2$lower[7]), col = col4)
lines(c(2.05, 2.05), c(eff2$upper[8], eff2$lower[8]), col = col4)
axis(1, at = c(1.05, 2.05), 
     labels = c("Neutral", "Negative"), 
     cex.axis=0.75)
legend("topright", col = c(col3, col4), pch = c(1, 16), legend = c("Normal sleep", "Sleep restriction"), bty = "n", lty = c(1,2))


# Present data in Table 1 and analyse effect of manipulation on sleepiness

# Demographic data
Demographic <- Data_ARROWSRatings[!duplicated(Data_ARROWSRatings$Subject),]
Data_unique <- Data_ARROWSRatings[!duplicated(Data_ARROWSRatings[c(60,1)]),]

Count_data <- summary(Demographic$AgeGroup)
Age_data <- getDescriptionStatsBy(Demographic$Age, Demographic$AgeGroup, html=TRUE, 
                                  continuous_fn = describeMedian)
Sex_data <- getDescriptionStatsBy(Demographic$Sex, Demographic$AgeGroup, html=TRUE)
BMI_data <- getDescriptionStatsBy(Demographic$BMI1, Demographic$AgeGroup, html=TRUE)
Edu_data <- getDescriptionStatsBy(Demographic$EducationLevel, Demographic$AgeGroup, html=TRUE)
Depression_data <- getDescriptionStatsBy(Demographic$HADS_Depression, Demographic$AgeGroup, html=TRUE)
Anxiety_data <- getDescriptionStatsBy(Demographic$HADS_Anxiety, Demographic$AgeGroup, html=TRUE)
ISI_data <- getDescriptionStatsBy(Demographic$ISI, Demographic$AgeGroup, html=TRUE)
KSS_fullsleep <- getDescriptionStatsBy(subset(Data_unique, DeprivationCondition == "Not Sleep Deprived")$KSS, 
                                       subset(Data_unique, DeprivationCondition == "Not Sleep Deprived")$AgeGroup, html=TRUE)
KSS_sleeprestriction <- getDescriptionStatsBy(subset(Data_unique, DeprivationCondition == "Sleep Deprived")$KSS, 
                                              subset(Data_unique, DeprivationCondition == "Sleep Deprived")$AgeGroup, html=TRUE)
TST_fullsleep <- getDescriptionStatsBy(subset(Data_unique, DeprivationCondition == "Not Sleep Deprived")$tst__00_nsd, 
                                       subset(Data_unique, DeprivationCondition == "Not Sleep Deprived")$AgeGroup, useNA = c("no"), html=TRUE)
TST_sleeprestriction <- getDescriptionStatsBy(subset(Data_unique, DeprivationCondition == "Sleep Deprived")$tst__00_sd, 
                                             subset(Data_unique, DeprivationCondition == "Sleep Deprived")$AgeGroup, useNA = c("no"), html=TRUE)
REM_fullsleep <- getDescriptionStatsBy(subset(Data_unique, DeprivationCondition == "Not Sleep Deprived")$r____00_nsd, 
                                       subset(Data_unique, DeprivationCondition == "Not Sleep Deprived")$AgeGroup, useNA = c("no"), html=TRUE)
REM_sleeprestriction <- getDescriptionStatsBy(subset(Data_unique, DeprivationCondition == "Sleep Deprived")$r____00_sd, 
                                              subset(Data_unique, DeprivationCondition == "Sleep Deprived")$AgeGroup, useNA = c("no"), html=TRUE)
SWS_fullsleep <- getDescriptionStatsBy(subset(Data_unique, DeprivationCondition == "Not Sleep Deprived")$n3___00_nsd, 
                                       subset(Data_unique, DeprivationCondition == "Not Sleep Deprived")$AgeGroup, useNA = c("no"), html=TRUE)
SWS_sleeprestriction <- getDescriptionStatsBy(subset(Data_unique, DeprivationCondition == "Sleep Deprived")$n3___00_sd, 
                                              subset(Data_unique, DeprivationCondition == "Sleep Deprived")$AgeGroup, useNA = c("no"), html=TRUE)


# Function to show htmlTable in viewer.
viewHtmlTable <- function(htmlText) {
  tf <- tempfile(fileext = ".html")
  writeLines(htmlText, tf)
  getOption("viewer")(tf)
}
# Make table with demographics
viewHtmlTable(htmlTable(
  x        = rbind(Count_data, Age_data, Sex_data, BMI_data, Edu_data, 
                   Depression_data, Anxiety_data, 
                   ISI_data, KSS_fullsleep, KSS_sleeprestriction,
                   TST_fullsleep, TST_sleeprestriction,
                   REM_fullsleep, REM_sleeprestriction,
                   SWS_fullsleep, SWS_sleeprestriction
                   ),
  caption  = paste("Table 1. Continuous values are reported as",
                   "means with standard deviations, unless otherwise indicated). Categorical data",
                   "are reported with percentages. Sleep measures are reported in minutes"),
  label    = "Table1",
  rowlabel = "Variables",
  rnames = c("Number of subjects", "Age (median, interquartile range)", "Sex (females)", "BMI", "Elementary school", "High school", 
             "University degree", "University student", "Depression", "Anxiety", 
             "Insomnia severity index", "Karolinska Sleepiness Scale, full sleep", 
             "Karolinska Sleepiness Scale, sleep restriction", "Total sleep time (min), full sleep",
             "Total sleep time (min), sleep restriction", "REM sleep (min), full sleep",
             "REM sleep (min), sleep restriction", "Slow wave sleep (min), full sleep",
             "Slow wave sleep, min (sleep restriction)",
  rgroup   = c("Sample", 
               "Demographics",
               "Education",
               "HADS",
               "Sleep"),
  n.rgroup = c(1,
               3,
               NROW(Edu_data),
               2,
               9),
  ctable   = TRUE)
))



