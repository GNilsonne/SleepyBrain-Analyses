# Participant ratings

# Rating ~ Block_type * condition * AgeGroup +
# MAybe all interactions?

# Define functions
# Function to extract estimates for models without covariates and put them in a table
fun_extractvalues1 <- function(x){ # For main models
  interv <- matrix(unlist(intervals(x, which = "fixed")), ncol = 3)
  tTable <- summary(x)$tTable
  results <- data.frame(intercept_estimate_CI = paste(round(tTable[1, 1], 3), " [", round(interv[1, 1], 3), ", ", round(interv[1, 3], 3), "]", sep = ""), intercept_p = round(tTable[1, 5], 3),
                        intercept_block_type_CI = paste(round(tTable[2, 1], 3), " [", round(interv[2, 1], 3), ", ", round(interv[2, 3], 3), "]", sep = ""), block_type_p = round(tTable[2, 5], 3),
                        intercept_deprivation_CI = paste(round(tTable[3, 1], 3), " [", round(interv[3, 1], 3), ", ", round(interv[3, 3], 3), "]", sep = ""), deprivation_p = round(tTable[3, 5], 3),
                        intercept_age_CI = paste(round(tTable[4, 1], 3), " [", round(interv[4, 1], 3), ", ", round(interv[4, 3], 3), "]", sep = ""), age_p = round(tTable[4, 5], 3))
  return(results)
}
# Same for models for models with covariates
fun_extractvalues2 <- function(x){ # For models with covariates
  interv <- matrix(unlist(intervals(x, which = "fixed")), ncol = 3)
  tTable <- summary(x)$tTable
  results <- data.frame(estimate_CI = paste(round(tTable[5, 1], 3), " [", round(interv[5, 1], 3), ", ", round(interv[5, 3], 3), "]", sep = ""), p = round(tTable[5, 5], 3))
  return(results)
}

# Initialise and read data ------------------------------------------------
setwd("~/Desktop/SleepyBrain-Analyses/")

# Require packages
require(nlme)
require(effects)
require(RColorBrewer)
cols <- brewer.pal(3,"Dark2")

# Read data
files <- list.files("~/Box Sync/Sleepy Brain/Datafiles/Presentation_logfiles/", recursive = T)
files <- files[grep(files, pattern = "FACES")] # Select only logfiles from this experiment
files <- files[grep(files, pattern = ".txt")] # Select only logfiles containing ratings
files <- files[-grep(files, pattern = "Hanna")] # Remove logfile from one piloting run

for(i in 1:length(files)){
  thisfile <- read.delim(paste("~/Box Sync/Sleepy Brain/Datafiles/Presentation_logfiles/", files[i], sep = ""), header = T)
  thisfile$file <- files[i]
  thisfile$Rating_no <- 1:length(thisfile$Rating)
  if(i == 1){
    data <- thisfile
  } else {
    data <- rbind(data, thisfile)
  }
}

# Make columns for subject and date, find session numbers
data$subject <- as.integer(substr(data$file, 1, 3))
data$date <- as.integer(substr(data$file, 5, 10))
data$session <- NA
data$block[data$file != "324_131202_Presentationlogfiles/FACES_log.txt"] <- c(1, 1, 2, 2, 3, 3, 4, 4)

for(i in unique(data$subject)){
  date1 <- min(data$date[data$subject == i])
  date2 <- max(data$date[data$subject == i])
  if(date1 < date2){
    data$session[data$subject == i & data$date == date1] <- 1
    data$session[data$subject == i & data$date == date2] <- 2
  }
  if(date1 > date2){
    data$session[data$subject == i & data$date == date1] <- 2
    data$session[data$subject == i & data$date == date2] <- 1
  }
  if(date1 == date2){
    data$session[data$subject == i & data$date == date1] <- NA
    data$session[data$subject == i & data$date == date2] <- NA
  }
}

# Retain only included subjects
subjects <- read.csv2("~/Box Sync/Sleepy Brain/Datafiles/Subjects_151215.csv")
data <- merge(data, subjects[, c("Subject", "FulfillsCriteriaAndNoPathologicalFinding", "SuccessfulIntervention", "newid")], by.x = "subject", by.y = "Subject")
data <- data[!is.na(data$FulfillsCriteriaAndNoPathologicalFinding), ]
data$session[is.na(data$session)] <- 1 # Two participants only, should be session 1 for both

