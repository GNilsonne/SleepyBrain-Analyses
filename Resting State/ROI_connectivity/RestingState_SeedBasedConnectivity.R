# Script to analyse roi-roi functional connectivity in the Stockholm Sleepy Brain Project
# Gustav Nilsonne 2015-11-11

######################

# Require packages

require(nlme)
require(lattice)
require(effects)

######################

# List of investigated roi:s

#'/data/stress/Resting_State/ROI/de Havas/LIPL.nii'
#'/data/stress/Resting_State/ROI/de Havas/RIPL.nii'
#'/data/stress/Resting_State/ROI/de Havas/LLTC.nii'
#'/data/stress/Resting_State/ROI/de Havas/RLTC.nii'
#'/data/stress/Resting_State/ROI/de Havas/PCC.nii'
#'/data/stress/Resting_State/ROI/de Havas/dMPFC.nii'
#'/data/stress/Resting_State/ROI/de Havas/vMPFC.nii'
#'/data/stress/Resting_State/ROI/de Havas/L_Insula.nii'
#'/data/stress/Resting_State/ROI/de Havas/R_Insula.nii'
#'/data/stress/Resting_State/ROI/de Havas/L_IPS.nii'
#'/data/stress/Resting_State/ROI/de Havas/R_IPS.nii'
#'/data/stress/Resting_State/ROI/de Havas/L_TPJ.nii'
#'/data/stress/Resting_State/ROI/de Havas/R_TPJ.nii'
#'/data/stress/Resting_State/ROI/wfu_thalamus.nii'
#'/data/stress/Resting_State/ROI/wfu_thalamus_L.nii'
#'/data/stress/Resting_State/ROI/wfu_thalamus_R.nii'
#'/data/stress/Resting_State/ROI/Julich_amygdala/ROI_L_Amyg_MNI.nii'
#'/data/stress/Resting_State/ROI/Julich_amygdala/ROI_R_Amyg_MNI.nii'
#'/data/stress/Resting_State/ROI/Julich_amygdala/ROI_Amygdala_CM_L_MNI.nii'
#'/data/stress/Resting_State/ROI/Julich_amygdala/ROI_Amygdala_CM_R_MNI.nii'
#'/data/stress/Resting_State/ROI/Julich_amygdala/ROI_Amygdala_LB_L_MNI.nii'
#'/data/stress/Resting_State/ROI/Julich_amygdala/ROI_Amygdala_LB_R_MNI.nii'
#'/data/stress/Resting_State/ROI/Julich_amygdala/ROI_Amygdala_SF_L_MNI.nii'
#'/data/stress/Resting_State/ROI/Julich_amygdala/ROI_Amygdala_SF_R_MNI.nii'
#'/data/stress/Resting_State/ROI/left_k3/cluster_1_L_Ant_Insula.nii'
#'/data/stress/Resting_State/ROI/right_k3/cluster_2_R_Ant_Insula.nii'
#'/data/stress/Resting_State/ROI/Kelly_endotoxin/ROI_Mask_insula_midCing/MidCing.nii'

######################

# Read files
# The files contain z-transformed correlation coefficients and have been generated with DPARSFA

files_S1 <- list.files("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/Resting State/ROISignals_151110/FunImgARWSDFCB_ROISignals", pattern = c("ROICorrelation_FisherZ", ".txt"))
files_S1 <- files_S1[(seq(2, 106, 2))] # Workaround to get only .txt files
corrs_S1 <- list()
for (i in 1:length(files_S1)){
  data <- read.table(paste("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/Resting State/ROISIgnals_151110/FunImgARWSDFCB_ROISignals/", files_S1[i], sep = ""))
  corrs_S1[[i]] <- data
}

files_S2 <- list.files("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/Resting State/ROISIgnals_151110/S2_FunImgARWSDFCB_ROISignals", pattern = c("ROICorrelation_FisherZ", ".txt"))
files_S2 <- files_S2[(seq(2, 106, 2))] # Workaround to get only .txt files
corrs_S2 <- list()
for (i in 1:length(files_S2)){
  data <- read.table(paste("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/Resting State/ROISIgnals_151110/S2_FunImgARWSDFCB_ROISignals/", files_S2[i], sep = ""))
  corrs_S2[[i]] <- data
}

files_S3 <- list.files("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/Resting State/ROISignals_151110/S3_FunImgARWSDFCB_ROISignals", pattern = c("ROICorrelation_FisherZ", ".txt"))
files_S3 <- files_S3[(seq(2, 106, 2))] # Workaround to get only .txt files
corrs_S3 <- list()
for (i in 1:length(files_S3)){
  data <- read.table(paste("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/Resting State/ROISIgnals_151110/S3_FunImgARWSDFCB_ROISignals/", files_S3[i], sep = ""))
  corrs_S3[[i]] <- data
}

files_S4 <- list.files("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/Resting State/ROISIgnals_151110/S4_FunImgARWSDFCB_ROISignals", pattern = c("ROICorrelation_FisherZ", ".txt"))
files_S4 <- files_S4[(seq(2, 106, 2))] # Workaround to get only .txt files
corrs_S4 <- list()
for (i in 1:length(files_S4)){
  data <- read.table(paste("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/Resting State/ROISIgnals_151110/S4_FunImgARWSDFCB_ROISignals/", files_S4[i], sep = ""))
  corrs_S4[[i]] <- data
}

########################

# Read data files for analysis covariates

