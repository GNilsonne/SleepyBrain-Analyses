require(readr)

# Read data
demdata <- read.csv2("~/Box Sync/Sleepy Brain/Datafiles/150215_Demographic.csv")
subjects <- read.csv2("~/Box Sync/Sleepy Brain/Datafiles/Subjects_151215.csv")
demdata <- merge(demdata, subjects[, c("Subject", "CanBeIncludedForInterventionEffectsWithMRI", "newid")], by = "Subject")
demdata <- demdata[!is.na(demdata$CanBeIncludedForInterventionEffectsWithMRI), ]
randlist <- read.csv("~/Box Sync/Sleepy Brain/Datafiles/RandomisationList_140804.csv", sep=";")
demdata <- merge(demdata, randlist, by = "Subject")
sleepdata <- read_delim("~/Box Sync/Sleepy Brain/Datafiles/sleepdata_short_160731.txt", 
                        "\t", escape_double = FALSE, trim_ws = TRUE)
SIESTAdata <-read_delim("~/Desktop/SleepyBrain-Analyses/SIESTAdata_160516_pseudonymized.csv", ";", escape_double = FALSE, 
                        locale = locale(decimal_mark = ","), trim_ws = TRUE)
SIESTAdata <- subset(SIESTAdata, select=c("id", "slat_00_nsd", "rl___00_nsd", "n3l__00_nsd", "slat_00_sd", "rl___00_sd", "n3l__00_sd", "eff__00_nsd"))
subjectlist <- read.csv("~/Box Sync/Sleepy Brain/Datafiles/Subjects_151215.csv", sep=";")
subjectlist <- subset(subjectlist, select=c("Subject", "newid"))
SIESTAdata <- merge(SIESTAdata, subjectlist, by.x = "id", by.y = "newid", all.x =T)
sleepdata <- merge(sleepdata, SIESTAdata, by="Subject")
sleepdata$NREM_sd <- sleepdata$n1___00_sd + sleepdata$n2___00_sd + sleepdata$n3___00_sd
sleepdata$NREM_nsd <- sleepdata$n1___00_nsd + sleepdata$n2___00_nsd + sleepdata$n3___00_nsd

demdata <- merge(demdata, sleepdata, all.x = T)


# Make table with demographic data
outtable <- data.frame(variable = "n", younger = summary(demdata$AgeGroup)[2], older = summary(demdata$AgeGroup)[1])
outtable <- rbind(outtable, data.frame(variable = "Age, median (range)", 
                                       younger = paste(median(demdata$Age[demdata$AgeGroup == "Young"]), "(", min(demdata$Age[demdata$AgeGroup == "Young"]), "-", max(demdata$Age[demdata$AgeGroup == "Young"]), ")"),
                                       older = paste(median(demdata$Age[demdata$AgeGroup == "Old"]), "(", min(demdata$Age[demdata$AgeGroup == "Old"]),"-", max(demdata$Age[demdata$AgeGroup == "Old"]), ")")))
outtable <- rbind(outtable, data.frame(variable = "Sex, n male, n female", 
                                       younger = paste(length(demdata$Sex[demdata$AgeGroup == "Young" & demdata$Sex == "Male"]), ",", length(demdata$Sex[demdata$AgeGroup == "Young" & demdata$Sex == "Female"])),
                                       older = paste(length(demdata$Sex[demdata$AgeGroup == "Old" & demdata$Sex == "Male"]), ",", length(demdata$Sex[demdata$AgeGroup == "Old" & demdata$Sex == "Female"]))))
outtable <- rbind(outtable, data.frame(variable = "BMI at first scanning (mean, SD)", 
                                       younger = paste(round(mean(demdata$BMI1[demdata$AgeGroup == "Young"]), 1), "(", round(sd(demdata$BMI1[demdata$AgeGroup == "Young"]), 1), ")"),
                                       older = paste(round(mean(demdata$BMI1[demdata$AgeGroup == "Old"]), 1), "(", round(sd(demdata$BMI1[demdata$AgeGroup == "Old"]), 1), ")")))
outtable <- rbind(outtable, data.frame(variable = "Completed primary education (n)", 
                                       younger = paste(length(demdata$Sex[demdata$AgeGroup == "Young" & demdata$EducationLevel == "Har avslutat grundskolan"])),
                                       older = paste(length(demdata$Sex[demdata$AgeGroup == "Old" & demdata$EducationLevel == "Har avslutat grundskolan"]))))