# Add demographic data etc
demdata <- read.csv2("~/Box Sync/Sleepy Brain/Datafiles/demdata_160225_pseudonymized.csv")
data <- merge(data, demdata[, c("id", "AgeGroup", "Sl_cond", "IRI_EC", "PPIR_C", "ESS", "PSS14", "ECS", "PANAS_Positive", "PANAS_Negative", 
                                "PANAS_Positive_byScanner.x", "PANAS_Negative_byScanner.x", "PANAS_Positive_byScanner.y", "PANAS_Negative_byScanner.y")], by.x = "newid", by.y = "id")
data$condition <- "fullsleep"
data$condition[data$session == 1 & data$Sl_cond == 1] <- "sleepdeprived"
data$condition[data$session == 2 & data$Sl_cond == 2] <- "sleepdeprived"
data$condition <- as.factor(data$condition)
data$condition <- relevel(data$condition, ref = "fullsleep")
data$AgeGroup <- relevel(data$AgeGroup, ref = "Young")

# Write data file
#write.csv(data[, c("newid", "block", "Block_type", "Question_type", "Rating", "Response_time",                                    
#                   "session", "AgeGroup", "condition")], file = "FACES/EMG/ratings.csv", row.names = F)


# This piece of code was written to answer reviewer comments. Here we just removed the second half of the data

#data <- subset(data, Rating_no < 5)


# Analyse data ------------------------------------------------------------

# Plot results exploratorily
boxplot(Rating ~ Block_type, data = data[data$Question_type == 2, ], frame.plot = F, main = "Rated happiness", xlab = "Block type", ylab = "VAS")
boxplot(Rating ~ Block_type, data = data[data$Question_type == 3, ], frame.plot = F, main = "Rated angriness", xlab = "Block type", ylab = "VAS")
agg_happy <- aggregate(Rating ~  subject + session + Block_type + condition + AgeGroup, data = data[data$Question_type == 2, ], FUN = "mean")
agg_angry <- aggregate(Rating ~  subject + session + Block_type + condition + AgeGroup, data = data[data$Question_type == 3, ], FUN = "mean")
boxplot(Rating ~ Block_type, data = agg_happy, frame.plot = F, main = "Rated happiness", xlab = "Block type", ylab = "VAS")
boxplot(Rating ~ Block_type, data = agg_angry, frame.plot = F, main = "Rated angriness", xlab = "Block type", ylab = "VAS")

# Analyse main effects
# Contrast coding
contrasts(data$Block_type) <- c(-0.5, 0.5)
contrasts(data$condition) <- c(-0.5, 0.5)
contrasts(data$AgeGroup) <- c(-0.5, 0.5)

# Rated happiness
lme1 <- lme(Rating ~ Block_type * condition * AgeGroup, data = data[data$subject %in% subjects$SuccessfulIntervention & data$Question_type == 2, ], random = ~1|subject/session)
summary(lme1)
intervals(lme1)
plot(effect("Block_type", lme1))
plot(effect("Block_type*condition*AgeGroup", lme1))
sink(file = "FACES/Ratings/happy_regression_output.txt")
summary(lme1) 
intervals(lme1, which = "fixed")
sink()

# Rated angriness
lme2 <- lme(Rating ~ Block_type * condition * AgeGroup, data = data[data$subject %in% subjects$SuccessfulIntervention & data$Question_type == 3, ], random = ~1|subject/session)
summary(lme2)
intervals(lme2)
plot(effect("Block_type", lme2))
plot(effect("Block_type*condition*AgeGroup", lme2))
sink(file = "FACES/Ratings/angry_regression_output.txt") 
summary(lme2) 
intervals(lme2, which = "fixed")
sink()

lme2b <- lme(Rating ~ condition * AgeGroup, data = data[data$subject %in% subjects$SuccessfulIntervention & data$Question_type == 3 & data$Block_type == "Happy", ], random = ~1|subject/session)
summary(lme2b)

