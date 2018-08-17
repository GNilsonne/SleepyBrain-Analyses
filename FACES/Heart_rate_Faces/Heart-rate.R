

NormalisedSuperList <- SuperList
AllMeanEvents <- data.frame(matrix(ncol=0, nrow=1201))
for(i in 1:length(NormalisedSuperList)){
  for(j in 1:length(NormalisedSuperList[[i]][1, ])){
    Baseline <- mean(NormalisedSuperList[[i]][300:500,j], na.rm=T)
    NormalisedSuperList[[i]][ ,j] <- NormalisedSuperList[[i]][ ,j]/Baseline
  }
  MeanEvent <- apply(NormalisedSuperList[[i]], 1, mean, na.rm=T)
  AllMeanEvents <- cbind(AllMeanEvents, MeanEvent)
}


plot(AllMeanEvents[ ,1], type = "l", ylim = c(min(AllMeanEvents, na.rm=T), max(AllMeanEvents, na.rm=T)))
for(i in 2:length(AllMeanEvents)){
  lines(AllMeanEvents[ ,i])
}

#Find conditions
ResponsesPain <- data.frame(matrix(ncol=0, nrow=1201))
ResponsesNoPain <- data.frame(matrix(ncol=0, nrow=1201))
for(i in 1:length(OnsetTimesForAll)){
  for(j in 1:length(OnsetTimesForAll[[i]]$Condition)){
    ThisResponse <- SuperList[[i]][, j]
    if(OnsetTimesForAll[[i]]$Condition[j] == "Pain"){
      ResponsesPain <- cbind(ResponsesPain, ThisResponse)
    }else{
      ResponsesNoPain <- cbind(ResponsesNoPain, ThisResponse)      
    }
  }
}

#Find sleep condition
SleepList <- PgDataHands[ ,5:6]
SleepList$Subject <- PgDataHands$Subject
SleepList <- SleepList[!duplicated(SleepList), ]


for(i in 1:length(OnsetTimesForAll)){
  OnsetTimesForAll[[i]]$DeprivationCondition
  OnsetTimesForAll[[i]]$DeprivationCondition <- SleepList$DeprivationCondition[i]
}

#Deprivation conditions

ResponsesSleepDeprived <- data.frame(matrix(ncol=0, nrow=1201))
ResponsesNotSleepDeprived <- data.frame(matrix(ncol=0, nrow=1201))
for(i in 1:length(OnsetTimesForAll)){
  if(i == c(59:61)){
  }else{
  for(j in 1:length(OnsetTimesForAll[[i]]$Condition)){
    ThisResponse <- SuperList[[i]][, j]
    if(OnsetTimesForAll[[i]]$DeprivationCondition[j] == "Sleep Deprived"){
      ResponsesSleepDeprived <- cbind(ResponsesSleepDeprived, ThisResponse)
    }else{
      ResponsesNotSleepDeprived <- cbind(ResponsesNotSleepDeprived, ThisResponse)      
    }
  }
  }
}

#Conditions and deprivation

ResponsesPainSleepDeprived <- data.frame(matrix(ncol=0, nrow=1201))
ResponsesNoPainSleepDeprived <- data.frame(matrix(ncol=0, nrow=1201))
ResponsesPainNotSleepDeprived <- data.frame(matrix(ncol=0, nrow=1201))
ResponsesNoPainNotSleepDeprived <- data.frame(matrix(ncol=0, nrow=1201))
for(i in 1:length(OnsetTimesForAll)){
  if(i == c(59:61)){
  }else{
  for(j in 1:length(OnsetTimesForAll[[i]]$DeprivationCondition)){
    ThisResponse <- NormalisedSuperList[[i]][, j]
    if(OnsetTimesForAll[[i]]$Condition[j] == "Pain" && OnsetTimesForAll[[i]]$DeprivationCondition[j] == "Sleep Deprived"){
      ResponsesPainSleepDeprived <- cbind(ResponsesPainSleepDeprived, ThisResponse)
    }
    if(OnsetTimesForAll[[i]]$Condition[j] == "Pain" && OnsetTimesForAll[[i]]$DeprivationCondition[j] == "Not Sleep Deprived"){
      ResponsesPainNotSleepDeprived <- cbind(ResponsesPainNotSleepDeprived, ThisResponse)
    }
    if(OnsetTimesForAll[[i]]$Condition[j] == "No_Pain" && OnsetTimesForAll[[i]]$DeprivationCondition[j] == "Sleep Deprived"){
        ResponsesNoPainSleepDeprived <- cbind(ResponsesNoPainSleepDeprived, ThisResponse)
    }
    if(OnsetTimesForAll[[i]]$Condition[j] == "No_Pain" && OnsetTimesForAll[[i]]$DeprivationCondition[j] == "Not Sleep Deprived"){
      ResponsesNoPainNotSleepDeprived <- cbind(ResponsesNoPainNotSleepDeprived, ThisResponse)
    }
  }
  }
}



