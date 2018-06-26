setwd("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/HR/PgDataHandsStimulusCorrected")

Files <- list.files()

AllMeanPain <- data.frame()
for(i in 1:length(Files)){
  Data <- read.csv(Files[i], sep=";", dec=",")
  Pain <- Data[ , grepl("^Pain", names(Data))]
  Pain$Mean <- rowMeans(Pain, na.rm = T)
  if(i == 1){
    plot(Pain$Mean, type = "l", ylim = c(40, 100))
    AllMeanPain <- Pain$Mean
  }else{
    lines(Pain$Mean)
    AllMeanPain <- cbind(AllMeanPain, Pain$Mean)
  }
}
AllMeanPain$Mean <- rowMeans(AllMeanPain)
lines(AllMeanPain$Mean, col= "red")

AllMeanNoPain <- data.frame()
for(i in 1:length(Files)){
  Data <- read.csv(Files[i], sep=";", dec=",")
  NoPain <- Data[ , grepl("^No_Pain", names(Data))]
  NoPain$Mean <- rowMeans(NoPain, na.rm = T)
  if(i == 1){
    plot(NoPain$Mean, type = "l", ylim = c(40, 100))
    AllMeanNoPain <- NoPain$Mean
  }else{
    lines(NoPain$Mean)
    AllMeanNoPain <- cbind(AllMeanNoPain, NoPain$Mean)
  }
}
AllMeanNoPain$Mean <- rowMeans(AllMeanNoPain)
lines(AllMeanNoPain$Mean, col= "red")

plot(AllMeanPain$Mean, type = "l", col = "red")
lines(AllMeanNoPain$Mean, type = "l", col = "blue")

setwd("~/Dropbox/Sleepy Brain (1)/Datafiles/HR")
write.csv2(AllMeanPain, file = "AllMeanPain.csv", row.names=FALSE)
write.csv2(AllMeanNoPain, file = "AllMeanNoPain.csv", row.names=FALSE)


