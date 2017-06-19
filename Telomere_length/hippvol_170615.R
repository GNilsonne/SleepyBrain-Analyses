# This script analyses the association betweem telomere length and hippocampus volume in the Sleepy Brain dataset
# The age variable is essential for analyses but cannot be published openly on account of the risk of reidentification
# Published here will be the residualised variables on which the final correlation analysis is performed
# Telomere length data are available at openfmri.org/dataset/ds000201/
# Script by Gustav Nilsonne

# Read data
data2 <- read.csv("C:/Users/gusta/Box Sync/Sleepy Brain/Datafiles/HippVol_from_KristofferM_170129/hippoc_cluster_sb_170616.csv")
TLdata <- read.csv2("C:/Users/gusta/Box Sync/Sleepy Brain/Datafiles/TL_160523.csv")
data2 <- merge(data2, TLdata[, c("Subject", "relative.TL", "ApoE")], by.x = "id", by.y = "Subject")
data2_young <- data2[data2$age_group == 0, ]
data2_older <- data2[data2$age_group == 1, ]

# Compare telomere lengths between groups
ttest <- t.test(data2_young$relative.TL, data2_older$relative.TL, alternative = "greater")
ttest
ttest$estimate[1] - ttest$estimate[2] # Find difference between groups for reporting in manuscript

# Check correlations of hippocampus volumes, create average
plot(hippocampus_l_cluster ~ hippocampus_r_cluster, data = data2_young)
cor.test(data2_young$hippocampus_l_cluster, data2_young$hippocampus_r_cluster)
plot(hippocampus_l_cluster ~ hippocampus_r_cluster, data = data2_older)
cor.test(data2_older$hippocampus_l_cluster, data2_older$hippocampus_r_cluster)
data2_young$hippvol_mean <- (data2_young$hippocampus_l_cluster + data2_young$hippocampus_r_cluster)/2
data2_older$hippvol_mean <- (data2_older$hippocampus_l_cluster + data2_older$hippocampus_r_cluster)/2

# Residualize hippocampus volume within each group on age and intracranial volume
lm_young <- lm(hippvol_mean ~ age + fs_tiv, data = data2_young)
summary(lm_young)
data2_young$hippvol_mean_residual <- lm_young$residuals

lm_older <- lm(hippvol_mean ~ age + fs_tiv, data = data2_older)
summary(lm_older)
data2_older$hippvol_mean_residual <- lm_older$residuals

# Residualize telomere length within each group on age and intracranial volume
lm_young_TL <- lm(relative.TL ~ age, data = data2_young)
summary(lm_young_TL)
data2_young$TL_residual <- lm_young_TL$residuals

lm_older_TL <- lm(relative.TL ~ age, data = data2_older)
summary(lm_older_TL)
data2_older$TL_residual <- lm_older_TL$residuals

# Write datafiles with residualised data. These datafiles do not contain identifying information and will be published.
write.csv(data2_young[, c("hippvol_mean_residual", "TL_residual")], file = "Telomere_length/young_hippvol_TL_residualised")
write.csv(data2_older[, c("hippvol_mean_residual", "TL_residual")], file = "Telomere_length/older_hippvol_TL_residualised")

# Analyse hippocampus volume and telomere length
plot(hippvol_mean_residual ~ TL_residual, data = data2_young, frame.plot = F)
cor.test(data2_young$hippvol_mean_residual, data2_young$TL_residual)

plot(hippvol_mean_residual ~ TL_residual, data = data2_older, frame.plot = F)
cor.test(data2_older$hippvol_mean_residual, data2_older$TL_residual)

pdf("figure_hippvol_TL.pdf")
plot(hippvol_mean_residual ~ relative.TL, data = data2_young, frame.plot = F, xlim = c(min(data2$relative.TL), max(data2$relative.TL)), ylim = c(min(c(data2_young$hippvol_mean_residual), c(data2_older$hippvol_mean_residual)), max(c(data2_young$hippvol_mean_residual), c(data2_older$hippvol_mean_residual))),
     xlab = "Telomere length ratio, residualised", ylab = "Hippocampus volume, residualized")
points(hippvol_mean_residual ~ relative.TL, data = data2_older, pch = 16)
legend("bottomright", pch = c(1, 16), legend = c("Young", "Older"))
dev.off()