subjects <- read.csv2("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/Resting state/Subjects_RestingState_151110.csv")
demdata <- read.csv2("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/150215_Demographic.csv")
demdata <- merge(subjects, demdata, by.x = "subject", by.y = "Subject")
randlist <- read.csv2("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/RandomisationList_140804.csv")
demdata <- merge(demdata, randlist, by.x = "subject", by.y = "Subject")
demdata$Sl_cond_binary <- demdata$Sl_cond -1

FDdata <- read.table("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/Resting state/RealignParameter_RestingState_151001/n_excluded.txt", header = T) # Framewise displacement, data say how many volumes had FD > 0.5 and were interpolated
#FDdata$SleepDeprived12[demdata$Sl_cond == 1] <- FDdata$S1[demdata$Sl_cond == 1]
#FDdata$SleepDeprived12[demdata$Sl_cond == 2] <- FDdata$S2[demdata$Sl_cond == 2]
#FDdata$FullSleep12[demdata$Sl_cond == 1] <- FDdata$S2[demdata$Sl_cond == 1]
#FDdata$FullSleep12[demdata$Sl_cond == 2] <- FDdata$S1[demdata$Sl_cond == 2]
#FDdata$SleepDeprived34[demdata$Sl_cond == 1] <- FDdata$S3[demdata$Sl_cond == 1]
#FDdata$SleepDeprived34[demdata$Sl_cond == 2] <- FDdata$S4[demdata$Sl_cond == 2]
#FDdata$FullSleep34[demdata$Sl_cond == 1] <- FDdata$S4[demdata$Sl_cond == 1]
#FDdata$FullSleep34[demdata$Sl_cond == 2] <- FDdata$S3[demdata$Sl_cond == 2]

FDdatalong <- rbind(as.matrix(FDdata$S1), as.matrix(FDdata$S2), as.matrix(FDdata$S3), as.matrix(FDdata$S4))


########################

# Test differences in correlations within DMN and ACN
# Each roi-roi correlation is tested in a loop and results are put in new objects

sessiondata <- list()
models <- list()
estimates_sleep <- list()
estimates_age <- list()
estimates_sleep_age_interaction <- list()
p_vals_sleep <- list()
p_vals_age <- list()
p_vals_sleep_age_interaction <- list()

for(i in 1:13){
  sessiondata[[i]] <- rep(list(list()), 13)
  models[[i]] <- rep(list(list()), 13)
  estimates_sleep[[i]] <- rep(list(list()), 13)
  estimates_age[[i]] <- rep(list(list()), 13)
  estimates_sleep_age_interaction[[i]] <- rep(list(list()), 13)
  p_vals_sleep[[i]] <- rep(list(list()), 13)
  p_vals_age[[i]] <- rep(list(list()), 13)
  p_vals_sleep_age_interaction[[i]] <- rep(list(list()), 13)
  
  for(j in 1:13){
    if(j == i){ # Correlation of a roi to itself, not interesting
      estimates_sleep[[i]][[j]] <- NA
      estimates_age[[i]][[j]] <- NA
      estimates_sleep_age_interaction[[i]][[j]] <- NA
      p_vals_sleep[[i]][[j]] <- NA
      p_vals_age[[i]][[j]] <- NA
      p_vals_sleep_age_interaction[[i]][[j]] <- NA
    }
    else{
      data <- data.frame(ID = rep(1:53, 4))
      data$z[1:53] <- unlist(lapply(corrs_S1, function(x) {
        x[i, j]
      }))
      data$z[54:106] <- unlist(lapply(corrs_S2, function(x) {
        x[i, j]
      }))
      data$z[107:159] <- unlist(lapply(corrs_S3, function(x) {
        x[i, j]
      }))
      data$z[160:212] <- unlist(lapply(corrs_S4, function(x) {
        x[i, j]
      }))
      data$condition <- c(abs(demdata$Sl_cond_binary - 1), demdata$Sl_cond_binary, abs(demdata$Sl_cond_binary - 1), demdata$Sl_cond_binary) # Randomisation condition was coded as 1 or 2, then recoded above to 0 and 1. If original code was 1, then participant had sleep deprivation at sessions 1 and 3 and full sleep at session 2 and 4. This vector now gives sleep deprivation (1) vs full sleep (0).
      data$AgeGroup <- demdata$AgeGroup
      data$AgeGroup <- relevel(data$AgeGroup, ref = "Young")
      data$FD <- FDdatalong
      data$run <- c(rep(0, 53), rep(1, 53), rep(0, 53), rep(1, 53))
      
      lme1 <- lme(z ~ condition*AgeGroup + FD, data = data, random = ~1|ID)
    
      sessiondata[[i]][[j]] <- data
      models[[i]][[j]] <- lme1
      estimates_sleep[[i]][[j]] <- lme1$coefficients$fixed[2]
      estimates_age[[i]][[j]] <- lme1$coefficients$fixed[3]
      estimates_sleep_age_interaction[[i]][[j]] <- lme1$coefficients$fixed[5]
      p_vals_sleep[[i]][[j]] <- summary(lme1)$tTable[,"p-value"][2]
      p_vals_age[[i]][[j]] <- summary(lme1)$tTable[,"p-value"][3]
      p_vals_sleep_age_interaction[[i]][[j]] <- summary(lme1)$tTable[,"p-value"][5]
    }
  }
}

# Take each set of results, check p-values and plot effect estimates

