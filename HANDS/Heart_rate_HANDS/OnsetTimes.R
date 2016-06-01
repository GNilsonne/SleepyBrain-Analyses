# Script to process pulse gating data from HANDS experiment
# By Sandra Tamm
# Modified by Gustav Nilsonne 2015-12-19

setwd("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles")

# List included subjects 
IncludedSubjects <- read.table("HR/IncludedSubjectsPgHands_86subjects.csv", header=T, quote="\"")$x

# Get onset times for stimuli 
OnsetTimesForAll <- list()
AllOnsetFiles <- list.files("Presentation_logfiles/", pattern = "HANDS_sce.log", recursive = T)
AllStimulusFiles <- list.files("Presentation_logfiles/", pattern = "HANDS_log.txt", recursive = T)

# Remove times for non-included subjects
getSubjectFromFileName <- function (filename) {
  return(as.integer(substr(filename, 1, 3)))
}

AllOnsetFiles = AllOnsetFiles[unlist(lapply(AllOnsetFiles, getSubjectFromFileName)) %in% IncludedSubjects]
AllStimulusFiles = AllStimulusFiles[unlist(lapply(AllStimulusFiles, getSubjectFromFileName)) %in% IncludedSubjects]

# Find onset times
for(i in 1:length(AllOnsetFiles)){
  OnsetTime <- read.table(paste("Presentation_logfiles/",AllOnsetFiles[i], sep = ""), header=F, quote="\"", fill=TRUE, blank.lines.skip=FALSE)
  OnsetTime <- subset(OnsetTime, V1 == "Picture")
  OnsetTime <- OnsetTime[ , c(2,4)]
  OnsetTime$File <- AllOnsetFiles[i]
  OnsetTime$Subject <- as.integer(substr(OnsetTime$File, 1, 3)) 
  OnsetTime$Date <- as.integer(substr(OnsetTime$File, 5, 10))
  OnsetTime <- subset(OnsetTime, V2 == "Pic2")
  OnsetTime$V4 <- as.numeric(as.character(OnsetTime$V4))/10000
  if(i == 90){ # Ugly hack (credit to GN) to handle sessions with fewer than 40 events recorded
    OnsetTime <- rbind(OnsetTime, rep(NA, 5))
    OnsetTime <- rbind(OnsetTime, rep(NA, 5))
  }
  if(i == 111){
    OnsetTime <- rbind(OnsetTime, rep(NA, 5))
    OnsetTime <- rbind(OnsetTime, rep(NA, 5))
    OnsetTime <- rbind(OnsetTime, rep(NA, 5))
    OnsetTime <- rbind(OnsetTime, rep(NA, 5))
  }
  StimulusType <- read.delim(paste("Presentation_logfiles/", AllStimulusFiles[i], sep = ""))
  OnsetTimeAndStimulus <- cbind(OnsetTime, StimulusType) 
  OnsetTimeAndStimulus <- OnsetTimeAndStimulus[ , c("V4", "Condition", "Rated_Unpleasantness", "Subject", "Date")]
  if(!is.na(OnsetTime$Subject[1]) && OnsetTime$Subject[1] %in% as.integer(IncludedSubjects) ){
    OnsetTimesForAll[[length(OnsetTimesForAll)+1]] <- OnsetTimeAndStimulus
  }
}

# Add session to onset time matrix
FunGetSubject <- function(x){return(x$Subject[1])}
DoubleSubjects <- unlist(lapply(OnsetTimesForAll, FunGetSubject))
DoubleSubjectsTemp <- c(NA, DoubleSubjects)
DoubleSubjects <- c(DoubleSubjects, NA)
Session2 <- DoubleSubjects == DoubleSubjectsTemp 

for(i in 1:length(OnsetTimesForAll)){
  if(isTRUE(Session2[i])){
    OnsetTimesForAll[[i]]$Session <- 2
  }else{
    OnsetTimesForAll[[i]]$Session <- 1     
  }
}

write.csv2(OnsetTimesForAll, file = "HR/OnsetTimesForAll_86subjects.csv", row.names=FALSE)

# Import pulse gating data
PgDataHandsTime <- read.csv("HR/PgDataHandsTime_86subjects.csv", sep=";")

# Rescale time variable
PgDataHandsTime[ , 1] <- as.numeric(PgDataHandsTime[ , 1])/100

# Cut pieces of data that start 4 seconds before onset of every stimulus and end 10 seconds after
# 4 seconds is chosen because that was the shortest possible duration of the jittered fixation cross
# 10 seconds extends into the rating event and we are unlikely to be interested in anything going on later than that
CutFun <- function(x){
  if(is.na(x)){ # Added by GN so ugly hack (see above) will continue to work
    return(rep(NA, 1401))
  } else {
    ThisOnset <- round(x, 2)
    FirstRow <- (ThisOnset-4)*100
    LastRow <- (ThisOnset+10)*100
    #if (LastRow > length(PgDataHandsTime[,])) {
    #  stop(paste("Error in CutFun. x: ", x, " i: ", i, " LastRow: ", LastRow))
    #}
    #if (i > 62) stop(paste("iiii", i, "xxxx", x))
    colname = paste("X", Subject, "...", Session, sep="")
    colindex = which(names(PgDataHandsTime) == colname)
    CutBit <- PgDataHandsTime[FirstRow:LastRow, colindex] 
    return(CutBit)
  }
}

# Loop over subjects and sessions, cut out data for events and write to file
for(i in 1:length(OnsetTimesForAll)){
  Subject <- OnsetTimesForAll[[i]]$Subject[1]
  Session <- OnsetTimesForAll[[i]]$Session[1]
  SuperList <- sapply(OnsetTimesForAll[[i]]$V4, CutFun)
  if(length(SuperList[[1]]) != 0){
    colnames(SuperList) <- OnsetTimesForAll[[i]]$Condition
    write.csv2(SuperList, file = paste("HR/PgDataHandsStimulus/", Subject, "_", Session, ".csv", sep=""), row.names=FALSE)
  }
}