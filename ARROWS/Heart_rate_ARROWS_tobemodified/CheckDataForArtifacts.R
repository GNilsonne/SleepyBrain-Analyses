setwd("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/HR/PgDataHandsStimulus")

ReadSubjectAndSessionData <- function(Subject, Session) {
  filename = paste(Subject, "_", Session, ".csv", sep = "")
  SubjectSession <- read.csv(filename, sep=";", dec=",")
  return(SubjectSession)
}

PlotDataForSubjectAndSession <- function(Subject, Session, Data){
  plot(Data[ ,1], type = "l", ylim = c(0, 200), ylab = "Pulse", xlab = "Time (ms)", main = paste("Subject:", Subject, "Session", Session), frame.plot = F)
  polygon(x = c(400, 400, 750, 750), y = c(200, 0, 0, 200), density = NULL, border = NULL, col = "gray", lty = 0)
  abline(v = c(950), lty = 2)
  abline(h = 40, col = "red")
  abline(h = 100, col = "red")
  for(i in 2:length(Data)){
    lines(Data[ ,i])
  }
}

Files <- list.files(pattern = ".csv")

oldPar <- par(mfrow=c(2, 2))
for (i in 1:length(Files)){
  Split <- strsplit(Files[i], "_")[[1]]
  Subject <- as.integer(Split[1])
  Session <- as.integer(substr(Split[2], 1, 1))
  Data = ReadSubjectAndSessionData(Subject, Session)
  PlotDataForSubjectAndSession(Subject, Session, Data)
}
par(oldPar)
