# Script to analyse effects of KSS on seed-based connectivity
# Since KSS varies over time, we take the time series of roi:s pair-wise, and then we analyse effects of kss as a moderator by linear regression, with an interaction term for KSS

# Read files
# The files contain nuisance regressors including motion and total signal from GM, WM, and CSF

files_S1 <- list.files("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/Resting State/Covs_151110b_160407/FunImgARWSDFCovs", pattern = c("Covariables", ".txt"))
files_S1 <- files_S1[(seq(2, 106, 2))] # Workaround to get only .txt files
covs_S1 <- list()
for (i in 1:length(files_S1)){
  data <- read.table(paste("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/Resting State/Covs_151110b_160407/FunImgARWSDFCovs/", files_S1[i], sep = ""))
  covs_S1[[i]] <- data$V10
}

files_S2 <- list.files("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/Resting State/Covs_151110b_160407/S2_FunImgARWSDFCovs", pattern = c("Covariables", ".txt"))
files_S2 <- files_S2[(seq(2, 106, 2))] # Workaround to get only .txt files
covs_S2 <- list()
for (i in 1:length(files_S2)){
  data <- read.table(paste("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/Resting State/Covs_151110b_160407/S2_FunImgARWSDFCovs/", files_S2[i], sep = ""))
  covs_S2[[i]] <- data$V10
}

files_S3 <- list.files("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/Resting State/Covs_151110b_160407/S3_FunImgARWSDFCovs", pattern = c("Covariables", ".txt"))
files_S3 <- files_S3[(seq(2, 106, 2))] # Workaround to get only .txt files
covs_S3 <- list()
for (i in 1:length(files_S3)){
  data <- read.table(paste("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/Resting State/Covs_151110b_160407/S3_FunImgARWSDFCovs/", files_S3[i], sep = ""))
  covs_S3[[i]] <- data$V10
}

files_S4 <- list.files("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/Resting State/Covs_151110b_160407/S4_FunImgARWSDFCovs", pattern = c("Covariables", ".txt"))
files_S4 <- files_S4[(seq(2, 106, 2))] # Workaround to get only .txt files
covs_S4 <- list()
for (i in 1:length(files_S4)){
  data <- read.table(paste("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/Resting State/Covs_151110b_160407/S4_FunImgARWSDFCovs/", files_S4[i], sep = ""))
  covs_S4[[i]] <- data$V10
}

########################

# Calculate mean global signal and other measures and put in data frame
fun_rms <- function(x) sqrt(mean(x^2))

data_glob <- data.frame(
  ID = rep(1:53, 4),
  session = c(rep(1, 53), rep(2, 53), rep(3, 53), rep(4, 53)),
  globalsignal = c(unlist(lapply(covs_S1, mean)), unlist(lapply(covs_S2, mean)), unlist(lapply(covs_S3, mean)), unlist(lapply(covs_S4, mean))),
  globalsignal_rms = c(unlist(lapply(covs_S1, fun_rms)), unlist(lapply(covs_S2, fun_rms)), unlist(lapply(covs_S3, fun_rms)), unlist(lapply(covs_S4, fun_rms))),
  globalsignal_sd = c(unlist(lapply(covs_S1, sd)), unlist(lapply(covs_S2, sd)), unlist(lapply(covs_S3, sd)), unlist(lapply(covs_S4, sd)))
)

hist(data_glob$globalsignal)
hist(data_glob$globalsignal_rms)
hist(data_glob$globalsignal_sd)
hist(log(data_glob$globalsignal_sd))

data_glob$globalsignal_logsd <- log(data_glob$globalsignal_sd) # Log transform to achieve a more normal distribution

gs <- c(unlist(covs_S1), unlist(covs_S2), unlist(covs_S3), unlist(covs_S4))

hist(gs)

########################

# Read data files for randomisation list etc, make final data frame
subjects <- read.csv2("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/Resting state/Subjects_RestingState_151110.csv")
demdata <- read.csv2("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/150215_Demographic.csv")
demdata <- merge(subjects, demdata, by.x = "subject", by.y = "Subject")
randlist <- read.csv2("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/RandomisationList_140804.csv")
demdata <- merge(demdata, randlist, by.x = "subject", by.y = "Subject")
FDdata <- read.table("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/Resting state/RealignParameter_RestingState_151001/n_excluded.txt", header = T) # Framewise displacement, data say how many volumes had FD > 0.5 and were interpolated
FDdata <- reshape(FDdata, direction = "long", varying = c("S1", "S2", "S3", "S4"), idvar = "subject", v.names = "FD")
FDdata <- FDdata[with(FDdata, order(subject, time)), ]

