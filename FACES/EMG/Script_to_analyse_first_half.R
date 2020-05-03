# EMG

# Require packages
require(nlme)
require(effects)
require(RColorBrewer)
cols <- brewer.pal(3,"Dark2")

# Read data
# Define files
files <- list.files("~/Box Sync/Sleepy Brain/Datafiles/Acqknowledge_logfiles_exported/")
files <- files[-grep(files, pattern = "excluded")] # Remove files from participants excluded from the experiment altogether
files <- files[-length(files)] # Remove last, provisional due to zipped archive present in folder

files <- files[-c(16, 44, 45, 115, 162)] # Remove files where both channels failed quality inspection in Acqknowledge (9009_2, 9028_2, 9029_1, 9071_1, 9096_1)
#files <- files[files != "9087_1.txt"] # Remove file where reference waves were wrong, possibly because wrong Acqknowledge template was used for recording?
files <- files[files != "9002_2.txt"] # Remove file where reference was incomplete
#files <- files[files != "9041_1.txt"] # Remove file where reference was incomplete
files <- files[files != "9046_2.txt"] # Remove file where reference wave was on throughout for an unknown reason
files <- files[files != "9025_2.txt"] # Remove file where reference wave was on throughout for an unknown reason

# Loop over data files, read them, write check plots for reference waves, regress the signals on one another
for(i in 1:length(files)){
  data <- read.delim(paste("~/Box Sync/Sleepy Brain/Datafiles/Acqknowledge_logfiles_exported/", files[i], sep = ""), skip = 19, header = F)
  data <- data[, c(1, 4:8)]
  subject_session <- substr(files[i], 1, 6)
  plot(data$V6, type = "l", frame.plot = F, col = "gray", xlab = "Time (min)", ylab = "", xaxt = "n", main = subject_session)
  axis(1, at = c(0, 12000, 24000, 36000, 48000), labels = c(0, 2, 4, 6, 8))
  lines(data$V7, col = "orange")
  lines(data$V8, col = "green")
  lm_zyg <- lm(V4 ~ V5, data = data)
  data$zyg_resid <- lm_zyg$residuals
  lm_corr <- lm(V5 ~ V4, data = data)
  data$corr_resid <- lm_corr$residuals
  
  # Define where blocks begin
  # The following code handles the problem that artifacts sometimes caused spikes in the reference channels for event onsets
  neutraldataindices <- which(data$V6 > 4)
  neutral_compareindices <- c(0, neutraldataindices)
  neutral_compare <- c(neutraldataindices, 0) - neutral_compareindices
  neutral_retain <- which(neutral_compare > 1000)
  neutraldataindices <- neutraldataindices[neutral_retain]
  if(subject_session == "9026_1"){
    neutraldataindices <- neutraldataindices[-c(3)]
  }
  if(subject_session == "9034_2"){
    neutraldataindices <- neutraldataindices[-c(1)]
  }
  if(subject_session == "9079_2"){ 
    neutraldataindices <- neutraldataindices[-c(1)]
  }
  if(subject_session == "9088_2"){
    neutraldataindices <- neutraldataindices[-c(4)]
  }
  points(neutraldataindices, rep(1, length(neutraldataindices)), pch = "|")
  
  happydataindices <- which(data$V7 > 4)
  happy_compareindices <- c(0, happydataindices)
  happy_compare <- c(happydataindices, 0) - happy_compareindices
  happy_retain <- which(happy_compare > 1000)
  happydataindices <- happydataindices[happy_retain]
  if(subject_session == "9018_2"){
    happydataindices <- happydataindices[-c(3)]
  }
  if(subject_session == "9041_2"){
    happydataindices <- happydataindices[-c(3, 4)]
  }
  if(subject_session == "9071_2"){
    happydataindices <- happydataindices[-c(3, 6)]
  }
  if(subject_session == "9084_2"){
    happydataindices <- happydataindices[-c(4)]
  }
  points(happydataindices, rep(1, length(happydataindices)), pch = "o")
  
  angrydataindices <- which(data$V8 > 4)
  angry_compareindices <- c(0, angrydataindices)
  angry_compare <- c(angrydataindices, 0) - angry_compareindices
  angry_retain <- which(angry_compare > 1000)
  angrydataindices <- angrydataindices[angry_retain]
  if(subject_session == "9033_1"){
    angrydataindices <- angrydataindices[-c(1)]
  }
  if(subject_session == "9034_2"){
    angrydataindices <- angrydataindices[-c(1)]
  }
  if(subject_session == "9042_2"){
    angrydataindices <- angrydataindices[-c(2)]
  }
  if(subject_session == "9074_2"){
    angrydataindices <- angrydataindices[-c(3)]
  }
  if(subject_session == "9088_2"){
    angrydataindices <- angrydataindices[-c(5)]
  }
  points(angrydataindices, rep(1, length(angrydataindices)), pch = "x")
  
  if(length(neutraldataindices) != 4 | length(happydataindices) != 4 | length(angrydataindices) != 4){
    break
    return(paste(files[i], "Too many or too few onsets found"))
  }
  
  neutraldataindices <- as.vector(sapply(neutraldataindices, FUN = function(x){x:(x+1999)}, simplify = T))
  happydataindices <- as.vector(sapply(happydataindices, FUN = function(x){x:(x+1999)}, simplify = T))
  angrydataindices <- as.vector(sapply(angrydataindices, FUN = function(x){x:(x+1999)}, simplify = T))
  
  neutraldata <- data[neutraldataindices, ]
  neutraldata$file <- files[i]
  neutraldata$stimulus <- "neutral"
  neutraldata$block <- c(rep(1, 2000), rep(2, 2000), rep(3, 2000), rep(4, 2000))
  
  happydata <- data[happydataindices, ]
  happydata$file <- files[i]
  happydata$stimulus <- "happy"
  happydata$block <- c(rep(1, 2000), rep(2, 2000), rep(3, 2000), rep(4, 2000))
  
  angrydata <- data[angrydataindices, ]
  angrydata$file <- files[i]
  angrydata$stimulus <- "angry"
  angrydata$block <- c(rep(1, 2000), rep(2, 2000), rep(3, 2000), rep(4, 2000))
  
  dataout <- rbind(neutraldata, happydata, angrydata)
  #hist(dataout$zyg_resid, main = paste(files[i]))
  #qqnorm(dataout$zyg_resid)
  #qqline(dataout$zyg_resid)
  #hist(dataout$corr_resid, main = paste(files[i]))
  #qqnorm(dataout$corr_resid)
  #qqline(dataout$corr_resid)
  
  if (!exists("extracteddata")){
    extracteddata <- dataout
  } else{
    extracteddata <- rbind(extracteddata, dataout)
  }
}