plot(ResponsesNoPainNotSleepDeprived[ ,1], type = "l", ylim = c(min(ResponsesNoPainNotSleepDeprived, na.rm=T), max(ResponsesPainNotSleepDeprived, na.rm=T)))
for(i in 2:length(ResponsesNoPainNotSleepDeprived)){
  lines(ResponsesNoPainNotSleepDeprived[, i])
}

plot(ResponsesNoPainSleepDeprived[ ,1], type = "l", ylim = c(min(ResponsesNoPainSleepDeprived, na.rm=T), max(ResponsesPainNotSleepDeprived, na.rm=T)))
for(i in 2:length(ResponsesNoPainSleepDeprived)){
  lines(ResponsesNoPainSleepDeprived[, i])
}

plot(ResponsesPainNotSleepDeprived[ ,1], type = "l", ylim = c(min(ResponsesPainNotSleepDeprived, na.rm=T), max(ResponsesPainNotSleepDeprived, na.rm=T)))
for(i in 2:length(ResponsesPainNotSleepDeprived)){
  lines(ResponsesPainNotSleepDeprived[, i])
}

plot(ResponsesPainSleepDeprived[ ,1], type = "l", ylim = c(min(ResponsesPainSleepDeprived, na.rm=T), max(ResponsesPainNotSleepDeprived, na.rm=T)))
for(i in 2:length(ResponsesPainSleepDeprived)){
  lines(ResponsesPainSleepDeprived[, i])
}

plot(ResponsesPain[ ,1], type = "l", ylim = c(min(ResponsesPain, na.rm=T), max(ResponsesPain, na.rm=T)))
for(i in 2:length(ResponsesPain)){
  lines(ResponsesPain[, i])
}

plot(ResponsesNoPain[ ,1], type = "l", ylim = c(min(ResponsesNoPain, na.rm=T), max(ResponsesNoPain, na.rm=T)))
for(i in 2:length(ResponsesNoPain)){
  lines(ResponsesNoPain[, i])
}

#Normalised pulses
MeanResponsesPainSleepDeprived <- apply(ResponsesPainSleepDeprived, 1, mean, na.rm=T)
MeanResponsesPainNotSleepDeprived <- apply(ResponsesPainNotSleepDeprived, 1, mean, na.rm=T)
MeanResponsesNoPainSleepDeprived <- apply(ResponsesNoPainSleepDeprived, 1, mean, na.rm=T)
MeanResponsesNoPainNotSleepDeprived <- apply(ResponsesNoPainNotSleepDeprived, 1, mean, na.rm=T)

plot(MeanResponsesPainSleepDeprived, type="l", col="red", xlim=c(400, 1200), ylim=c(0.95, 1.03), ann=F)
lines(MeanResponsesPainNotSleepDeprived, col="blue")
lines(MeanResponsesNoPainSleepDeprived, col="green")
lines(MeanResponsesNoPainNotSleepDeprived, col="purple")
lines(c(500, 500), c(0.5,1.3))
legend("bottomleft", c("SleepDeprived_Pain", "SleepDeprived_NoPain", "NotSleepDeprived_Pain", "NotSleepDeprived_NoPain"), col=c("red", "green", "blue", "purple"), pch="-", bty="n", cex=0.8)
title(main="All normalised responses (mean)", xlab="Time (ms)", ylab="Heart rate (normalised)")


#Non normalised pulses

RawResponsesPainSleepDeprived <- data.frame(matrix(ncol=0, nrow=1201))
RawResponsesNoPainSleepDeprived <- data.frame(matrix(ncol=0, nrow=1201))
RawResponsesPainNotSleepDeprived <- data.frame(matrix(ncol=0, nrow=1201))
RawResponsesNoPainNotSleepDeprived <- data.frame(matrix(ncol=0, nrow=1201))
for(i in 1:length(OnsetTimesForAll)){
  for(j in 1:length(OnsetTimesForAll[[i]]$DeprivationCondition)){
    ThisResponse <- SuperList[[i]][, j]
    if(OnsetTimesForAll[[i]]$Condition[j] == "Pain" && OnsetTimesForAll[[i]]$DeprivationCondition[j] == "Sleep Deprived"){
      RawResponsesPainSleepDeprived <- cbind(RawResponsesPainSleepDeprived, ThisResponse)
    }
    if(OnsetTimesForAll[[i]]$Condition[j] == "Pain" && OnsetTimesForAll[[i]]$DeprivationCondition[j] == "Not Sleep Deprived"){
      RawResponsesPainNotSleepDeprived <- cbind(RawResponsesPainNotSleepDeprived, ThisResponse)
    }
    if(OnsetTimesForAll[[i]]$Condition[j] == "No_Pain" && OnsetTimesForAll[[i]]$DeprivationCondition[j] == "Sleep Deprived"){
      RawResponsesNoPainSleepDeprived <- cbind(RawResponsesNoPainSleepDeprived, ThisResponse)
    }
    if(OnsetTimesForAll[[i]]$Condition[j] == "No_Pain" && OnsetTimesForAll[[i]]$DeprivationCondition[j] == "Not Sleep Deprived"){
      RawResponsesNoPainNotSleepDeprived <- cbind(RawResponsesNoPainNotSleepDeprived, ThisResponse)
    }
  }
}