lme2c <- lme(Rating ~ condition * AgeGroup, data = data[data$subject %in% subjects$SuccessfulIntervention & data$Question_type == 3 & data$Block_type == "Angry", ], random = ~1|subject/session)
summary(lme2c)

# # Analyse again with difference scores to reduce model complexity
# data_angry1 <- agg_angry[agg_angry$Block_type == "Happy", ]
# data_angry2 <- agg_angry[agg_angry$Block_type == "Angry", ]
# data_diff_angry <- data_angry1
# data_diff_angry$diff <- data_diff_angry$Rating - data_angry2$Rating
# 
# data_happy1 <- agg_happy[agg_happy$Block_type == "Happy", ]
# data_happy2 <- agg_happy[agg_happy$Block_type == "Angry", ]
# data_diff_happy <- data_happy1
# data_diff_happy$diff <- data_diff_happy$Rating - data_happy2$Rating
# 
# lme1d <- lme(diff ~ condition * AgeGroup, data = data_diff_angry[data_diff_angry$subject %in% subjects$SuccessfulIntervention, ], random = ~1|subject)
# summary(lme1d)
# intervals(lme1d)
# plot(effect("condition*AgeGroup", lme1d))
# 
# lme1e <- lme(diff ~ condition, data = data_diff_angry[data_diff_angry$subject %in% subjects$SuccessfulIntervention & data_diff_angry$AgeGroup == "Young", ], random = ~1|subject)
# summary(lme1e)
# intervals(lme1e)
# plot(effect("condition", lme1e))
# 
# lme1f <- lme(diff ~ condition, data = data_diff_angry[data_diff_angry$subject %in% subjects$SuccessfulIntervention & data_diff_angry$AgeGroup == "Old", ], random = ~1|subject)
# summary(lme1f)
# intervals(lme1f)
# plot(effect("condition", lme1f))
# 
# lme2d <- lme(diff ~ condition * AgeGroup, data = data_diff_happy[data_diff_happy$subject %in% subjects$SuccessfulIntervention, ], random = ~1|subject)
# summary(lme2d)
# intervals(lme2d)
# plot(effect("condition*AgeGroup", lme2d))


# Plot model estimates
# Make objects with estimates
eff1 <- effect("Block_type*condition*AgeGroup", lme1)
eff2 <- effect("Block_type*condition*AgeGroup", lme2)

# Make plots
pdf("FACES/Ratings/Ratings.pdf", height = 5, width = 5) 
#par(mar = c(4, 5, 1, 2))

plot(1, frame.plot = F, xlim = c(0, 1), ylim = c(0, 100), xlab = "stimulus block", ylab = "VAS rating", xaxt = "n", type = "n", main = "Rated happiness, young")
axis(1, at = c(0.05, 0.95), labels = c("Happy", "Angry"))
lines(x = c(0, 0.9), y = eff1$fit[c(2, 1)], pch = 16, col = cols[2], type = "b", lwd = 1.5)
lines(x = c(0.1, 1), y = eff1$fit[c(4, 3)], pch = 15, col = cols[3], type = "b", lwd = 1.5)
lines(x = c(0, 0), y = c(eff1$lower[2], eff1$upper[2]), col = cols[2], lwd = 1.5)
lines(x = c(0.9, 0.9), y = c(eff1$lower[1], eff1$upper[1]), col = cols[2], lwd = 1.5)
lines(x = c(0.1, 0.1), y = c(eff1$lower[4], eff1$upper[4]), col = cols[3], lwd = 1.5)
lines(x = c(1, 1), y = c(eff1$lower[3], eff1$upper[3]), col = cols[3], lwd = 1.5)
legend("top", lwd = 1.5, pch = c(16, 15), legend = c("full sleep", "sleep deprivation"), col = cols[c(2, 3)], bty = "n")

