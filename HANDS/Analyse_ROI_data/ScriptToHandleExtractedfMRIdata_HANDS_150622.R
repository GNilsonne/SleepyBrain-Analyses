# Script to read extracted fMRI data and plot/test it. HANDS experiment, 150622
# Sandra Tamm
require(ggplot2)
require(nlme)

# Use for colors of plots
cPalette <- c("#E69F00","#56B4E9")

# Change if other system
setwd("~/Desktop/Stockholm-Sleepy-Brain-Project-R-Scripts")
source('Utils/SummarisingFunctions.R', chdir = T)
source('Utils/Multiplot.R', chdir = T)

# Read data
Data_all <- read.csv2("~/Desktop/SleepyBrain_HANDS/Data/Data_ROIs")
Data <- subset(Data_all, IncludeForIntervention == TRUE)

# Right Insula
# Summarize for plot
pio <- summarySEwithin(Data, measurevar="AI_R", withinvars="DeprivationCondition", 
                       betweenvars="AgeGroup", idvar="Subject", na.rm=FALSE, conf.interval=.95)

# Plot right insula
ggplot(pio, aes(x=DeprivationCondition, y=AI_R)) + 
  geom_point(aes(colour = factor(AgeGroup)), position=position_dodge(.9), stat="identity",
             #colour="black", # Use black outlines,
             size=3.5) +      # Thinner lines
  geom_errorbar(aes(ymin=AI_R-ci, ymax=AI_R+ci, colour = factor(AgeGroup)),
                size=0.6,    # Thinner lines
                width=.3,
                position=position_dodge(.9)) +
  scale_y_continuous(limits = c(-1, 1))+
  scale_x_discrete(label = c("Normal sleep", "Sleep restriction")) +
  xlab("SleepCondition") +
  ylab("Mean contrast value [pain > no pain]") +
  scale_color_manual(name = "Age group", values=cPalette, 
                     breaks=c("Old", "Young"),
                     labels=c("Old", "Young"))+
  ggtitle("The effect of age and sleep restriction on activity right Insula") +
  theme_bw() +
  theme(
    legend.position=c(1,1),legend.justification=c(1,1),
    axis.title.x=element_blank(),
    axis.title.y = element_text(size = rel(1.4)),
    axis.text.x  = element_text(size=16)
  )


# Test effect of sleep restriction
lme_AIR <- lme(AI_R ~ DeprivationCondition*AgeGroup, 
               data = Data, random = ~ 1|Subject, na.action = na.exclude)

anova(lme_AIR, type = "marginal")
intervals(lme_AIR)
summary(lme_AIR)

# Left Insula
# Summarize for plot
pio <- summarySEwithin(Data, measurevar="AI_L", withinvars="DeprivationCondition", 
                       betweenvars="AgeGroup", idvar="Subject", na.rm=FALSE, conf.interval=.95)


# Plot left insula
ggplot(pio, aes(x=DeprivationCondition, y=AI_L)) + 
  geom_point(aes(colour = factor(AgeGroup)), position=position_dodge(.9), stat="identity",
             #colour="black", # Use black outlines,
             size=3.5) +      # Thinner lines
  geom_errorbar(aes(ymin=AI_L-ci, ymax=AI_L+ci, colour = factor(AgeGroup)),
                size=0.6,    # Thinner lines
                width=.3,
                position=position_dodge(.9)) +
  scale_y_continuous(limits = c(-1, 1))+
  scale_x_discrete(label = c("Normal sleep", "Sleep restriction")) +
  xlab("SleepCondition") +
  ylab("Mean contrast value [pain > no pain]") +
  scale_color_manual(name = "Age group", values=cPalette, 
                     breaks=c("Old", "Young"),
                     labels=c("Old", "Young"))+
  ggtitle("The effect of age and sleep restriction on activity left Insula") +
  theme_bw() +
  theme(
    legend.position=c(1,1),legend.justification=c(1,1),
    axis.title.x=element_blank(),
    axis.title.y = element_text(size = rel(1.4)),
    axis.text.x  = element_text(size=16)
  )


# Test effect of sleep restriction
lme_AIL <- lme(AI_L ~ DeprivationCondition*AgeGroup, 
               data = Data, random = ~ 1|Subject, na.action = na.exclude)

anova(lme_AIL, type = "marginal")
intervals(lme_AIL)
summary(lme_AIL)


# cACC
# Summarize for plot
pio <- summarySEwithin(Data, measurevar="ACC", withinvars="DeprivationCondition", 
                       betweenvars="AgeGroup", idvar="Subject", na.rm=FALSE, conf.interval=.95)