p_vals_sleep2 <- matrix(as.vector(unlist(p_vals_sleep)), nrow = 13, ncol = 13)
p_vals_sleep2
p_vals_sleep2[p_vals_sleep2 <= 0.05]
p_vals_sleep3 <- c(p_vals_sleep2[1, 2], p_vals_sleep2[1:2, 3], p_vals_sleep2[1:3, 4], p_vals_sleep2[1:4, 5], p_vals_sleep2[1:5, 6], p_vals_sleep2[1:6, 7], p_vals_sleep2[1:7, 8], p_vals_sleep2[1:8, 9], p_vals_sleep2[1:9, 10], p_vals_sleep2[1:10, 11], p_vals_sleep2[1:11, 12], p_vals_sleep2[1:12, 13])
p_vals_sleep4 <- p.adjust(p_vals_sleep3, method = "fdr")
table(p_vals_sleep4)
estimates_sleep2 <- matrix(as.vector(unlist(estimates_sleep)), nrow = 13, ncol = 13)
estimates_sleep2
row.names(estimates_sleep2) <- c("LIPL", "RIPL", "LLTC", "RLTC", "PCC", "dMPFC", "vMPFC", "L_Insula", "R_Insula", "LIPS", "RIPS", "LTPJ", "RTPJ")
levelplot(estimates_sleep2, main = "Effect of sleep deprivation")

p_vals_age2 <- matrix(as.vector(unlist(p_vals_age)), nrow = 13, ncol = 13)
p_vals_age2
p_vals_age2[p_vals_age2 <= 0.05]
p_vals_age3 <- c(p_vals_age2[1, 2], p_vals_age2[1:2, 3], p_vals_age2[1:3, 4], p_vals_age2[1:4, 5], p_vals_age2[1:5, 6], p_vals_age2[1:6, 7], p_vals_age2[1:7, 8], p_vals_age2[1:8, 9], p_vals_age2[1:9, 10], p_vals_age2[1:10, 11], p_vals_age2[1:11, 12], p_vals_age2[1:12, 13])
p_vals_age4 <- p.adjust(p_vals_age3, method = "fdr")
table(p_vals_age4)
estimates_age2 <- matrix(as.vector(unlist(estimates_age)), nrow = 13, ncol = 13)
estimates_age2
row.names(estimates_age2) <- c("LIPL", "RIPL", "LLTC", "RLTC", "PCC", "dMPFC", "vMPFC", "L_Insula", "R_Insula", "LIPS", "RIPS", "LTPJ", "RTPJ")
levelplot(estimates_age2, main = "Effect of age group")

p_vals_sleep_age_interaction2 <- matrix(as.vector(unlist(p_vals_sleep_age_interaction)), nrow = 13, ncol = 13)
p_vals_sleep_age_interaction2
p_vals_sleep_age_interaction2[p_vals_sleep_age_interaction2 <= 0.05]
p_vals_sleep_age_interaction3 <- c(p_vals_sleep_age_interaction2[1, 2], p_vals_sleep_age_interaction2[1:2, 3], p_vals_sleep_age_interaction2[1:3, 4], p_vals_sleep_age_interaction2[1:4, 5], p_vals_sleep_age_interaction2[1:5, 6], p_vals_sleep_age_interaction2[1:6, 7], p_vals_sleep_age_interaction2[1:7, 8], p_vals_sleep_age_interaction2[1:8, 9], p_vals_sleep_age_interaction2[1:9, 10], p_vals_sleep_age_interaction2[1:10, 11], p_vals_sleep_age_interaction2[1:11, 12], p_vals_sleep_age_interaction2[1:12, 13])
p_vals_sleep_age_interaction4 <- p.adjust(p_vals_sleep_age_interaction3, method = "fdr")
table(p_vals_sleep_age_interaction4)
estimates_sleep_age_interaction2 <- matrix(as.vector(unlist(estimates_sleep_age_interaction)), nrow = 13, ncol = 13)
estimates_sleep_age_interaction2
row.names(estimates_sleep_age_interaction2) <- c("LIPL", "RIPL", "LLTC", "RLTC", "PCC", "dMPFC", "vMPFC", "L_Insula", "R_Insula", "LIPS", "RIPS", "LTPJ", "RTPJ")
levelplot(estimates_sleep_age_interaction2, main = "Sleep deprivation - age group interaction")

max_z <- max(c(estimates_sleep2, estimates_age2, estimates_sleep_age_interaction2), na.rm = T)
min_z <- min(c(estimates_sleep2, estimates_age2, estimates_sleep_age_interaction2), na.rm = T)

# Make new plots with a uniform scale

levelplot(estimates_sleep2, main = "Effect of sleep deprivation", at = unique(c(seq(min_z, 0, length=50), seq(0, max_z, length=50))), col.regions = colorRampPalette(c("red", "white", "blue"))(1e3))
levelplot(estimates_age2, main = "Effect of age group", at = unique(c(seq(min_z, 0, length=50), seq(0, max_z, length=50))), col.regions = colorRampPalette(c("red", "white", "blue"))(1e3))
levelplot(estimates_sleep_age_interaction2, main = "Sleep deprivation - age group interaction", at = unique(c(seq(min_z, 0, length=50), seq(0, max_z, length=50))), col.regions = colorRampPalette(c("red", "white", "blue"))(1e3))


# Test differences in correlations within DMN and ACN USING ONLY S3 AND S4 for comparison with regression based approach
# Each roi-roi correlation is tested in a loop and results are put in new objects

sessiondata <- list()
models <- list()
estimates_sleep <- list()
estimates_age <- list()
estimates_sleep_age_interaction <- list()
p_vals_sleep <- list()
p_vals_age <- list()
p_vals_sleep_age_interaction <- list()

