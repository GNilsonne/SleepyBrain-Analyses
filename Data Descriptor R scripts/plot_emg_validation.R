data <- read.delim("~/Git Sleepy Brain/SleepyBrain-Analyses/Data Descriptor R scripts/FACES_1_processed_for_illustration_of_methods_cutout.txt", header=FALSE)
data2 <- data[data$V1 > 4.32 & data$V1 < 4.44, ]

#par(mar = c(1, 1, 0, 0))
pdf("EMG_validation.pdf", width = 10, height = 4)
plot(V2 ~ V1, data2, type = "l", frame.plot = F, xlab = "time (s)", ylab = "mV", xaxt = "n")
axis(1, at = c(4.32, 4.38, 4.44), labels = c(0, 1, 2))
plot(V3 ~ V1, data2, type = "l", frame.plot = F, xlab = "time (s)", ylab = "mV", xaxt = "n")
axis(1, at = c(4.32, 4.38, 4.44), labels = c(0, 1, 2))
plot(V4 ~ V1, data2, type = "l", frame.plot = F, xlab = "time (s)", ylab = "mV", xaxt = "n")
axis(1, at = c(4.32, 4.38, 4.44), labels = c(0, 1, 2))
plot(V6 ~ V1, data2, type = "l", frame.plot = F, xlab = "time (s)", ylab = "mV", xaxt = "n")
axis(1, at = c(4.32, 4.38, 4.44), labels = c(0, 1, 2))
dev.off()