data_glob <- merge(data_glob, subjects, by = "ID")
data_glob <- merge(data_glob, randlist[, 1:2], by.x = "subject", by.y = "Subject")

data_glob$condition <- "fullsleep"
data_glob$condition[data_glob$session == 1 & data_glob$Sl_cond == 1] <- "sleepdeprived"
data_glob$condition[data_glob$session == 3 & data_glob$Sl_cond == 1] <- "sleepdeprived"
data_glob$condition[data_glob$session == 2 & data_glob$Sl_cond == 2] <- "sleepdeprived"
data_glob$condition[data_glob$session == 4 & data_glob$Sl_cond == 2] <- "sleepdeprived"

data_glob <- merge(data_glob, demdata)
data_glob <- merge(data_glob, FDdata, by.x = c("subject", "session"), by.y = c("subject", "time"))

# Read KSS data
KSSfolders <- list.files("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/Presentation_logfiles")
KSSfolders <- data.frame(folder = KSSfolders, subject = as.integer(substring(KSSfolders, 1, 3)))
KSSfolders <- KSSfolders[KSSfolders$subject %in% subjects$subject, ]
kssdata <- data.frame(folder = NULL, kss2 = NULL, kss69 = NULL)
for (i in 1:length(KSSfolders$folder)){
  KSSratings2 <- read.delim(paste("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/Presentation_logfiles/", KSSfolders$folder[i], "/KSS_brief2.txt", sep = ""), skip = 1, header = F)
  KSSratings6_9 <- read.delim(paste("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/Presentation_logfiles/", KSSfolders$folder[i], "/KSS.txt", sep = ""), skip = 1, header = F)
  KSSratings6_9 <- mean(KSSratings6_9$V1)
  data <- data.frame(folder = KSSfolders$folder[i], kss2 = as.integer(KSSratings2), kss69 = KSSratings6_9)
  kssdata <- rbind(kssdata, data)
}

boxplot(kssdata$kss2, kssdata$kss69)
t.test(kssdata$kss2, kssdata$kss69)

kssdata$subject <- substring(kssdata$folder, 1, 3)
kssdata$sessionpair <- c("1_3", "2_4")
kssdata <- reshape(kssdata, direction = "long", , varying = c("kss2", "kss69"), idvar = c("subject", "sessionpair"), v.names = "kss")
kssdata$session <- 1
kssdata$session[kssdata$sessionpair == "1_3" & kssdata$time == 2] <- 3
kssdata$session[kssdata$sessionpair == "2_4" & kssdata$time == 1] <- 2
kssdata$session[kssdata$sessionpair == "2_4" & kssdata$time == 2] <- 4
kssdata <- kssdata[, c("subject", "session", "kss")]
kssdata$subject <- as.integer(kssdata$subject)

data_glob  <- merge(data_glob, kssdata, by = c("subject", "session"))

# Read sleep data
sleepdata <- read.csv2("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/SleepData_140901.csv")
sleepdata <- sleepdata[sleepdata$Subject %in% subjects$subject, ]
unique(sleepdata$Subject)

# Change reference levels for modelling
data_glob$AgeGroup <- relevel(data_glob$AgeGroup, ref = "Young")
data_glob$condition <- as.factor(data_glob$condition)
data_glob$condition <- relevel(data_glob$condition, ref = "fullsleep")

#######################

# Main analyses
require(nlme)
require(effects)
require(RColorBrewer)
cols <- brewer.pal(n = 3, name = "Dark2")

# Full model
lm1 <- lme(globalsignal_rms ~ condition * AgeGroup + FD, data = data_glob, random = ~1|ID)
summary(lm1)
intervals(lm1)
plot(effect("condition*AgeGroup", lm1))

