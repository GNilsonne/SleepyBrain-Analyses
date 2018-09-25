# Script to perform ROI analyses on extracted data from PPI analyses

setwd("~/Desktop/SleepyBrain_ARROWS")

PPI_down_vs_maintain_left_Amygdala <- read.csv('Data/PPI_Down_vs_maintain_left_Amygdala.txt')
PPI_down_vs_maintain_right_Amygdala <- read.csv('Data/PPI_Down_vs_maintain_right_Amygdala.txt')
PPI_neg_vs_neu_left_Amygdala <- read.csv('Data/PPI_Negative_vs_neutral_left_Amygdala.txt')
PPI_neg_vs_neu_right_Amygdala <- read.csv('Data/PPI_Negative_vs_neutral_right_Amygdala.txt')


Demographic <- read.csv("~/Box Sync/Sleepy Brain/Datafiles/150215_Demographic.csv", sep=";", dec=",")
PPI_down_vs_maintain_left_Amygdala <- merge(PPI_down_vs_maintain_left_Amygdala, Demographic)
PPI_down_vs_maintain_right_Amygdala <- merge(PPI_down_vs_maintain_right_Amygdala, Demographic)
PPI_neg_vs_neu_left_Amygdala <- merge(PPI_neg_vs_neu_left_Amygdala, Demographic)
PPI_neg_vs_neu_right_Amygdala <- merge(PPI_neg_vs_neu_right_Amygdala, Demographic)


# Find data for early/late scan session
KSSData <- read.csv2("~/Box Sync/Sleepy Brain/Datafiles/140806_KSSData")
# Retain only one rating to get unique rows for subject and session
KSSData <- subset(KSSData, RatingNo == 4)
KSSData <- KSSData[, c(2, 5, 7, 10:11)]
PPI_down_vs_maintain_left_Amygdala <- merge(PPI_down_vs_maintain_left_Amygdala, KSSData)
PPI_down_vs_maintain_right_Amygdala <- merge(PPI_down_vs_maintain_right_Amygdala, KSSData)
PPI_neg_vs_neu_left_Amygdala <- merge(PPI_neg_vs_neu_left_Amygdala, KSSData)
PPI_neg_vs_neu_right_Amygdala <- merge(PPI_neg_vs_neu_right_Amygdala, KSSData)



# # Make column with both group and sleep condition
PPI_down_vs_maintain_left_Amygdala$Group <- paste(PPI_down_vs_maintain_left_Amygdala$AgeGroup, ":", PPI_down_vs_maintain_left_Amygdala$DeprivationCondition, sep = "")
PPI_down_vs_maintain_right_Amygdala$Group <- paste(PPI_down_vs_maintain_right_Amygdala$AgeGroup, ":", PPI_down_vs_maintain_right_Amygdala$DeprivationCondition, sep = "")
PPI_neg_vs_neu_left_Amygdala$Group <- paste(PPI_neg_vs_neu_left_Amygdala$AgeGroup, ":", PPI_neg_vs_neu_left_Amygdala$DeprivationCondition, sep = "")
PPI_neg_vs_neu_right_Amygdala$Group <- paste(PPI_neg_vs_neu_right_Amygdala$AgeGroup, ":", PPI_neg_vs_neu_right_Amygdala$DeprivationCondition, sep = "")



# Subject list 
IncludedSubjects <- read.table("~/Box Sync/Sleepy Brain/Datafiles/SubjectsForARROWS.csv", sep=";", header=T)
IncludedForIntervention <- as.integer(IncludedSubjects$CanBeIncludedForInterventionEffectsWithMRI)
IncludedAnyAnalysis <- as.integer(IncludedSubjects$IncludedAnyfMRI)

# Retain only subjects in list
PPI_down_vs_maintain_left_Amygdala <- PPI_down_vs_maintain_left_Amygdala[PPI_down_vs_maintain_left_Amygdala$Subject %in% as.integer(IncludedForIntervention), ]
PPI_down_vs_maintain_right_Amygdala <- PPI_down_vs_maintain_right_Amygdala[PPI_down_vs_maintain_right_Amygdala$Subject %in% as.integer(IncludedForIntervention), ]
PPI_neg_vs_neu_left_Amygdala <- PPI_neg_vs_neu_left_Amygdala[PPI_neg_vs_neu_left_Amygdala$Subject %in% as.integer(IncludedForIntervention), ]
PPI_neg_vs_neu_right_Amygdala <- PPI_neg_vs_neu_right_Amygdala[PPI_neg_vs_neu_right_Amygdala$Subject %in% as.integer(IncludedForIntervention), ]