plot(1, frame.plot = F, xlim = c(0, 1), ylim = c(0, 100), xlab = "stimulus block", ylab = "VAS rating", xaxt = "n", type = "n", main = "Rated happiness, older")
axis(1, at = c(0.05, 0.95), labels = c("Happy", "Angry"))
lines(x = c(0, 0.9), y = eff1$fit[c(6, 5)], pch = 16, col = cols[2], type = "b", lwd = 1.5)
lines(x = c(0.1, 1), y = eff1$fit[c(8, 7)], pch = 15, col = cols[3], type = "b", lwd = 1.5)
lines(x = c(0, 0), y = c(eff1$lower[6], eff1$upper[6]), col = cols[2], lwd = 1.5)
lines(x = c(0.9, 0.9), y = c(eff1$lower[5], eff1$upper[5]), col = cols[2], lwd = 1.5)
lines(x = c(0.1, 0.1), y = c(eff1$lower[8], eff1$upper[8]), col = cols[3], lwd = 1.5)
lines(x = c(1, 1), y = c(eff1$lower[7], eff1$upper[7]), col = cols[3], lwd = 1.5)
legend("top", lwd = 1.5, pch = c(16, 15), legend = c("full sleep", "sleep deprivation"), col = cols[c(2, 3)], bty = "n")

plot(1, frame.plot = F, xlim = c(0, 1), ylim = c(0, 100), xlab = "stimulus block", ylab = "VAS rating", xaxt = "n", type = "n", main = "Rated angriness, young")
axis(1, at = c(0.05, 0.95), labels = c("Happy", "Angry"))
lines(x = c(0, 0.9), y = eff2$fit[c(2, 1)], pch = 16, col = cols[2], type = "b", lwd = 1.5)
lines(x = c(0.1, 1), y = eff2$fit[c(4, 3)], pch = 15, col = cols[3], type = "b", lwd = 1.5)
lines(x = c(0, 0), y = c(eff2$lower[2], eff2$upper[2]), col = cols[2], lwd = 1.5)
lines(x = c(0.9, 0.9), y = c(eff2$lower[1], eff2$upper[1]), col = cols[2], lwd = 1.5)
lines(x = c(0.1, 0.1), y = c(eff2$lower[4], eff2$upper[4]), col = cols[3], lwd = 1.5)
lines(x = c(1, 1), y = c(eff2$lower[3], eff2$upper[3]), col = cols[3], lwd = 1.5)
legend("top", lwd = 1.5, pch = c(16, 15), legend = c("full sleep", "sleep deprivation"), col = cols[c(2, 3)], bty = "n")

plot(1, frame.plot = F, xlim = c(0, 1), ylim = c(0, 100), xlab = "stimulus block", ylab = "VAS rating", xaxt = "n", type = "n", main = "Rated angriness, older")
axis(1, at = c(0.05, 0.95), labels = c("Happy", "Angry"))
lines(x = c(0, 0.9), y = eff2$fit[c(6, 5)], pch = 16, col = cols[2], type = "b", lwd = 1.5)
lines(x = c(0.1, 1), y = eff2$fit[c(8, 7)], pch = 15, col = cols[3], type = "b", lwd = 1.5)
lines(x = c(0, 0), y = c(eff2$lower[6], eff2$upper[6]), col = cols[2], lwd = 1.5)
lines(x = c(0.9, 0.9), y = c(eff2$lower[5], eff2$upper[5]), col = cols[2], lwd = 1.5)
lines(x = c(0.1, 0.1), y = c(eff2$lower[8], eff2$upper[8]), col = cols[3], lwd = 1.5)
lines(x = c(1, 1), y = c(eff2$lower[7], eff2$upper[7]), col = cols[3], lwd = 1.5)
legend("top", lwd = 1.5, pch = c(16, 15), legend = c("full sleep", "sleep deprivation"), col = cols[c(2, 3)], bty = "n")

dev.off()

# Analyse covariates
# Read KSS data
KSS_FACES <- read_csv2("~/Box Sync/Sleepy Brain/Datafiles/KSS_FACES.csv")
# Read sleep data
siesta_data <- read_csv2("~/Box Sync/Sleepy Brain/Datafiles/siesta_FACES.csv")

data <- merge(data, KSS_FACES, all.x = T)
data <- merge(data, siesta_data, by.x = c("newid", "condition"), by.y = c("id", "condition"), all.x = T)

# Define covariates
covariates_across <- c("IRI_EC", "PPIR_C", "ESS", "PSS14", "ECS", "PANAS_Positive", "PANAS_Negative") # Trait measures in participants, wchich should be investigated across conditions
# Ratings on ESS, PSS14, and ECS were added post hoc to harmonize with other outcomes, for which they were investigated as predictors

