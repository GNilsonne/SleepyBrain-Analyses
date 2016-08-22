# EMG

# Require packages
require(nlme)
require(effects)

# Read data
# Define files
files <- list.files("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/Acqknowledge_logfiles_exported/")
files <- files[-grep(files, pattern = "excluded")] # Remove files from participants excluded from the experiment altogether
files <- files[-length(files)] # Remove last, provisional due to zipped archive present in folder

files <- files[-c(16, 44, 45, 115, 162)] # Remove files where both channels failed quality inspection in Acqknowledge (9009_2, 9028_2, 9029_1, 9071_1, 9096_1)
files <- files[files != "9087_1.txt"] # Remove file where reference waves were wrong, possibly because wrong Acqknowledge template was used for recording?
files <- files[files != "9002_2.txt"] # Remove file where reference was incomplete
files <- files[files != "9041_1.txt"] # Remove file where reference was incomplete
files <- files[files != "9046_2.txt"] # Remove file where reference wave was on throughout for an unknown reason
files <- files[files != "9025_2.txt"] # Remove file where reference wave was on throughout for an unknown reason

# Loop over data files, read them, write check plots for reference waves, regress the signals on one another
for(i in 1:length(files)){
  data <- read.delim(paste("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/Acqknowledge_logfiles_exported/", files[i], sep = ""), skip = 19, header = F)
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
demdata <- read.csv2("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/demdata_160225_pseudonymized.csv")
blockdata <- merge(blockdata, demdata[, c("id", "AgeGroup", "Sl_cond")], by.x = "subject", by.y = "id")
subjects <- read.csv2("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/Subjects_151215.csv")
blockdata <- merge(blockdata, subjects[, c("SuccessfulIntervention", "newid")], by.x = "subject", by.y = "newid")

blockdata$condition <- "fullsleep"
blockdata$condition[blockdata$session == 1 & blockdata$Sl_cond == 1] <- "sleepdeprived"
blockdata$condition[blockdata$session == 2 & blockdata$Sl_cond == 2] <- "sleepdeprived"
blockdata$condition <- as.factor(blockdata$condition)
blockdata$condition <- relevel(blockdata$condition, ref = "fullsleep")
blockdata$AgeGroup <- relevel(blockdata$AgeGroup, ref = "Young")

# Build and inspect regression models
lme1 <- lme(zyg_resid ~ stimulus*condition*AgeGroup, data = blockdata, random = ~ 1|subject/session/block, na.action = na.omit)
plot(lme1)
plot(effect("stimulus", lme1))
plot(effect("stimulus*condition*AgeGroup", lme1))
summary(lme1)

lme1b <- lme(zyg_resid ~ stimulus*condition*AgeGroup, data = blockdata[blockdata$stimulus != "neutral" & !is.na(blockdata$SuccessfulIntervention), ], random = ~ 1|subject/session/block, na.action = na.omit)
plot(lme1b)
plot(effect("stimulus", lme1b))
plot(effect("stimulus*condition", lme1b))
plot(effect("stimulus*condition*AgeGroup", lme1b))
summary(lme1b)

lme1c <- lme(zyg_resid ~ stimulus, data = blockdata, random = ~ 1|subject/session/block, na.action = na.omit)
plot(lme1c)
plot(effect("stimulus", lme1c))
summary(lme1c)

lme2 <- lme(corr_resid ~ stimulus*condition*AgeGroup, data = blockdata, random = ~ 1|subject/session/block, na.action = na.omit)
plot(lme2)
plot(effect("stimulus", lme2))
plot(effect("stimulus*condition*AgeGroup", lme2))
summary(lme2)

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