# List data that failed manual quality check, corrugator readings only
rejectedcorr <- c("9003_1", "9005_2", "9011_2", "9018_1", "9018_2", "9028_1", "9028_2",
                  "9032_1", "9036_1", "9038_2", "9039_1", "9045_2", "9047_1", "9048_1", 
                  "9054_1", "9054_2", "9055_1", "9064_2", "9068_2", "9069_2", "9072_1",
                  "9074_1", "9075_1", "9086_2", "9088_1")
extracteddata$subject_session <- substr(extracteddata$file, 1, 6)
#extracteddata$corr_resid[extracteddata$subject_session %in% rejectedcorr] <- NA

# Write regressors to enter in SPM
mriregressors <- extracteddata[, c("V1", "zyg_resid", "corr_resid", "file", "block", "subject_session")]
mriregressors$subject <- substr(mriregressors$subject_session, 1, 4)
mriregressors$session <- substr(mriregressors$subject_session, 6, 6)
mriregressors <- mriregressors[, c("V1", "zyg_resid", "corr_resid", "subject", "session", "block")]
names(mriregressors)[1] <- "time_min"
write.csv(head(mriregressors), file = "mriregressors_160819_head.csv", row.names = FALSE)

# Aggregate data over blocks
blockdata <- aggregate(cbind(zyg_resid, corr_resid) ~ subject_session + block + stimulus, data = extracteddata, FUN = mean, na.rm = T)
blockdata$subject <- substr(blockdata$subject_session, 1, 4)
blockdata$session <- substr(blockdata$subject_session, 6, 6)
blockdata$stimulus <- as.factor(blockdata$stimulus)
blockdata$stimulus <- relevel(blockdata$stimulus, ref = "neutral")

# Inspect data distributions
blockdata$log_zyg_resid <- log(20 + blockdata$zyg_resid)
blockdata$log_corr_resid <- log(20 + blockdata$corr_resid)

hist(blockdata$zyg_resid)
plot(density(blockdata$zyg_resid))
qqnorm(blockdata$zyg_resid)
qqline(blockdata$zyg_resid)

hist(blockdata$log_zyg_resid)
plot(density(blockdata$log_zyg_resid))
qqnorm(blockdata$log_zyg_resid)
qqline(blockdata$log_zyg_resid)

hist(blockdata$corr_resid)
plot(density(blockdata$corr_resid))
qqnorm(blockdata$corr_resid)
qqline(blockdata$corr_resid)

hist(blockdata$log_corr_resid)
plot(density(blockdata$log_corr_resid))
qqnorm(blockdata$log_corr_resid)
qqline(blockdata$log_corr_resid)
# Data are not well approximating a normal distribution, but it looks like a log transformation won't help

# Read demographic and other data, add, prepare for modelling
demdata <- read.csv2("~/Box Sync/Sleepy Brain/Datafiles/demdata_160225_pseudonymized.csv")
blockdata <- merge(blockdata, demdata[, c("id", "AgeGroup", "Sl_cond")], by.x = "subject", by.y = "id")
subjects <- read.csv2("~/Box Sync/Sleepy Brain/Datafiles/Subjects_151215.csv")
blockdata <- merge(blockdata, subjects[, c("SuccessfulIntervention", "newid")], by.x = "subject", by.y = "newid")

blockdata$condition <- "fullsleep"
blockdata$condition[blockdata$session == 1 & blockdata$Sl_cond == 1] <- "sleepdeprived"
blockdata$condition[blockdata$session == 2 & blockdata$Sl_cond == 2] <- "sleepdeprived"
blockdata$condition <- as.factor(blockdata$condition)
blockdata$condition <- relevel(blockdata$condition, ref = "fullsleep")
blockdata$AgeGroup <- relevel(blockdata$AgeGroup, ref = "Young")
blockdata$corr_resid[blockdata$subject_session %in% rejectedcorr] <- NA

# Contrast coding
contrasts(blockdata$stimulus)[, 1] <- c(-0.5, 1, -0.5) # Will test angry vs neutral and happy
contrasts(blockdata$stimulus)[, 2] <- c(-0.5, -0.5, 1) # Will test happy vs neutral and angry
contrasts(blockdata$condition) <- c(-0.5, 0.5)
contrasts(blockdata$AgeGroup) <- c(-0.5, 0.5)

# Make data frame with only final sample
blockdata2 <- blockdata[!is.na(blockdata$SuccessfulIntervention), ]

# Piece of code to only analyse the first half of the experiment
blockdata2 <- subset(blockdata2, block < 3)

