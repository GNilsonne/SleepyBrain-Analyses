library("stringr")
library("lavaan")
library("DiagrammeR")
library("dplyr")
library("semPlot")
library("readr")

modelData <- read_csv("~/Desktop/SleepyBrain-Analyses/Sleepmeasures_emotion/SEM_young_Singer_standardized.csv") ;
model<-"
! regressions 
ER=~1.0*Downr
ER=~1.0*Upreg
EC=~1.0*C_hap
EC=~1.0*C_ang
Ep =~1.0*Unp
! residuals, variances and covariances
EC ~~ VAR_EC*EC
C_ang ~~ VAR_C_ang*C_ang
C_hap ~~ VAR_C_hap*C_hap
Unp ~~ 0*Unp
ER ~~ VAR_ER*ER
ER ~~ COV_ER_EC*EC
Downr ~~ VAR_Downr*Downr
Upreg ~~ VAR_Upreg*Upreg
Ep ~~ VAR_Ep*Ep
ER ~~ COV_ER_Ep*Ep
Ep ~~ COV_Ep_EC*EC
! means
EC~0*1;
C_ang~0*1;
C_hap~0*1;
Unp~0*1;
ER~0*1;
Downr~0*1;
Upreg~0*1;
Ep~0*1;
";
result<-lavaan(model, data=modelData, missing="FIML");

summary(result, fit.measures=TRUE);
sink("Singer_young_SEM_ratings.txt")
summary(result, fit.measures=T);
sink()

# Plot path diagram:
fit <- lavaan:::cfa(model, data = modelData, missing="FIML")

semPaths(fit, intercept = F, whatLabel = "std", nCharNodes = 0, nCharEdges =0, sizeMan = 5,
         exoVar = F,
         groups = list(c("Ep", "Unp"), 
                       c("EC", "C_Ang", "C_hap"),
                       c("ER", "Downr", "Upreg")),
         residuals = T, exoCov = T, layout = "circle", ask = F, as.expression = "edges", fixedStyle = c("black",3),
         pastel = T)

# Parameter estimates
parameterEstimates(result)
# Standardized estimates
standardizedSolution(result)

library(dplyr) 
library(tidyr)
library(knitr)
parameterEstimates(fit, standardized=TRUE) %>% 
  filter(op == "=~") %>% 
  select('Latent Factor'=lhs, Indicator=rhs, B=est, SE=se, Z=z, 'p-value'=pvalue, Beta=std.all) %>% 
  kable(digits = 3, format="pandoc", caption="Factor Loadings")