#plot Raw data

MeanRawResponsesPainSleepDeprived <- apply(RawResponsesPainSleepDeprived, 1, mean, na.rm=T)
MeanRawResponsesPainNotSleepDeprived <- apply(RawResponsesPainNotSleepDeprived, 1, mean, na.rm=T)
MeanRawResponsesNoPainSleepDeprived <- apply(RawResponsesNoPainSleepDeprived, 1, mean, na.rm=T)
MeanRawResponsesNoPainNotSleepDeprived <- apply(RawResponsesNoPainNotSleepDeprived, 1, mean, na.rm=T)

plot(MeanRawResponsesPainSleepDeprived, type="l", col="red", xlim=c(400, 1200), ylim=c(64.5, 71), ann=F)
lines(MeanRawResponsesPainNotSleepDeprived, col="blue")
lines(MeanRawResponsesNoPainSleepDeprived, col="green")
lines(MeanRawResponsesNoPainNotSleepDeprived, col="purple")
lines(c(500, 500), c(60, 72))
legend("bottomleft", c("SleepDeprived_Pain", "SleepDeprived_NoPain", "NotSleepDeprived_Pain", "NotSleepDeprived_NoPain"), 
       col=c("red", "green", "blue", "purple"), pch="-", bty="n", cex=0.8)

title(main="All raw responses (mean)", xlab="Time (ms)", ylab="Heart rate (bpm)")




#Pain vs no pain
MeanResponsesPain <- apply(ResponsesPain, 1, mean, na.rm=T)
MeanResponsesNoPain <- apply(ResponsesNoPain, 1, mean, na.rm=T)

plot(MeanResponsesPain, type="l", ann=F, col="red", xlim=c(400, 1200), ylim=c(min(MeanResponsesNoPain, na.rm=T), max(MeanResponsesPain, na.rm=T)))
lines(MeanResponsesNoPain, col="blue")
title(main="Pain vs. no pain (mean)", ylab="Heart rate (bpm)", xlab="Time (ms)")
lines(c(500, 500),  c(60, 70))
legend("topright", c("Pain", "NoPain"), col=c("red", "blue"), pch="-", bty="n", cex=1.0)

#sleep vs no sleep
MeanResponsesSleepDeprived <- apply(ResponsesSleepDeprived, 1, mean, na.rm=T)
MeanResponsesNotSleepDeprived <- apply(ResponsesNotSleepDeprived, 1, mean, na.rm=T)

plot(MeanResponsesSleepDeprived, type="l", ann=F, col="red", xlim=c(400, 1200), ylim=c(64, 70))
lines(MeanResponsesNotSleepDeprived, col="blue")
title(main="Sleep deprived vs. not sleep deprived (mean)", ylab="Heart rate (bpm)", xlab="Time (ms)")
lines(c(500, 500),  c(60, 76))
legend("bottomleft", c("SleepDeprived", "NotSleepDeprived"), col=c("red", "blue"), pch="-", bty="n", cex=1.0)




HabituationVecPain <- apply(ResponsesPain[800:1000, ], 2, mean, na.rm=T)
HabituationMatrixPain <- matrix(HabituationVecPain, nrow=10)
MeanHabituationPainVec <- apply(HabituationMatrixPain, 1, mean, na.rm=T)
plot(MeanHabituationPainVec, ann=F)
title(main="Habituation (Pain)", ylab="Heart rate (normalised)", xlab="Events (no)")


HabituationVecNoPain <- apply(ResponsesNoPain[800:1000, ], 2, mean, na.rm=T)
HabituationMatrixNoPain <- matrix(HabituationVecNoPain, nrow=10)
MeanHabituationNoPainVec <- apply(HabituationMatrixNoPain, 1, mean, na.rm=T)


plot(MeanHabituationNoPainVec, ann=F)
title(main="Habituation (No pain)", ylab="Heart rate (normalised)", xlab="Events (no)")

#example of dirty data

plot(PgDataHandsTime[, 8], ann=F, type="l")
title(ylab="Pulse", xlab="Time(ms)")

#Spridningsmått

plot(PgDataHands$Pulse)

boxplot(PgDataHands$Pulse)


