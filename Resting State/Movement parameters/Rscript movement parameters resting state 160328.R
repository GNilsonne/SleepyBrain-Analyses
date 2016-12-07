# Script to analyse and plot realignment parameters for data descriptor paper
# By Gustav Nilsonne 2016-03-28
# Only participants meeting criteria of fewer than 40 volumes with FD > 0.5 are included here

# Require packages
require(RColorBrewer)

# Read data
FDdata <- read.csv2("FD_160328_pseudonymized.csv")
FDmeans <- aggregate(cbind(FD_S1, FD_S2, FD_S3, FD_S4) ~ id, data = FDdata, mean)
demdata <- read.csv2("demdata_160225_pseudonymized.csv")

# Determine number of interpolated volumes, analyse and plot
FDdata$S1ex <- FDdata$FD_S1 > 0.5
FDdata$S2ex <- FDdata$FD_S2 > 0.5
FDdata$S3ex <- FDdata$FD_S3 > 0.5
FDdata$S4ex <- FDdata$FD_S4 > 0.5

FDex <- aggregate(cbind(S1ex, S2ex, S3ex, S4ex) ~ id, data = FDdata, sum)
FDex <- merge(FDex, demdata, by = "id")

FDex$S1_PSD[FDex$Sl_cond == 1] <- FDex$S1ex[FDex$Sl_cond == 1]
FDex$S1_PSD[FDex$Sl_cond == 2] <- FDex$S2ex[FDex$Sl_cond == 2]
FDex$S1_Full[FDex$Sl_cond == 2] <- FDex$S1ex[FDex$Sl_cond == 2]
FDex$S1_Full[FDex$Sl_cond == 1] <- FDex$S2ex[FDex$Sl_cond == 1]
FDex$S3_PSD[FDex$Sl_cond == 1] <- FDex$S3ex[FDex$Sl_cond == 1]
FDex$S3_PSD[FDex$Sl_cond == 2] <- FDex$S4ex[FDex$Sl_cond == 2]
FDex$S3_Full[FDex$Sl_cond == 2] <- FDex$S3ex[FDex$Sl_cond == 2]
FDex$S3_Full[FDex$Sl_cond == 1] <- FDex$S4ex[FDex$Sl_cond == 1]

pdf("fig2a.pdf", height = 5, width = 5) 
par(mar = c(4, 4, 0, 0))
hist(FDex$S1_Full, breaks = c(0, 5, 10, 15, 20, 25, 30, 35), ylim = c(0, 42), main = "", xlab = "Interpolated volumes", col = "gray")
dev.off()
pdf("fig2b.pdf", height = 5, width = 5) 
par(mar = c(4, 4, 0, 0))
hist(FDex$S1_PSD, breaks = c(0, 5, 10, 15, 20, 25, 30, 35), ylim = c(0, 42), main = "", xlab = "Interpolated volumes", col = "gray")
dev.off()
pdf("fig2c.pdf", height = 5, width = 5) 
par(mar = c(4, 4, 0, 0))
hist(FDex$S3_Full, breaks = c(0, 5, 10, 15, 20, 25, 30, 35), ylim = c(0, 42), main = "", xlab = "Interpolated volumes", col = "gray")
dev.off()
pdf("fig2d.pdf", height = 5, width = 5) 
par(mar = c(4, 4, 0, 0))
hist(FDex$S3_PSD, breaks = c(0, 5, 10, 15, 20, 25, 30, 35), ylim = c(0, 42), main = "", xlab = "Interpolated volumes", col = "gray")
dev.off()

t.test(FDex$S1_Full, FDex$S1_PSD, paired = T)
t.test(FDex$S3_Full, FDex$S3_PSD, paired = T)
t.test(FDex$S1_Full, FDex$S3_Full, paired = T)
t.test(FDex$S1_PSD, FDex$S3_PSD, paired = T)


# Determine mean displacement and plot
FDmeans <- merge(FDmeans, demdata, by = "id")