# Build and inspect regression models
lme1 <- lme(zyg_resid ~ stimulus*condition*AgeGroup, data = blockdata2, random = ~ 1|subject/session/block, na.action = na.omit)
plot(lme1)
plot(effect("stimulus", lme1))
plot(effect("stimulus*condition*AgeGroup", lme1))
summary(lme1)
sink(file = "FACES/EMG/zyg_regression_output.txt") 
summary(lme1) 
intervals(lme1, which = "fixed")
sink() 

lme1b <- lme(zyg_resid ~ stimulus*condition*AgeGroup, data = blockdata2[blockdata2$stimulus != "neutral", ], random = ~ 1|subject/session/block, na.action = na.omit)
plot(lme1b)
plot(effect("stimulus", lme1b))
plot(effect("stimulus*condition", lme1b))
plot(effect("stimulus*condition*AgeGroup", lme1b))
summary(lme1b)

lme1c <- lme(zyg_resid ~ stimulus, data = blockdata, random = ~ 1|subject/session/block, na.action = na.omit)
plot(lme1c)
plot(effect("stimulus", lme1c))
summary(lme1c)
intervals(lme1c, which = "fixed")

lme2 <- lme(corr_resid ~ stimulus*condition*AgeGroup, data = blockdata2, random = ~ 1|subject/session/block, na.action = na.omit)
plot(lme2)
plot(effect("stimulus", lme2))
plot(effect("stimulus*condition*AgeGroup", lme2))
summary(lme2)
sink(file = "FACES/EMG/corr_regression_output.txt") 
summary(lme2) 
intervals(lme2, which = "fixed")
sink() 

lme2bb <- lme(corr_resid ~ stimulus*condition, data = blockdata2[blockdata2$AgeGroup == "Young", ], random = ~ 1|subject/session/block, na.action = na.omit)
plot(lme2bb)
plot(effect("stimulus", lme2bb))
plot(effect("stimulus*condition", lme2bb))
summary(lme2bb)
sink(file = "FACES/EMG/corr_regression_output_younger.txt") 
summary(lme2bb) 
intervals(lme2bb, which = "fixed")
sink() 

lme2bc <- lme(corr_resid ~ stimulus*condition, data = blockdata2[blockdata2$AgeGroup == "Old", ], random = ~ 1|subject/session/block, na.action = na.omit)
plot(lme2bc)
plot(effect("stimulus", lme2bc))
plot(effect("stimulus*condition", lme2bc))
summary(lme2bc)
sink(file = "FACES/EMG/corr_regression_output_older.txt") 
summary(lme2bc) 
intervals(lme2bc, which = "fixed")
sink() 

lme2b <- lme(corr_resid ~ stimulus*condition*AgeGroup, data = blockdata[blockdata$stimulus != "neutral" & !is.na(blockdata$SuccessfulIntervention & !(blockdata$subject_session %in% rejectedcorr)), ], random = ~ 1|subject/session/block, na.action = na.omit)
plot(lme2b)
plot(effect("stimulus", lme2b))
plot(effect("stimulus*condition", lme2b))
plot(effect("stimulus*condition*AgeGroup", lme2b))
summary(lme2b)

lme2c <- lme(corr_resid ~ stimulus, data = blockdata, random = ~ 1|subject/session/block, na.action = na.omit)
plot(lme2c)
plot(effect("stimulus", lme2c))
summary(lme2c)
intervals(lme2c, which = "fixed")

# Plot main effects
pdf("EMG1a.pdf", height = 5, width = 5) 
par(mar = c(4, 5, 1, 2))
plot(1, frame.plot = F, xlim = c(0, 1), ylim = c(-0.02, 0.04), xlab = "", ylab = "microV, mean residual difference", xaxt = "n", type = "n", main = "Zygomatic mimicry")
axis(1, at = c(0.05, 0.5, 0.95), labels = c("Neutral", "Happy", "Angry"))
lines(x = c(0, 0.9), y = effect("condition*AgeGroup", lme1d)$fit[1:2]*1000, pch = 16, col = cols[3], type = "b", lwd = 1.5)
lines(x = c(0.1, 1), y = effect("condition*AgeGroup", lme1d)$fit[3:4]*1000, pch = 16, col = cols[2], type = "b", lwd = 1.5)
lines(x = c(0, 0), y = c(effect("condition*AgeGroup", lme1d)$lower[1]*1000, effect("condition*AgeGroup", lme1d)$upper[1]*1000), col = cols[3], lwd = 1.5)
lines(x = c(0.9, 0.9), y = c(effect("condition*AgeGroup", lme1d)$lower[2]*1000, effect("condition*AgeGroup", lme1d)$upper[2]*1000), col = cols[3], lwd = 1.5)
lines(x = c(0.1, 0.1), y = c(effect("condition*AgeGroup", lme1d)$lower[3]*1000, effect("condition*AgeGroup", lme1d)$upper[3]*1000), col = cols[2], lwd = 1.5)
lines(x = c(1, 1), y = c(effect("condition*AgeGroup", lme1d)$lower[4]*1000, effect("condition*AgeGroup", lme1d)$upper[4]*1000), col = cols[2], lwd = 1.5)
legend("top", lty = 1, lwd = 1.5, pch = 16, col = cols[3:2], legend = c("Younger", "Older"), bty = "n")
dev.off()

