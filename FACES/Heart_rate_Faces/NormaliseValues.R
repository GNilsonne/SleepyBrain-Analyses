setwd("~/Box Sync/Sleepy Brain/Datafiles/HR/PgDataARROWSStimulusCorrected180703")

Files <- list.files()

AllNormalisedMeanMaintainNeutral <- data.frame()
for(i in 1:length(Files)){
  Data <- read.table(Files[i], sep=",", dec=",", header = T)
  Data <- data.frame(apply(Data, 2, as.numeric))
  MaintainNeutral <- Data[ , grepl("^MaintainNeutral", names(Data))]
  BaselineMaintainNeutral <- colMeans(MaintainNeutral[1:400, ], na.rm = T)
  MaintainNeutral <- MaintainNeutral[401:2201, ]
  NormalisedMaintainNeutral <- MaintainNeutral/BaselineMaintainNeutral
  NormalisedMaintainNeutral$Mean <- rowMeans(NormalisedMaintainNeutral)
  if(i == 1){
    plot(NormalisedMaintainNeutral$Mean, type = "l", ylim = c(0.5, 1.5))
    AllNormalisedMeanMaintainNeutral <- NormalisedMaintainNeutral$Mean
  }else{
    lines(NormalisedMaintainNeutral$Mean)
    AllNormalisedMeanMaintainNeutral <- cbind(AllNormalisedMeanMaintainNeutral, NormalisedMaintainNeutral$Mean)
  }
}
AllNormalisedMeanMaintainNeutral$Mean <- rowMeans(AllNormalisedMeanMaintainNeutral, na.rm=T)
lines(AllNormalisedMeanMaintainNeutral$Mean, col= "red")

AllNormalisedMeanMaintainNegative <- data.frame()
for(i in 1:length(Files)){
  Data <- read.table(Files[i], sep=",", dec=",", header = T)
  Data <- data.frame(apply(Data, 2, as.numeric))
  MaintainNegative <- Data[ , grepl("^MaintainNegative", names(Data))]
  BaselineMaintainNegative <- colMeans(MaintainNegative[1:400, ], na.rm = T)
  MaintainNegative <- MaintainNegative[401:2201, ]
  NormalisedMaintainNegative <- MaintainNegative/BaselineMaintainNegative
  NormalisedMaintainNegative$Mean <- rowMeans(NormalisedMaintainNegative)
  if(i == 1){
    plot(NormalisedMaintainNegative$Mean, type = "l", ylim = c(0.5, 1.5))
    AllNormalisedMeanMaintainNegative <- NormalisedMaintainNegative$Mean
  }else{
    lines(NormalisedMaintainNegative$Mean)
    AllNormalisedMeanMaintainNegative <- cbind(AllNormalisedMeanMaintainNegative, NormalisedMaintainNegative$Mean)
  }
}
AllNormalisedMeanMaintainNegative$Mean <- rowMeans(AllNormalisedMeanMaintainNegative, na.rm=T)
lines(AllNormalisedMeanMaintainNegative$Mean, col= "red")

AllNormalisedMeanDownregulateNegative <- data.frame()
for(i in 1:length(Files)){
  Data <- read.table(Files[i], sep=",", dec=",", header = T)
  Data <- data.frame(apply(Data, 2, as.numeric))
  DownregulateNegative <- Data[ , grepl("^DownregulateNegative", names(Data))]
  BaselineDownregulateNegative <- colMeans(DownregulateNegative[1:400, ], na.rm = T)
  DownregulateNegative <- DownregulateNegative[401:2201, ]
  NormalisedDownregulateNegative <- DownregulateNegative/BaselineDownregulateNegative
  NormalisedDownregulateNegative$Mean <- rowMeans(NormalisedDownregulateNegative)
  if(i == 1){
    plot(NormalisedDownregulateNegative$Mean, type = "l", ylim = c(0.5, 1.5))
    AllNormalisedMeanDownregulateNegative <- NormalisedDownregulateNegative$Mean
  }else{
    lines(NormalisedDownregulateNegative$Mean)
    AllNormalisedMeanDownregulateNegative <- cbind(AllNormalisedMeanDownregulateNegative, NormalisedDownregulateNegative$Mean)
  }
}
AllNormalisedMeanDownregulateNegative$Mean <- rowMeans(AllNormalisedMeanDownregulateNegative, na.rm=T)
lines(AllNormalisedMeanDownregulateNegative$Mean, col= "red")

AllNormalisedMeanUpregulateNegative <- data.frame()
for(i in 1:length(Files)){
  Data <- read.table(Files[i], sep=",", dec=",", header = T)
  Data <- data.frame(apply(Data, 2, as.numeric))
  UpregulateNegative <- Data[ , grepl("^UpregulateNegative", names(Data))]
  BaselineUpregulateNegative <- colMeans(UpregulateNegative[1:400, ], na.rm = T)
  UpregulateNegative <- UpregulateNegative[401:2201, ]
  NormalisedUpregulateNegative <- UpregulateNegative/BaselineUpregulateNegative
  NormalisedUpregulateNegative$Mean <- rowMeans(NormalisedUpregulateNegative)
  if(i == 1){
    plot(NormalisedUpregulateNegative$Mean, type = "l", ylim = c(0.5, 1.5))
    AllNormalisedMeanUpregulateNegative <- NormalisedUpregulateNegative$Mean
  }else{
    lines(NormalisedUpregulateNegative$Mean)
    AllNormalisedMeanUpregulateNegative <- cbind(AllNormalisedMeanUpregulateNegative, NormalisedUpregulateNegative$Mean)
  }
}
AllNormalisedMeanUpregulateNegative$Mean <- rowMeans(AllNormalisedMeanUpregulateNegative, na.rm=T)
lines(AllNormalisedMeanUpregulateNegative$Mean, col= "red")


plot(AllNormalisedMeanMaintainNeutral$Mean, col= "red", type = "l")
lines(AllNormalisedMeanMaintainNegative$Mean, col= "blue")
lines(AllNormalisedMeanDownregulateNegative$Mean, col= "green")
lines(AllNormalisedMeanUpregulateNegative$Mean, col= "violet")