lme_down_vs_maintain <- lme(dlPFC_L ~ DeprivationCondition*AgeGroup, 
                       data = PPI_down_vs_maintain_left_Amygdala, random = ~ 1|Subject, na.action = na.exclude)

anova(lme_down_vs_maintain, type = "marginal")
intervals(lme_down_vs_maintain)
summary(lme_down_vs_maintain)

lme_down_vs_maintain <- lme(dlPFC_R ~ DeprivationCondition*AgeGroup, 
                            data = PPI_down_vs_maintain_left_Amygdala, random = ~ 1|Subject, na.action = na.exclude)

anova(lme_down_vs_maintain, type = "marginal")
intervals(lme_down_vs_maintain)
summary(lme_down_vs_maintain)

lme_down_vs_maintain <- lme(lOFC_L ~ DeprivationCondition*AgeGroup, 
                            data = PPI_down_vs_maintain_left_Amygdala, random = ~ 1|Subject, na.action = na.exclude)

anova(lme_down_vs_maintain, type = "marginal")
intervals(lme_down_vs_maintain)
summary(lme_down_vs_maintain)

lme_down_vs_maintain <- lme(lOFC_R ~ DeprivationCondition*AgeGroup, 
                            data = PPI_down_vs_maintain_left_Amygdala, random = ~ 1|Subject, na.action = na.exclude)

anova(lme_down_vs_maintain, type = "marginal")
intervals(lme_down_vs_maintain)
summary(lme_down_vs_maintain)


lme_down_vs_maintain <- lme(dlPFC_L ~ DeprivationCondition*AgeGroup, 
                            data = PPI_down_vs_maintain_right_Amygdala, random = ~ 1|Subject, na.action = na.exclude)

anova(lme_down_vs_maintain, type = "marginal")
intervals(lme_down_vs_maintain)
summary(lme_down_vs_maintain)

lme_down_vs_maintain <- lme(dlPFC_R ~ DeprivationCondition*AgeGroup, 
                            data = PPI_down_vs_maintain_right_Amygdala, random = ~ 1|Subject, na.action = na.exclude)

anova(lme_down_vs_maintain, type = "marginal")
intervals(lme_down_vs_maintain)
summary(lme_down_vs_maintain)

lme_down_vs_maintain <- lme(lOFC_L ~ DeprivationCondition*AgeGroup, 
                            data = PPI_down_vs_maintain_right_Amygdala, random = ~ 1|Subject, na.action = na.exclude)

anova(lme_down_vs_maintain, type = "marginal")
intervals(lme_down_vs_maintain)
summary(lme_down_vs_maintain)

lme_down_vs_maintain <- lme(lOFC_R ~ DeprivationCondition*AgeGroup, 
                            data = PPI_down_vs_maintain_right_Amygdala, random = ~ 1|Subject, na.action = na.exclude)

anova(lme_down_vs_maintain, type = "marginal")
intervals(lme_down_vs_maintain)
summary(lme_down_vs_maintain)

lme_neg_vs_neu <- lme(dlPFC_L ~ DeprivationCondition*AgeGroup, 
                            data = PPI_neg_vs_neu_left_Amygdala, random = ~ 1|Subject, na.action = na.exclude)

anova(lme_neg_vs_neu, type = "marginal")
intervals(lme_neg_vs_neu)
summary(lme_neg_vs_neu)

lme_neg_vs_neu <- lme(dlPFC_R ~ DeprivationCondition*AgeGroup, 
                            data = PPI_neg_vs_neu_left_Amygdala, random = ~ 1|Subject, na.action = na.exclude)

anova(lme_neg_vs_neu, type = "marginal")
intervals(lme_neg_vs_neu)
summary(lme_neg_vs_neu)

lme_neg_vs_neu <- lme(lOFC_L ~ DeprivationCondition*AgeGroup, 
                            data = PPI_neg_vs_neu_left_Amygdala, random = ~ 1|Subject, na.action = na.exclude)

