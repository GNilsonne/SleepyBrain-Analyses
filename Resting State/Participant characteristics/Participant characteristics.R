# Script to make table of participant characteristics and plots of sleep measures for resting state manuscript

# Require packages 
require(nlme)

# 1. Participant characteristics
# Read files
demographics <- read.csv2("demdata_160225_pseudonymized.csv", header = T)
IncludedSubjects <- c(9001, 9002, 9003, 9004, 9005, 9007, 9008, 9009, 9011, 9013, 9014, 9017, 9019, 9020, 9026,
                      9028, 9033, 9034, 9035, 9036, 9038, 9039, 9041, 9042, 9045, 9049, 9050, 9053, 9055, 9057,
                      9058, 9059, 9061, 9062, 9064, 9068, 9069, 9070, 9072, 9073, 9075, 9076, 9077, 9084, 9085,
                      9087, 9088, 9090, 9091, 9092, 9094, 9098, 9100)
demo2 <- demographics[demographics$id %in% IncludedSubjects, ]
#PSGdata <- read.csv2("PSGdata_160507_pseudonymized.csv", header = T)
#PSGdata <- PSGdata[PSGdata$id %in% IncludedSubjects, ]

PSGdata <- read.delim("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/sb_wide__6_Jun_2016.txt")

young <- demo2$id[demo2$AgeGroup == "Young"]
old <- demo2$id[demo2$AgeGroup != "Young"]

# Tabulate and calculate participant characteristics
table(demo2[, c("Sex", "AgeGroup")])

summary(demo2$Age)
summary(demo2$Age[demo2$AgeGroup == "Young"])
summary(demo2$Age[demo2$AgeGroup == "Old"])

mean(PSGdata$tst_nsd, na.rm = T)*60
sd(PSGdata$tst_nsd, na.rm = T)*60
mean(PSGdata$tst_sd, na.rm = T)*60
sd(PSGdata$tst_sd, na.rm = T)*60
mean(PSGdata$tst_nsd[PSGdata$agensd < 40], na.rm = T)*60
sd(PSGdata$tst_nsd[PSGdata$agensd < 40], na.rm = T)*60
mean(PSGdata$tst_sd[PSGdata$agensd < 40], na.rm = T)*60
sd(PSGdata$tst_sd[PSGdata$agensd < 40], na.rm = T)*60
mean(PSGdata$tst_nsd[PSGdata$agensd > 40], na.rm = T)*60
sd(PSGdata$tst_nsd[PSGdata$agensd > 40], na.rm = T)*60
mean(PSGdata$tst_sd[PSGdata$agensd > 40], na.rm = T)*60
sd(PSGdata$tst_sd[PSGdata$agensd > 40], na.rm = T)*60

mean(PSGdata$rp___00_nsd, na.rm = T)
sd(PSGdata$rp___00_nsd, na.rm = T)
mean(PSGdata$rp___00_sd, na.rm = T)
sd(PSGdata$rp___00_sd, na.rm = T)
mean(PSGdata$rp___00_nsd[PSGdata$agensd < 40], na.rm = T)
sd(PSGdata$rp___00_nsd[PSGdata$agensd < 40], na.rm = T)
mean(PSGdata$rp___00_sd[PSGdata$agensd < 40], na.rm = T)
sd(PSGdata$rp___00_sd[PSGdata$agensd < 40], na.rm = T)
mean(PSGdata$rp___00_nsd[PSGdata$agensd > 40], na.rm = T)
sd(PSGdata$rp___00_nsd[PSGdata$agensd > 40], na.rm = T)
mean(PSGdata$rp___00_sd[PSGdata$agensd > 40], na.rm = T)
sd(PSGdata$rp___00_sd[PSGdata$agensd > 40], na.rm = T)

