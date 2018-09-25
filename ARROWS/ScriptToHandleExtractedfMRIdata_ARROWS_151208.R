# Script to read extracted fMRI data and plot/test it. ARROWS experiment. 2018-07-03
# Sandra Tamm
require(ggplot2)
require(nlme)

# Change if other system
source('Utils/SummarisingFunctions.R', chdir = T)
source('Utils/Multiplot.R', chdir = T)

Data_Negneu_L <- read.csv("~/Desktop/SleepyBrain_ARROWS/Data/Data_Amygdala_L_160121", header=FALSE)
Data_Negneu_R <- read.csv("~/Desktop/SleepyBrain_ARROWS/Data/Data_Amygdala_R_160121", header=FALSE)
colnames(Data_Negneu_L) <- c("Subject", "Session", "Amygdala_L_negneu_full", "Amygdala_voxels_L")
colnames(Data_Negneu_R) <- c("Subject", "Session", "Amygdala_R_negneu_full", "Amygdala_voxels_R")
Data_NegNeu <- merge(Data_Negneu_L, Data_Negneu_R)

Data_Negneu_L_0s <- read.csv("~/Desktop/SleepyBrain_ARROWS/Data/Data_Amygdala_L_0s_160121", header=FALSE)
Data_Negneu_R_0s <- read.csv("~/Desktop/SleepyBrain_ARROWS/Data/Data_Amygdala_R_0s_160121", header=FALSE)
colnames(Data_Negneu_L_0s) <- c("Subject", "Session", "Amygdala_L_negneu_0s", "Amygdala_voxels_L")
colnames(Data_Negneu_R_0s) <- c("Subject", "Session", "Amygdala_R_negneu_0s", "Amygdala_voxels_R")
Data_NegNeu <- merge(Data_NegNeu, Data_Negneu_R_0s)
Data_NegNeu <- merge(Data_NegNeu, Data_Negneu_L_0s)

Data_Downmaintain_amygdala_L <- read.csv("~/Desktop/SleepyBrain_ARROWS/Data/Data_Amygdala_L_downmaintain_160121", header=FALSE)
Data_Downmaintain_amygdala_R <- read.csv("~/Desktop/SleepyBrain_ARROWS/Data/Data_Amygdala_R_downmaintain_160121", header=FALSE)
colnames(Data_Downmaintain_amygdala_L) <- c("Subject", "Session", "Amygdala_L_Down", "Amygdala_voxels_L")
colnames(Data_Downmaintain_amygdala_R) <- c("Subject", "Session", "Amygdala_R_Down", "Amygdala_voxels_R")
Data_Downreg <- merge(Data_Downmaintain_amygdala_R, Data_Downmaintain_amygdala_L)

Data_Downmaintain_dlPFC_L <- read.csv("~/Desktop/SleepyBrain_ARROWS/Data/Data_dlPFCL_downmaintain_160121", header=FALSE)
Data_Downmaintain_dlPFC_R <- read.csv("~/Desktop/SleepyBrain_ARROWS/Data/Data_dlPFCR_downmaintain_160121", header=FALSE)
colnames(Data_Downmaintain_dlPFC_L) <- c("Subject", "Session", "dlPFC_L_Down", "dlPFC_voxels_L")
colnames(Data_Downmaintain_dlPFC_R) <- c("Subject", "Session", "dlPFC_R_Down", "dlPFC_voxels_R")
Data_Downreg <- merge(Data_Downreg, Data_Downmaintain_dlPFC_L)
Data_Downreg <- merge(Data_Downreg, Data_Downmaintain_dlPFC_R)

Data_Downmaintain_lOFC_L <- read.csv("~/Desktop/SleepyBrain_ARROWS/Data/Data_lOFCL_downmaintain_160121", header=FALSE)
Data_Downmaintain_lOFC_R <- read.csv("~/Desktop/SleepyBrain_ARROWS/Data/Data_lOFCR_downmaintain_160121", header=FALSE)
colnames(Data_Downmaintain_lOFC_L) <- c("Subject", "Session", "lOFC_L_Down", "lOFC_voxels_L")
colnames(Data_Downmaintain_lOFC_R) <- c("Subject", "Session", "lOFC_R_Down", "lOFC_voxels_R")
Data_Downreg <- merge(Data_Downreg, Data_Downmaintain_lOFC_L)
Data_Downreg <- merge(Data_Downreg, Data_Downmaintain_lOFC_R)

Data <- merge(Data_NegNeu, Data_Downreg)

Demographic <- read.csv("~/Box Sync/Sleepy Brain/Datafiles/150215_Demographic.csv", sep=";", dec=",")
Data <- merge(Data, Demographic)