# Make figure
pdf("GS1.pdf", height = 6, width = 6) 
par(mar = c(4, 5, 1, 2))
plot(1, frame.plot = F, xlim = c(0, 1), ylim = c(4100, 4400), xlab = "", ylab = "Global signal intensity (rms)", xaxt = "n", type = "n")
axis(1, at = c(0.05, 0.95), labels = c("Full sleep", "Sleep deprived"))
lines(x = c(0, 0.9), y = effect("condition*AgeGroup", lm1)$fit[1:2], pch = 16, col = cols[3], type = "b", lwd = 1.5)
lines(x = c(0.1, 1), y = effect("condition*AgeGroup", lm1)$fit[3:4], pch = 16, col = cols[2], type = "b", lwd = 1.5)
lines(x = c(0, 0), y = c(effect("condition*AgeGroup", lm1)$lower[1], effect("condition*AgeGroup", lm1)$upper[1]), col = cols[3], lwd = 1.5)
lines(x = c(0.9, 0.9), y = c(effect("condition*AgeGroup", lm1)$lower[2], effect("condition*AgeGroup", lm1)$upper[2]), col = cols[3], lwd = 1.5)
lines(x = c(0.1, 0.1), y = c(effect("condition*AgeGroup", lm1)$lower[3], effect("condition*AgeGroup", lm1)$upper[3]), col = cols[2], lwd = 1.5)
lines(x = c(1, 1), y = c(effect("condition*AgeGroup", lm1)$lower[4], effect("condition*AgeGroup", lm1)$upper[4]), col = cols[2], lwd = 1.5)
legend("topleft", lty = 1, lwd = 1.5, pch = 16, col = cols[3:2], legend = c("Younger", "Older"), bty = "n")
dev.off()

# Model old and young separately due to interaction effect
lm1b <- lme(globalsignal_rms ~ condition + FD, data = data_glob[data_glob$AgeGroup == "Young", ], random = ~1|ID)
summary(lm1b)
intervals(lm1b)

lm1c <- lme(globalsignal_rms ~ condition + FD, data = data_glob[data_glob$AgeGroup == "Old", ], random = ~1|ID)
summary(lm1c)
intervals(lm1c)



# Separate models for sessions (1 and 3) and (2 and 4) mostly as a kind of sensitivity analysis
lm2 <- lme(globalsignal_rms ~ condition * AgeGroup + FD, data = subset(data_glob, data_glob$session %in% c(1, 3)), random = ~1|ID)
summary(lm2)
lm3 <- lme(globalsignal_rms ~ condition * AgeGroup + FD, data = subset(data_glob, data_glob$session %in% c(2, 4)), random = ~1|ID)
summary(lm3)


# Full model, global signal amplitude (SD, following Wong et al)
lm2 <- lme(globalsignal_sd ~ condition * AgeGroup + FD, data = data_glob, random = ~1|ID)
summary(lm2)
intervals(lm2)
plot(effect("condition*AgeGroup", lm2))

pdf("GS2.pdf", height = 6, width = 6) 
par(mar = c(4, 5, 1, 2))
plot(1, frame.plot = F, xlim = c(0, 1), ylim = c(10, 22), xlab = "", ylab = "Global signal amplitude (sd)", xaxt = "n", type = "n")
axis(1, at = c(0.05, 0.95), labels = c("Full sleep", "Sleep deprived"))
lines(x = c(0, 0.9), y = effect("condition*AgeGroup", lm2)$fit[1:2], pch = 16, col = cols[3], type = "b", lwd = 1.5)
lines(x = c(0.1, 1), y = effect("condition*AgeGroup", lm2)$fit[3:4], pch = 16, col = cols[2], type = "b", lwd = 1.5)
lines(x = c(0, 0), y = c(effect("condition*AgeGroup", lm2)$lower[1], effect("condition*AgeGroup", lm2)$upper[1]), col = cols[3], lwd = 1.5)
lines(x = c(0.9, 0.9), y = c(effect("condition*AgeGroup", lm2)$lower[2], effect("condition*AgeGroup", lm2)$upper[2]), col = cols[3], lwd = 1.5)
lines(x = c(0.1, 0.1), y = c(effect("condition*AgeGroup", lm2)$lower[3], effect("condition*AgeGroup", lm2)$upper[3]), col = cols[2], lwd = 1.5)
lines(x = c(1, 1), y = c(effect("condition*AgeGroup", lm2)$lower[4], effect("condition*AgeGroup", lm2)$upper[4]), col = cols[2], lwd = 1.5)
legend("topleft", lty = 1, lwd = 1.5, pch = 16, col = cols[3:2], legend = c("Younger", "Older"), bty = "n")
dev.off()

# Full model, global signal amplitude (log SD to better meet model assumptions)
lm3 <- lme(globalsignal_logsd ~ condition * AgeGroup + FD, data = data_glob, random = ~1|ID)
summary(lm3)
intervals(lm3)
plot(effect("condition*AgeGroup", lm3))