covariates_within <- c("KSS_Rating", "tst", "rem", "rem_p", "n3", "n3_p") # TODO: check variable selection
# slow wave sleep (SWS), slow wave energy (SWE), slow wave activity (SWA), REM sleep time, and predicted by prefrontal (Fp1 + Fp2) gamma activity in REM sleep.


# Prefrontal (Fp1 + Fp2) gamma (30-40 Hz) in REM sleep was also specified but this variable does not exist


# Analyse effects of sleep deprivation, age group, and covariates
# Initialise output objects
lme_nocovariates_list <- list()
lme_covariates_across_list <- list()
lme_covariates_within_fullsleep_list <- list()
lme_covariates_within_sleepdeprived_list <- list()
# Loop over dependent variables (SPM contrasts)
for(i in 1:2){
  # Main analyses without covariates
  fml <- as.formula(paste("Rating ~ Block_type * condition * AgeGroup"))
  this_lm_nocovariate <- lme(fml, 
                             data = data[data$subject %in% subjects$SuccessfulIntervention & data$Question_type == i+1, ], 
                             random = ~1|subject/session, na.action = na.omit)
  lme_nocovariates_list[[i]] <- this_lm_nocovariate
  print(unique(data[data$Question_type == i+1, ]$Question_type))
  
  # Loop over covariates across conditions
  for(j in 1:length(covariates_across)){
    thisindex <- (i-1)*length(covariates_across) + j
    fml <- as.formula(paste("Rating ~ Block_type * condition * AgeGroup +", paste(covariates_across[j])))
    this_lm_covariate <- lme(fml, data = data[data$subject %in% subjects$SuccessfulIntervention & data$Question_type == i+1, ], 
                             random = ~1|subject/session, na.action = na.omit)
    lme_covariates_across_list[[thisindex]] <- this_lm_covariate
    print(paste(covariates_across[j]))
  }
  
  # Loop over covariates within conditions
  for(j in 1:length(covariates_within)){
    thisindex2 <- (i-1)*length(covariates_within) + j
    fml <- as.formula(paste("Rating ~ Block_type * AgeGroup +", paste(covariates_within[j])))
    this_lm_covariate <- lme(fml, 
                             data = data[data$subject %in% subjects$SuccessfulIntervention & data$Question_type == i+1 & data$condition == "fullsleep", ], 
                             random = ~1|subject/session, na.action = na.omit)
    lme_covariates_within_fullsleep_list[[thisindex2]] <- this_lm_covariate
    
    fml2 <- as.formula(paste("Rating ~ Block_type * AgeGroup +", paste(covariates_within[j])))
    this_lm_covariate2 <- lme(fml2, 
                              data = data[data$subject %in% subjects$SuccessfulIntervention & data$Question_type == i+1 & data$condition == "sleepdeprived", ], 
                              random = ~1|subject/session, na.action = na.omit)
    lme_covariates_within_sleepdeprived_list[[thisindex2]] <- this_lm_covariate2
  }
}


# Write results to a table
for(i in 1:2){
  if (i == 1){
    lme_results_ratings_nocovariates <- fun_extractvalues1(lme_nocovariates_list[[i]])
  } else {
    lme_results_ratings_nocovariates <- rbind(lme_results_ratings_nocovariates, fun_extractvalues1(lme_nocovariates_list[[i]]))
  }
}

rownames(lme_results_ratings_nocovariates) <- c("Rated_happiness", "Rated_angriness")
write.csv(lme_results_ratings_nocovariates, "~/Desktop/SleepyBrain-Analyses/FACES/Ratings/results_ratings_nocovariates.csv")
# p-values for prespecified directional analyses should be changed manually to one-sided

for(i in 1:length(lme_covariates_across_list)){
  if (i == 1){
    lme_results_ratings_covariates_across <- fun_extractvalues2(lme_covariates_across_list[[i]])
  } else {
    lme_results_ratings_covariates_across <- rbind(lme_results_ratings_covariates_across, fun_extractvalues2(lme_covariates_across_list[[i]]))
  }
}