pdf("EMG3.pdf", height = 5, width = 5) 
par(mar = c(4, 5, 1, 2))
plot(1, frame.plot = F, xlim = c(0, 1), ylim = c(-0.4, 0.2), xlab = "", ylab = "microV, mean residual difference", xaxt = "n", type = "n", main = "Corrugator mimicry")
axis(1, at = c(0.05, 0.95), labels = c("Full sleep", "Sleep deprived"))
lines(x = c(0, 0.9), y = effect("condition*AgeGroup", lme2d)$fit[1:2]*1000, pch = 16, col = cols[3], type = "b", lwd = 1.5)
lines(x = c(0.1, 1), y = effect("condition*AgeGroup", lme2d)$fit[3:4]*1000, pch = 16, col = cols[2], type = "b", lwd = 1.5)
lines(x = c(0, 0), y = c(effect("condition*AgeGroup", lme2d)$lower[1]*1000, effect("condition*AgeGroup", lme2d)$upper[1]*1000), col = cols[3], lwd = 1.5)
lines(x = c(0.9, 0.9), y = c(effect("condition*AgeGroup", lme2d)$lower[2]*1000, effect("condition*AgeGroup", lme2d)$upper[2]*1000), col = cols[3], lwd = 1.5)
lines(x = c(0.1, 0.1), y = c(effect("condition*AgeGroup", lme2d)$lower[3]*1000, effect("condition*AgeGroup", lme2d)$upper[3]*1000), col = cols[2], lwd = 1.5)
lines(x = c(1, 1), y = c(effect("condition*AgeGroup", lme2d)$lower[4]*1000, effect("condition*AgeGroup", lme2d)$upper[4]*1000), col = cols[2], lwd = 1.5)
#legend("top", lty = 1, lwd = 1.5, pch = 16, col = cols[3:2], legend = c("Younger", "Older"), bty = "n")
dev.off()

pdf("EMG_validation2.pdf", height = 4, width = 5) 
plot(1, frame.plot = F, xlim = c(0, 2), ylim = c(-0.07, 0), xlab = "stimulus", ylab = "microV, residual", xaxt = "n", yaxt = "n", type = "n", main = "Zygomatic")
axis(1, at = c(0, 1, 2), labels = c("Happy", "Neutral", "Angry"))
axis(2, at = c(0, -0.03, -0.06))
lines(x = c(0, 1, 2), y = effect("stimulus", lme1c)$fit[c(3, 1, 2)]*1000, pch = 16, type = "b", lwd = 1.5)
lines(x = c(0, 0), y = c(effect("stimulus", lme1c)$lower[3]*1000, effect("stimulus", lme1c)$upper[3]*1000), lwd = 1.5)
lines(x = c(1, 1), y = c(effect("stimulus", lme1c)$lower[1]*1000, effect("stimulus", lme1c)$upper[1]*1000), lwd = 1.5)
lines(x = c(2, 2), y = c(effect("stimulus", lme1c)$lower[2]*1000, effect("stimulus", lme1c)$upper[2]*1000), lwd = 1.5)

plot(1, frame.plot = F, xlim = c(0, 2), ylim = c(-0.7, -0.1), xlab = "stimulus", ylab = "microV, residual", xaxt = "n", yaxt = "n", type = "n", main = "Corrugator")
axis(1, at = c(0, 1, 2), labels = c("Happy", "Neutral", "Angry"))
axis(2, at = c(-0.2, -0.4, -0.6))
lines(x = c(0, 1, 2), y = effect("stimulus", lme2c)$fit[c(3, 1, 2)]*1000, pch = 16, type = "b", lwd = 1.5)
lines(x = c(0, 0), y = c(effect("stimulus", lme2c)$lower[3]*1000, effect("stimulus", lme2c)$upper[3]*1000), lwd = 1.5)
lines(x = c(1, 1), y = c(effect("stimulus", lme2c)$lower[1]*1000, effect("stimulus", lme2c)$upper[1]*1000), lwd = 1.5)
lines(x = c(2, 2), y = c(effect("stimulus", lme2c)$lower[2]*1000, effect("stimulus", lme2c)$upper[2]*1000), lwd = 1.5)
dev.off()

eff <- effect("stimulus*condition*AgeGroup", lme1)
eff$fit <- eff$fit*1000
eff$upper <- eff$upper*1000
eff$lower <- eff$lower*1000

eff2 <- effect("stimulus*condition*AgeGroup", lme2)
eff2$fit <- eff2$fit*1000
eff2$upper <- eff2$upper*1000
eff2$lower <- eff2$lower*1000

pdf("FACES/EMG/EMG_main2.pdf", height = 5, width = 5) 

plot(1, frame.plot = F, xlim = c(-0.1, 2.1), ylim = c(min(eff$lower), 0.1), xlab = "stimulus", ylab = "microV, residual", xaxt = "n", yaxt = "n", type = "n", main = "Zygomatic, young")
axis(1, at = c(0, 1, 2), labels = c("Happy", "Neutral", "Angry"))
axis(2, at = c(-0.1, -0.05, 0, 0.05, 0.1))
lines(x = c(-0.05, 0.95, 1.95), y = eff$fit[c(3, 1, 2)], pch = 16, type = "b", lwd = 1.5, col = cols[2])
lines(x = c(-0.05, -0.05), y = c(eff$lower[3], eff$upper[3]), lwd = 1.5, col = cols[2])
lines(x = c(0.95, 0.95), y = c(eff$lower[1], eff$upper[1]), lwd = 1.5, col = cols[2])
lines(x = c(1.95, 1.95), y = c(eff$lower[2], eff$upper[2]), lwd = 1.5, col = cols[2])
lines(x = c(0.05, 1.05, 2.05), y = eff$fit[c(6, 4, 5)], pch = 15, type = "b", lwd = 1.5, col = cols[3])
lines(x = c(0.05, 0.05), y = c(eff$lower[6], eff$upper[6]), lwd = 1.5, col = cols[3])
lines(x = c(1.05, 1.05), y = c(eff$lower[4], eff$upper[4]), lwd = 1.5, col = cols[3])
lines(x = c(2.05, 2.05), y = c(eff$lower[5], eff$upper[5]), lwd = 1.5, col = cols[3])
legend("top", lwd = 1.5, pch = c(16, 15), legend = c("full sleep", "sleep deprivation"), col = cols[c(2, 3)], bty = "n")