# Find data for early/late scan session
KSSData <- read.csv2("~/Box Sync/Sleepy Brain/Datafiles/140806_KSSData")
# Retain only one rating to get unique rows for subject and session
KSSData <- subset(KSSData, RatingNo == 4)
KSSData <- KSSData[, c(2, 5, 7, 10:11)]
Data <- merge(Data, KSSData)

# # Make column with both group and sleep condition
Data$Group <- paste(Data$AgeGroup, ":", Data$DeprivationCondition, sep = "")

# Subject list 
IncludedSubjects <- read.table("~/Box Sync/Sleepy Brain/Datafiles/SubjectsForARROWS.csv", sep=";", header=T)
IncludedForIntervention <- as.integer(IncludedSubjects$CanBeIncludedForInterventionEffectsWithMRI)
IncludedAnyAnalysis <- as.integer(IncludedSubjects$IncludedAnyfMRI)

# Retain only subjects in list
Data_all <- Data[Data$Subject %in% as.integer(IncludedAnyAnalysis), ]
Data <- Data[Data$Subject %in% as.integer(IncludedForIntervention), ]


plot.mean <- function(x) {
  m <- mean(x)
  c(y = m, ymin = m, ymax = m)
}

## dotplot with mean line
plot1 <- ggplot(Data, aes(x=Group, y = Amygdala_L_negneu_full)) +
  labs(list(title = "Left amygdala, negative > neutral, full event", x = "Group and condition", y = "Contrast value")) +
  theme(axis.title.x = element_text(face="bold"), axis.text.x = element_text(face="bold")) +
  theme(axis.title.y = element_text(face="bold"), axis.text.y = element_text(face="bold"))

plot1 <- plot1 + geom_dotplot(binaxis='y', stackdir='center', method="histodot", binwidth=0.05) +
  stat_summary(fun.data="plot.mean", geom="errorbar", colour="red", width=0.5, size=1)
print(plot1)

plot2 <- ggplot(Data, aes(x=Group, y = Amygdala_R_negneu_full)) +
  labs(list(title = "Right amygdala, negative > neutral, full event", x = "Group and condition", y = "Contrast value")) +
  theme(axis.title.x = element_text(face="bold"), axis.text.x = element_text(face="bold")) +
  theme(axis.title.y = element_text(face="bold"), axis.text.y = element_text(face="bold"))

plot2 <- plot2 + geom_dotplot(binaxis='y', stackdir='center', method="histodot", binwidth=0.05) +
  stat_summary(fun.data="plot.mean", geom="errorbar", colour="red", width=0.5, size=1)
print(plot1)

plot3 <- ggplot(Data, aes(x=Group, y = Amygdala_L_negneu_0s)) +
  labs(list(title = "Left amygdala, negative > neutral, 0 s", x = "Group and condition", y = "Contrast value")) +
  theme(axis.title.x = element_text(face="bold"), axis.text.x = element_text(face="bold")) +
  theme(axis.title.y = element_text(face="bold"), axis.text.y = element_text(face="bold"))

plot3 <- plot3 + geom_dotplot(binaxis='y', stackdir='center', method="histodot", binwidth=0.1) +
  stat_summary(fun.data="plot.mean", geom="errorbar", colour="red", width=0.5, size=1)
print(plot3)

plot4 <- ggplot(Data, aes(x=Group, y = Amygdala_R_negneu_0s)) +
  labs(list(title = "Right amygdala, negative > neutral, 0 s", x = "Group and condition", y = "Contrast value")) +
  theme(axis.title.x = element_text(face="bold"), axis.text.x = element_text(face="bold")) +
  theme(axis.title.y = element_text(face="bold"), axis.text.y = element_text(face="bold"))

plot4 <- plot4 + geom_dotplot(binaxis='y', stackdir='center', method="histodot", binwidth=0.1) +
  stat_summary(fun.data="plot.mean", geom="errorbar", colour="red", width=0.5, size=1)
print(plot4)

multiplot(plot1, plot2, plot3, plot4, cols =2)

# Test effect of sleep restriction, full (left)
lme_Amygdala_L_full <- lme(Amygdala_L_negneu_full ~ DeprivationCondition*AgeGroup, 
                      data = Data, random = ~ 1|Subject, na.action = na.exclude)

anova(lme_Amygdala_L_full, type = "marginal")
intervals(lme_Amygdala_L_full)
summary(lme_Amygdala_L_full)

