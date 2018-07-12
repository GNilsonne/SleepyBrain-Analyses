# Script to generate new data passing quality control
# First version by Sandra Tamm
# Rewritten entirely by GN 2015-12-19
# Adapted for ARROWS 2018-07-03

# For each participant: Inspect data and decide whether to exclude whole recording if quality is too poor
# This script will remove all data where heart rate is < 40 or > 110 and exclude sessions with more than 50% missing data overall, which turned out to be 2

setwd("~/Box Sync/Sleepy Brain/Datafiles/HR/PgDataARROWSStimulus")

files <- list.files()
length(files)

excluded <- c("137_2.csv", "15_1.csv", "227_1.csv", "227_2.csv", "286_1.csv", "313_2.csv",
              "315_1.csv", "315_2.csv", "356_2.csv", "357_1.csv", "358_2.csv", "376_1.csv", "376_2.csv",
              "410_1.csv", "410_2.csv", "425_2.csv", "451_1.csv", "472_1.csv", "79_2.csv") # Based on inspection of plots from script "CheckDataForArtifacts.R" by ST and GN
# after separate check and consensus discussion 2018-07-02

fun_correctdata <- function(x){
  data <- read.csv2(x)
  data[data < 40] <- NA
  data[data > 110] <- NA
  if(!(x %in% excluded) & (sum(is.na(data)) < (1401*40/2))){
    write.csv(data, file = paste("~/Box Sync/Sleepy Brain/Datafiles/HR/PgDataARROWSStimulusCorrected180703/", x, sep=""), row.names=FALSE)
  }
}

lapply(files, fun_correctdata)