mean(PSGdata$n1p__00_nsd, na.rm = T)
sd(PSGdata$n1p__00_nsd, na.rm = T)
mean(PSGdata$n1p__00_sd, na.rm = T)
sd(PSGdata$n1p__00_sd, na.rm = T)
mean(PSGdata$n1p__00_nsd[PSGdata$agensd < 40], na.rm = T)
sd(PSGdata$n1p__00_nsd[PSGdata$agensd < 40], na.rm = T)
mean(PSGdata$n1p__00_sd[PSGdata$agensd < 40], na.rm = T)
sd(PSGdata$n1p__00_sd[PSGdata$agensd < 40], na.rm = T)
mean(PSGdata$n1p__00_nsd[PSGdata$agensd > 40], na.rm = T)
sd(PSGdata$n1p__00_nsd[PSGdata$agensd > 40], na.rm = T)
mean(PSGdata$n1p__00_sd[PSGdata$agensd > 40], na.rm = T)
sd(PSGdata$n1p__00_sd[PSGdata$agensd > 40], na.rm = T)

mean(PSGdata$n2p__00_nsd, na.rm = T)
sd(PSGdata$n2p__00_nsd, na.rm = T)
mean(PSGdata$n2p__00_sd, na.rm = T)
sd(PSGdata$n2p__00_sd, na.rm = T)
mean(PSGdata$n2p__00_nsd[PSGdata$agensd < 40], na.rm = T)
sd(PSGdata$n2p__00_nsd[PSGdata$agensd < 40], na.rm = T)
mean(PSGdata$n2p__00_sd[PSGdata$agensd < 40], na.rm = T)
sd(PSGdata$n2p__00_sd[PSGdata$agensd < 40], na.rm = T)
mean(PSGdata$n2p__00_nsd[PSGdata$agensd > 40], na.rm = T)
sd(PSGdata$n2p__00_nsd[PSGdata$agensd > 40], na.rm = T)
mean(PSGdata$n2p__00_sd[PSGdata$agensd > 40], na.rm = T)
sd(PSGdata$n2p__00_sd[PSGdata$agensd > 40], na.rm = T)

mean(PSGdata$n3p__00_nsd, na.rm = T)
sd(PSGdata$n3p__00_nsd, na.rm = T)
mean(PSGdata$n3p__00_sd, na.rm = T)
sd(PSGdata$n3p__00_sd, na.rm = T)
mean(PSGdata$n3p__00_nsd[PSGdata$agensd < 40], na.rm = T)
sd(PSGdata$n3p__00_nsd[PSGdata$agensd < 40], na.rm = T)
mean(PSGdata$n3p__00_sd[PSGdata$agensd < 40], na.rm = T)
sd(PSGdata$n3p__00_sd[PSGdata$agensd < 40], na.rm = T)
mean(PSGdata$n3p__00_nsd[PSGdata$agensd > 40], na.rm = T)
sd(PSGdata$n3p__00_nsd[PSGdata$agensd > 40], na.rm = T)
mean(PSGdata$n3p__00_sd[PSGdata$agensd > 40], na.rm = T)
sd(PSGdata$n3p__00_sd[PSGdata$agensd > 40], na.rm = T)