# Right
lme_Amygdala_R_full <- lme(Amygdala_R_negneu_full ~ DeprivationCondition*AgeGroup, 
                           data = Data, random = ~ 1|Subject, na.action = na.exclude)

anova(lme_Amygdala_R_full, type = "marginal")
intervals(lme_Amygdala_R_full)
summary(lme_Amygdala_R_full)

# Test effect of sleep restriction, full, young (left)
lme_Amygdala_L_full_y <- lme(Amygdala_L_negneu_full ~ DeprivationCondition, 
                           data = subset(Data, AgeGroup == "Young"), random = ~ 1|Subject, na.action = na.exclude)

anova(lme_Amygdala_L_full_y, type = "marginal")
intervals(lme_Amygdala_L_full_y)
summary(lme_Amygdala_L_full_y)

# Right
lme_Amygdala_R_full_y <- lme(Amygdala_R_negneu_full ~ DeprivationCondition, 
                           data = subset(Data, AgeGroup == "Young"), random = ~ 1|Subject, na.action = na.exclude)

anova(lme_Amygdala_R_full_y, type = "marginal")
intervals(lme_Amygdala_R_full_y)
summary(lme_Amygdala_R_full_y)



# Test effect of sleep restriction, 0s (left)
lme_Amygdala_L_0s <- lme(Amygdala_L_negneu_0s ~ DeprivationCondition*AgeGroup, 
                           data = Data, random = ~ 1|Subject, na.action = na.exclude)

anova(lme_Amygdala_L_0s, type = "marginal")
intervals(lme_Amygdala_L_0s)
summary(lme_Amygdala_L_0s)

# Right
lme_Amygdala_R_0s <- lme(Amygdala_R_negneu_0s ~ DeprivationCondition*AgeGroup, 
                           data = Data, random = ~ 1|Subject, na.action = na.exclude)

anova(lme_Amygdala_R_0s, type = "marginal")
intervals(lme_Amygdala_R_0s)
summary(lme_Amygdala_R_0s)



# Test effect of sleep restriction on amygdala, down > negative

plot5 <- ggplot(Data, aes(x=Group, y = Amygdala_L_Down)) +
  labs(list(title = "Left amygdala, downregulate > maintain [negative]", x = "Group and condition", y = "Contrast value")) +
  theme(axis.title.x = element_text(face="bold"), axis.text.x = element_text(face="bold")) +
  theme(axis.title.y = element_text(face="bold"), axis.text.y = element_text(face="bold"))

plot5 <- plot5 + geom_dotplot(binaxis='y', stackdir='center', method="histodot", binwidth=0.05) +
  stat_summary(fun.data="plot.mean", geom="errorbar", colour="red", width=0.5, size=1)
print(plot5)

plot6 <- ggplot(Data, aes(x=Group, y = Amygdala_R_Down)) +
  labs(list(title = "Right amygdala, downregulate > maintain [negative]", x = "Group and condition", y = "Contrast value")) +
  theme(axis.title.x = element_text(face="bold"), axis.text.x = element_text(face="bold")) +
  theme(axis.title.y = element_text(face="bold"), axis.text.y = element_text(face="bold"))

plot6 <- plot6 + geom_dotplot(binaxis='y', stackdir='center', method="histodot", binwidth=0.05) +
  stat_summary(fun.data="plot.mean", geom="errorbar", colour="red", width=0.5, size=1)
print(plot6)

multiplot(plot5, plot6)

# Test effect of sleep restriction on amygdala for the contrast downregulate > maintain
lme_Amygdala_L_Down <- lme(Amygdala_L_Down ~ DeprivationCondition*AgeGroup, 
                           data = Data, random = ~ 1|Subject, na.action = na.exclude)

anova(lme_Amygdala_L_Down, type = "marginal")
intervals(lme_Amygdala_L_Down)
summary(lme_Amygdala_L_Down)

# Right
lme_Amygdala_R_Down <- lme(Amygdala_R_Down ~ DeprivationCondition*AgeGroup, 
                           data = Data, random = ~ 1|Subject, na.action = na.exclude)

anova(lme_Amygdala_R_Down, type = "marginal")
intervals(lme_Amygdala_R_Down)
summary(lme_Amygdala_R_Down)

# Test effect of sleep restriction on amygdala for the contrast downregulate > maintain. Only young
lme_Amygdala_L_Down_y <- lme(Amygdala_L_Down ~ DeprivationCondition, 
                           data = subset(Data, AgeGroup == "Young"), random = ~ 1|Subject, na.action = na.exclude)

anova(lme_Amygdala_L_Down_y, type = "marginal")
intervals(lme_Amygdala_L_Down_y)
summary(lme_Amygdala_L_Down_y)