for(i in 1:13){
  sessiondata[[i]] <- rep(list(list()), 13)
  models[[i]] <- rep(list(list()), 13)
  estimates_sleep[[i]] <- rep(list(list()), 13)
  estimates_age[[i]] <- rep(list(list()), 13)
  estimates_sleep_age_interaction[[i]] <- rep(list(list()), 13)
  p_vals_sleep[[i]] <- rep(list(list()), 13)
  p_vals_age[[i]] <- rep(list(list()), 13)
  p_vals_sleep_age_interaction[[i]] <- rep(list(list()), 13)
  
  for(j in 1:13){
    if(j == i){ # Correlation of a roi to itself, not interesting
      estimates_sleep[[i]][[j]] <- NA
      estimates_age[[i]][[j]] <- NA
      estimates_sleep_age_interaction[[i]][[j]] <- NA
      p_vals_sleep[[i]][[j]] <- NA
      p_vals_age[[i]][[j]] <- NA
      p_vals_sleep_age_interaction[[i]][[j]] <- NA
    }
    else{
      data <- data.frame(ID = rep(1:53, 4))
      data$z[1:53] <- unlist(lapply(corrs_S1, function(x) {
        x[i, j]
      }))
      data$z[54:106] <- unlist(lapply(corrs_S2, function(x) {
        x[i, j]
      }))
      data$z[107:159] <- unlist(lapply(corrs_S3, function(x) {
        x[i, j]
      }))
      data$z[160:212] <- unlist(lapply(corrs_S4, function(x) {
        x[i, j]
      }))
      data$condition <- c(abs(demdata$Sl_cond_binary - 1), demdata$Sl_cond_binary, abs(demdata$Sl_cond_binary - 1), demdata$Sl_cond_binary) # Randomisation condition was coded as 1 or 2, then recoded above to 0 and 1. If original code was 1, then participant had sleep deprivation at sessions 1 and 3 and full sleep at session 2 and 4. This vector now gives sleep deprivation (1) vs full sleep (0).
      data$AgeGroup <- demdata$AgeGroup
      data$AgeGroup <- relevel(data$AgeGroup, ref = "Young")
      data$FD <- FDdatalong
      data$run <- c(rep(0, 53), rep(1, 53), rep(0, 53), rep(1, 53))
      data$session <- c(rep(1, 53), rep(2, 53), rep(3, 53), rep(4, 53))
      
      lme1 <- lme(z ~ condition*AgeGroup + FD, data = data[data$session >= 3, ], random = ~1|ID)
      
      sessiondata[[i]][[j]] <- data
      models[[i]][[j]] <- lme1
      estimates_sleep[[i]][[j]] <- lme1$coefficients$fixed[2]
      estimates_age[[i]][[j]] <- lme1$coefficients$fixed[3]
      estimates_sleep_age_interaction[[i]][[j]] <- lme1$coefficients$fixed[5]
      p_vals_sleep[[i]][[j]] <- summary(lme1)$tTable[,"p-value"][2]
      p_vals_age[[i]][[j]] <- summary(lme1)$tTable[,"p-value"][3]
      p_vals_sleep_age_interaction[[i]][[j]] <- summary(lme1)$tTable[,"p-value"][5]
    }
  }
}

# Take each set of results, check p-values and plot effect estimates

p_vals_sleep2 <- matrix(as.vector(unlist(p_vals_sleep)), nrow = 13, ncol = 13)
p_vals_sleep2
p_vals_sleep2[p_vals_sleep2 <= 0.05]
p_vals_sleep3 <- c(p_vals_sleep2[1, 2], p_vals_sleep2[1:2, 3], p_vals_sleep2[1:3, 4], p_vals_sleep2[1:4, 5], p_vals_sleep2[1:5, 6], p_vals_sleep2[1:6, 7], p_vals_sleep2[1:7, 8], p_vals_sleep2[1:8, 9], p_vals_sleep2[1:9, 10], p_vals_sleep2[1:10, 11], p_vals_sleep2[1:11, 12], p_vals_sleep2[1:12, 13])
p_vals_sleep4 <- p.adjust(p_vals_sleep3, method = "fdr")
table(p_vals_sleep4)
estimates_sleep2 <- matrix(as.vector(unlist(estimates_sleep)), nrow = 13, ncol = 13)
estimates_sleep2
row.names(estimates_sleep2) <- c("LIPL", "RIPL", "LLTC", "RLTC", "PCC", "dMPFC", "vMPFC", "L_Insula", "R_Insula", "LIPS", "RIPS", "LTPJ", "RTPJ")
levelplot(estimates_sleep2, main = "Effect of sleep deprivation")

p_vals_age2 <- matrix(as.vector(unlist(p_vals_age)), nrow = 13, ncol = 13)
p_vals_age2
p_vals_age2[p_vals_age2 <= 0.05]
p_vals_age3 <- c(p_vals_age2[1, 2], p_vals_age2[1:2, 3], p_vals_age2[1:3, 4], p_vals_age2[1:4, 5], p_vals_age2[1:5, 6], p_vals_age2[1:6, 7], p_vals_age2[1:7, 8], p_vals_age2[1:8, 9], p_vals_age2[1:9, 10], p_vals_age2[1:10, 11], p_vals_age2[1:11, 12], p_vals_age2[1:12, 13])
p_vals_age4 <- p.adjust(p_vals_age3, method = "fdr")
table(p_vals_age4)
estimates_age2 <- matrix(as.vector(unlist(estimates_age)), nrow = 13, ncol = 13)
estimates_age2
row.names(estimates_age2) <- c("LIPL", "RIPL", "LLTC", "RLTC", "PCC", "dMPFC", "vMPFC", "L_Insula", "R_Insula", "LIPS", "RIPS", "LTPJ", "RTPJ")
levelplot(estimates_age2, main = "Effect of age group")

