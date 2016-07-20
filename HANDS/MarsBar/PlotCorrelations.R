setwd("~/Dropbox/Sleepy Brain (1)/Datafiles/fMRI_HANDS")

# Get data
AllSessionCorrelationMatrix <- read.csv("AllSessionsKSS.csv", sep=";", dec=",")
CorrelationMatrix <- read.csv("FullSleepBaselineScreening.csv", sep=";", dec=",")

# Load packages for linear models
library("nlme", lib.loc="/Users/sandratham/Library/R/3.0/library")


#Correlations with IRI
plot(as.numeric(CorrelationMatrix$AI_L) ~ CorrelationMatrix$IRI_EC, xlab ="IRI, empathic concern", ylab= "Anterior Insula, left")
abline(lm(as.numeric(CorrelationMatrix$AI_L) ~ CorrelationMatrix$IRI_EC))
smry <- summary(lm(as.numeric(CorrelationMatrix$AI_L) ~ CorrelationMatrix$IRI_EC))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))

plot(CorrelationMatrix$AI_R ~ CorrelationMatrix$IRI_EC, xlab ="IRI, empathic concern", ylab= "Anterior Insula, right")
abline(lm(as.numeric(CorrelationMatrix$AI_R) ~ CorrelationMatrix$IRI_EC))
smry <- summary(lm(as.numeric(CorrelationMatrix$AI_R) ~ CorrelationMatrix$IRI_EC))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))


plot(CorrelationMatrix$MCC ~ CorrelationMatrix$IRI_EC, xlab ="IRI, empathic concern", ylab= "Medial Cingulate Cortex")
abline(lm(as.numeric(CorrelationMatrix$MCC) ~ CorrelationMatrix$IRI_EC))
smry <- summary(lm(as.numeric(CorrelationMatrix$MCC) ~ CorrelationMatrix$IRI_EC))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))


plot(CorrelationMatrix$IPC_L ~ CorrelationMatrix$IRI_EC, xlab ="IRI, empathic concern", ylab= "IPC (Supramarginal Gyrus), left")
abline(lm(as.numeric(CorrelationMatrix$IPC_L) ~ CorrelationMatrix$IRI_EC))
smry <- summary(lm(as.numeric(CorrelationMatrix$IPC_L) ~ CorrelationMatrix$IRI_EC))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))


#Correlations with Coldheartedness
plot(CorrelationMatrix$AI_L ~ CorrelationMatrix$C, xlab ="PPI_R, coldheartedness", ylab= "Anterior Insula, left")
abline(lm(CorrelationMatrix$AI_L ~ CorrelationMatrix$C))
smry <- summary(lm(as.numeric(CorrelationMatrix$AI_L) ~ CorrelationMatrix$C))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))

plot(CorrelationMatrix$AI_R ~ CorrelationMatrix$C, xlab ="PPI_R, coldheartedness", ylab= "Anterior Insula, right")
abline(lm(CorrelationMatrix$AI_L ~ CorrelationMatrix$C))
smry <- summary(lm(as.numeric(CorrelationMatrix$AI_R) ~ CorrelationMatrix$C))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))

plot(CorrelationMatrix$MCC ~ CorrelationMatrix$C, xlab ="PPI_R, coldheartedness", ylab= "Medial Cingulate Cortex")
abline(lm(CorrelationMatrix$MCC ~ CorrelationMatrix$C))
smry <- summary(lm(as.numeric(CorrelationMatrix$MCC) ~ CorrelationMatrix$C))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))

plot(CorrelationMatrix$IPC ~ CorrelationMatrix$C, xlab ="PPI_R, coldheartedness", ylab= "IPC (Supramarginal Gyrus), left")
abline(lm(CorrelationMatrix$IPC ~ CorrelationMatrix$C))
smry <- summary(lm(as.numeric(CorrelationMatrix$IPC) ~ CorrelationMatrix$C))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))

#Correlations with KSQ_SleepSymptomIndex
plot(CorrelationMatrix$AI_L ~ CorrelationMatrix$KSQ_SleepSymptomIndex, xlab ="KSQ_SleepSymptomIndex", ylab= "Anterior Insula, left")
abline(lm(CorrelationMatrix$AI_L ~ CorrelationMatrix$KSQ_SleepSymptomIndex))
smry <- summary(lm(as.numeric(CorrelationMatrix$AI_L) ~ CorrelationMatrix$KSQ_SleepSymptomIndex))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))