plot(1, frame.plot = F, xlim = c(-0.1, 2.1), ylim = c(min(eff$lower), 0.1), xlab = "stimulus", ylab = "microV, residual", xaxt = "n", yaxt = "n", type = "n", main = "Zygomatic, older")
axis(1, at = c(0, 1, 2), labels = c("Happy", "Neutral", "Angry"))
axis(2, at = c(-0.1, -0.05, 0, 0.05, 0.1))
lines(x = c(-0.05, 0.95, 1.95), y = eff$fit[c(9, 7, 8)], pch = 16, type = "b", lwd = 1.5, col = cols[2])
lines(x = c(-0.05, -0.05), y = c(eff$lower[9], eff$upper[9]), lwd = 1.5, col = cols[2])
lines(x = c(0.95, 0.95), y = c(eff$lower[7], eff$upper[7]), lwd = 1.5, col = cols[2])
lines(x = c(1.95, 1.95), y = c(eff$lower[8], eff$upper[8]), lwd = 1.5, col = cols[2])
lines(x = c(0.05, 1.05, 2.05), y = eff$fit[c(12, 10, 11)], pch = 15, type = "b", lwd = 1.5, col = cols[3])
lines(x = c(0.05, 0.05), y = c(eff$lower[12], eff$upper[12]), lwd = 1.5, col = cols[3])
lines(x = c(1.05, 1.05), y = c(eff$lower[10], eff$upper[10]), lwd = 1.5, col = cols[3])
lines(x = c(2.05, 2.05), y = c(eff$lower[11], eff$upper[11]), lwd = 1.5, col = cols[3])
legend("top", lwd = 1.5, pch = c(16, 15), legend = c("full sleep", "sleep deprivation"), col = cols[c(2, 3)], bty = "n")

plot(1, frame.plot = F, xlim = c(-0.1, 2.1), ylim = c(-0.5, 0.5), xlab = "stimulus", ylab = "microV, residual", xaxt = "n", yaxt = "n", type = "n", main = "Corrugator, young")
axis(1, at = c(0, 1, 2), labels = c("Happy", "Neutral", "Angry"))
axis(2, at = c(-0.5, 0, 0.5))
lines(x = c(-0.05, 0.95, 1.95), y = eff2$fit[c(3, 1, 2)], pch = 16, type = "b", lwd = 1.5, col = cols[2])
lines(x = c(-0.05, -0.05), y = c(eff2$lower[3], eff2$upper[3]), lwd = 1.5, col = cols[2])
lines(x = c(0.95, 0.95), y = c(eff2$lower[1], eff2$upper[1]), lwd = 1.5, col = cols[2])
lines(x = c(1.95, 1.95), y = c(eff2$lower[2], eff2$upper[2]), lwd = 1.5, col = cols[2])
lines(x = c(0.05, 1.05, 2.05), y = eff2$fit[c(6, 4, 5)], pch = 15, type = "b", lwd = 1.5, col = cols[3])
lines(x = c(0.05, 0.05), y = c(eff2$lower[6], eff2$upper[6]), lwd = 1.5, col = cols[3])
lines(x = c(1.05, 1.05), y = c(eff2$lower[4], eff2$upper[4]), lwd = 1.5, col = cols[3])
lines(x = c(2.05, 2.05), y = c(eff2$lower[5], eff2$upper[5]), lwd = 1.5, col = cols[3])
legend("top", lwd = 1.5, pch = c(16, 15), legend = c("full sleep", "sleep deprivation"), col = cols[c(2, 3)], bty = "n")

plot(1, frame.plot = F, xlim = c(-0.1, 2.1), ylim = c(-0.5, 0.5), xlab = "stimulus", ylab = "microV, residual", xaxt = "n", yaxt = "n", type = "n", main = "Corrugator, older")
axis(1, at = c(0, 1, 2), labels = c("Happy", "Neutral", "Angry"))
axis(2, at = c(-0.5, 0, 0.5))
lines(x = c(-0.05, 0.95, 1.95), y = eff2$fit[c(9, 7, 8)], pch = 15, type = "b", lwd = 1.5, col = cols[3])
lines(x = c(-0.05, -0.05), y = c(eff2$lower[9], eff2$upper[9]), lwd = 1.5, col = cols[3])
lines(x = c(0.95, 0.95), y = c(eff2$lower[7], eff2$upper[7]), lwd = 1.5, col = cols[3])
lines(x = c(1.95, 1.95), y = c(eff2$lower[8], eff2$upper[8]), lwd = 1.5, col = cols[3])
lines(x = c(0.05, 1.05, 2.05), y = eff2$fit[c(12, 10, 11)], pch = 16, type = "b", lwd = 1.5, col = cols[2])
lines(x = c(0.05, 0.05), y = c(eff2$lower[12], eff2$upper[12]), lwd = 1.5, col = cols[2])
lines(x = c(1.05, 1.05), y = c(eff2$lower[10], eff2$upper[10]), lwd = 1.5, col = cols[2])
lines(x = c(2.05, 2.05), y = c(eff2$lower[11], eff2$upper[11]), lwd = 1.5, col = cols[2])
legend("top", lwd = 1.5, pch = c(16, 15), legend = c("full sleep", "sleep deprivation"), col = cols[c(2, 3)], bty = "n")