outtable <- rbind(outtable, data.frame(variable = "Completed secondary education (n)", 
                                       younger = paste(length(demdata$Sex[demdata$AgeGroup == "Young" & demdata$EducationLevel == "Har avslutat gymnasieskolan"])),
                                       older = paste(length(demdata$Sex[demdata$AgeGroup == "Old" & demdata$EducationLevel == "Har avslutat gymnasieskolan"]))))
outtable <- rbind(outtable, data.frame(variable = "Currently enrolled in tertiary education (n)", 
                                       younger = paste(length(demdata$Sex[demdata$AgeGroup == "Young" & demdata$EducationLevel == "Studerar f????r n??_rvarande p???? universitet/h????gskola"])),
                                       older = paste(length(demdata$Sex[demdata$AgeGroup == "Old" & demdata$EducationLevel == "Studerar f????r n??_rvarande p???? universitet/h????gskola"]))))
outtable <- rbind(outtable, data.frame(variable = "Completed tertiary education (n)", 
                                       younger = paste(length(demdata$Sex[demdata$AgeGroup == "Young" & demdata$EducationLevel == "Har examen fr????n universitet/h????gskola"])),
                                       older = paste(length(demdata$Sex[demdata$AgeGroup == "Old" & demdata$EducationLevel == "Har examen fr????n universitet/h????gskola"]))))
outtable <- rbind(outtable, data.frame(variable = "ISI (mean, SD)", 
                                       younger = paste(round(mean(demdata$ISI[demdata$AgeGroup == "Young"]), 1), "(", round(sd(demdata$ISI[demdata$AgeGroup == "Young"]), 1), ")"),
                                       older = paste(round(mean(demdata$ISI[demdata$AgeGroup == "Old"]), 1), "(", round(sd(demdata$ISI[demdata$AgeGroup == "Old"]), 1), ")")))
outtable <- rbind(outtable, data.frame(variable = "HADS-Depression (mean, SD)", 
                                       younger = paste(round(mean(demdata$HADS_Depression[demdata$AgeGroup == "Young"]), 1), "(", round(sd(demdata$HADS_Depression[demdata$AgeGroup == "Young"]), 1), ")"),
                                       older = paste(round(mean(demdata$HADS_Depression[demdata$AgeGroup == "Old"]), 1), "(", round(sd(demdata$HADS_Depression[demdata$AgeGroup == "Old"]), 1), ")")))
outtable <- rbind(outtable, data.frame(variable = "Total sleep time, full sleep (mean, SD)", 
                                       younger = paste(round(mean(demdata$tst__00_nsd[demdata$AgeGroup == "Young"], na.rm = T), 1), "(", round(sd(demdata$tst__00_nsd[demdata$AgeGroup == "Young"], na.rm = T), 1), ")"),
                                       older = paste(round(mean(demdata$tst__00_nsd[demdata$AgeGroup == "Old"], na.rm = T), 1), "(", round(sd(demdata$tst__00_nsd[demdata$AgeGroup == "Old"], na.rm = T), 1), ")")))
outtable <- rbind(outtable, data.frame(variable = "Total sleep time, partial sleep deprivation (mean, SD)", 
                                       younger = paste(round(mean(demdata$tst__00_sd[demdata$AgeGroup == "Young"], na.rm = T), 1), "(", round(sd(demdata$tst__00_sd[demdata$AgeGroup == "Young"], na.rm = T), 1), ")"),
                                       older = paste(round(mean(demdata$tst__00_sd[demdata$AgeGroup == "Old"], na.rm = T), 1), "(", round(sd(demdata$tst__00_sd[demdata$AgeGroup == "Old"], na.rm = T), 1), ")")))
outtable <- rbind(outtable, data.frame(variable = "NREM, full sleep (mean, SD)", 
                                       younger = paste(round(mean(demdata$NREM_nsd[demdata$AgeGroup == "Young"], na.rm = T), 1), "(", round(sd(demdata$NREM_nsd[demdata$AgeGroup == "Young"], na.rm = T), 1), ")"),
                                       older = paste(round(mean(demdata$NREM_nsd[demdata$AgeGroup == "Old"], na.rm = T), 1), "(", round(sd(demdata$NREM_nsd[demdata$AgeGroup == "Old"], na.rm = T), 1), ")")))
