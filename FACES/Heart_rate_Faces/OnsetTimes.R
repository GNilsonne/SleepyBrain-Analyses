# Script to process pulse gating data from FACES experiment
# By Sandra Tamm
# Modified by Gustav Nilsonne 2015-12-19
# Adapted for FACES experiment 2018-08-17

setwd("~/Box Sync/Sleepy Brain/Datafiles")

# List included subjects 
IncludedSubjects <- read.table("HR/IncludedSubjectsPgFACES.csv", header=T, quote="\"")$x

# Get onset times for stimuli 
OnsetTimesForAll <- list()
AllOnsetFiles <- list.files("Presentation_logfiles/", pattern = "FACES_sce.log", recursive = T)
AllStimulusFiles <- list.files("Presentation_logfiles/", pattern = "FACES_log.txt", recursive = T)

# Remove times for non-included subjects
getSubjectFromFileName <- function (filename) {
  return(as.integer(substr(filename, 1, 3)))
}

AllOnsetFiles = AllOnsetFiles[unlist(lapply(AllOnsetFiles, getSubjectFromFileName)) %in% IncludedSubjects]
AllStimulusFiles = AllStimulusFiles[unlist(lapply(AllStimulusFiles, getSubjectFromFileName)) %in% IncludedSubjects]


# Check for FACES!!
# Subject 190 and 426 have fewer registrations (onset times) than expected. NA.s added, below


# Find onset times
for(i in 1:length(AllOnsetFiles)){
  OnsetTime <- read.table(paste("Presentation_logfiles/",AllOnsetFiles[i], sep = ""), header=F, quote="\"", fill=TRUE, blank.lines.skip=FALSE)
  OnsetTime <- subset(OnsetTime, V1 == "Picture")
  OnsetTime <- OnsetTime[ , c(2,4)]
  OnsetTime$File <- AllOnsetFiles[i]
  OnsetTime$Subject <- as.integer(substr(OnsetTime$File, 1, 3)) 
  OnsetTime$Date <- as.integer(substr(OnsetTime$File, 5, 10))
  OnsetTime <- subset(OnsetTime, V2 == "happy" | V2 == "neutral" | V2 == "angry")
  OnsetTime$V4 <- as.numeric(as.character(OnsetTime$V4))/10000
  OnsetTime$temp <- c("x", as.character(OnsetTime$V2[1:239])) 
  OnsetTime$temp2 <- ifelse(OnsetTime$temp == OnsetTime$V2, 1, 2)
  OnsetTime <- subset(OnsetTime, OnsetTime$temp2 == 2)
  OnsetTime <- OnsetTime[ , 1:5]
  #OnsetTime$BlockType <- OnsetTime$V2
  if(!is.na(OnsetTime$Subject[1]) && OnsetTime$Subject[1] %in% as.integer(IncludedSubjects) ){
     OnsetTimesForAll[[length(OnsetTimesForAll)+1]] <- OnsetTime
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

write.csv2(OnsetTimesForAll, file = "HR/OnsetTimesForAll_FACES.csv", row.names=FALSE)

# Import pulse gating data
PgDataFACESTime <- read.csv("HR/PgDataFACESTime.csv", sep=";")

# Rescale time variable
PgDataFACESTime[ , 1] <- as.numeric(PgDataFACESTime[ , 1])/100



# Cut pieces of data that start 2 seconds before every block and 2 seconds after each block (24 s in total)
CutFun <- function(x){
    ThisOnset <- round(x, 2)
    FirstRow <- (ThisOnset-2)*100
    LastRow <- (ThisOnset+22)*100

    colname = paste("X", Subject, "...", Session, sep="")
    colindex = which(names(PgDataFACESTime) == colname)
    CutBit <- PgDataFACESTime[FirstRow:LastRow, colindex] 
    return(CutBit)
}

ThisOnset <- round(OnsetTimesForAll[[i]]$V4, 2)
FirstRow <- (ThisOnset-2)*100
LastRow <- (ThisOnset+22)*100

colname = paste("X", Subject, "...", Session, sep="")
colindex = which(names(PgDataFACESTime) == colname)
CutBit <- PgDataFACESTime[FirstRow:LastRow, colindex] 

# Check for FACES
### 426, session 2 does not work. This session is not included in analyses since the recording is very short?
# Loop over subjects and sessions, cut out data for events and write to file


for(i in 1:length(OnsetTimesForAll)){
    Subject <- OnsetTimesForAll[[i]]$Subject[1]
    Session <- OnsetTimesForAll[[i]]$Session[1]
    SuperList <- sapply(OnsetTimesForAll[[i]]$V4, CutFun)
    if(length(SuperList[[1]]) != 0){
      colnames(SuperList) <- OnsetTimesForAll[[i]]$V2
      write.csv2(SuperList, file = paste("HR/PgDataFACESStimulus/", Subject, "_", Session, ".csv", sep=""), row.names=FALSE)
  }
}
  