p_vals_sleep_age_interaction2 <- matrix(as.vector(unlist(p_vals_sleep_age_interaction)), nrow = 13, ncol = 13)
p_vals_sleep_age_interaction2
p_vals_sleep_age_interaction2[p_vals_sleep_age_interaction2 <= 0.05]
p_vals_sleep_age_interaction3 <- c(p_vals_sleep_age_interaction2[1, 2], p_vals_sleep_age_interaction2[1:2, 3], p_vals_sleep_age_interaction2[1:3, 4], p_vals_sleep_age_interaction2[1:4, 5], p_vals_sleep_age_interaction2[1:5, 6], p_vals_sleep_age_interaction2[1:6, 7], p_vals_sleep_age_interaction2[1:7, 8], p_vals_sleep_age_interaction2[1:8, 9], p_vals_sleep_age_interaction2[1:9, 10], p_vals_sleep_age_interaction2[1:10, 11], p_vals_sleep_age_interaction2[1:11, 12], p_vals_sleep_age_interaction2[1:12, 13])
p_vals_sleep_age_interaction4 <- p.adjust(p_vals_sleep_age_interaction3, method = "fdr")
table(p_vals_sleep_age_interaction4)
estimates_sleep_age_interaction2 <- matrix(as.vector(unlist(estimates_sleep_age_interaction)), nrow = 13, ncol = 13)
estimates_sleep_age_interaction2
row.names(estimates_sleep_age_interaction2) <- c("LIPL", "RIPL", "LLTC", "RLTC", "PCC", "dMPFC", "vMPFC", "L_Insula", "R_Insula", "LIPS", "RIPS", "LTPJ", "RTPJ")
levelplot(estimates_sleep_age_interaction2, main = "Sleep deprivation - age group interaction")

max_z <- max(c(estimates_sleep2, estimates_age2, estimates_sleep_age_interaction2), na.rm = T)
min_z <- min(c(estimates_sleep2, estimates_age2, estimates_sleep_age_interaction2), na.rm = T)
max_z <- 0.75
min_z <- -0.75

# Make new plots with a uniform scale

jpeg('sleep_corr.jpg', height = 600, width = 600)
levelplot(estimates_sleep2, main = "Effect of sleep deprivation", at = unique(c(seq(min_z, 0, length=50), seq(0, max_z, length=50))), col.regions = colorRampPalette(c("red", "white", "blue"))(1e3))
dev.off()
jpeg('age_corr.jpg', height = 600, width = 600)
levelplot(estimates_age2, main = "Effect of age group", at = unique(c(seq(min_z, 0, length=50), seq(0, max_z, length=50))), col.regions = colorRampPalette(c("red", "white", "blue"))(1e3))
dev.off()
jpeg('interaction_corr.jpg', height = 600, width = 600)
levelplot(estimates_sleep_age_interaction2, main = "Sleep deprivation - age group interaction", at = unique(c(seq(min_z, 0, length=50), seq(0, max_z, length=50))), col.regions = colorRampPalette(c("red", "white", "blue"))(1e3))
dev.off()

########################

# Test differences in correlations between insula and cingulum
# Put data in a new list, by roi-roi correlation so they each can be tested

ins_sessiondata <- list()
ins_models <- list()
ins_estimates_sleep <- list()
ins_estimates_age <- list()
ins_estimates_sleep_age_interaction <- list()
ins_p_vals_sleep <- list()
ins_p_vals_age <- list()
ins_p_vals_sleep_age_interaction <- list()

for(i in 25:27){
  ins_sessiondata[[i]] <- rep(list(list()), 3)
  ins_models[[i]] <- rep(list(list()), 3)
  ins_estimates_sleep[[i]] <- rep(list(list()), 3)
  ins_estimates_age[[i]] <- rep(list(list()), 3)
  ins_estimates_sleep_age_interaction[[i]] <- rep(list(list()), 3)
  ins_p_vals_sleep[[i]] <- rep(list(list()), 3)
  ins_p_vals_age[[i]] <- rep(list(list()), 3)
  ins_p_vals_sleep_age_interaction[[i]] <- rep(list(list()), 3)
  for(j in 25:27){
    if(j == i){ # Correlation of a roi to itself, not interesting
      ins_estimates_sleep[[i]][[j]] <- NA
      ins_estimates_age[[i]][[j]] <- NA
      ins_estimates_sleep_age_interaction[[i]][[j]] <- NA
      ins_p_vals_sleep[[i]][[j]] <- NA
      ins_p_vals_age[[i]][[j]] <- NA
      ins_p_vals_sleep_age_interaction[[i]][[j]] <- NA
    }
    else{
      data <- data.frame(ID = rep(1:53, 4))
      data$z[1:53] <- unlist(lapply(corrs_S1, function(x) {
        x[i, j]
      }))
      data$z[54:106] <- unlist(lapply(corrs_S2, function(x) {
        x[i, j]
      }))
      data$z[107:159] <- unlist(lapply(corrs_S3, function(x) {
        x[i, j]
      }))
      data$z[160:212] <- unlist(lapply(corrs_S4, function(x) {
        x[i, j]
      }))
      data$deprivation <- c(rep(0, 106), rep(1, 106))
      data$deprivation <- as.factor(data$deprivation)
      data$run <- c(rep(0, 53), rep(1, 53), rep(0, 53), rep(1, 53))
      data <- merge(data, demdata[, c("ID", "AgeGroup")], by = "ID")
      
      data$AgeGroup <- relevel(data$AgeGroup, ref = "Young")
      data$FD <- FDdatalong
      
      lme1 <- lme(z ~ deprivation*AgeGroup + run + FD, data = data, random = ~1|ID)
      
      ins_sessiondata[[i]][[j]] <- data
      ins_models[[i]][[j]] <- lme1
      ins_estimates_sleep[[i]][[j]] <- lme1$coefficients$fixed[2]
      ins_estimates_age[[i]][[j]] <- lme1$coefficients$fixed[3]
      ins_estimates_sleep_age_interaction[[i]][[j]] <- lme1$coefficients$fixed[4]
      ins_p_vals_sleep[[i]][[j]] <- summary(lme1)$tTable[,"p-value"][2]
      ins_p_vals_age[[i]][[j]] <- summary(lme1)$tTable[,"p-value"][3]
      ins_p_vals_sleep_age_interaction[[i]][[j]] <- summary(lme1)$tTable[,"p-value"][4]
    }
  }
}