plot(CorrelationMatrix$AI_R ~ CorrelationMatrix$KSQ_SleepSymptomIndex, xlab ="KSQ_SleepSymptomIndex", ylab= "Anterior Insula, right")
abline(lm(CorrelationMatrix$AI_L ~ CorrelationMatrix$KSQ_SleepSymptomIndex))
smry <- summary(lm(as.numeric(CorrelationMatrix$AI_R) ~ CorrelationMatrix$KSQ_SleepSymptomIndex))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))

plot(CorrelationMatrix$MCC ~ CorrelationMatrix$KSQ_SleepSymptomIndex, xlab ="KSQ_SleepSymptomIndex", ylab= "Medial Cingulate Cortex")
abline(lm(CorrelationMatrix$MCC ~ CorrelationMatrix$KSQ_SleepSymptomIndex))
smry <- summary(lm(as.numeric(CorrelationMatrix$MCC) ~ CorrelationMatrix$KSQ_SleepSymptomIndex))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))

plot(CorrelationMatrix$IPC ~ CorrelationMatrix$KSQ_SleepSymptomIndex, xlab ="KSQ_SleepSymptomIndex", ylab= "IPC (Supramarginal Gyrus), left")
abline(lm(CorrelationMatrix$IPC ~ CorrelationMatrix$KSQ_SleepSymptomIndex))
smry <- summary(lm(as.numeric(CorrelationMatrix$IPC) ~ CorrelationMatrix$KSQ_SleepSymptomIndex))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))

#Correlations with KSQ_SleepQualityIndex
plot(CorrelationMatrix$AI_L ~ CorrelationMatrix$KSQ_SleepQualityIndex, xlab ="KSQ_SleepQualityIndex", ylab= "Anterior Insula, left")
abline(lm(CorrelationMatrix$AI_L ~ CorrelationMatrix$KSQ_SleepQualityIndex))
smry <- summary(lm(as.numeric(CorrelationMatrix$AI_L) ~ CorrelationMatrix$KSQ_SleepQualityIndex))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))

plot(CorrelationMatrix$AI_R ~ CorrelationMatrix$KSQ_SleepQualityIndex, xlab ="KSQ_SleepQualityIndex", ylab= "Anterior Insula, right")
abline(lm(CorrelationMatrix$AI_L ~ CorrelationMatrix$KSQ_SleepQualityIndex))
smry <- summary(lm(as.numeric(CorrelationMatrix$AI_R) ~ CorrelationMatrix$KSQ_SleepQualityIndex))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))

plot(CorrelationMatrix$MCC ~ CorrelationMatrix$KSQ_SleepQualityIndex, xlab ="KSQ_SleepQualityIndex", ylab= "Medial Cingulate Cortex")
abline(lm(CorrelationMatrix$MCC ~ CorrelationMatrix$KSQ_SleepQualityIndex))
smry <- summary(lm(as.numeric(CorrelationMatrix$MCC) ~ CorrelationMatrix$KSQ_SleepQualityIndex))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))

plot(CorrelationMatrix$IPC ~ CorrelationMatrix$KSQ_SleepQualityIndex, xlab ="KSQ_SleepQualityIndex", ylab= "IPC (Supramarginal Gyrus), left")
abline(lm(CorrelationMatrix$IPC ~ CorrelationMatrix$KSQ_SleepQualityIndex))
smry <- summary(lm(as.numeric(CorrelationMatrix$IPC) ~ CorrelationMatrix$KSQ_SleepQualityIndex))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))

#Correlations with STAI-T
plot(CorrelationMatrix$AI_L ~ CorrelationMatrix$STAI_T, xlab ="STAI-T", ylab= "Anterior Insula, left")
abline(lm(as.numeric(CorrelationMatrix$AI_L) ~ CorrelationMatrix$STAI_T))
smry <- summary(lm(as.numeric(CorrelationMatrix$AI_L) ~ CorrelationMatrix$STAI_T))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))


plot(CorrelationMatrix$AI_R ~ CorrelationMatrix$STAI_T, xlab ="STAI-T", ylab= "Anterior Insula, right")
abline(lm(as.numeric(CorrelationMatrix$AI_R) ~ CorrelationMatrix$STAI_T))
smry <- summary(lm(as.numeric(CorrelationMatrix$AI_R) ~ CorrelationMatrix$STAI_T))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))