outtable <- rbind(outtable, data.frame(variable = "NREM, partial sleep deprivation (mean, SD)", 
                                       younger = paste(round(mean(demdata$NREM_sd[demdata$AgeGroup == "Young"], na.rm = T), 1), "(", round(sd(demdata$NREM_sd[demdata$AgeGroup == "Young"], na.rm = T), 1), ")"),
                                       older = paste(round(mean(demdata$NREM_sd[demdata$AgeGroup == "Old"], na.rm = T), 1), "(", round(sd(demdata$NREM_sd[demdata$AgeGroup == "Old"], na.rm = T), 1), ")")))
outtable <- rbind(outtable, data.frame(variable = "N3, full sleep (mean, SD)", 
                                       younger = paste(round(mean(demdata$n3___00_nsd[demdata$AgeGroup == "Young"], na.rm = T), 1), "(", round(sd(demdata$n3___00_nsd[demdata$AgeGroup == "Young"], na.rm = T), 1), ")"),
                                       older = paste(round(mean(demdata$n3___00_nsd[demdata$AgeGroup == "Old"], na.rm = T), 1), "(", round(sd(demdata$n3___00_nsd[demdata$AgeGroup == "Old"], na.rm = T), 1), ")")))
outtable <- rbind(outtable, data.frame(variable = "N3, partial sleep deprivation (mean, SD)", 
                                       younger = paste(round(mean(demdata$n3___00_sd[demdata$AgeGroup == "Young"], na.rm = T), 1), "(", round(sd(demdata$n3___00_sd[demdata$AgeGroup == "Young"], na.rm = T), 1), ")"),
                                       older = paste(round(mean(demdata$n3___00_sd[demdata$AgeGroup == "Old"], na.rm = T), 1), "(", round(sd(demdata$n3___00_sd[demdata$AgeGroup == "Old"], na.rm = T), 1), ")")))
outtable <- rbind(outtable, data.frame(variable = "N2, full sleep (mean, SD)", 
                                       younger = paste(round(mean(demdata$n2___00_nsd[demdata$AgeGroup == "Young"], na.rm = T), 1), "(", round(sd(demdata$n2___00_nsd[demdata$AgeGroup == "Young"], na.rm = T), 1), ")"),
                                       older = paste(round(mean(demdata$n2___00_nsd[demdata$AgeGroup == "Old"], na.rm = T), 1), "(", round(sd(demdata$n2___00_nsd[demdata$AgeGroup == "Old"], na.rm = T), 1), ")")))
outtable <- rbind(outtable, data.frame(variable = "N2, partial sleep deprivation (mean, SD)", 
                                       younger = paste(round(mean(demdata$n2___00_sd[demdata$AgeGroup == "Young"], na.rm = T), 1), "(", round(sd(demdata$n2___00_sd[demdata$AgeGroup == "Young"], na.rm = T), 1), ")"),
                                       older = paste(round(mean(demdata$n2___00_sd[demdata$AgeGroup == "Old"], na.rm = T), 1), "(", round(sd(demdata$n2___00_sd[demdata$AgeGroup == "Old"], na.rm = T), 1), ")")))
outtable <- rbind(outtable, data.frame(variable = "N1, full sleep (mean, SD)", 
                                       younger = paste(round(mean(demdata$n1___00_nsd[demdata$AgeGroup == "Young"], na.rm = T), 1), "(", round(sd(demdata$n1___00_nsd[demdata$AgeGroup == "Young"], na.rm = T), 1), ")"),
                                       older = paste(round(mean(demdata$n1___00_nsd[demdata$AgeGroup == "Old"], na.rm = T), 1), "(", round(sd(demdata$n1___00_nsd[demdata$AgeGroup == "Old"], na.rm = T), 1), ")")))
outtable <- rbind(outtable, data.frame(variable = "N1, partial sleep deprivation (mean, SD)", 
                                       younger = paste(round(mean(demdata$n1___00_sd[demdata$AgeGroup == "Young"], na.rm = T), 1), "(", round(sd(demdata$n1___00_sd[demdata$AgeGroup == "Young"], na.rm = T), 1), ")"),
                                       older = paste(round(mean(demdata$n1___00_sd[demdata$AgeGroup == "Old"], na.rm = T), 1), "(", round(sd(demdata$n1___00_sd[demdata$AgeGroup == "Old"], na.rm = T), 1), ")")))