ins_p_vals2 <- matrix(as.vector(unlist(ins_p_vals)), nrow = 3, ncol = 3)
ins_p_vals2
ins_p_vals2[ins_p_vals2 <= 0.05]
ins_p_vals3 <- c(ins_p_vals2[1, 2], ins_p_vals2[1:2, 3])
ins_p_vals4 <- p.adjust(ins_p_vals3, method = "fdr")

ins_estimates2 <- matrix(as.vector(unlist(ins_estimates_sleep)), nrow = 3, ncol = 3)
ins_estimates2

row.names(ins_estimates2) <- c("L_Ant_Insula", "R_Ant_Insula", "MidCing")
levelplot(ins_estimates2)

# Alternative approach without loop
data_insulaL <- data.frame(ID = rep(1:53, 4))
data_insulaL$z[1:53] <- unlist(lapply(corrs_S1, function(x) {
  x[25, 27]
}))
data_insulaL$z[54:106] <- unlist(lapply(corrs_S2, function(x) {
  x[25, 27]
}))
data_insulaL$z[107:159] <- unlist(lapply(corrs_S3, function(x) {
  x[25, 27]
}))
data_insulaL$z[160:212] <- unlist(lapply(corrs_S4, function(x) {
  x[25, 27]
}))
data_insulaL$deprivation <- c(rep(0, 106), rep(1, 106))
data_insulaL$deprivation <- as.factor(data_insulaL$deprivation)
data_insulaL$run <- c(rep(0, 53), rep(1, 53), rep(0, 53), rep(1, 53))
data_insulaL <- merge(data_insulaL, demdata[, c("ID", "AgeGroup", "SicknessQ_Total_reduced")], by = "ID")
data_insulaL$AgeGroup <- relevel(data_insulaL$AgeGroup, ref = "Young")
data_insulaL$FD <- FDdatalong

lme_insulaL <- lme(z ~ deprivation*AgeGroup + run + FD, data = data_insulaL, random = ~1|ID)
summary(lme_insulaL)
intervals(lme_insulaL)
plot(effect("deprivation*AgeGroup", lme_insulaL))

plot(z ~ SicknessQ_Total_reduced, data = data_insulaL)
lme_insulaL_SQa <- lme(z ~ SicknessQ_Total_reduced*AgeGroup + run + FD, data = data_insulaL[data_insulaL$deprivation == 0, ], random = ~1|ID)
summary(lme_insulaL_SQa)
intervals(lme_insulaL_SQa)
plot(effect("SicknessQ_Total_reduced*AgeGroup", lme_insulaL_SQa))
lme_insulaL_SQb <- lme(z ~ SicknessQ_Total_reduced*AgeGroup + run + FD, data = data_insulaL[data_insulaL$deprivation == 1, ], random = ~1|ID)
summary(lme_insulaL_SQb)
intervals(lme_insulaL_SQb)
plot(effect("SicknessQ_Total_reduced*AgeGroup", lme_insulaL_SQb))

data_insulaR <- data.frame(ID = rep(1:53, 4))
data_insulaR$z[1:53] <- unlist(lapply(corrs_S1, function(x) {
  x[26, 27]
}))
data_insulaR$z[54:106] <- unlist(lapply(corrs_S2, function(x) {
  x[26, 27]
}))
data_insulaR$z[107:159] <- unlist(lapply(corrs_S3, function(x) {
  x[26, 27]
}))
data_insulaR$z[160:212] <- unlist(lapply(corrs_S4, function(x) {
  x[26, 27]
}))
data_insulaR$deprivation <- c(rep(0, 106), rep(1, 106))
data_insulaR$deprivation <- as.factor(data_insulaR$deprivation)
data_insulaR$run <- c(rep(0, 53), rep(1, 53), rep(0, 53), rep(1, 53))
data_insulaR <- merge(data_insulaR, demdata[, c("ID", "AgeGroup", "SicknessQ_Total_reduced")], by = "ID")
data_insulaR$AgeGroup <- relevel(data_insulaR$AgeGroup, ref = "Young")
data_insulaR$FD <- FDdatalong

lme_insulaR <- lme(z ~ deprivation*AgeGroup + run + FD, data = data_insulaR, random = ~1|ID)
summary(lme_insulaR)
intervals(lme_insulaR)
plot(effect("deprivation*AgeGroup", lme_insulaR))