plot(CorrelationMatrix$MCC ~ CorrelationMatrix$STAI_T, xlab ="STAI-T", ylab= "Medial Cingulate Cortex")
abline(lm(as.numeric(CorrelationMatrix$MCC) ~ CorrelationMatrix$STAI_T))
smry <- summary(lm(as.numeric(CorrelationMatrix$MCC) ~ CorrelationMatrix$STAI_T))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))

plot(CorrelationMatrix$IPC_L ~ CorrelationMatrix$STAI_T, xlab ="STAI-T", ylab= "IPC (Supramarginal Gyrus), left")
abline(lm(as.numeric(CorrelationMatrix$IPC_L) ~ CorrelationMatrix$STAI_T))
smry <- summary(lm(as.numeric(CorrelationMatrix$IPC_L) ~ CorrelationMatrix$STAI_T))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))

#Correlations with TAS-20
plot(CorrelationMatrix$AI_L ~ CorrelationMatrix$TAS20_Total, xlab ="TAS-20 (total)", ylab= "Anterior Insula, left")
abline(lm(as.numeric(CorrelationMatrix$AI_L) ~ CorrelationMatrix$TAS20_Total))
smry <- summary(lm(as.numeric(CorrelationMatrix$AI_L) ~ CorrelationMatrix$TAS20_Total))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))


plot(CorrelationMatrix$AI_R ~ CorrelationMatrix$TAS20_Total, xlab ="TAS-20 (total)", ylab= "Anterior Insula, right")
abline(lm(as.numeric(CorrelationMatrix$AI_R) ~ CorrelationMatrix$TAS20_Total))
smry <- summary(lm(as.numeric(CorrelationMatrix$AI_R) ~ CorrelationMatrix$TAS20_Total))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))

plot(CorrelationMatrix$MCC ~ CorrelationMatrix$TAS20_Total, xlab ="TAS-20 (total)", ylab= "Medial Cingulate Cortex")
abline(lm(as.numeric(CorrelationMatrix$MCC) ~ CorrelationMatrix$TAS20_Total))
smry <- summary(lm(as.numeric(CorrelationMatrix$MCC) ~ CorrelationMatrix$TAS20_Total))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))

plot(CorrelationMatrix$IPC_L ~ CorrelationMatrix$TAS20_Total, xlab ="TAS-20 (total)", ylab= "IPC (Supramarginal Gyrus), left")
abline(lm(as.numeric(CorrelationMatrix$IPC_L) ~ CorrelationMatrix$TAS20_Total))
smry <- summary(lm(as.numeric(CorrelationMatrix$IPC_L) ~ CorrelationMatrix$TAS20_Total))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))


#Correlation with KSS
plot(as.numeric(AllSessionCorrelationMatrix$AI_L) ~ AllSessionCorrelationMatrix$KSS, xlab ="KSS after HANDS", ylab= "Anterior Insula, left")
abline(lm(as.numeric(AllSessionCorrelationMatrix$AI_L) ~ AllSessionCorrelationMatrix$KSS))
smry <- summary(lm(as.numeric(AllSessionCorrelationMatrix$AI_L) ~ AllSessionCorrelationMatrix$KSS))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))

plot(as.numeric(AllSessionCorrelationMatrix$AI_R) ~ AllSessionCorrelationMatrix$KSS, xlab ="KSS after HANDS", ylab= "Anterior Insula, right")
abline(lm(as.numeric(AllSessionCorrelationMatrix$AI_R) ~ AllSessionCorrelationMatrix$KSS))
smry <- summary(lm(as.numeric(AllSessionCorrelationMatrix$AI_R) ~ AllSessionCorrelationMatrix$KSS))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))

plot(as.numeric(AllSessionCorrelationMatrix$MCC) ~ AllSessionCorrelationMatrix$KSS, xlab ="KSS after HANDS", ylab= "Medial Cingulate Cortex")
abline(lm(as.numeric(AllSessionCorrelationMatrix$MCC) ~ AllSessionCorrelationMatrix$KSS))
smry <- summary(lm(as.numeric(AllSessionCorrelationMatrix$MCC) ~ AllSessionCorrelationMatrix$KSS))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))