anova(lme_neg_vs_neu, type = "marginal")
intervals(lme_neg_vs_neu)
summary(lme_neg_vs_neu)

lme_neg_vs_neu <- lme(lOFC_R ~ DeprivationCondition*AgeGroup, 
                            data = PPI_neg_vs_neu_left_Amygdala, random = ~ 1|Subject, na.action = na.exclude)

anova(lme_neg_vs_neu, type = "marginal")
intervals(lme_neg_vs_neu)
summary(lme_neg_vs_neu)

lme_neg_vs_neu <- lme(dlPFC_L ~ DeprivationCondition*AgeGroup, 
                      data = PPI_neg_vs_neu_right_Amygdala, random = ~ 1|Subject, na.action = na.exclude)

anova(lme_neg_vs_neu, type = "marginal")
intervals(lme_neg_vs_neu)
summary(lme_neg_vs_neu)

lme_neg_vs_neu <- lme(dlPFC_R ~ DeprivationCondition*AgeGroup, 
                      data = PPI_neg_vs_neu_right_Amygdala, random = ~ 1|Subject, na.action = na.exclude)

anova(lme_neg_vs_neu, type = "marginal")
intervals(lme_neg_vs_neu, which = "fixed")
summary(lme_neg_vs_neu)

lme_neg_vs_neu <- lme(lOFC_L ~ DeprivationCondition*AgeGroup, 
                      data = PPI_neg_vs_neu_right_Amygdala, random = ~ 1|Subject, na.action = na.exclude)

anova(lme_neg_vs_neu, type = "marginal")
intervals(lme_neg_vs_neu, which = "fixed")
summary(lme_neg_vs_neu)

lme_neg_vs_neu <- lme(lOFC_R ~ DeprivationCondition*AgeGroup, 
                      data = PPI_neg_vs_neu_right_Amygdala, random = ~ 1|Subject, na.action = na.exclude)

anova(lme_neg_vs_neu, type = "marginal")
intervals(lme_neg_vs_neu)
summary(lme_neg_vs_neu)


## Do the same, but only in young
# Retain only subjects in list
PPI_down_vs_maintain_left_Amygdala <- subset(PPI_down_vs_maintain_left_Amygdala, AgeGroup == "Young")
PPI_down_vs_maintain_right_Amygdala <- subset(PPI_down_vs_maintain_right_Amygdala, AgeGroup == "Young")
PPI_neg_vs_neu_left_Amygdala <- subset(PPI_neg_vs_neu_left_Amygdala, AgeGroup == "Young") 
PPI_neg_vs_neu_right_Amygdala <- subset(PPI_neg_vs_neu_right_Amygdala, AgeGroup == "Young")


lme_down_vs_maintain <- lme(dlPFC_L ~ DeprivationCondition, 
                            data = PPI_down_vs_maintain_left_Amygdala, random = ~ 1|Subject, na.action = na.exclude)

anova(lme_down_vs_maintain, type = "marginal")
intervals(lme_down_vs_maintain, which = "fixed")
summary(lme_down_vs_maintain)

lme_down_vs_maintain <- lme(dlPFC_R ~ DeprivationCondition, 
                            data = PPI_down_vs_maintain_left_Amygdala, random = ~ 1|Subject, na.action = na.exclude)

anova(lme_down_vs_maintain, type = "marginal")
intervals(lme_down_vs_maintain)
summary(lme_down_vs_maintain)

lme_down_vs_maintain <- lme(lOFC_L ~ DeprivationCondition, 
                            data = PPI_down_vs_maintain_left_Amygdala, random = ~ 1|Subject, na.action = na.exclude)

anova(lme_down_vs_maintain, type = "marginal")
intervals(lme_down_vs_maintain)
summary(lme_down_vs_maintain)

lme_down_vs_maintain <- lme(lOFC_R ~ DeprivationCondition, 
                            data = PPI_down_vs_maintain_left_Amygdala, random = ~ 1|Subject, na.action = na.exclude)

anova(lme_down_vs_maintain, type = "marginal")
intervals(lme_down_vs_maintain, which = "fixed")
summary(lme_down_vs_maintain)


