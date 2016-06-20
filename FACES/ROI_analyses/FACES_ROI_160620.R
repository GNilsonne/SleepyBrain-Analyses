setwd("~/Git Sleepy Brain/SleepyBrain-Analyses/FACES/ROI_analyses")

# Amygdala
L_fullsleep <- read.csv("amygdala_ROI_betas_L_fullsleep.csv", sep=";", dec=",")
R_fullsleep <- read.csv("amygdala_ROI_betas_R_fullsleep.csv", sep=";", dec=",")
L_sleepdeprived <- read.csv("amygdala_ROI_betas_L_sleepdeprived.csv", sep=";", dec=",")
R_sleepdeprived <- read.csv("amygdala_ROI_betas_R_sleepdeprived.csv", sep=";", dec=",")

boxplot(L_fullsleep$X.HA.AN.NE., L_sleepdeprived$X.HA.AN.NE., frame.plot = F, names = c("full sleep", "sleep deprived"), main = "All faces")
t.test(L_fullsleep$X.HA.AN.NE., L_sleepdeprived$X.HA.AN.NE., paired = T)
boxplot(R_fullsleep$X.HA.AN.NE., R_sleepdeprived$X.HA.AN.NE., frame.plot = F, names = c("full sleep", "sleep deprived"), main = "All faces")
t.test(R_fullsleep$X.HA.AN.NE., R_sleepdeprived$X.HA.AN.NE., paired = T)

boxplot(L_fullsleep$X.HA_NE., L_sleepdeprived$X.HA_NE., frame.plot = F, names = c("full sleep", "sleep deprived"), main = "Happy vs neutral")
t.test(L_fullsleep$X.HA_NE., L_sleepdeprived$X.HA_NE., paired = T)
boxplot(R_fullsleep$X.HA_NE., R_sleepdeprived$X.HA_NE., frame.plot = F, names = c("full sleep", "sleep deprived"), main = "Happy vs neutral")
t.test(R_fullsleep$X.HA_NE., R_sleepdeprived$X.HA_NE., paired = T)

boxplot(L_fullsleep$X.AN_NE., L_sleepdeprived$X.AN_NE., frame.plot = F, names = c("full sleep", "sleep deprived"), main = "Angry vs neutral")
t.test(L_fullsleep$X.AN_NE., L_sleepdeprived$X.AN_NE., paired = T)
boxplot(R_fullsleep$X.AN_NE., R_sleepdeprived$X.AN_NE., frame.plot = F, names = c("full sleep", "sleep deprived"), main = "Angry vs neutral")
t.test(R_fullsleep$X.AN_NE., R_sleepdeprived$X.AN_NE., paired = T)

# FFA
L_fullsleep <- read.csv("FFA_ROI_betas_L_fullsleep.csv", sep=";", dec=",")
R_fullsleep <- read.csv("FFA_ROI_betas_R_fullsleep.csv", sep=";", dec=",")
L_sleepdeprived <- read.csv("FFA_ROI_betas_L_sleepdeprived.csv", sep=";", dec=",")
R_sleepdeprived <- read.csv("FFA_ROI_betas_R_sleepdeprived.csv", sep=";", dec=",")

boxplot(L_fullsleep$X.HA.AN.NE., L_sleepdeprived$X.HA.AN.NE., frame.plot = F, names = c("full sleep", "sleep deprived"), main = "All faces")
t.test(L_fullsleep$X.HA.AN.NE., L_sleepdeprived$X.HA.AN.NE., paired = T)
boxplot(R_fullsleep$X.HA.AN.NE., R_sleepdeprived$X.HA.AN.NE., frame.plot = F, names = c("full sleep", "sleep deprived"), main = "All faces")
t.test(R_fullsleep$X.HA.AN.NE., R_sleepdeprived$X.HA.AN.NE., paired = T)

boxplot(L_fullsleep$X.HA_NE., L_sleepdeprived$X.HA_NE., frame.plot = F, names = c("full sleep", "sleep deprived"), main = "Happy vs neutral")
t.test(L_fullsleep$X.HA_NE., L_sleepdeprived$X.HA_NE., paired = T)
boxplot(R_fullsleep$X.HA_NE., R_sleepdeprived$X.HA_NE., frame.plot = F, names = c("full sleep", "sleep deprived"), main = "Happy vs neutral")
t.test(R_fullsleep$X.HA_NE., R_sleepdeprived$X.HA_NE., paired = T)

boxplot(L_fullsleep$X.AN_NE., L_sleepdeprived$X.AN_NE., frame.plot = F, names = c("full sleep", "sleep deprived"), main = "Angry vs neutral")
t.test(L_fullsleep$X.AN_NE., L_sleepdeprived$X.AN_NE., paired = T)
boxplot(R_fullsleep$X.AN_NE., R_sleepdeprived$X.AN_NE., frame.plot = F, names = c("full sleep", "sleep deprived"), main = "Angry vs neutral")
t.test(R_fullsleep$X.AN_NE., R_sleepdeprived$X.AN_NE., paired = T)