plot(as.numeric(AllSessionCorrelationMatrix$IPC_L) ~ AllSessionCorrelationMatrix$KSS, xlab ="KSS after HANDS", ylab= "IPC (Supramarginal Gyrus), left")
abline(lm(as.numeric(AllSessionCorrelationMatrix$IPC_L) ~ AllSessionCorrelationMatrix$KSS))
smry <- summary(lm(as.numeric(AllSessionCorrelationMatrix$IPC_L) ~ AllSessionCorrelationMatrix$KSS))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))

#KSSexp
#plot(as.numeric(AllSessionCorrelationMatrix$AI_L) ~ AllSessionCorrelationMatrix$KSSexp, xlab ="KSSexp after HANDS", ylab= "Anterior Insula, left")
#abline(lm(as.numeric(AllSessionCorrelationMatrix$AI_L) ~ AllSessionCorrelationMatrix$KSSexp))
#smry <- summary(lm(as.numeric(AllSessionCorrelationMatrix$AI_L) ~ AllSessionCorrelationMatrix$KSSexp))
#legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))

#plot(as.numeric(AllSessionCorrelationMatrix$MCC) ~ AllSessionCorrelationMatrix$KSSexp, xlab ="KSSexp after HANDS", ylab= "Medial Cingulate Cortex")
#abline(lm(as.numeric(AllSessionCorrelationMatrix$MCC) ~ AllSessionCorrelationMatrix$KSSexp))
#smry <- summary(lm(as.numeric(AllSessionCorrelationMatrix$MCC) ~ AllSessionCorrelationMatrix$KSSexp))
#legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))))


#Check for normality
plot(AllSessionCorrelationMatrix$KSS ~ AllSessionCorrelationMatrix$Subject, xlab ="Subject", ylab= "KSS")
SleepDeprived <- subset(AllSessionCorrelationMatrix, AllSessionCorrelationMatrix$SleepCondition == "Sleep Deprived")
NotSleepDeprived <- subset(AllSessionCorrelationMatrix, AllSessionCorrelationMatrix$SleepCondition == "Not Sleep Deprived")
boxplot(SleepDeprived$KSS, NotSleepDeprived$KSS)


# Deprivation condition for SFSS
boxplot(SleepDeprived$AI_L, NotSleepDeprived$AI_L, names = c("Sömnbrist", "Fullsömn"), ylab = "Främre Insula, vänster")
boxplot(SleepDeprived$AI_R, NotSleepDeprived$AI_R, names = c("Sömnbrist", "Fullsömn"), ylab = "Främre Insula, höger")
boxplot(SleepDeprived$MCC, NotSleepDeprived$MCC, names = c("Sömnbrist", "Fullsömn"), ylab = "Främre cingulum")


#Compare sleepy and not sleepy
Sleepy <- subset(AllSessionCorrelationMatrix, AllSessionCorrelationMatrix$KSS > 7)
NotSleepy <- subset(AllSessionCorrelationMatrix, AllSessionCorrelationMatrix$KSS < 7)
SleepySeven <- subset(AllSessionCorrelationMatrix, AllSessionCorrelationMatrix$KSS == 7)



boxplot(NotSleepy$AI_L, SleepySeven$AI_L, Sleepy$AI_L, names = c("KSS < 7", "KSS = 7", "KSS > 7"), ylab = "Anterior Insula, left")
t.test(Sleepy$AI_L, NotSleepy$AI_L)
AllSessionCorrelationMatrix$KSSexp <- exp(AllSessionCorrelationMatrix$KSS)

boxplot(NotSleepy$AI_R, SleepySeven$AI_R, Sleepy$AI_R, names = c("KSS < 7", "KSS = 7", "KSS > 7)"), ylab = "Anterior Insula, rightt")
t.test(Sleepy$AI_R, NotSleepy$AI_R)

boxplot(NotSleepy$MCC, SleepySeven$MCC, Sleepy$MCC, names = c("KSS < 7", "KSS = 7", "KSS > 7"), ylab = "Medial Cingulate Cortex")
t.test(Sleepy$MCC, NotSleepy$MCC)

AllSessionCorrelationMatrix$SleepCondition <- as.factor(AllSessionCorrelationMatrix$SleepCondition)

