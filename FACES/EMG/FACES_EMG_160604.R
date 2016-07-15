# EMG

# Require packages
require(nlme)
require(effects)

files <- list.files("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/Acqknowledge_logfiles_exported/")

# TODO: FIx 104_2, which has one too many neutral onset indices

# Read data
for(i in 30:length(files)){
  data <- read.delim(paste("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/Acqknowledge_logfiles_exported/", files[i], sep = ""), skip = 19, header = F)
  data <- data[, c(1, 4:8)]
  plot(data$V6, type = "l", frame.plot = F, col = "gray", xlab = "Time (min)", ylab = "", xaxt = "n", main = paste(files[i]))
  axis(1, at = c(0, 12000, 24000, 36000, 48000), labels = c(0, 2, 4, 6, 8))
  lines(data$V7, col = "orange")
  lines(data$V8, col = "green")
  lm_zyg <- lm(V4 ~ V5, data = data)
  data$zyg_resid <- lm_zyg$residuals
  lm_corr <- lm(V5 ~ V4, data = data)
  data$corr_resid <- lm_corr$residuals
  
  # Define where blocks begin
  # The following code handles the problem that artifacts sometimes caused spikes in the reference channels for event onsets
  neutraldataindices <- which(data$V6 > 0)
  neutral_compareindices <- c(0, neutraldataindices)
  neutral_compare <- c(neutraldataindices, 0) - neutral_compareindices
  neutral_retain <- which(neutral_compare > 1000)
  neutraldataindices <- neutraldataindices[neutral_retain]
  if(i == 55){
    neutraldataindices <- neutraldataindices[-2]
  }
  if(i == 56){
    neutraldataindices <- neutraldataindices[-c(1, 3, 4)]
  }
  if(i == 62){
    neutraldataindices <- neutraldataindices[-c(1, 2, 6, 7)]
  }
  points(neutraldataindices, rep(1, length(neutraldataindices)), pch = "|")
  
  happydataindices <- which(data$V7 > 0)
  happy_compareindices <- c(0, happydataindices)
  happy_compare <- c(happydataindices, 0) - happy_compareindices
  happy_retain <- which(happy_compare > 1000)
  happydataindices <- happydataindices[happy_retain]
  if(i == 56){
    happydataindices <- happydataindices[-c(1, 3)]
  }
  if(i == 62){
    happydataindices <- happydataindices[-c(1, 4)]
  }
  points(happydataindices, rep(1, length(happydataindices)), pch = "o")
  
  angrydataindices <- which(data$V8 > 0)
  angry_compareindices <- c(0, angrydataindices)
  angry_compare <- c(angrydataindices, 0) - angry_compareindices
  angry_retain <- which(angry_compare > 1000)
  angrydataindices <- angrydataindices[angry_retain]
  if(i == 32){
    angrydataindices <- angrydataindices[-3]
  }
  if(i == 55){
    angrydataindices <- angrydataindices[-1]
  }
  if(i == 56){
    angrydataindices <- angrydataindices[-c(3, 4)]
  }
  if(i == 62){
    angrydataindices <- angrydataindices[-c(1, 2, 5)]
  }
  points(angrydataindices, rep(1, length(angrydataindices)), pch = "x")
  
  if(length(neutraldataindices) != 4 | length(happydataindices) != 4 | length(angrydataindices) != 4){
    return(paste(files[i], "Too many onsets found"))
    break
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
  hist(dataout$zyg_resid, main = paste(files[i]))
  qqnorm(dataout$zyg_resid)
  qqline(dataout$zyg_resid)
  hist(dataout$corr_resid, main = paste(files[i]))
  qqnorm(dataout$corr_resid)
  qqline(dataout$corr_resid)
  
  if (!exists("extracteddata")){
    extracteddata <- dataout
  } else{
    extracteddata <- rbind(extracteddata, dataout)
  }
}

blockdata <- aggregate(cbind(zyg_resid, corr_resid) ~ file + block + stimulus, data = extracteddata, FUN = mean)




blockdata$stimulus <- as.factor(blockdata$stimulus)
blockdata$stimulus <- relevel(blockdata$stimulus, ref = "neutral")
#blockdata$log_zyg_resid <- log(blockdata$zyg_resid) # TODO: Figure out why log transformation does not work well
#blockdata$log_corr_resid <- log(blockdata$corr_resid)

hist(blockdata$zyg_resid)
plot(density(blockdata$zyg_resid))
qqnorm(blockdata$zyg_resid)
qqline(blockdata$zyg_resid)

#hist(blockdata$log_zyg_resid)
#plot(density(blockdata$log_zyg_resid))
#qqnorm(blockdata$log_zyg_resid)
#qqline(blockdata$log_zyg_resid)

hist(blockdata$corr_resid)
plot(density(blockdata$corr_resid))
qqnorm(blockdata$corr_resid)
qqline(blockdata$corr_resid)

lme1 <- lme(zyg_resid ~ stimulus, data = blockdata, random = ~ 1|file)
plot(effect("stimulus", lme1))
summary(lme1)

lme1b <- lme(zyg_resid ~ stimulus, data = blockdata[blockdata$stimulus != "neutral", ], random = ~ 1|file)
plot(effect("stimulus", lme1b))
summary(lme1b)

lme2 <- lme(corr_resid ~ stimulus, data = blockdata, random = ~ 1|file)
plot(effect("stimulus", lme2))
summary(lme2)

lme2b <- lme(corr_resid ~ stimulus, data = blockdata[blockdata$stimulus != "neutral", ], random = ~ 1|file)
plot(effect("stimulus", lme2b))
summary(lme2b)