# mean(PSGdata$TST[PSGdata$Cond == 1], na.rm = T)
# sd(PSGdata$TST[PSGdata$Cond == 1], na.rm = T)
# mean(PSGdata$TST[PSGdata$Cond == 2], na.rm = T)
# sd(PSGdata$TST[PSGdata$Cond == 2], na.rm = T)
# mean(PSGdata$TST[PSGdata$Cond == 1 & PSGdata$id %in% young], na.rm = T)
# sd(PSGdata$TST[PSGdata$Cond == 1 & PSGdata$id %in% young], na.rm = T)
# mean(PSGdata$TST[PSGdata$Cond == 1 & PSGdata$id %in% old], na.rm = T)
# sd(PSGdata$TST[PSGdata$Cond == 1 & PSGdata$id %in% old], na.rm = T)
# mean(PSGdata$TST[PSGdata$Cond == 2 & PSGdata$id %in% young], na.rm = T)
# sd(PSGdata$TST[PSGdata$Cond == 2 & PSGdata$id %in% young], na.rm = T)
# mean(PSGdata$TST[PSGdata$Cond == 2 & PSGdata$id %in% old], na.rm = T)
# sd(PSGdata$TST[PSGdata$Cond == 2 & PSGdata$id %in% old], na.rm = T)
# 
# mean(PSGdata$REM_.[PSGdata$Cond == 1], na.rm = T)
# sd(PSGdata$REM_.[PSGdata$Cond == 1], na.rm = T)
# mean(PSGdata$REM_.[PSGdata$Cond == 2], na.rm = T)
# sd(PSGdata$REM_.[PSGdata$Cond == 2], na.rm = T)
# mean(PSGdata$REM_.[PSGdata$Cond == 1 & PSGdata$id %in% young], na.rm = T)
# sd(PSGdata$REM_.[PSGdata$Cond == 1 & PSGdata$id %in% young], na.rm = T)
# mean(PSGdata$REM_.[PSGdata$Cond == 1 & PSGdata$id %in% old], na.rm = T)
# sd(PSGdata$REM_.[PSGdata$Cond == 1 & PSGdata$id %in% old], na.rm = T)
# mean(PSGdata$REM_.[PSGdata$Cond == 2 & PSGdata$id %in% young], na.rm = T)
# sd(PSGdata$REM_.[PSGdata$Cond == 2 & PSGdata$id %in% young], na.rm = T)
# mean(PSGdata$REM_.[PSGdata$Cond == 2 & PSGdata$id %in% old], na.rm = T)
# sd(PSGdata$REM_.[PSGdata$Cond == 2 & PSGdata$id %in% old], na.rm = T)
# 
# mean(PSGdata$St1_.[PSGdata$Cond == 1], na.rm = T)
# sd(PSGdata$St1_.[PSGdata$Cond == 1], na.rm = T)
# mean(PSGdata$St1_.[PSGdata$Cond == 2], na.rm = T)
# sd(PSGdata$St1_.[PSGdata$Cond == 2], na.rm = T)
# mean(PSGdata$St1_.[PSGdata$Cond == 1 & PSGdata$id %in% young], na.rm = T)
# sd(PSGdata$St1_.[PSGdata$Cond == 1 & PSGdata$id %in% young], na.rm = T)
# mean(PSGdata$St1_.[PSGdata$Cond == 1 & PSGdata$id %in% old], na.rm = T)
# sd(PSGdata$St1_.[PSGdata$Cond == 1 & PSGdata$id %in% old], na.rm = T)
# mean(PSGdata$St1_.[PSGdata$Cond == 2 & PSGdata$id %in% young], na.rm = T)
# sd(PSGdata$St1_.[PSGdata$Cond == 2 & PSGdata$id %in% young], na.rm = T)
# mean(PSGdata$St1_.[PSGdata$Cond == 2 & PSGdata$id %in% old], na.rm = T)
# sd(PSGdata$St1_.[PSGdata$Cond == 2 & PSGdata$id %in% old], na.rm = T)
# 
# mean(PSGdata$St3_.[PSGdata$Cond == 1], na.rm = T)
# sd(PSGdata$St3_.[PSGdata$Cond == 1], na.rm = T)
# mean(PSGdata$St3_.[PSGdata$Cond == 2], na.rm = T)
# sd(PSGdata$St3_.[PSGdata$Cond == 2], na.rm = T)
# mean(PSGdata$St3_.[PSGdata$Cond == 1 & PSGdata$id %in% young], na.rm = T)
# sd(PSGdata$St3_.[PSGdata$Cond == 1 & PSGdata$id %in% young], na.rm = T)
# mean(PSGdata$St3_.[PSGdata$Cond == 1 & PSGdata$id %in% old], na.rm = T)
# sd(PSGdata$St3_.[PSGdata$Cond == 1 & PSGdata$id %in% old], na.rm = T)
# mean(PSGdata$St3_.[PSGdata$Cond == 2 & PSGdata$id %in% young], na.rm = T)
# sd(PSGdata$St3_.[PSGdata$Cond == 2 & PSGdata$id %in% young], na.rm = T)
# mean(PSGdata$St3_.[PSGdata$Cond == 2 & PSGdata$id %in% old], na.rm = T)
# sd(PSGdata$St3_.[PSGdata$Cond == 2 & PSGdata$id %in% old], na.rm = T)