ModelAI_L <- lme(AI_L ~ KSS + Session, data = AllSessionCorrelationMatrix, random = ~ 1|Subject)
plot(ModelAI_L)
summary(ModelAI_L)

out<-capture.output(summary(ModelAI_L))
cat(out,file="~/Dropbox/Resultat_131216/AI_L_KSS.txt",sep="\n",append=F)

ModelAI_R <- lme(AI_R ~ KSS + Session, data = AllSessionCorrelationMatrix, random = ~ 1|Subject)
plot(ModelAI_R)
summary(ModelAI_R)

out<-capture.output(summary(ModelAI_R))
cat(out,file="~/Dropbox/Resultat_131216/AI_R_KSS.txt",sep="\n",append=F)

ModelMCC <- lme(MCC ~ KSS + Session, data = AllSessionCorrelationMatrix, random = ~ 1|Subject)
plot(ModelMCC)
summary(ModelMCC)

out<-capture.output(summary(ModelMCC))
cat(out,file="~/Dropbox/Resultat_131216/MCC_KSS.txt",sep="\n",append=F)

ModelAI_L <- lme(AI_L ~ SleepCondition + Session, data = AllSessionCorrelationMatrix, random = ~ 1|Subject)
plot(ModelAI_L)
summary(ModelAI_L)

out<-capture.output(summary(ModelAI_L))
cat(out,file="~/Dropbox/Resultat_131216/AI_L_SC.txt",sep="\n",append=F)

ModelAI_R <- lme(AI_R ~ SleepCondition + Session, data = AllSessionCorrelationMatrix, random = ~ 1|Subject)
plot(ModelAI_R)
summary(ModelAI_R)

out<-capture.output(summary(ModelAI_R))
cat(out,file="~/Dropbox/Resultat_131216/AI_R_SC.txt",sep="\n",append=F)

ModelMCC <- lme(MCC ~ SleepCondition + Session, data = AllSessionCorrelationMatrix, random = ~ 1|Subject)
plot(ModelMCC)
summary(ModelMCC)

out<-capture.output(summary(ModelMCC))
cat(out,file="~/Dropbox/Resultat_131216/MCC_SC.txt",sep="\n",append=F)

age <- mean(as.numeric(CorrelationMatrix$Age))
ageSD <- sd(as.numeric(CorrelationMatrix$Age))
IncludedSubjects <- AllSessionCorrelationMatrix$Subject
IncludedSubjects <- unique(IncludedSubjects)


# Separat regression för sömnbetingelse (deprivation)
SleepSessionCorrelationMatrix <- subset(AllSessionCorrelationMatrix, AllSessionCorrelationMatrix$SleepCondition == "Sleep Deprived")

plot(as.numeric(SleepSessionCorrelationMatrix$MCC) ~ SleepSessionCorrelationMatrix$KSS, xlim = c(0, 10), xlab ="KSS after HANDS", ylab= "Medial Cingulate Cortex")
abline(lm(as.numeric(SleepSessionCorrelationMatrix$MCC) ~ SleepSessionCorrelationMatrix$KSS))
smry <- summary(lm(as.numeric(SleepSessionCorrelationMatrix$MCC) ~ SleepSessionCorrelationMatrix$KSS))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))), cex =0.8)

ModelMCC <- lme(MCC ~ KSS + Session, data = SleepSessionCorrelationMatrix, random = ~ 1|Subject)
plot(ModelMCC)
summary(ModelMCC)

# Anterior Insula, left
plot(as.numeric(SleepSessionCorrelationMatrix$AI_L) ~ SleepSessionCorrelationMatrix$KSS, xlim = c(0, 10), xlab ="KSS after HANDS", ylab= "Anterior Insula, left")
abline(lm(as.numeric(SleepSessionCorrelationMatrix$AI_L) ~ SleepSessionCorrelationMatrix$KSS))
smry <- summary(lm(as.numeric(SleepSessionCorrelationMatrix$AI_L) ~ SleepSessionCorrelationMatrix$KSS))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))), cex =0.8)


