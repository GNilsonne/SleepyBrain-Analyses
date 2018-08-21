# Script to generate new data passing quality control
# First version by Sandra Tamm
# Rewritten entirely by GN 2015-12-19
# Adapted for ARROWS 2018-07-03

# For each participant: Inspect data and decide whether to exclude whole recording if quality is too poor
# This script will remove all data where heart rate is < 40 or > 110 and exclude sessions with more than 50% missing data overall, which turned out to be 2

setwd("~/Box Sync/Sleepy Brain/Datafiles/HR/PgDataARROWSStimulus")

files <- list.files()
length(files)

excluded <- c("") # Based on inspection of plots from script "CheckDataForArtifacts.R" by ST and GN
# after separate check and consensus discussion 2018-07-02. 
# For the purpose of anonymity this list is removed from the open repository

fun_correctdata <- function(x){
  data <- read.csv2(x)
  data[data < 40] <- NA
  data[data > 110] <- NA
  if(!(x %in% excluded) & (sum(is.na(data)) < (1401*40/2))){
    write.csv(data, file = paste("~/Box Sync/Sleepy Brain/Datafiles/HR/PgDataARROWSStimulusCorrected180703/", x, sep=""), row.names=FALSE)
  }
}

lapply(files, fun_correctdata)