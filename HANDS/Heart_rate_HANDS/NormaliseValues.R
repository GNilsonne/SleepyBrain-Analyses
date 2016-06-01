setwd("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/HR/PgDataHandsStimulusCorrected")

Files <- list.files()

AllNormalisedMeanPain <- data.frame()
for(i in 1:length(Files)){
  Data <- read.csv(Files[i], sep=";", dec=",")
  Pain <- Data[ , grepl("^Pain", names(Data))]
  BaselinePain <- colMeans(Pain[1:500, ], na.rm = T)
  Pain <- Pain[501:1201, ]
  NoPain <- Data[ , grepl("^No_Pain", names(Data))]
  NoPain <- NoPain[501:1201, ]
  BaselineNoPain <- colMeans(NoPain[1:500, ], na.rm = T)
  NormalisedPain <- Pain/BaselinePain
  NormalisedNoPain <- NoPain/BaselineNoPain
  NormalisedPain$Mean <- rowMeans(NormalisedPain)
  NormalisedNoPain$Mean <- rowMeans(NormalisedNoPain)
  if(i == 1){
    plot(NormalisedPain$Mean, type = "l", ylim = c(0.5, 1.5))
    AllNormalisedMeanPain <- NormalisedPain$Mean
  }else{
    lines(NormalisedPain$Mean)
    AllNormalisedMeanPain <- cbind(AllNormalisedMeanPain, NormalisedPain$Mean)
  }
}
AllNormalisedMeanPain$Mean <- rowMeans(AllNormalisedMeanPain, na.rm=T)
lines(AllNormalisedMeanPain$Mean, col= "red")


# No pain
AllNormalisedMeanNoPain <- data.frame()
for(i in 1:length(Files)){
  Data <- read.csv(Files[i], sep=";", dec=",")
  NoPain <- Data[ , grepl("^No_Pain", names(Data))]
  NoPain$Mean <- rowMeans(NoPain, na.rm = T)
  NoPain <- NoPain[501:1201, ]
  BaselineNoPain <- colMeans(NoPain[1:500, ], na.rm = T)
  NormalisedNoPain <- NoPain/BaselineNoPain
  NormalisedNoPain$Mean <- rowMeans(NormalisedNoPain)
  if(i == 1){
    plot(NormalisedNoPain$Mean, type = "l", ylim = c(0.5, 1.5))
    AllNormalisedMeanNoPain <- NormalisedNoPain$Mean
  }else{
    lines(NormalisedNoPain$Mean)
    AllNormalisedMeanNoPain <- cbind(AllNormalisedMeanNoPain, NormalisedNoPain$Mean)
  }
}
AllNormalisedMeanNoPain$Mean <- rowMeans(AllNormalisedMeanNoPain, na.rm=T)
lines(AllNormalisedMeanNoPain$Mean, col= "red")



plot(AllNormalisedMeanPain$Mean, col= "red", type = "l")
lines(AllNormalisedMeanNoPain$Mean, col= "blue")