# Anterior Insula, right
plot(as.numeric(SleepSessionCorrelationMatrix$AI_R) ~ SleepSessionCorrelationMatrix$KSS, xlim = c(0, 10), xlab ="KSS after HANDS", ylab= "Anterior Insula, right")
abline(lm(as.numeric(SleepSessionCorrelationMatrix$AI_R) ~ SleepSessionCorrelationMatrix$KSS))
smry <- summary(lm(as.numeric(SleepSessionCorrelationMatrix$AI_R) ~ SleepSessionCorrelationMatrix$KSS))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))), cex =0.8)


# Separat regression för sömnbetingelse (fullsömn)
FullSessionCorrelationMatrix <- subset(AllSessionCorrelationMatrix, AllSessionCorrelationMatrix$SleepCondition == "Not Sleep Deprived")

plot(as.numeric(FullSessionCorrelationMatrix$MCC) ~ FullSessionCorrelationMatrix$KSS, xlim= c(0, 10), xlab ="KSS after HANDS", ylab= "Medial Cingulate Cortex")
abline(lm(as.numeric(FullSessionCorrelationMatrix$MCC) ~ FullSessionCorrelationMatrix$KSS))
smry <- summary(lm(as.numeric(FullSessionCorrelationMatrix$MCC) ~ FullSessionCorrelationMatrix$KSS))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))), cex =0.8)

ModelMCC <- lme(MCC ~ KSS + Session, data = FullSessionCorrelationMatrix, random = ~ 1|Subject)
plot(ModelMCC)
summary(ModelMCC)

# Anterior Insula, left
plot(as.numeric(FullSessionCorrelationMatrix$AI_L) ~ FullSessionCorrelationMatrix$KSS, xlim= c(0, 10), xlab ="KSS after HANDS", ylab= "Anterior Insula, left")
abline(lm(as.numeric(FullSessionCorrelationMatrix$AI_L) ~ FullSessionCorrelationMatrix$KSS))
smry <- summary(lm(as.numeric(FullSessionCorrelationMatrix$AI_L) ~ FullSessionCorrelationMatrix$KSS))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))), cex =0.8)

# Anterior Insula, right
plot(as.numeric(FullSessionCorrelationMatrix$AI_R) ~ FullSessionCorrelationMatrix$KSS, xlim= c(0, 10), xlab ="KSS after HANDS", ylab= "Anterior Insula, right")
abline(lm(as.numeric(FullSessionCorrelationMatrix$AI_R) ~ FullSessionCorrelationMatrix$KSS))
smry <- summary(lm(as.numeric(FullSessionCorrelationMatrix$AI_R) ~ FullSessionCorrelationMatrix$KSS))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))), cex =0.8)



# Relation between mean ratings of unpleasantness (pain) and brain activity
plot(as.numeric(AllSessionCorrelationMatrix$AI_L) ~ AllSessionCorrelationMatrix$mean, xlab ="Rated unpleasantness", ylab= "Anterior Insula, left")
abline(lm(as.numeric(AllSessionCorrelationMatrix$AI_L) ~ AllSessionCorrelationMatrix$mean))
smry <- summary(lm(as.numeric(AllSessionCorrelationMatrix$AI_L) ~ AllSessionCorrelationMatrix$mean))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))), cex=0.6)

# Relation between mean ratings of unpleasantness (pain) and brain activity
plot(as.numeric(AllSessionCorrelationMatrix$AI_R) ~ AllSessionCorrelationMatrix$mean, xlab ="Rated unpleasantness", ylab= "Anterior Insula, right")
abline(lm(as.numeric(AllSessionCorrelationMatrix$AI_R) ~ AllSessionCorrelationMatrix$mean))
smry <- summary(lm(as.numeric(AllSessionCorrelationMatrix$AI_R) ~ AllSessionCorrelationMatrix$mean))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))), cex=0.6)

# Relation between mean ratings of unpleasantness (pain) and brain activity
plot(as.numeric(AllSessionCorrelationMatrix$MCC) ~ AllSessionCorrelationMatrix$mean, xlab ="Rated unpleasantness", ylab= "Medial Cingulate Cortex")
abline(lm(as.numeric(AllSessionCorrelationMatrix$MCC) ~ AllSessionCorrelationMatrix$mean))
smry <- summary(lm(as.numeric(AllSessionCorrelationMatrix$MCC) ~ AllSessionCorrelationMatrix$mean))
legend("topright", c(paste("r2 =",signif(smry$r.squared,3)), paste("p =", signif(smry$coefficients[8],3))), cex=0.6)