lme_down_vs_maintain <- lme(dlPFC_L ~ DeprivationCondition, 
                            data = PPI_down_vs_maintain_right_Amygdala, random = ~ 1|Subject, na.action = na.exclude)

anova(lme_down_vs_maintain, type = "marginal")
intervals(lme_down_vs_maintain)
summary(lme_down_vs_maintain)

lme_down_vs_maintain <- lme(dlPFC_R ~ DeprivationCondition, 
                            data = PPI_down_vs_maintain_right_Amygdala, random = ~ 1|Subject, na.action = na.exclude)

anova(lme_down_vs_maintain, type = "marginal")
intervals(lme_down_vs_maintain)
summary(lme_down_vs_maintain)

lme_down_vs_maintain <- lme(lOFC_L ~ DeprivationCondition, 
                            data = PPI_down_vs_maintain_right_Amygdala, random = ~ 1|Subject, na.action = na.exclude)

anova(lme_down_vs_maintain, type = "marginal")
intervals(lme_down_vs_maintain)
summary(lme_down_vs_maintain)

lme_down_vs_maintain <- lme(lOFC_R ~ DeprivationCondition, 
                            data = PPI_down_vs_maintain_right_Amygdala, random = ~ 1|Subject, na.action = na.exclude)

anova(lme_down_vs_maintain, type = "marginal")
intervals(lme_down_vs_maintain)
summary(lme_down_vs_maintain)

lme_neg_vs_neu <- lme(dlPFC_L ~ DeprivationCondition, 
                      data = PPI_neg_vs_neu_left_Amygdala, random = ~ 1|Subject, na.action = na.exclude)

anova(lme_neg_vs_neu, type = "marginal")
intervals(lme_neg_vs_neu)
summary(lme_neg_vs_neu)

lme_neg_vs_neu <- lme(dlPFC_R ~ DeprivationCondition, 
                      data = PPI_neg_vs_neu_left_Amygdala, random = ~ 1|Subject, na.action = na.exclude)

anova(lme_neg_vs_neu, type = "marginal")
intervals(lme_neg_vs_neu)
summary(lme_neg_vs_neu)

lme_neg_vs_neu <- lme(lOFC_L ~ DeprivationCondition, 
                      data = PPI_neg_vs_neu_left_Amygdala, random = ~ 1|Subject, na.action = na.exclude)

anova(lme_neg_vs_neu, type = "marginal")
intervals(lme_neg_vs_neu, which = "fixed")
summary(lme_neg_vs_neu)

lme_neg_vs_neu <- lme(lOFC_R ~ DeprivationCondition, 
                      data = PPI_neg_vs_neu_left_Amygdala, random = ~ 1|Subject, na.action = na.exclude)

anova(lme_neg_vs_neu, type = "marginal")
intervals(lme_neg_vs_neu)
summary(lme_neg_vs_neu)

lme_neg_vs_neu <- lme(dlPFC_L ~ DeprivationCondition, 
                      data = PPI_neg_vs_neu_right_Amygdala, random = ~ 1|Subject, na.action = na.exclude)

anova(lme_neg_vs_neu, type = "marginal")
intervals(lme_neg_vs_neu)
summary(lme_neg_vs_neu)

lme_neg_vs_neu <- lme(dlPFC_R ~ DeprivationCondition, 
                      data = PPI_neg_vs_neu_right_Amygdala, random = ~ 1|Subject, na.action = na.exclude)

anova(lme_neg_vs_neu, type = "marginal")
intervals(lme_neg_vs_neu, which = "fixed")
summary(lme_neg_vs_neu)

lme_neg_vs_neu <- lme(lOFC_L ~ DeprivationCondition, 
                      data = PPI_neg_vs_neu_right_Amygdala, random = ~ 1|Subject, na.action = na.exclude)

anova(lme_neg_vs_neu, type = "marginal")
intervals(lme_neg_vs_neu, which = "fixed")
summary(lme_neg_vs_neu)

lme_neg_vs_neu <- lme(lOFC_R ~ DeprivationCondition, 
                      data = PPI_neg_vs_neu_right_Amygdala, random = ~ 1|Subject, na.action = na.exclude)

anova(lme_neg_vs_neu, type = "marginal")
intervals(lme_neg_vs_neu)
summary(lme_neg_vs_neu)