outtable <- rbind(outtable, data.frame(variable = "REM sleep, full sleep (mean, SD)", 
                                       younger = paste(round(mean(demdata$r____00_nsd[demdata$AgeGroup == "Young"], na.rm = T), 1), "(", round(sd(demdata$r____00_nsd[demdata$AgeGroup == "Young"], na.rm = T), 1), ")"),
                                       older = paste(round(mean(demdata$r____00_nsd[demdata$AgeGroup == "Old"], na.rm = T), 1), "(", round(sd(demdata$r____00_nsd[demdata$AgeGroup == "Old"], na.rm = T), 1), ")")))
outtable <- rbind(outtable, data.frame(variable = "REM sleep, partial sleep deprivation (mean, SD)", 
                                       younger = paste(round(mean(demdata$r____00_sd[demdata$AgeGroup == "Young"], na.rm = T), 1), "(", round(sd(demdata$r____00_sd[demdata$AgeGroup == "Young"], na.rm = T), 1), ")"),
                                       older = paste(round(mean(demdata$r____00_sd[demdata$AgeGroup == "Old"], na.rm = T), 1), "(", round(sd(demdata$r____00_sd[demdata$AgeGroup == "Old"], na.rm = T), 1), ")")))
outtable <- rbind(outtable, data.frame(variable = "Sleep efficiency, full sleep (mean, SD)", 
                                       younger = paste(round(mean(demdata$eff__00_nsd[demdata$AgeGroup == "Young"], na.rm = T), 1), "(", round(sd(demdata$eff__00_nsd[demdata$AgeGroup == "Young"], na.rm = T), 1), ")"),
                                       older = paste(round(mean(demdata$eff__00_nsd[demdata$AgeGroup == "Old"], na.rm = T), 1), "(", round(sd(demdata$eff__00_nsd[demdata$AgeGroup == "Old"], na.rm = T), 1), ")")))
outtable <- rbind(outtable, data.frame(variable = "Sleep efficiency, partial sleep deprivation (mean, SD)", 
                                       younger = paste(round(mean(demdata$eff__00_sd[demdata$AgeGroup == "Young"], na.rm = T), 1), "(", round(sd(demdata$eff__00_sd[demdata$AgeGroup == "Young"], na.rm = T), 1), ")"),
                                       older = paste(round(mean(demdata$eff__00_sd[demdata$AgeGroup == "Old"], na.rm = T), 1), "(", round(sd(demdata$eff__00_sd[demdata$AgeGroup == "Old"], na.rm = T), 1), ")")))
outtable <- rbind(outtable, data.frame(variable = "Sleep latency, full sleep (mean, SD)", 
                                       younger = paste(round(mean(demdata$slat_00_nsd[demdata$AgeGroup == "Young"], na.rm = T), 1), "(", round(sd(demdata$slat_00_nsd[demdata$AgeGroup == "Young"], na.rm = T), 1), ")"),
                                       older = paste(round(mean(demdata$slat_00_nsd[demdata$AgeGroup == "Old"], na.rm = T), 1), "(", round(sd(demdata$slat_00_nsd[demdata$AgeGroup == "Old"], na.rm = T), 1), ")")))
outtable <- rbind(outtable, data.frame(variable = "Sleep latency, partial sleep deprivation (mean, SD)", 
                                       younger = paste(round(mean(demdata$slat_00_sd[demdata$AgeGroup == "Young"], na.rm = T), 1), "(", round(sd(demdata$slat_00_sd[demdata$AgeGroup == "Young"], na.rm = T), 1), ")"),
                                       older = paste(round(mean(demdata$slat_00_sd[demdata$AgeGroup == "Old"], na.rm = T), 1), "(", round(sd(demdata$slat_00_sd[demdata$AgeGroup == "Old"], na.rm = T), 1), ")")))
outtable <- rbind(outtable, data.frame(variable = "N3 latency, full sleep (mean, SD)", 
                                       younger = paste(round(mean(demdata$n3l__00_nsd[demdata$AgeGroup == "Young"], na.rm = T), 1), "(", round(sd(demdata$n3l__00_nsd[demdata$AgeGroup == "Young"], na.rm = T), 1), ")"),
                                       older = paste(round(mean(demdata$n3l__00_nsd[demdata$AgeGroup == "Old"], na.rm = T), 1), "(", round(sd(demdata$n3l__00_nsd[demdata$AgeGroup == "Old"], na.rm = T), 1), ")")))