mean(demo2$ESS)
sd(demo2$ESS)
mean(demo2$ESS[demo2$AgeGroup == "Young"])
sd(demo2$ESS[demo2$AgeGroup == "Young"])
mean(demo2$ESS[demo2$AgeGroup == "Old"])
sd(demo2$ESS[demo2$AgeGroup == "Old"])

mean(demo2$ISI)
sd(demo2$ISI)
mean(demo2$ISI[demo2$AgeGroup == "Young"])
sd(demo2$ISI[demo2$AgeGroup == "Young"])
mean(demo2$ISI[demo2$AgeGroup == "Old"])
sd(demo2$ISI[demo2$AgeGroup == "Old"])

mean(demo2$KSQ_SleepQualityIndex)
sd(demo2$KSQ_SleepQualityIndex)
mean(demo2$KSQ_SleepQualityIndex[demo2$AgeGroup == "Young"])
sd(demo2$KSQ_SleepQualityIndex[demo2$AgeGroup == "Young"])
mean(demo2$KSQ_SleepQualityIndex[demo2$AgeGroup == "Old"])
sd(demo2$KSQ_SleepQualityIndex[demo2$AgeGroup == "Old"])

mean(demo2$KSQ_SnoringSymptomIndex)
sd(demo2$KSQ_SnoringSymptomIndex)
mean(demo2$KSQ_SnoringSymptomIndex[demo2$AgeGroup == "Young"])
sd(demo2$KSQ_SnoringSymptomIndex[demo2$AgeGroup == "Young"])
mean(demo2$KSQ_SnoringSymptomIndex[demo2$AgeGroup == "Old"])
sd(demo2$KSQ_SnoringSymptomIndex[demo2$AgeGroup == "Old"])

# 2. Sleep measures
# KSS
# Read files
kss <- read.csv2("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/150715_KSSData.csv")
kss <- kss[kss$Subject %in% IncludedSubjects, ]
kss$kss_jitt <- jitter(kss$KSS_Rating)

# Make plots
plot(kss_jitt ~ TimeInScanner, data = kss[kss$DeprivationCondition == "Not Sleep Deprived" & kss$RatingNo %in% c(2, 6, 7, 8,9), ], frame.plot = F, pch = 3, xlim = c(0, 120), ylim = c(1, 9), xlab = "Time (min)", ylab = "KSS rating", yaxt = "n", main = "Full sleep")
points(kss_jitt ~ TimeInScanner, data = kss[kss$DeprivationCondition == "Not Sleep Deprived" & !kss$RatingNo %in% c(2, 6, 7, 8,9), ], col = "gray", pch = 3)
axis(2, at = c(1:9))
mod <- lm(kss_jitt ~ TimeInScanner, data = kss[kss$DeprivationCondition == "Not Sleep Deprived", ])
newdat <- data.frame(TimeInScanner = c(0:120))
lines(predict(mod, newdat), col = "blue", lwd = 2)
with(kss[kss$DeprivationCondition == "Not Sleep Deprived", ], lines(lowess(TimeInScanner, kss_jitt), col="blue", lwd = 2, lty = 2))

