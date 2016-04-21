# Script to validate blinding and design balance

# Read data
demdata <- read.csv("~/Git Sleepy Brain/SleepyBrain-Analyses/demdata_160225_pseudonymized.csv", sep=";", dec=",")

# Analyse efficacy of blinding
demdata$SleepDeprivedSession1[demdata$SleepDeprivedSession1 == ""] <- NA
demdata$SleepDeprivedSession2[demdata$SleepDeprivedSession2 == ""] <- NA
demdata$SleepDeprivedSession1 <- ordered(demdata$SleepDeprivedSession1, levels = c("SurelyNot", "LikelyNot", "Equivocal", "Likely", "Surely"))
demdata$SleepDeprivedSession2 <- ordered(demdata$SleepDeprivedSession2, levels = c("SurelyNot", "LikelyNot", "Equivocal", "Likely", "Surely"))

demdata$SleepDeprived_deprived <- demdata$SleepDeprivedSession1
demdata$SleepDeprived_deprived[demdata$Sl_cond == 2] <- demdata$SleepDeprivedSession2[demdata$Sl_cond == 2]
demdata$SleepDeprived_full <- demdata$SleepDeprivedSession2
demdata$SleepDeprived_full[demdata$Sl_cond == 2] <- demdata$SleepDeprivedSession1[demdata$Sl_cond == 2]

tab3 <- table(demdata$AgeGroup, demdata$SleepDeprived_deprived)
tab4 <- table(demdata$AgeGroup, demdata$SleepDeprived_full)
tab5 <- table(demdata$SleepDeprived_full)
tab6 <- table(demdata$SleepDeprived_deprived)
tab7 <- rbind(tab5, tab6)

pdf("blinding.pdf")
barplot(tab7, beside = T, main = "", col = rev(grey.colors(2)), ylim = c(0, 40), cex.axis = 1.5, cex = 1.3)
legend("topleft", legend = c("Full sleep", "Sleep deprived"), bty = "n", fill = rev(grey.colors(2)), cex = 1.4)
dev.off()

t.test(as.numeric(demdata$SleepDeprived_full), as.numeric(demdata$SleepDeprived_deprived), na.action = "na.omit", paired = T)

# Analyse design balance
table(demdata$Sl_cond, demdata$AgeGroup)
# Participant 9015/500 is not included here, she had condition 2 (young)
# Participant 