outtable <- rbind(outtable, data.frame(variable = "N3 latency, partial sleep deprivation (mean, SD)", 
                                       younger = paste(round(mean(demdata$n3l__00_sd[demdata$AgeGroup == "Young"], na.rm = T), 1), "(", round(sd(demdata$n3l__00_sd[demdata$AgeGroup == "Young"], na.rm = T), 1), ")"),
                                       older = paste(round(mean(demdata$n3l__00_sd[demdata$AgeGroup == "Old"], na.rm = T), 1), "(", round(sd(demdata$n3l__00_sd[demdata$AgeGroup == "Old"], na.rm = T), 1), ")")))
outtable <- rbind(outtable, data.frame(variable = "REM latency, full sleep (mean, SD)", 
                                       younger = paste(round(mean(demdata$rl___00_nsd[demdata$AgeGroup == "Young"], na.rm = T), 1), "(", round(sd(demdata$rl___00_nsd[demdata$AgeGroup == "Young"], na.rm = T), 1), ")"),
                                       older = paste(round(mean(demdata$rl___00_nsd[demdata$AgeGroup == "Old"], na.rm = T), 1), "(", round(sd(demdata$rl___00_nsd[demdata$AgeGroup == "Old"], na.rm = T), 1), ")")))
outtable <- rbind(outtable, data.frame(variable = "REM latency, partial sleep deprivation (mean, SD)", 
                                       younger = paste(round(mean(demdata$rl___00_sd[demdata$AgeGroup == "Young"], na.rm = T), 1), "(", round(sd(demdata$rl___00_sd[demdata$AgeGroup == "Young"], na.rm = T), 1), ")"),
                                       older = paste(round(mean(demdata$rl___00_sd[demdata$AgeGroup == "Old"], na.rm = T), 1), "(", round(sd(demdata$rl___00_sd[demdata$AgeGroup == "Old"], na.rm = T), 1), ")")))






# Analyse PANAS
demdata$PANAS_Positive_fullsleep <- NA
demdata$PANAS_Positive_fullsleep[demdata$Sl_cond == 1] <- demdata$PANAS_Positive_byScanner.y[demdata$Sl_cond == 1]
demdata$PANAS_Positive_fullsleep[demdata$Sl_cond == 2] <- demdata$PANAS_Positive_byScanner.x[demdata$Sl_cond == 2]
demdata$PANAS_Positive_sleepdeprived <- NA
demdata$PANAS_Positive_sleepdeprived[demdata$Sl_cond == 1] <- demdata$PANAS_Positive_byScanner.x[demdata$Sl_cond == 1]
demdata$PANAS_Positive_sleepdeprived[demdata$Sl_cond == 2] <- demdata$PANAS_Positive_byScanner.y[demdata$Sl_cond == 2]

demdata$PANAS_Negative_fullsleep <- NA
demdata$PANAS_Negative_fullsleep[demdata$Sl_cond == 1] <- demdata$PANAS_Negative_byScanner.y[demdata$Sl_cond == 1]
demdata$PANAS_Negative_fullsleep[demdata$Sl_cond == 2] <- demdata$PANAS_Negative_byScanner.x[demdata$Sl_cond == 2]
demdata$PANAS_Negative_sleepdeprived <- NA
demdata$PANAS_Negative_sleepdeprived[demdata$Sl_cond == 1] <- demdata$PANAS_Negative_byScanner.x[demdata$Sl_cond == 1]
demdata$PANAS_Negative_sleepdeprived[demdata$Sl_cond == 2] <- demdata$PANAS_Negative_byScanner.y[demdata$Sl_cond == 2]

boxplot(demdata$PANAS_Positive, demdata$PANAS_Positive_fullsleep, demdata$PANAS_Positive_sleepdeprived, frame.plot = F, names = c("Baseline", "Full sleep", "Sleep deprived"), main = "PANAS positive")
t.test(demdata$PANAS_Positive_fullsleep, demdata$PANAS_Positive_sleepdeprived, paired = T)

boxplot(demdata$PANAS_Negative, demdata$PANAS_Negative_fullsleep, demdata$PANAS_Negative_sleepdeprived, frame.plot = F, names = c("Baseline", "Full sleep", "Sleep deprived"), main = "PANAS negative")
t.test(demdata$PANAS_Negative_fullsleep, demdata$PANAS_Negative_sleepdeprived, paired = T)

