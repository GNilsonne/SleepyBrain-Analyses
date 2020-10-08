# Script to check normality/outliers

#SEM_Singer <- read_csv("~/Desktop/SleepyBrain-Analyses/Sleepmeasures_emotion/Data/SEM_Singer.csv")

SEM_Singer_standardized <- read_csv("~/Desktop/SleepyBrain-Analyses/Sleepmeasures_emotion/Data/SEM_Singer_standardized.csv")

#SEM_Singer <- as.data.frame(SEM_Singer)
SEM_Singer_standardized <- as.data.frame(SEM_Singer_standardized)

# 
# 
# 
# par(mfrow=c(4, 5))
# colnames <- dimnames(SEM_Singer)[[2]]
# for (i in c(3:17, 21:24)){
#   d <- density(SEM_Singer[,i], na.rm = T)
#   plot(d, type="n", main=colnames[i])
#   polygon(d, col="red", border="gray")
# }

par(mfrow=c(4, 5))
colnames <- dimnames(SEM_Singer_standardized)[[2]]
for (i in c(4:7, 10:18, 20:22)) {
  d <- density(SEM_Singer_standardized[,i], na.rm = T)
  plot(d, type="n", main=colnames[i])
  polygon(d, col="red", border="gray")
}