# This needs to be checked
lme_results_ratings_covariates_across$dependent_var <- rep(c("Happy", "Angry"), each = length(lme_results_ratings_covariates_across$estimate_CI)/2)
lme_results_ratings_covariates_across$covariate <- covariates_across
#lme_results_ratings_covariates_across <- reshape(lme_results_ratings_covariates_across, direction = "wide", v.names = c("estimate_CI", "p"), timevar = "covariate", idvar = "dependent_var")
write.csv2(lme_results_ratings_covariates_across, "~/Desktop/SleepyBrain-Analyses/FACES/Ratings/results_ratings_covariates_across.csv", row.names = F)


# # Write datafile with aggregated ratings by participant
# data_diff_angry2 <- data_diff_angry[data_diff_angry$condition == "fullsleep", ]
# data_diff_happy2 <- data_diff_happy[data_diff_happy$condition == "fullsleep", ]
# data_diff2 <- merge(data_diff_angry2[, c("subject", "diff")], data_diff_happy2[, c("subject", "diff")], by = "subject")
# names(data_diff2) <- c("id", "diff_angry", "diff_happy")
# plot(diff_happy ~ diff_angry, data = data_diff2, main = "Diff happy blocks vs angry blocks", frame.plot = F)
# lm_diff <- lm(diff_happy ~ diff_angry, data = data_diff2)
# abline(lm_diff, col = "red")
# cor.test(data_diff2$diff_angry, data_diff2$diff_happy)
# subjectlist <- read.csv2("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/Subjects_151215.csv")
# data_diff3 <- merge(data_diff2, subjectlist[, c("Subject", "newid")], by.x = "id", by.y = "Subject")
# write.csv(data_diff3[, -1], "rated_anger_happiness_diff.csv", row.names = FALSE)

# Analyse habituation
setwd("~/Desktop/SleepyBrain-Analyses/FACES/Ratings/")
pdf("plots_habituation_happiness.pdf")
plot(1, frame.plot = F, xlim = c(0, 5), ylim = c(0, 100), xlab = "Block", ylab = "VAS rating", type = "n", main = "Rated happiness")
points(Rating ~ block, subset(data, data$Question_type == 2 & Block_type == "Happy"), col = "red")
points(Rating ~ block, subset(data, data$Question_type == 2 & Block_type == "Angry"), col = "blue")
abline(lm(Rating ~ block, subset(data, data$Question_type == 2 & Block_type == "Happy")), col = "red")
abline(lm(Rating ~ block, subset(data, data$Question_type == 2 & Block_type == "Angry")), col = "blue")
legend("topleft",  pch = c(1, 1), legend = c("Happy", "Angry"), col = cols[c(2, 3)], bty = "n")
dev.off()

pdf("plots_habituation_angriness.pdf")
plot(1, frame.plot = F, xlim = c(0, 5), ylim = c(0, 100), xlab = "Block", ylab = "VAS rating", type = "n", main = "Rated angriness")
points(Rating ~ block, subset(data, data$Question_type == 3 & Block_type == "Happy"), col = "red")
points(Rating ~ block, subset(data, data$Question_type == 3 & Block_type == "Angry"), col = "blue")
abline(lm(Rating ~ block, subset(data, data$Question_type == 3 & Block_type == "Happy")), col = "red")
abline(lm(Rating ~ block, subset(data, data$Question_type == 3 & Block_type == "Angry")), col = "blue")
legend("topleft",  pch = c(1, 1), legend = c("Happy", "Angry"), col = cols[c(2, 3)], bty = "n")
dev.off()

lme_hab_happy <- lme(Rating ~ condition * AgeGroup + Block_type * block, data = data[data$Question_type == 2, ], random = ~1|subject/session)
summary(lme_hab_happy)
intervals(lme_hab_happy)
sink(file = "results_ratings_habituation_happiness.txt") 
summary(lme_hab_happy) 
intervals(lme_hab_happy, which = "fixed")
sink()

lme_hab_angry <- lme(Rating ~ condition * AgeGroup * Block_type + block, data = data[data$Question_type == 3, ], random = ~1|subject/session)
summary(lme_hab_angry)
intervals(lme_hab_angry)
sink(file = "results_ratings_habituation_angriness.txt") 
summary(lme_hab_angry) 
intervals(lme_hab_angry, which = "fixed")
sink()

