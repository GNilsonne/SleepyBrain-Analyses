# Script to generate new data passing quality control
# First version by Sandra Tamm
# Rewritten entirely by GN 2015-12-19

# For each participant: Inspect data and decide whether to exclude whole recording if quality is too poor
# This script will remove all data where heart rate is < 40 or > 100 and exclude sessions with more than 50% missing data overall, which turned out to be 2

setwd("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/HR/PgDataHandsStimulus")

files <- list.files()
length(files)

excluded <- c("129_1.csv", "129_2.csv", "177_2.csv", "190_1.csv", "210_2.csv", "227_1.csv", "249_1.csv", "253_1.csv", 
              "286_1.csv", "299_1.csv", "315_1.csv", "315_2.csv", "352_1.csv", "356_2.csv", "357_1.csv", "376_1.csv", 
              "376_2.csv", "389_2.csv", "410_1.csv", "431_2.csv", "433_1.csv", "441_1.csv") # Based on inspection of plots from script "CheckDataForArtifacts.R" by GN 2015-12-19

fun_correctdata <- function(x){
  data <- read.csv2(x)
  data[data < 40] <- NA
  data[data > 100] <- NA
  if(!(x %in% excluded) & (sum(is.na(data)) < (1401*40/2))){
    write.csv(data, file = paste("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/HR/PgDataHandsStimulusCorrected151219/", x, sep=""), row.names=FALSE)
  }
}

lapply(files, fun_correctdata)