# Right
lme_Amygdala_R_Down_y <- lme(Amygdala_R_Down ~ DeprivationCondition, 
                           data = subset(Data, AgeGroup == "Young"), random = ~ 1|Subject, na.action = na.exclude)

anova(lme_Amygdala_R_Down_y, type = "marginal")
intervals(lme_Amygdala_R_Down_y)
summary(lme_Amygdala_R_Down_y)



plot7 <- ggplot(Data, aes(x=Group, y = dlPFC_L_Down)) +
  labs(list(title = "Left dlPFC, downregulate > maintain [negative]", x = "Group and condition", y = "Contrast value")) +
  theme(axis.title.x = element_text(face="bold"), axis.text.x = element_text(face="bold")) +
  theme(axis.title.y = element_text(face="bold"), axis.text.y = element_text(face="bold"))

plot7 <- plot7 + geom_dotplot(binaxis='y', stackdir='center', method="histodot", binwidth=0.05) +
  stat_summary(fun.data="plot.mean", geom="errorbar", colour="red", width=0.5, size=1)
print(plot7)

plot8 <- ggplot(Data, aes(x=Group, y = dlPFC_R_Down)) +
  labs(list(title = "Right dlPFC, downregulate > maintain [negative]", x = "Group and condition", y = "Contrast value")) +
  theme(axis.title.x = element_text(face="bold"), axis.text.x = element_text(face="bold")) +
  theme(axis.title.y = element_text(face="bold"), axis.text.y = element_text(face="bold"))

plot8 <- plot8 + geom_dotplot(binaxis='y', stackdir='center', method="histodot", binwidth=0.05) +
  stat_summary(fun.data="plot.mean", geom="errorbar", colour="red", width=0.5, size=1)
print(plot8)

plot9 <- ggplot(Data, aes(x=Group, y = lOFC_L_Down)) +
  labs(list(title = "Left lOFC, downregulate > maintain [negative]", x = "Group and condition", y = "Contrast value")) +
  theme(axis.title.x = element_text(face="bold"), axis.text.x = element_text(face="bold")) +
  theme(axis.title.y = element_text(face="bold"), axis.text.y = element_text(face="bold"))

plot9 <- plot9 + geom_dotplot(binaxis='y', stackdir='center', method="histodot", binwidth=0.05) +
  stat_summary(fun.data="plot.mean", geom="errorbar", colour="red", width=0.5, size=1)
print(plot9)


plot10 <- ggplot(Data, aes(x=Group, y = lOFC_R_Down)) +
  labs(list(title = "Right lOFC, downregulate > maintain [negative]", x = "Group and condition", y = "Contrast value")) +
  theme(axis.title.x = element_text(face="bold"), axis.text.x = element_text(face="bold")) +
  theme(axis.title.y = element_text(face="bold"), axis.text.y = element_text(face="bold"))

plot10 <- plot10 + geom_dotplot(binaxis='y', stackdir='center', method="histodot", binwidth=0.05) +
  stat_summary(fun.data="plot.mean", geom="errorbar", colour="red", width=0.5, size=1)
print(plot10)


multiplot(plot7, plot8, plot9, plot10, cols = 2)


# Test effect of sleep restriction on dlPFC for the contrast downregulate > maintain
lme_dlPFC_L_Down <- lme(dlPFC_L_Down ~ DeprivationCondition*AgeGroup, 
                           data = Data, random = ~ 1|Subject, na.action = na.exclude)

anova(lme_dlPFC_L_Down, type = "marginal")
intervals(lme_dlPFC_L_Down)
summary(lme_dlPFC_L_Down)

# Right
lme_dlPFC_R_Down <- lme(dlPFC_R_Down ~ DeprivationCondition*AgeGroup, 
                           data = Data, random = ~ 1|Subject, na.action = na.exclude)

anova(lme_dlPFC_R_Down, type = "marginal")
intervals(lme_dlPFC_R_Down)
summary(lme_dlPFC_R_Down)

# Test effect of sleep restriction on dlPFC for the contrast downregulate > maintain. Only young. Left
lme_dlPFC_L_Down_y <- lme(dlPFC_L_Down ~ DeprivationCondition, 
                             data = subset(Data, AgeGroup == "Young"), random = ~ 1|Subject, na.action = na.exclude)

anova(lme_dlPFC_L_Down_y, type = "marginal")
intervals(lme_dlPFC_L_Down_y)
summary(lme_dlPFC_L_Down_y)