plot(z ~ SicknessQ_Total_reduced, data = data_insulaR)
lme_insulaR_SQa <- lme(z ~ SicknessQ_Total_reduced*AgeGroup + run + FD, data = data_insulaR[data_insulaR$deprivation == 0, ], random = ~1|ID)
summary(lme_insulaR_SQa)
intervals(lme_insulaR_SQa)
plot(effect("SicknessQ_Total_reduced*AgeGroup", lme_insulaR_SQa))
lme_insulaR_SQb <- lme(z ~ SicknessQ_Total_reduced*AgeGroup + run + FD, data = data_insulaR[data_insulaR$deprivation == 1, ], random = ~1|ID)
summary(lme_insulaR_SQb)
intervals(lme_insulaR_SQb)
plot(effect("SicknessQ_Total_reduced*AgeGroup", lme_insulaR_SQb))


# Investigate PSG parameters and other putative covariates

sleepdata <- read.delim("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/sb_wide__6_Jun_2016.txt")
sleepdata <- sleepdata[sleepdata$id %in% subjects$subject, ]
sleepdata_nsd <- sleepdata[, 1:1995]
sleepdata_sd <- sleepdata[, c(1, 1996:3989)]
sleepdata_nsd$condition <- 0
sleepdata_sd$condition <- 1

names(sleepdata_sd) <- names(sleepdata_nsd)
sleepdata2 <- rbind(sleepdata_nsd, sleepdata_sd)

# Read KSS data
KSSfolders <- list.files("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/Presentation_logfiles")
KSSfolders <- data.frame(folder = KSSfolders, subject = as.integer(substring(KSSfolders, 1, 3)))
KSSfolders <- KSSfolders[KSSfolders$subject %in% subjects$subject, ]
kssdata <- data.frame(folder = NULL, kss2 = NULL, kss69 = NULL)
for (i in 1:length(KSSfolders$folder)){
  KSSratings2 <- read.delim(paste("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/Presentation_logfiles/", KSSfolders$folder[i], "/KSS_brief2.txt", sep = ""), skip = 1, header = F)
  KSSratings6_9 <- read.delim(paste("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/Presentation_logfiles/", KSSfolders$folder[i], "/KSS.txt", sep = ""), skip = 1, header = F)
  KSSratings6_9 <- mean(KSSratings6_9$V1)
  data <- data.frame(folder = KSSfolders$folder[i], kss2 = as.integer(KSSratings2), kss69 = KSSratings6_9)
  kssdata <- rbind(kssdata, data)
}

boxplot(kssdata$kss2, kssdata$kss69)
t.test(kssdata$kss2, kssdata$kss69)

kssdata$subject <- substring(kssdata$folder, 1, 3)
kssdata$sessionpair <- c("1_3", "2_4")
kssdata <- reshape(kssdata, direction = "long", , varying = c("kss2", "kss69"), idvar = c("subject", "sessionpair"), v.names = "kss")
kssdata$session <- 1
kssdata$session[kssdata$sessionpair == "1_3" & kssdata$time == 2] <- 3
kssdata$session[kssdata$sessionpair == "2_4" & kssdata$time == 1] <- 2
kssdata$session[kssdata$sessionpair == "2_4" & kssdata$time == 2] <- 4
kssdata <- kssdata[, c("subject", "session", "kss")]
kssdata$subject <- as.integer(kssdata$subject)

#sleepdata2$session <- 1
#sleepdata2$session[sleepdata2$condition == 0 & sleepdata2$sl_cond_nsd == 1] <- 2
#sleepdata2$session[sleepdata2$condition == 1 & sleepdata2$sl_cond_nsd == 2] <- 2

covs <- c("kss", "tst__00_nsd", "rp___00_nsd", "n1p__00_nsd", "n2p__00_nsd", "n3p__00_nsd", "fstst00_nsd", "delta_t_l_n3_p25_m_use_nsd", "fw___00_nsd", "eff__00_nsd", "waso_00_nsd", "ISI", "ESS", "KSQ_SleepQualityIndex") # List covariate names

estimates_cov <- list()
estimates_covsleep <- list()
estimates_covage <- list()
estimates_cov3way <- list()
p_vals_cov <- list()
p_vals_covsleep <- list()
p_vals_covage <- list()
p_vals_cov3way <- list()