pdf("GS3.pdf", height = 6, width = 6) 
par(mar = c(4, 5, 1, 2))
plot(1, frame.plot = F, xlim = c(0, 1), ylim = c(2.3, 3.1), xlab = "", ylab = "Global signal amplitude (ln sd)", xaxt = "n", type = "n")
axis(1, at = c(0.05, 0.95), labels = c("Full sleep", "Sleep deprived"))
lines(x = c(0, 0.9), y = effect("condition*AgeGroup", lm3)$fit[1:2], pch = 16, col = cols[3], type = "b", lwd = 1.5)
lines(x = c(0.1, 1), y = effect("condition*AgeGroup", lm3)$fit[3:4], pch = 16, col = cols[2], type = "b", lwd = 1.5)
lines(x = c(0, 0), y = c(effect("condition*AgeGroup", lm3)$lower[1], effect("condition*AgeGroup", lm3)$upper[1]), col = cols[3], lwd = 1.5)
lines(x = c(0.9, 0.9), y = c(effect("condition*AgeGroup", lm3)$lower[2], effect("condition*AgeGroup", lm3)$upper[2]), col = cols[3], lwd = 1.5)
lines(x = c(0.1, 0.1), y = c(effect("condition*AgeGroup", lm3)$lower[3], effect("condition*AgeGroup", lm3)$upper[3]), col = cols[2], lwd = 1.5)
lines(x = c(1, 1), y = c(effect("condition*AgeGroup", lm3)$lower[4], effect("condition*AgeGroup", lm3)$upper[4]), col = cols[2], lwd = 1.5)
legend("topleft", lty = 1, lwd = 1.5, pch = 16, col = cols[3:2], legend = c("Younger", "Older"), bty = "n")
dev.off()


#######################

# Analyses of covariates
# KSS: analysed separately for the two conditions because sleepiness was higher in the sleep deprivation condition
lm4 <- lme(globalsignal_rms ~ kss * AgeGroup + FD, data = subset(data_glob, data_glob$condition == "fullsleep"), random = ~1|ID)
summary(lm4)
intervals(lm4)
plot(effect("kss*AgeGroup", lm4))

lm5 <- lme(globalsignal_rms ~ kss * AgeGroup + FD, data = subset(data_glob, data_glob$condition == "sleepdeprived"), random = ~1|ID)
summary(lm5)
intervals(lm5)
plot(effect("kss*AgeGroup", lm5))

# ISI
lm6 <- lme(globalsignal ~ condition * AgeGroup + ISI + FD, data = data_glob, random = ~1|ID)
summary(lm6)
intervals(lm6)
lm7 <- lme(globalsignal ~ AgeGroup + ISI + FD, data = subset(data_glob, data_glob$condition == "fullsleep"), random = ~1|ID)
summary(lm7)
intervals(lm7)
lm8 <- lme(globalsignal ~ AgeGroup + ISI + FD, data = subset(data_glob, data_glob$condition == "sleepdeprived"), random = ~1|ID)
summary(lm8)
intervals(lm8)

# ESS
ess1 <- lme(globalsignal ~ condition * AgeGroup + ESS + FD, data = data_glob, random = ~1|ID)
summary(ess1)
intervals(ess1)
ess2 <- lme(globalsignal ~ AgeGroup + ESS + FD, data = subset(data_glob, data_glob$condition == "fullsleep"), random = ~1|ID)
summary(ess2)
intervals(ess2)
ess3 <- lme(globalsignal ~ AgeGroup + ESS + FD, data = subset(data_glob, data_glob$condition == "sleepdeprived"), random = ~1|ID)
summary(ess3)
intervals(ess3)

# KSQ sleep quality
ksq1 <- lme(globalsignal ~ condition * AgeGroup + KSQ_SleepQualityIndex + FD, data = data_glob, random = ~1|ID)
summary(ksq1)
intervals(ksq1)
ksq2 <- lme(globalsignal ~ AgeGroup + KSQ_SleepQualityIndex + FD, data = subset(data_glob, data_glob$condition == "fullsleep"), random = ~1|ID)
summary(ksq2)
intervals(ksq2)
ksq3 <- lme(globalsignal ~ AgeGroup + KSQ_SleepQualityIndex + FD, data = subset(data_glob, data_glob$condition == "sleepdeprived"), random = ~1|ID)
summary(ksq3)
intervals(ksq3)