# Right
lme_dlPFC_R_Down_y <- lme(dlPFC_R_Down ~ DeprivationCondition, 
                             data = subset(Data, AgeGroup == "Young"), random = ~ 1|Subject, na.action = na.exclude)

anova(lme_dlPFC_R_Down_y, type = "marginal")
intervals(lme_dlPFC_R_Down_y)
summary(lme_dlPFC_R_Down_y)


# Test effect of sleep restriction on lOFC for the contrast downregulate > maintain
lme_lOFC_L_Down <- lme(lOFC_L_Down ~ DeprivationCondition*AgeGroup, 
                        data = Data, random = ~ 1|Subject, na.action = na.exclude)

anova(lme_lOFC_L_Down, type = "marginal")
intervals(lme_lOFC_L_Down)
summary(lme_lOFC_L_Down)

# Right
lme_lOFC_R_Down <- lme(lOFC_R_Down ~ DeprivationCondition*AgeGroup, 
                        data = Data, random = ~ 1|Subject, na.action = na.exclude)

anova(lme_lOFC_R_Down, type = "marginal")
intervals(lme_lOFC_R_Down)
summary(lme_lOFC_R_Down)

# Test effect of sleep restriction on lOFC for the contrast downregulate > maintain. Only young. Left
lme_lOFC_L_Down_y <- lme(lOFC_L_Down ~ DeprivationCondition, 
                          data = subset(Data, AgeGroup == "Young"), random = ~ 1|Subject, na.action = na.exclude)

anova(lme_lOFC_L_Down_y, type = "marginal")
intervals(lme_lOFC_L_Down_y)
summary(lme_lOFC_L_Down_y)

# Right
lme_lOFC_R_Down_y <- lme(lOFC_R_Down ~ DeprivationCondition, 
                          data = subset(Data, AgeGroup == "Young"), random = ~ 1|Subject, na.action = na.exclude)

anova(lme_lOFC_R_Down_y, type = "marginal")
intervals(lme_lOFC_R_Down_y)
summary(lme_lOFC_R_Down_y)



# Left amygdala
# Summarize for plot
pio <- summarySEwithin(Data_all, measurevar="Amygdala_L_negneu_full", withinvars="DeprivationCondition", 
                       betweenvars="AgeGroup", idvar="Subject", na.rm=FALSE, conf.interval=.95)

ggplot(pio, aes(x=DeprivationCondition, y=Amygdala_L_negneu_full, fill=AgeGroup)) + 
  geom_bar(position=position_dodge(), stat="identity",
           colour="black", # Use black outlines,
           size=.3) +      # Thinner lines
  geom_errorbar(aes(ymin=Amygdala_L_negneu_full-se, ymax=Amygdala_L_negneu_full+se),
                size=.3,    # Thinner lines
                width=.2,
                position=position_dodge(.9)) +
  xlab("Sleep Condition") +
  ylab("Mean contrast value [negative > neutral]") +
  scale_fill_hue(name="Age group", # Legend label, use darker colors
                 breaks=c("Old", "Young"),
                 labels=c("Old", "Young")) +
  ggtitle("The effect of age and sleep restriction on activity left amygdala") +
  theme_bw()


# Right amygdala
# Summarize for plot
pio <- summarySEwithin(Data_all, measurevar= "Amygdala_R_negneu_full", withinvars="DeprivationCondition", 
                       betweenvars="AgeGroup", idvar="Subject", na.rm=FALSE, conf.interval=.95)

ggplot(pio, aes(x=DeprivationCondition, y=Amygdala_R_negneu_full, fill=AgeGroup)) + 
  geom_bar(position=position_dodge(), stat="identity",
           colour="black", # Use black outlines,
           size=.3) +      # Thinner lines
  geom_errorbar(aes(ymin=Amygdala_R_negneu_full-se, ymax=Amygdala_R_negneu_full+se),
                size=.3,    # Thinner lines
                width=.2,
                position=position_dodge(.9)) +
  xlab("Sleep Condition") +
  ylab("Mean contrast value [negative > neutral]") +
  scale_fill_hue(name="Age group", # Legend label, use darker colors
                 breaks=c("Old", "Young"),
                 labels=c("Old", "Young")) +
  ggtitle("The effect of age and sleep restriction on activity right amygdala") +
  theme_bw()

# Test effect of sleep restriction
lme_Amygdala_R <- lme(Amygdala_R ~ DeprivationCondition*AgeGroup, 
               data = Data_all, random = ~ 1|Subject, na.action = na.exclude)

anova(lme_Amygdala_R, type = "marginal")
intervals(lme_Amygdala_R)
summary(lme_Amygdala_R)


