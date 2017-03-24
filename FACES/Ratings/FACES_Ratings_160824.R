# Participant ratings

# Require packages
require(nlme)
require(effects)
require(RColorBrewer)
cols <- brewer.pal(3,"Dark2")

# Read data
files <- list.files("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/Presentation_logfiles/", recursive = T)
files <- files[grep(files, pattern = "FACES")] # Select only logfiles from this experiment
files <- files[grep(files, pattern = ".txt")] # Select only logfiles containing ratings
files <- files[-grep(files, pattern = "Hanna")] # Remove logfile from one piloting run

for(i in 1:length(files)){
  thisfile <- read.delim(paste("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/Presentation_logfiles/", files[i], sep = ""), header = T)
  thisfile$file <- files[i]
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
subjects <- read.csv2("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/Subjects_151215.csv")
data <- merge(data, subjects[, c("Subject", "FulfillsCriteriaAndNoPathologicalFinding", "SuccessfulIntervention", "newid")], by.x = "subject", by.y = "Subject")
data <- data[!is.na(data$FulfillsCriteriaAndNoPathologicalFinding), ]
data$session[is.na(data$session)] <- 1 # Two participants only, should be session 1 for both

# Add demographic data etc
demdata <- read.csv2("C:/Users/Gustav Nilsonne/Box Sync/Sleepy Brain/Datafiles/demdata_160225_pseudonymized.csv")
data <- merge(data, demdata[, c("id", "AgeGroup", "Sl_cond")], by.x = "newid", by.y = "id")
data$condition <- "fullsleep"
data$condition[data$session == 1 & data$Sl_cond == 1] <- "sleepdeprived"
data$condition[data$session == 2 & data$Sl_cond == 2] <- "sleepdeprived"
data$condition <- as.factor(data$condition)
data$condition <- relevel(data$condition, ref = "fullsleep")
data$AgeGroup <- relevel(data$AgeGroup, ref = "Young")

# Plot results
boxplot(Rating ~ Block_type, data = data[data$Question_type == 2, ], frame.plot = F, main = "Rated happiness", xlab = "Block type", ylab = "VAS")
boxplot(Rating ~ Block_type, data = data[data$Question_type == 3, ], frame.plot = F, main = "Rated angriness", xlab = "Block type", ylab = "VAS")
agg_happy <- aggregate(Rating ~  subject + session + Block_type + condition + AgeGroup, data = data[data$Question_type == 2, ], FUN = "mean")
agg_angry <- aggregate(Rating ~  subject + session + Block_type + condition + AgeGroup, data = data[data$Question_type == 3, ], FUN = "mean")
boxplot(Rating ~ Block_type, data = agg_happy, frame.plot = F, main = "Rated happiness", xlab = "Block type", ylab = "VAS")
boxplot(Rating ~ Block_type, data = agg_angry, frame.plot = F, main = "Rated angriness", xlab = "Block type", ylab = "VAS")

# Analyse main effects
lme1 <- lme(Rating ~ Block_type * condition * AgeGroup, data = data[data$subject %in% subjects$SuccessfulIntervention & data$Question_type == 2, ], random = ~1|subject/session)
summary(lme1)
intervals(lme1)
plot(effect("Block_type", lme1))
plot(effect("Block_type*condition*AgeGroup", lme1))
plot(effect("condition*AgeGroup", lme1))

lme2 <- lme(Rating ~ Block_type * condition * AgeGroup, data = data[data$subject %in% subjects$SuccessfulIntervention & data$Question_type == 3, ], random = ~1|subject/session)
summary(lme2)
intervals(lme2)
plot(effect("Block_type", lme2))
plot(effect("Block_type*condition*AgeGroup", lme2))

lme2b <- lme(Rating ~ Block_type * condition, data = data[data$subject %in% subjects$SuccessfulIntervention & data$Question_type == 3 & data$AgeGroup == "Young", ], random = ~1|subject/session)
summary(lme2b)
intervals(lme2b)
plot(effect("Block_type", lme2b))
plot(effect("Block_type*condition", lme2b))

lme2c <- lme(Rating ~ Block_type * condition, data = data[data$subject %in% subjects$SuccessfulIntervention & data$Question_type == 3 & data$AgeGroup == "Old", ], random = ~1|subject/session)
summary(lme2c)
intervals(lme2c)
plot(effect("Block_type", lme2c))
plot(effect("Block_type*condition", lme2c))

# Analyse again with difference scores to reduce model complexity
data_angry1 <- agg_angry[agg_angry$Block_type == "Happy", ]
data_angry2 <- agg_angry[agg_angry$Block_type == "Angry", ]
data_diff_angry <- data_angry1
data_diff_angry$diff <- data_diff_angry$Rating - data_angry2$Rating

data_happy1 <- agg_happy[agg_happy$Block_type == "Happy", ]
data_happy2 <- agg_happy[agg_happy$Block_type == "Angry", ]
data_diff_happy <- data_happy1
data_diff_happy$diff <- data_diff_happy$Rating - data_happy2$Rating

lme1d <- lme(diff ~ condition * AgeGroup, data = data_diff_angry[data_diff_angry$subject %in% subjects$SuccessfulIntervention, ], random = ~1|subject)
summary(lme1d)
intervals(lme1d)
plot(effect("condition*AgeGroup", lme1d))

lme1e <- lme(diff ~ condition , data = data_diff_angry[data_diff_angry$subject %in% subjects$SuccessfulIntervention & data_diff_angry$AgeGroup == "Young", ], random = ~1|subject)
summary(lme1e)
intervals(lme1e)
plot(effect("condition", lme1e))

lme1f <- lme(diff ~ condition, data = data_diff_angry[data_diff_angry$subject %in% subjects$SuccessfulIntervention & data_diff_angry$AgeGroup == "Old", ], random = ~1|subject)
summary(lme1f)
intervals(lme1f)
plot(effect("condition", lme1f))


lme2d <- lme(diff ~ condition * AgeGroup, data = data_diff_happy[data_diff_happy$subject %in% subjects$SuccessfulIntervention, ], random = ~1|subject)
summary(lme2d)
intervals(lme2d)
plot(effect("condition*AgeGroup", lme2d))


# Plot model estimates
pdf("Ratings1.pdf", height = 5, width = 5) 
par(mar = c(4, 5, 1, 2))
plot(1, frame.plot = F, xlim = c(0, 1), ylim = c(-30, 0), xlab = "", ylab = expression(paste(delta, " VAS")), xaxt = "n", type = "n", main = "Rated feeling of angriness")
axis(1, at = c(0.05, 0.95), labels = c("Full sleep", "Sleep deprived"))
lines(x = c(0, 0.9), y = effect("condition*AgeGroup", lme1d)$fit[1:2], pch = 16, col = cols[3], type = "b", lwd = 1.5)
lines(x = c(0.1, 1), y = effect("condition*AgeGroup", lme1d)$fit[3:4], pch = 16, col = cols[2], type = "b", lwd = 1.5)
lines(x = c(0, 0), y = c(effect("condition*AgeGroup", lme1d)$lower[1], effect("condition*AgeGroup", lme1d)$upper[1]), col = cols[3], lwd = 1.5)
lines(x = c(0.9, 0.9), y = c(effect("condition*AgeGroup", lme1d)$lower[2], effect("condition*AgeGroup", lme1d)$upper[2]), col = cols[3], lwd = 1.5)
lines(x = c(0.1, 0.1), y = c(effect("condition*AgeGroup", lme1d)$lower[3], effect("condition*AgeGroup", lme1d)$upper[3]), col = cols[2], lwd = 1.5)
lines(x = c(1, 1), y = c(effect("condition*AgeGroup", lme1d)$lower[4], effect("condition*AgeGroup", lme1d)$upper[4]), col = cols[2], lwd = 1.5)
#legend("top", lty = 1, lwd = 1.5, pch = 16, col = cols[3:2], legend = c("Younger", "Older"), bty = "n")
dev.off()

pdf("Ratings2.pdf", height = 5, width = 5) 
par(mar = c(4, 5, 1, 2))
plot(1, frame.plot = F, xlim = c(0, 1), ylim = c(10, 35), xlab = "", ylab = expression(paste(delta, " VAS")), xaxt = "n", type = "n", main = "Rated feeling of happiness")
axis(1, at = c(0.05, 0.95), labels = c("Full sleep", "Sleep deprived"))
lines(x = c(0, 0.9), y = effect("condition*AgeGroup", lme2d)$fit[1:2], pch = 16, col = cols[3], type = "b", lwd = 1.5)
lines(x = c(0.1, 1), y = effect("condition*AgeGroup", lme2d)$fit[3:4], pch = 16, col = cols[2], type = "b", lwd = 1.5)
lines(x = c(0, 0), y = c(effect("condition*AgeGroup", lme2d)$lower[1], effect("condition*AgeGroup", lme2d)$upper[1]), col = cols[3], lwd = 1.5)
lines(x = c(0.9, 0.9), y = c(effect("condition*AgeGroup", lme2d)$lower[2], effect("condition*AgeGroup", lme2d)$upper[2]), col = cols[3], lwd = 1.5)
lines(x = c(0.1, 0.1), y = c(effect("condition*AgeGroup", lme2d)$lower[3], effect("condition*AgeGroup", lme2d)$upper[3]), col = cols[2], lwd = 1.5)
lines(x = c(1, 1), y = c(effect("condition*AgeGroup", lme2d)$lower[4], effect("condition*AgeGroup", lme2d)$upper[4]), col = cols[2], lwd = 1.5)
legend("top", lty = 1, lwd = 1.5, pch = 16, col = cols[3:2], legend = c("Younger", "Older"), bty = "n")
dev.off()


# Write datafile with aggregated ratings by participant
data_diff_angry2 <- data_diff_angry[data_diff_angry$condition == "fullsleep", ]
data_diff_happy2 <- data_diff_happy[data_diff_happy$condition == "fullsleep", ]

data_diff2 <- merge(data_diff_angry2[, c("subject", "diff")], data_diff_happy2[, c("subject", "diff")], by = "subject")
names(data_diff2) <- c("id", "diff_angry", "diff_happy")
plot(diff_happy ~ diff_angry, data = data_diff2, main = "Diff happy blocks vs angry blocks", frame.plot = F)
lm_diff <- lm(diff_happy ~ diff_angry, data = data_diff2)
abline(lm_diff, col = "red")
cor.test(data_diff2$diff_angry, data_diff2$diff_happy)
write.csv(data_diff2, "rated_anger_happiness_diff.csv", row.names = FALSE)