FDmeans$S1_PSD[FDmeans$Sl_cond == 1] <- FDmeans$FD_S1[FDmeans$Sl_cond == 1]
FDmeans$S1_PSD[FDmeans$Sl_cond == 2] <- FDmeans$FD_S2[FDmeans$Sl_cond == 2]
FDmeans$S1_Full[FDmeans$Sl_cond == 2] <- FDmeans$FD_S1[FDmeans$Sl_cond == 2]
FDmeans$S1_Full[FDmeans$Sl_cond == 1] <- FDmeans$FD_S2[FDmeans$Sl_cond == 1]

FDmeans$S3_PSD[FDmeans$Sl_cond == 1] <- FDmeans$FD_S3[FDmeans$Sl_cond == 1]
FDmeans$S3_PSD[FDmeans$Sl_cond == 2] <- FDmeans$FD_S4[FDmeans$Sl_cond == 2]
FDmeans$S3_Full[FDmeans$Sl_cond == 2] <- FDmeans$FD_S3[FDmeans$Sl_cond == 2]
FDmeans$S3_Full[FDmeans$Sl_cond == 1] <- FDmeans$FD_S4[FDmeans$Sl_cond == 1]

cols <- brewer.pal(n = 3, name = "Dark2")

pdf("fig2e.pdf", height = 5, width = 5) 
par(mar = c(4, 4, 0, 0))
plot(S1_PSD ~ S1_Full, data = FDmeans, frame.plot = F, xlim = c(0, 0.4), ylim = c(0, 0.4), xlab = "Mean framewise displacement (mm), Full sleep", ylab = "Mean framewise displacement (mm), Sleep deprived", type = "n")
lines(x = c(0, 0.4), y = c(0, 0.4), col = "gray")
points(S1_PSD ~ S1_Full, data = FDmeans[FDmeans$AgeGroup == "Young", ], col = cols[3], pch = 16)
points(S1_PSD ~ S1_Full, data = FDmeans[FDmeans$AgeGroup == "Old", ], col = cols[2], pch = 16)
dev.off()

pdf("fig2f.pdf", height = 5, width = 5) 
par(mar = c(4, 4, 0, 0))
plot(S3_PSD ~ S3_Full, data = FDmeans, frame.plot = F, xlim = c(0, 0.4), ylim = c(0, 0.4), xlab = "Mean framewise displacement (mm), Full sleep", ylab = "Mean framewise displacement (mm), Sleep deprived", type = "n")
lines(x = c(0, 0.4), y = c(0, 0.4), col = "gray")
points(S3_PSD ~ S3_Full, data = FDmeans[FDmeans$AgeGroup == "Young", ], col = cols[3], pch = 16)
points(S3_PSD ~ S3_Full, data = FDmeans[FDmeans$AgeGroup == "Old", ], col = cols[2], pch = 16)
dev.off()

# Analyse differences between groups
FDex$AgeGroup <- relevel(FDex$AgeGroup, ref = "Young")
lm1 <- lm(S1_Full ~ AgeGroup, data = FDex)
summary(lm1)
confint(lm1)
lm2 <- lm(S1_PSD ~ AgeGroup, data = FDex)
summary(lm2)
confint(lm2)
lm3 <- lm(S3_Full ~ AgeGroup, data = FDex)
summary(lm3)
confint(lm3)
lm4 <- lm(S3_PSD ~ AgeGroup, data = FDex)
summary(lm4)
confint(lm4)

FDmeans$AgeGroup <- relevel(FDmeans$AgeGroup, ref = "Young")
lm1 <- lm(S1_Full ~ AgeGroup, data = FDmeans)
summary(lm1)
lm2 <- lm(S1_PSD ~ AgeGroup, data = FDmeans)
summary(lm2)
lm3 <- lm(S3_Full ~ AgeGroup, data = FDmeans)
summary(lm3)
lm4 <- lm(S3_PSD ~ AgeGroup, data = FDmeans)
summary(lm4)