dev.off()

# Analyse again with difference scores to reduce model complexity
# Reduce data
agg_zyg <- aggregate(zyg_resid ~  subject + session + stimulus + condition + AgeGroup, data = blockdata[blockdata$stimulus %in% c("angry", "happy") & !is.na(blockdata$SuccessfulIntervention), ], FUN = "mean")
data_zyg1 <- agg_zyg[agg_zyg$stimulus == "happy", ]
data_zyg2 <- agg_zyg[agg_zyg$stimulus == "angry", ]
data_diff_zyg <- data_zyg1
data_diff_zyg$diff <- data_diff_zyg$zyg_resid - data_zyg2$zyg_resid

agg_corr <- aggregate(corr_resid ~  subject + session + stimulus + condition + AgeGroup, data = blockdata[blockdata$stimulus %in% c("angry", "happy") & !is.na(blockdata$SuccessfulIntervention), ], FUN = "mean")
data_corr1 <- agg_corr[agg_corr$stimulus == "happy", ]
data_corr2 <- agg_corr[agg_corr$stimulus == "angry", ]
data_diff_corr <- data_corr1
data_diff_corr$diff <- data_diff_corr$corr_resid - data_corr2$corr_resid

# Build models
lme0 <- lme(diff ~ 1, data = data_diff_zyg, random = ~1|subject/session)
summary(lme0)
intervals(lme0, which = "fixed")
lme0b <- lme(diff ~ 1, data = data_diff_corr, random = ~1|subject/session)
summary(lme0b)
intervals(lme0b, which = "fixed")

lme1d <- lme(diff ~ condition * AgeGroup, data = data_diff_zyg, random = ~1|subject)
summary(lme1d)
intervals(lme1d, which = "fixed")
plot(effect("condition*AgeGroup", lme1d))

lme2d <- lme(diff ~ condition * AgeGroup, data = data_diff_corr, random = ~1|subject)
summary(lme2d)
intervals(lme2d, which = "fixed")
plot(effect("condition*AgeGroup", lme2d))

# Plot model estimates
pdf("EMG2.pdf", height = 5, width = 5) 
par(mar = c(4, 5, 1, 2))
plot(1, frame.plot = F, xlim = c(0, 1), ylim = c(-0.03, 0.05), xlab = "", ylab = "microV, mean residual difference", xaxt = "n", type = "n", main = "Zygomatic mimicry")
axis(1, at = c(0.05, 0.95), labels = c("Full sleep", "Sleep deprived"))
lines(x = c(0, 0.9), y = effect("condition*AgeGroup", lme1d)$fit[1:2]*1000, pch = 16, col = cols[3], type = "b", lwd = 1.5)
lines(x = c(0.1, 1), y = effect("condition*AgeGroup", lme1d)$fit[3:4]*1000, pch = 16, col = cols[2], type = "b", lwd = 1.5)
lines(x = c(0, 0), y = c(effect("condition*AgeGroup", lme1d)$lower[1]*1000, effect("condition*AgeGroup", lme1d)$upper[1]*1000), col = cols[3], lwd = 1.5)
lines(x = c(0.9, 0.9), y = c(effect("condition*AgeGroup", lme1d)$lower[2]*1000, effect("condition*AgeGroup", lme1d)$upper[2]*1000), col = cols[3], lwd = 1.5)
lines(x = c(0.1, 0.1), y = c(effect("condition*AgeGroup", lme1d)$lower[3]*1000, effect("condition*AgeGroup", lme1d)$upper[3]*1000), col = cols[2], lwd = 1.5)
lines(x = c(1, 1), y = c(effect("condition*AgeGroup", lme1d)$lower[4]*1000, effect("condition*AgeGroup", lme1d)$upper[4]*1000), col = cols[2], lwd = 1.5)
legend("top", lty = 1, lwd = 1.5, pch = 16, col = cols[3:2], legend = c("Younger", "Older"), bty = "n")
dev.off()

pdf("EMG3.pdf", height = 5, width = 5) 
par(mar = c(4, 5, 1, 2))
plot(1, frame.plot = F, xlim = c(0, 1), ylim = c(-0.4, 0.3), xlab = "", ylab = "microV, mean residual difference", xaxt = "n", type = "n", main = "Corrugator mimicry")
axis(1, at = c(0.05, 0.95), labels = c("Full sleep", "Sleep deprived"))
lines(x = c(0, 0.9), y = effect("condition*AgeGroup", lme2d)$fit[1:2]*1000, pch = 16, col = cols[3], type = "b", lwd = 1.5)
lines(x = c(0.1, 1), y = effect("condition*AgeGroup", lme2d)$fit[3:4]*1000, pch = 16, col = cols[2], type = "b", lwd = 1.5)
lines(x = c(0, 0), y = c(effect("condition*AgeGroup", lme2d)$lower[1]*1000, effect("condition*AgeGroup", lme2d)$upper[1]*1000), col = cols[3], lwd = 1.5)
lines(x = c(0.9, 0.9), y = c(effect("condition*AgeGroup", lme2d)$lower[2]*1000, effect("condition*AgeGroup", lme2d)$upper[2]*1000), col = cols[3], lwd = 1.5)
lines(x = c(0.1, 0.1), y = c(effect("condition*AgeGroup", lme2d)$lower[3]*1000, effect("condition*AgeGroup", lme2d)$upper[3]*1000), col = cols[2], lwd = 1.5)
lines(x = c(1, 1), y = c(effect("condition*AgeGroup", lme2d)$lower[4]*1000, effect("condition*AgeGroup", lme2d)$upper[4]*1000), col = cols[2], lwd = 1.5)
#legend("top", lty = 1, lwd = 1.5, pch = 16, col = cols[3:2], legend = c("Younger", "Older"), bty = "n")
dev.off()


