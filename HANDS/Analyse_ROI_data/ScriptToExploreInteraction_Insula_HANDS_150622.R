# Script to read extracted fMRI data and plot/test it. HANDS experiment, Insula interaction, 150622
# Sandra Tamm
require(ggplot2)
source('Utils/Multiplot.R', chdir = T)
source('Utils/SummarisingFunctions.R', chdir = T)

# Use for colors of plots
cPalette <- c("#E69F00","#56B4E9")

Data <- read.csv2("~/Desktop/SleepyBrain_HANDS/Data/Data_Insula")

pio <- summarySEwithin(Data, measurevar="Pvbl_Insula_L", withinvars="DeprivationCondition", 
                       betweenvars="AgeGroup", idvar="Subject", na.rm=FALSE, conf.interval=.95)

P1 <- ggplot(pio, aes(x=DeprivationCondition, y=Pvbl_Insula_L)) + 
  geom_point(aes(colour = factor(AgeGroup)), position=position_dodge(.9), stat="identity",
             #colour="black", # Use black outlines,
             size=5) +      # Thinner lines
  geom_errorbar(aes(ymin=Pvbl_Insula_L-ci, ymax=Pvbl_Insula_L+ci, colour = factor(AgeGroup)),
                size=0.6,    # Thinner lines
                width=.3,
                position=position_dodge(.9)) +
  scale_y_continuous(limits = c(-1, 1))+
  scale_x_discrete(label = c("Normal sleep", "Sleep restriction")) +
  xlab("SleepCondition") +
  ylab("Mean contrast value [pain > baseline], left Insula") +
  scale_color_manual(name = "Age group", values=cPalette, 
                     breaks=c("Old", "Young"),
                     labels=c("Old", "Young"))+
  ggtitle("") +
  theme_bw() +
  theme(
    legend.position=c(1,1),legend.justification=c(1,1),
    axis.title.x=element_blank(),
    axis.title.y = element_text(size = rel(1.4)),
    axis.text.x  = element_text(size=16)
  )
  


pio2 <- summarySEwithin(Data, measurevar="Pvbl_Insula_R", withinvars="DeprivationCondition", 
                       betweenvars="AgeGroup", idvar="Subject", na.rm=FALSE, conf.interval=.95)

P2 <- ggplot(pio2, aes(x=DeprivationCondition, y=Pvbl_Insula_R)) + 
  geom_point(aes(colour = factor(AgeGroup)), position=position_dodge(.9), stat="identity",
             #colour="black", # Use black outlines,
             size=5) +      # Thinner lines
  geom_errorbar(aes(ymin=Pvbl_Insula_R-ci, ymax=Pvbl_Insula_R+ci, colour = factor(AgeGroup)),
                size=0.6,    # Thinner lines
                width=.3,
                position=position_dodge(.9)) +
  scale_y_continuous(limits = c(-1, 1))+
  scale_x_discrete(label = c("Normal sleep", "Sleep restriction")) +
  xlab("SleepCondition") +
  ylab("Mean contrast value [pain > baseline], right Insula") +
  scale_color_manual(name = "Age group", values=cPalette, 
                     breaks=c("Old", "Young"),
                     labels=c("Old", "Young"))+
  ggtitle("") +
  theme_bw() +
  theme(
    legend.position=c(1,1),legend.justification=c(1,1),
    axis.title.x=element_blank(),
    axis.title.y = element_text(size = rel(1.4)),
    axis.text.x  = element_text(size=16)
  )


multiplot(P1, P2, cols=2)