for(i in 1:13){ # Loop over rois
  #sessiondata[[i]] <- rep(list(list()), 13)
  #models[[i]] <- rep(list(list()), 13)
  estimates_cov[[i]] <- rep(list(list()), 13)
  estimates_covsleep[[i]] <- rep(list(list()), 13)
  estimates_covage[[i]] <- rep(list(list()), 13)
  estimates_cov3way[[i]] <- rep(list(list()), 13)
  p_vals_cov[[i]] <- rep(list(list()), 13)
  p_vals_covsleep[[i]] <- rep(list(list()), 13)
  p_vals_covage[[i]] <- rep(list(list()), 13)
  p_vals_cov3way[[i]] <- rep(list(list()), 13)
  
  for(j in 1:13){ # Loop over rois again to get pairwise comparisons
    #sessiondata[[i]][[j]] <- rep(list(list()), 15)
    #models[[i]][[j]] <- rep(list(list()), 13)
    estimates_cov[[i]][[j]] <- rep(list(list()), 13)
    estimates_covsleep[[i]][[j]] <- rep(list(list()), 13)
    estimates_covage[[i]][[j]] <- rep(list(list()), 13)
    estimates_cov3way[[i]][[j]] <- rep(list(list()), 13)
    p_vals_cov[[i]][[j]] <- rep(list(list()), 13)
    p_vals_covsleep[[i]][[j]] <- rep(list(list()), 13)
    p_vals_covage[[i]][[j]] <- rep(list(list()), 13)
    p_vals_cov3way[[i]][[j]] <- rep(list(list()), 13)
    
    for(k in 1:length(covs)){ # Loop over covariates
      if(j == i){ # Correlation of a roi to itself, not interesting
        estimates_cov[[i]][[j]][[k]] <- NA
        estimates_covsleep[[i]][[j]][[k]] <- NA
        estimates_covage[[i]][[j]][[k]] <- NA
        estimates_cov3way[[i]][[j]][[k]] <- NA
        p_vals_cov[[i]][[j]][[k]] <- NA
        p_vals_covsleep[[i]][[j]][[k]] <- NA
        p_vals_covage[[i]][[j]][[k]] <- NA
        p_vals_cov3way[[i]][[j]][[k]] <- NA
      }
      else{
        data <- data.frame(ID = rep(1:53, 4))
        data$z[1:53] <- unlist(lapply(corrs_S1, function(x) {
          x[i, j]
        }))
        data$z[54:106] <- unlist(lapply(corrs_S2, function(x) {
          x[i, j]
        }))
        data$z[107:159] <- unlist(lapply(corrs_S3, function(x) {
          x[i, j]
        }))
        data$z[160:212] <- unlist(lapply(corrs_S4, function(x) {
          x[i, j]
        }))
        data$condition <- c(abs(demdata$Sl_cond_binary - 1), demdata$Sl_cond_binary, abs(demdata$Sl_cond_binary - 1), demdata$Sl_cond_binary) # Randomisation condition was coded as 1 or 2, then recoded above to 0 and 1. If original code was 1, then participant had sleep deprivation at sessions 1 and 3 and full sleep at session 2 and 4. This vector now gives sleep deprivation (1) vs full sleep (0).
        data$AgeGroup <- demdata$AgeGroup
        data$AgeGroup <- relevel(data$AgeGroup, ref = "Young")
        data$FD <- FDdatalong
        data$session <- c(rep(1, 53), rep(2, 53), rep(1, 53), rep(2, 53))
        data$subject <- rep(subjects$subject, 4)
        
        datawithcovs <- merge(data, demdata[, c("subject", "ISI", "ESS", "KSQ_SleepQualityIndex")], all.x = T, by = "subject")
        #datawithcovs <- merge(datawithcovs, KSS) #TODO
        datawithcovs <- merge(datawithcovs, sleepdata2[, c("id", "condition", "tst__00_nsd", "rp___00_nsd", "n1p__00_nsd", "n2p__00_nsd", "n3p__00_nsd", "fstst00_nsd", "delta_t_l_n3_p25_m_use_nsd", "fw___00_nsd", "eff__00_nsd", "waso_00_nsd")], by.x = c("subject", "condition"), by.y = c("id", "condition"), all = T) #TODO
        datawithcovs <- merge(datawithcovs, kssdata, by = c("subject", "session"))
        
        modelterms <- paste("z ~ condition*AgeGroup*", covs[k], "+ FD", sep = "")
        lme1 <- lme(as.formula(modelterms), data = datawithcovs, random = ~1|ID, na.action = na.omit)
        
        #sessiondata[[i]][[j]][[k]] <- data # Save memory by not writing
        #models[[i]][[j]][[k]] <- lme1 # Save memory by not writing
        estimates_cov[[i]][[j]][[k]] <- lme1$coefficients$fixed[4]
        estimates_covsleep[[i]][[j]][[k]] <- lme1$coefficients$fixed[7]
        estimates_covage[[i]][[j]][[k]] <- lme1$coefficients$fixed[8]
        estimates_cov3way[[i]][[j]][[k]] <- lme1$coefficients$fixed[9]
        p_vals_cov[[i]][[j]][[k]] <- summary(lme1)$tTable[,"p-value"][4]
        p_vals_covsleep[[i]][[j]][[k]] <- summary(lme1)$tTable[,"p-value"][7]
        p_vals_covage[[i]][[j]][[k]] <- summary(lme1)$tTable[,"p-value"][8]
        p_vals_cov3way[[i]][[j]][[k]] <- summary(lme1)$tTable[,"p-value"][9]
      }
    }
  }
}

#test <- matrix(as.vector(unlist(estimates_cov[3][2])), nrow = 13, ncol = 13)

p_vals_cov_fdr <- p.adjust(unlist(p_vals_cov), method = "fdr")
hist(p_vals_cov_fdr)
p_vals_covsleep_fdr <- p.adjust(unlist(p_vals_covsleep), method = "fdr")
hist(p_vals_covsleep_fdr)
p_vals_covage_fdr <- p.adjust(unlist(p_vals_covage), method = "fdr")
hist(p_vals_cov_fdr)
p_vals_cov3way_fdr <- p.adjust(unlist(p_vals_cov3way), method = "fdr")
hist(p_vals_cov3way_fdr)

sum(p_vals_cov_fdr < 0.05, na.rm = T)
sum(p_vals_covsleep_fdr < 0.05, na.rm = T)
sum(p_vals_covage_fdr < 0.05, na.rm = T)
sum(p_vals_cov3way_fdr < 0.05, na.rm = T)

unlist(p_vals_cov3way)[which(p_vals_cov3way_fdr < 0.05)]
estimates_cov3way[[1]]