# Plot aMCC
ggplot(pio, aes(x=DeprivationCondition, y=ACC)) + 
  geom_point(aes(colour = factor(AgeGroup)), position=position_dodge(.9), stat="identity",
             #colour="black", # Use black outlines,
             size=3.5) +      # Thinner lines
  geom_errorbar(aes(ymin=ACC-ci, ymax=ACC+ci, colour = factor(AgeGroup)),
                size=0.6,    # Thinner lines
                width=.3,
                position=position_dodge(.9)) +
  scale_y_continuous(limits = c(-1, 1))+
  scale_x_discrete(label = c("Normal sleep", "Sleep restriction")) +
  xlab("SleepCondition") +
  ylab("Mean contrast value [pain > no pain]") +
  scale_color_manual(name = "Age group", values=cPalette, 
                     breaks=c("Old", "Young"),
                     labels=c("Old", "Young"))+
  ggtitle("The effect of age and sleep restriction on activity aMCC") +
  theme_bw() +
  theme(
    legend.position=c(1,1),legend.justification=c(1,1),
    axis.title.x=element_blank(),
    axis.title.y = element_text(size = rel(1.4)),
    axis.text.x  = element_text(size=16)
  )

# Test effect of sleep restriction
lme_ACC <- lme(ACC ~ DeprivationCondition*AgeGroup, 
               data = Data, random = ~ 1|Subject, na.action = na.exclude)

anova(lme_ACC, type = "marginal")
intervals(lme_ACC)
summary(lme_ACC)


#Test relation to IRI EC, AI_R
ggplot(Data_all, aes(x=IRI_EC, y=AI_R, colour=Group, group=Group)) + 
  geom_point() + 
  geom_smooth(method="lm", formula = y ~ x) +
  theme_bw()

Lme_EC <-lme(AI_R ~ IRI_EC+AgeGroup*DeprivationCondition, 
             Data_all, random = ~ 1|Subject )
anova(Lme_EC)
intervals(Lme_EC)

#Test relation to IRI EC, AI_L
ggplot(Data_all, aes(x=IRI_EC, y=AI_L, colour=Group, group=Group)) + 
  geom_point() + 
  geom_smooth(method="lm", formula = y ~ x) +
  theme_bw()

Lme_EC <-lme(AI_L ~ IRI_EC+AgeGroup*DeprivationCondition, 
             Data_all, random = ~ 1|Subject )
anova(Lme_EC)
intervals(Lme_EC)
intervals(Lme_EC, which = "fixed")

#Test relation to IRI EC, ACC
ggplot(Data_all, aes(x=IRI_EC, y=ACC, colour=Group, group=Group)) + 
  geom_point() + 
  geom_smooth(method="lm", formula = y ~ x) +
  theme_bw()

Lme_EC <-lme(ACC ~ IRI_EC+AgeGroup*DeprivationCondition, 
             Data_all, random = ~ 1|Subject )
anova(Lme_EC)
intervals(Lme_EC)

# Add analyses of PPI-R
setwd("~/Desktop/SleepyBrain_HANDS")
Data_PPIR <- read.csv("Data/Data_PPIR", sep=";", dec=",")
Data_all <- merge(Data_all, Data_PPIR, all.x = T)

#Test relation to PPIR-C, AI_R
ggplot(Data_all, aes(x=C, y=AI_R, colour=Group, group=Group)) + 
  geom_point() + 
  geom_smooth(method="lm", formula = y ~ x) +
  theme_bw()

Lme_PPIR <-lme(AI_R ~ C+AgeGroup*DeprivationCondition, 
             Data_all, random = ~ 1|Subject, na.action = na.exclude)
anova(Lme_PPIR)
intervals(Lme_PPIR)

#Test relation to PPIR-C, AI_L
ggplot(Data_all, aes(x=C, y=AI_L, colour=Group, group=Group)) + 
  geom_point() + 
  geom_smooth(method="lm", formula = y ~ x) +
  theme_bw()

Lme_PPIR <-lme(AI_L ~ C+AgeGroup*DeprivationCondition, 
             Data_all, random = ~ 1|Subject, na.action = na.exclude)
anova(Lme_PPIR)
intervals(Lme_PPIR)

#Test relation to PPIR-C, ACC
ggplot(Data_all, aes(x=C, y=ACC, colour=Group, group=Group)) + 
  geom_point() + 
  geom_smooth(method="lm", formula = y ~ x) +
  theme_bw()

Lme_PPIR <-lme(ACC ~ C+AgeGroup*DeprivationCondition, 
             Data_all, random = ~ 1|Subject, na.action = na.exclude)
anova(Lme_PPIR)
intervals(Lme_PPIR)