# Write datafile with aggregated ratings by participant
data_diff_zyg2 <- data_diff_zyg[data_diff_zyg$condition == "fullsleep", ]
data_diff_corr2 <- data_diff_corr[data_diff_corr$condition == "fullsleep", ]

data_diff2 <- merge(data_diff_zyg2[, c("subject", "diff")], data_diff_corr2[, c("subject", "diff")], by = "subject")
names(data_diff2) <- c("id", "diff_zyg", "diff_corr")
plot(diff_zyg ~ diff_corr, data = data_diff2, main = "Diff happy blocks vs angry blocks", frame.plot = F)
lm_diff <- lm(diff_zyg ~ diff_corr, data = data_diff2)
abline(lm_diff, col = "red")
cor.test(data_diff2$diff_corr, data_diff2$diff_zyg, method = "kendall")

subjectlist <- read.csv2("~/Box Sync/Sleepy Brain/Datafiles/Subjects_151215.csv")
data_diff3 <- merge(data_diff2, subjectlist[, c("Subject", "newid")], by.x = "id", by.y = "newid")

write.csv(data_diff3[, -1], "EMG_diff.csv", row.names = FALSE)

# Temporary workaround to fix file written with wrong ID:s
temp <- read.csv("EMG_diff.csv")
subjectlist <- read.csv2("~/Box Sync/Sleepy Brain/Datafiles/Subjects_151215.csv")
temp2 <- merge(temp, subjectlist[, c("Subject", "newid")])
temp2 <- temp2[, -1]
write.csv(temp2, "EMG_diff_2.csv", row.names = FALSE)

# Analyse habituation
lme1e <- lme(zyg_resid ~ stimulus*condition*AgeGroup + block, data = blockdata2, random = ~ 1|subject/session/block, na.action = na.omit)
plot(lme1e)
plot(effect("block", lme1e))
summary(lme1e)
sink(file = "FACES/EMG/zyg_regression_output_habituation.txt") 
summary(lme1e) 
intervals(lme1e, which = "fixed")
sink() 

lme2e <- lme(corr_resid ~ stimulus*condition*AgeGroup + block, data = blockdata2, random = ~ 1|subject/session/block, na.action = na.omit)
plot(lme2e)
plot(effect("block", lme2e))
summary(lme2e)
sink(file = "FACES/EMG/corr_regression_output_habituation.txt") 
summary(lme2e) 
intervals(lme2e, which = "fixed")
sink() 

# Analyse covariates
ratings <- read.csv("FACES/EMG/ratings.csv")
ratings_happy <- ratings[ratings$Question_type == 2, ]
ratings_angry <- ratings[ratings$Question_type == 3, ]
blockdata2_happyratings <- merge(blockdata2, ratings_happy, by.x = c("subject", "session", "block"), by.y = c("newid", "session", "block"))
blockdata2_angryratings <- merge(blockdata2, ratings_angry, by.x = c("subject", "session", "block"), by.y = c("newid", "session", "block"))

lme1f <- lme(zyg_resid ~ stimulus*Rating, data = blockdata2_happyratings, random = ~ 1|subject/session/block, na.action = na.omit)
plot(lme1f)
plot(effect("Rating", lme1f))
summary(lme1f)
sink(file = "FACES/EMG/zyg_regression_output_happy_rating.txt") 
summary(lme1f) 
intervals(lme1f, which = "fixed")
sink() 

lme2f <- lme(corr_resid ~ stimulus*Rating, data = blockdata2_happyratings, random = ~ 1|subject/session/block, na.action = na.omit)
plot(lme2f)
plot(effect("Rating", lme2f))
summary(lme2f)
sink(file = "FACES/EMG/corr_regression_output_happy_rating.txt") 
summary(lme2f) 
intervals(lme2f, which = "fixed")
sink() 

lme1g <- lme(zyg_resid ~ stimulus*Rating, data = blockdata2_angryratings, random = ~ 1|subject/session/block, na.action = na.omit)
plot(lme1g)
plot(effect("Rating", lme1g))
summary(lme1g)
sink(file = "FACES/EMG/zyg_regression_output_angry_rating.txt") 
summary(lme1g) 
intervals(lme1g, which = "fixed")
sink() 

lme2g <- lme(corr_resid ~ stimulus*Rating, data = blockdata2_angryratings, random = ~ 1|subject/session/block, na.action = na.omit)
plot(lme2g)
plot(effect("Rating", lme2g))
summary(lme2g)
sink(file = "FACES/EMG/corr_regression_output_angry_rating.txt") 
summary(lme2g) 
intervals(lme2g, which = "fixed")
sink() 

blockdata2 <- merge(blockdata2, demdata[, c("id", "IRI_EC", "PANAS_Positive", "PANAS_Negative", 
                                            "PSS14", "PPIR_C", "ESS", "ECS")], by.x = "subject", by.y = "id")

lme1h <- lme(zyg_resid ~ stimulus*IRI_EC, data = blockdata2, random = ~ 1|subject/session/block, na.action = na.omit)
plot(lme1h)
plot(effect("IRI_EC", lme1h))
summary(lme1h)
sink(file = "FACES/EMG/zyg_regression_output_IRI_EC.txt") 
summary(lme1h) 
intervals(lme1h, which = "fixed")
sink() 