plot(kss_jitt ~ TimeInScanner, data = kss[kss$DeprivationCondition == "Sleep Deprived" & kss$RatingNo %in% c(2, 6, 7, 8,9), ], frame.plot = F, pch = 3, xlim = c(0, 120), ylim = c(1, 9), xlab = "Time (min)", ylab = "KSS rating", yaxt = "n", main = "Sleep deprived")
points(kss_jitt ~ TimeInScanner, data = kss[kss$DeprivationCondition == "Sleep Deprived" & !kss$RatingNo %in% c(2, 6, 7, 8,9), ], col = "gray", pch = 3)
axis(2, at = c(1:9))
mod <- lm(kss_jitt ~ TimeInScanner, data = kss[kss$DeprivationCondition == "Sleep Deprived", ])
newdat <- data.frame(TimeInScanner = c(0:120))
lines(predict(mod, newdat), col = "red", lwd = 2)
with(kss[kss$DeprivationCondition == "Sleep Deprived", ], lines(lowess(TimeInScanner, kss_jitt), col="red", lwd = 2, lty = 2)) # lowess line (x,y)

# Analyse effects
kss$TimeInScannerH <- kss$TimeInScanner/60
kss <- merge(kss, demo2[, c("Subject", "AgeGroup")])
lme1 <- lme(KSS_Rating ~ DeprivationCondition + TimeInScannerH + AgeGroup, data = kss, random = ~ 1|Subject, na.action = "na.omit")
plot(lme1)
summary(lme1)
intervals(lme1)
anova(lme1, type = "marginal")

# Write regressor files
kss_S1S2 <- kss[kss$RatingNo == 2, ]
kss_S1S2_PSD <- kss_S1S2[kss_S1S2$DeprivationCondition == "Sleep Deprived", ]
kss_S1S2_Full <- kss_S1S2[kss_S1S2$DeprivationCondition == "Not Sleep Deprived", ]
#kss_S1S2 <- rbind(kss_S1S2_PSD, kss_S1S2_Full)
#kss_S1S2 <- kss_S1S2[order(kss_S1S2$Subject), ]
write.table(kss_S1S2_PSD$KSS_Rating, file = "C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/RealignParameter_RestingState_150923/kss_S1S2_PSD.txt", row.names = F, col.names = F)
write.table(kss_S1S2_Full$KSS_Rating, file = "C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/RealignParameter_RestingState_150923/kss_S1S2_Full.txt", row.names = F, col.names = F)

# Analyse PANAS as covariate
demographics_resting <- demographics[demographics$Subject %in% IncludedSubjects, ]
demographics_resting <- merge(demographics_resting, RandomisationList)

demographics_resting$PANAS_Positive_FullSleep[demographics_resting$Sl_cond == 1] <- demographics_resting$PANAS_Positive_byScanner.y[demographics_resting$Sl_cond == 1]
demographics_resting$PANAS_Positive_FullSleep[demographics_resting$Sl_cond == 2] <- demographics_resting$PANAS_Positive_byScanner.x[demographics_resting$Sl_cond == 2]
demographics_resting$PANAS_Positive_PSD[demographics_resting$Sl_cond == 1] <- demographics_resting$PANAS_Positive_byScanner.x[demographics_resting$Sl_cond == 1]
demographics_resting$PANAS_Positive_PSD[demographics_resting$Sl_cond == 2] <- demographics_resting$PANAS_Positive_byScanner.y[demographics_resting$Sl_cond == 2]

boxplot(demographics_resting$PANAS_Positive, demographics_resting$PANAS_Positive_FullSleep, demographics_resting$PANAS_Positive_PSD, frame.plot = F, names = c("Baseline", "Full Sleep", "PSD"), main = "PANAS positive")
for (i in demographics_resting$Subject[demographics_resting$AgeGroup == "Young"]){
  lines(x = c(1,2,3), y = c(demographics_resting[demographics_resting$Subject == i, c("PANAS_Positive", "PANAS_Positive_FullSleep", "PANAS_Positive_PSD")]), col = "lightblue")
}
for (i in demographics_resting$Subject[demographics_resting$AgeGroup == "Old"]){
  lines(x = c(1,2,3), y = c(demographics_resting[demographics_resting$Subject == i, c("PANAS_Positive", "PANAS_Positive_FullSleep", "PANAS_Positive_PSD")]), col = "lightcoral")
}
lines(x = c(1,2,3), y = colMeans(demographics_resting[demographics_resting$AgeGroup == "Young", c("PANAS_Positive", "PANAS_Positive_FullSleep", "PANAS_Positive_PSD")], na.rm = T), col = "blue", lwd = 2)
lines(x = c(1,2,3), y = colMeans(demographics_resting[demographics_resting$AgeGroup == "Old", c("PANAS_Positive", "PANAS_Positive_FullSleep", "PANAS_Positive_PSD")], na.rm = T), col = "red", lwd = 2)

