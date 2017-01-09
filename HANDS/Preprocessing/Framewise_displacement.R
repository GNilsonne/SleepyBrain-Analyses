# Script to analyse and plot data of movement in the HANDS experiment. 
# Sandra Tamm, 2016-10-03

require(nlme)

Data_rp <- read.csv("Data/Data_movement_HANDS.csv", sep=";", dec = ",")

Data_FD <- data.frame()
for(i in 1:length(unique(Data_rp$Subject))){
  temp <- subset(Data_rp, Subject == unique(Data_rp$Subject)[[i]])
  Data_subject <- data.frame()
  for(j in 1:length(unique(temp$Session))){
    rp <- subset(temp, Session == unique(temp$Session)[[j]])
    FD <- data.frame()
    for(k in 2:length(rp$V1)){
      FD[k,1] = 
        abs(rp[k-1,6])-abs(rp[k,6])+
        abs(rp[k-1,7])-abs(rp[k,7])+
        abs(rp[k-1,8])-abs(rp[k,8])+
        50*(abs(rp[k-1,9])-abs(rp[k,9]))+
        50*(abs(rp[k-1,10])-abs(rp[k,10]))+
        50*(abs(rp[k-1,11])-abs(rp[k,11]))
    }
    rp$FD <- FD$V1
    rp$meanFD <- mean(FD$V1, na.rm = T)
    Data_subject <- rbind(Data_subject, rp)
  }
  Data_FD <- rbind(Data_FD, Data_subject)
}

Data_unique <- Data_FD[is.na(Data_FD$FD), ]
Data_unique$AgeSleep <- as.factor(paste(Data_unique$AgeGroup, ":",  Data_unique$DeprivationCondition, sep = ""))

boxplot(meanFD ~ AgeSleep, data = Data_unique, lwd = 2, ylab = 'Mean framewise displacement', 
        names = c("Old\nNormal sleep", "Old\nSleep restriction", 
                  "Young\nNormal sleep", "Young\nSleep restriction"), cex.axis = 0.5)
stripchart(meanFD ~ AgeSleep, vertical = TRUE, data = Data_unique, 
           method = "jitter", add = TRUE, pch = 20, col = 'blue')

Lme <- lme(meanFD ~ DeprivationCondition*AgeGroup, 
               data = Data_unique, random = ~ 1|Subject, na.action = na.omit)

anova(Lme)
summary(Lme)
intervals(Lme)