lme2h <- lme(corr_resid ~ stimulus*IRI_EC, data = blockdata2, random = ~ 1|subject/session/block, na.action = na.omit)
plot(lme2h)
plot(effect("IRI_EC", lme2h))
summary(lme2h)
sink(file = "FACES/EMG/corr_regression_output_IRI_EC.txt") 
summary(lme2h) 
intervals(lme2h, which = "fixed")
sink() 





lme1k <- lme(zyg_resid ~ stimulus*PSS14, data = blockdata2, random = ~ 1|subject/session/block, na.action = na.omit)
plot(lme1k)
plot(effect("PSS14", lme1k))
summary(lme1k)
sink(file = "FACES/EMG/zyg_regression_output_PSS14.txt") 
summary(lme1k) 
intervals(lme1k, which = "fixed")
sink() 

lme2k <- lme(corr_resid ~ stimulus*PSS14, data = blockdata2, random = ~ 1|subject/session/block, na.action = na.omit)
plot(lme2k)
plot(effect("PSS14", lme2k))
summary(lme2k)
sink(file = "FACES/EMG/corr_regression_output_PSS14.txt") 
summary(lme2k) 
intervals(lme2k, which = "fixed")
sink()

lme1l <- lme(zyg_resid ~ stimulus*PPIR_C, data = blockdata2, random = ~ 1|subject/session/block, na.action = na.omit)
plot(lme1l)
plot(effect("PPIR_C", lme1l))
summary(lme1l)
sink(file = "FACES/EMG/zyg_regression_output_PPIR_C.txt") 
summary(lme1l) 
intervals(lme1l, which = "fixed")
sink() 

lme2l <- lme(corr_resid ~ stimulus*PPIR_C, data = blockdata2, random = ~ 1|subject/session/block, na.action = na.omit)
plot(lme2l)
plot(effect("PPIR_C", lme2l))
summary(lme2l)
sink(file = "FACES/EMG/corr_regression_output_PPIR_C.txt") 
summary(lme2l) 
intervals(lme2l, which = "fixed")
sink()

lme1m <- lme(zyg_resid ~ stimulus*ESS, data = blockdata2, random = ~ 1|subject/session/block, na.action = na.omit)
plot(lme1m)
plot(effect("ESS", lme1m))
summary(lme1m)
sink(file = "FACES/EMG/zyg_regression_output_ESS.txt") 
summary(lme1m) 
intervals(lme1m, which = "fixed")
sink() 

lme2m <- lme(corr_resid ~ stimulus*ESS, data = blockdata2, random = ~ 1|subject/session/block, na.action = na.omit)
plot(lme2m)
plot(effect("ESS", lme2m))
summary(lme2m)
sink(file = "FACES/EMG/corr_regression_output_ESS.txt") 
summary(lme2m) 
intervals(lme2m, which = "fixed")
sink()


lme1n <- lme(zyg_resid ~ stimulus*ECS, data = blockdata2, random = ~ 1|subject/session/block, na.action = na.omit)
plot(lme1n)
plot(effect("ECS", lme1n))
summary(lme1n)
sink(file = "FACES/EMG/zyg_regression_output_ECS.txt") 
summary(lme1n) 
intervals(lme1n, which = "fixed")
sink() 

lme2n <- lme(corr_resid ~ stimulus*ECS, data = blockdata2, random = ~ 1|subject/session/block, na.action = na.omit)
plot(lme2n)
plot(effect("ECS", lme2n))
summary(lme2n)
sink(file = "FACES/EMG/corr_regression_output_ECS.txt") 
summary(lme2n) 
intervals(lme2n, which = "fixed")
sink()

lme1o <- lme(zyg_resid ~ stimulus*PANAS_Positive, data = blockdata2, random = ~ 1|subject/session/block, na.action = na.omit)
plot(lme1o)
plot(effect("PANAS_Positive", lme1o))
summary(lme1o)
sink(file = "FACES/EMG/zyg_regression_output_PANAS_Positive.txt") 
summary(lme1o) 
intervals(lme1o, which = "fixed")
sink() 

lme2o <- lme(corr_resid ~ stimulus*PANAS_Positive, data = blockdata2, random = ~ 1|subject/session/block, na.action = na.omit)
plot(lme2o)
plot(effect("PANAS_Positive", lme2o))
summary(lme2o)
sink(file = "FACES/EMG/corr_regression_output_PANAS_Positive.txt") 
summary(lme2o) 
intervals(lme2o, which = "fixed")
sink()



lme1p <- lme(zyg_resid ~ stimulus*PANAS_Negative, data = blockdata2, random = ~ 1|subject/session/block, na.action = na.omit)
plot(lme1p)
plot(effect("PANAS_Negative", lme1p))
summary(lme1p)
sink(file = "FACES/EMG/zyg_regression_output_PANAS_Negative.txt") 
summary(lme1p) 
intervals(lme1p, which = "fixed")
sink() 

lme2p <- lme(corr_resid ~ stimulus*PANAS_Negative, data = blockdata2, random = ~ 1|subject/session/block, na.action = na.omit)
plot(lme2p)
plot(effect("PANAS_Negative", lme2p))
summary(lme2p)
sink(file = "FACES/EMG/corr_regression_output_PANAS_Negative.txt") 
summary(lme2p) 
intervals(lme2p, which = "fixed")
sink()

#############################
EMG responses will be predicted by 
- participants??? rated happiness and angriness during the experiment
- participants??? ratings on 
- the Interpersonal Reactivity Index Empathic Concern subscale (IRI-EC)
- the Positive and Negative Affect Scale (PANAS)
- the Perceived Stress Scale (PSS), and 
- inversely predicted by the Psychopathic Personality Index-Revised Coldheartedness subscale (PPI-R-C).