demographics_resting$PANAS_Negative_FullSleep[demographics_resting$Sl_cond == 1] <- demographics_resting$PANAS_Negative_byScanner.y[demographics_resting$Sl_cond == 1]
demographics_resting$PANAS_Negative_FullSleep[demographics_resting$Sl_cond == 2] <- demographics_resting$PANAS_Negative_byScanner.x[demographics_resting$Sl_cond == 2]
demographics_resting$PANAS_Negative_PSD[demographics_resting$Sl_cond == 1] <- demographics_resting$PANAS_Negative_byScanner.x[demographics_resting$Sl_cond == 1]
demographics_resting$PANAS_Negative_PSD[demographics_resting$Sl_cond == 2] <- demographics_resting$PANAS_Negative_byScanner.y[demographics_resting$Sl_cond == 2]

boxplot(demographics_resting$PANAS_Negative, demographics_resting$PANAS_Negative_FullSleep, demographics_resting$PANAS_Negative_PSD, frame.plot = F, names = c("Baseline", "Full Sleep", "PSD"), main = "PANAS Negative")
for (i in demographics_resting$Subject[demographics_resting$AgeGroup == "Young"]){
  lines(x = c(1,2,3), y = c(demographics_resting[demographics_resting$Subject == i, c("PANAS_Negative", "PANAS_Negative_FullSleep", "PANAS_Negative_PSD")]), col = "lightblue")
}
for (i in demographics_resting$Subject[demographics_resting$AgeGroup == "Old"]){
  lines(x = c(1,2,3), y = c(demographics_resting[demographics_resting$Subject == i, c("PANAS_Negative", "PANAS_Negative_FullSleep", "PANAS_Negative_PSD")]), col = "lightcoral")
}
lines(x = c(1,2,3), y = colMeans(demographics_resting[demographics_resting$AgeGroup == "Young", c("PANAS_Negative", "PANAS_Negative_FullSleep", "PANAS_Negative_PSD")], na.rm = T), col = "blue", lwd = 2)
lines(x = c(1,2,3), y = colMeans(demographics_resting[demographics_resting$AgeGroup == "Old", c("PANAS_Negative", "PANAS_Negative_FullSleep", "PANAS_Negative_PSD")], na.rm = T), col = "red", lwd = 2)

demographics_resting$deltaPANAS_Positive <- demographics_resting$PANAS_Positive_FullSleep - demographics_resting$PANAS_Positive_PSD
demographics_resting$deltaPANAS_Negative <- demographics_resting$PANAS_Negative_FullSleep - demographics_resting$PANAS_Negative_PSD

boxplot(demographics_resting$deltaPANAS_Positive, demographics_resting$deltaPANAS_Positive[demographics_resting$AgeGroup == "Young"], demographics_resting$deltaPANAS_Positive[demographics_resting$AgeGroup == "Old"], frame.plot = F, names = c("All", "Young", "Old"), main = "PANAS Positive, difference Full sleep-PSD")
boxplot(demographics_resting$deltaPANAS_Negative, demographics_resting$deltaPANAS_Negative[demographics_resting$AgeGroup == "Young"], demographics_resting$deltaPANAS_Negative[demographics_resting$AgeGroup == "Old"], frame.plot = F, names = c("All", "Young", "Old"), main = "PANAS Negative, difference Full sleep-PSD", ylim = c(-11, 21))
