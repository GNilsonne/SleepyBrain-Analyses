# Code used to parse baseline ratings and generate summary measures for rating scales
# The code is taken out of context and is not functional with the pseudonymized data that have been published
# Nonetheless it shows transparently how the summary measures have been generated
# If six dummy columns are added at beginning of data frame ("BaselineRatings_160320_pseudonymized.csv"), the code ought in principle to work again

parseBISAnswer <- function(answer) {
  lower_answer = tolower(answer)
  if (lower_answer == "sällan/aldrig")
    return(1)
  if (lower_answer == "ibland")
    return(2)
  if (lower_answer == "ofta")
    return(3)
  if (lower_answer == "nästan alltid/alltid")
    return(4)
  # Return NA if no matching answer found
  return(NA)
}

for (i in 1:length(IncludedSubjects[, 1])){
  dataTemp <- BaselineData[(!is.na(BaselineData[2]) & BaselineData[2] == IncludedSubjects[i,1])]
  
  
  dataTemp[6:163] <- (substring(dataTemp[6:163], 1, 1))
  dataTemp[172:191] <- (substring(dataTemp[172:191], 1, 1))
  
  dataOut <- data.frame("Subject" = 0)
  dataOut$Subject <- dataTemp[2]
  dataOut$Height <- dataTemp[4]
  dataOut$IRI_EC <- (as.integer(dataTemp[7]) + 
                       6 - as.integer(dataTemp[9]) + # Reverse scored
                       as.integer(dataTemp[14]) + 
                       6 - as.integer(dataTemp[19]) + # Reverse scored
                       6 - as.integer(dataTemp[23]) + # Reverse scored
                       as.integer(dataTemp[25]) +
                       as.integer(dataTemp[27]))/7
  dataOut$TAS20_Total <- sum(as.integer(dataTemp[34:53]))
  dataOut$TAS20_DIF <- (as.integer(dataTemp[34]) + 
                          as.integer(dataTemp[36]) + 
                          as.integer(dataTemp[39]) + 
                          as.integer(dataTemp[40]) +
                          as.integer(dataTemp[42]) + 
                          as.integer(dataTemp[46]) +
                          as.integer(dataTemp[47]))
  dataOut$TAS20_DDF <- (as.integer(dataTemp[35]) + 
                          as.integer(dataTemp[37]) + 
                          as.integer(dataTemp[44]) + 
                          as.integer(dataTemp[45]) +
                          as.integer(dataTemp[50]))
  dataOut$TAS20_EOT <- (as.integer(dataTemp[38]) + 
                          as.integer(dataTemp[41]) + 
                          as.integer(dataTemp[43]) + 
                          as.integer(dataTemp[48]) +
                          as.integer(dataTemp[49]) + 
                          as.integer(dataTemp[51]) +
                          as.integer(dataTemp[52]) +
                          as.integer(dataTemp[53]))
  dataOut$STAI_T <- (5 - as.integer(dataTemp[54]) + # Reverse scored
                       as.integer(dataTemp[55]) + 
                       as.integer(dataTemp[56]) + 
                       as.integer(dataTemp[57]) +
                       as.integer(dataTemp[58]) + 
                       5 - as.integer(dataTemp[59]) +  # Reverse scored
                       5 - as.integer(dataTemp[60]) +  # Reverse scored
                       as.integer(dataTemp[61]) + 
                       as.integer(dataTemp[62]) + 
                       5 - as.integer(dataTemp[63]) +   # Reverse scored
                       as.integer(dataTemp[64]) +
                       as.integer(dataTemp[65]) + 
                       5 - as.integer(dataTemp[66]) +  # Reverse scored
                       as.integer(dataTemp[67]) +
                       as.integer(dataTemp[68]) + 
                       5 - as.integer(dataTemp[69]) +  # Reverse scored
                       as.integer(dataTemp[70]) + 
                       as.integer(dataTemp[71]) +
                       5 - as.integer(dataTemp[72]) +  # Reverse scored
                       as.integer(dataTemp[73]))
  dataOut$BFI_Extraversion <- (as.integer(dataTemp[74]) + 
                                 6 - as.integer(dataTemp[79]) + 
                                 as.integer(dataTemp[84]) + 
                                 as.integer(dataTemp[89]) +
                                 6 - as.integer(dataTemp[94]) + 
                                 as.integer(dataTemp[99]) +
                                 6 - as.integer(dataTemp[104]) + 
                                 as.integer(dataTemp[109]))
  dataOut$BFI_Agreeableness <- (6 - as.integer(dataTemp[75]) + 
                                  as.integer(dataTemp[80]) + 
                                  6 - as.integer(dataTemp[85]) + 
                                  as.integer(dataTemp[90]) +
                                  as.integer(dataTemp[95]) + 
                                  6 - as.integer(dataTemp[100]) +
                                  as.integer(dataTemp[105]) + 
                                  6 - as.integer(dataTemp[110]) + 
                                  as.integer(dataTemp[115]))
  dataOut$BFI_Conscientiousness <- (as.integer(dataTemp[76]) + 
                                      6 - as.integer(dataTemp[81]) + 
                                      as.integer(dataTemp[86]) + 
                                      6 - as.integer(dataTemp[91]) +
                                      6 - as.integer(dataTemp[96]) + 
                                      as.integer(dataTemp[101]) +
                                      as.integer(dataTemp[106]) + 
                                      as.integer(dataTemp[111]) + 
                                      6 - as.integer(dataTemp[116]))
  dataOut$BFI_Neuroticism <- (as.integer(dataTemp[77]) + 
                                6 - as.integer(dataTemp[82]) + 
                                as.integer(dataTemp[87]) + 
                                as.integer(dataTemp[92]) +
                                6 - as.integer(dataTemp[97]) + 
                                as.integer(dataTemp[102]) +
                                6 - as.integer(dataTemp[107]) + 
                                as.integer(dataTemp[112]))
  dataOut$BFI_Openness <- (as.integer(dataTemp[78]) + 
                             as.integer(dataTemp[83]) + 
                             as.integer(dataTemp[88]) + 
                             as.integer(dataTemp[93]) +
                             as.integer(dataTemp[98]) + 
                             as.integer(dataTemp[103]) +
                             6 - as.integer(dataTemp[108]) + 
                             as.integer(dataTemp[113]) +
                             6 - as.integer(dataTemp[114]) + 
                             as.integer(dataTemp[117]))
  dataOut$PANAS_Positive <- (as.integer(dataTemp[118]) + 
                               as.integer(dataTemp[124]) + 
                               as.integer(dataTemp[125]) + 
                               as.integer(dataTemp[127]) +
                               as.integer(dataTemp[129]) + 
                               as.integer(dataTemp[131]) +
                               as.integer(dataTemp[132]) + 
                               as.integer(dataTemp[134]) +
                               as.integer(dataTemp[136]) + 
                               as.integer(dataTemp[137]))
  dataOut$PANAS_Negative <- (as.integer(dataTemp[119]) + 
                               as.integer(dataTemp[120]) + 
                               as.integer(dataTemp[121]) + 
                               as.integer(dataTemp[122]) +
                               as.integer(dataTemp[123]) + 
                               as.integer(dataTemp[126]) +
                               as.integer(dataTemp[138]) + 
                               as.integer(dataTemp[130]) +
                               as.integer(dataTemp[133]) + 
                               as.integer(dataTemp[135]))
  dataOut$PSS14 <- (as.integer(dataTemp[138]) + 
                      as.integer(dataTemp[139]) + 
                      as.integer(dataTemp[140]) + 
                      4 - as.integer(dataTemp[141]) +
                      4 - as.integer(dataTemp[142]) + 
                      4 - as.integer(dataTemp[143]) +
                      4 - as.integer(dataTemp[144]) + 
                      as.integer(dataTemp[145]) +
                      4 - as.integer(dataTemp[146]) + 
                      4 - as.integer(dataTemp[147]) + 
                      as.integer(dataTemp[148]) +
                      as.integer(dataTemp[149]) + 
                      4 - as.integer(dataTemp[150]) + 
                      as.integer(dataTemp[151]))
  dataOut$SelfRatedHealth <- as.integer(dataTemp[152])
  dataOut$SRH5 <- as.integer(dataTemp[153])
  dataOut$ESS <- sum(as.integer(dataTemp[172:179]))
  dataOut$SicknessQ_Emotion <- (as.integer(dataTemp[183]) + 
                                  as.integer(dataTemp[185]) + 
                                  as.integer(dataTemp[186]))
  dataOut$SicknessQ_Emotion_reduced <- (as.integer(dataTemp[183]) + 
                                          as.integer(dataTemp[186]))
  dataOut$SicknessQ_Fatigue <- (5 - as.integer(dataTemp[180]) + 
                                  as.integer(dataTemp[182]) + 
                                  5 - as.integer(dataTemp[187]) + 
                                  5 - as.integer(dataTemp[188]) +
                                  5 - as.integer(dataTemp[191]))
  dataOut$SicknessQ_Pain <- (as.integer(dataTemp[181]) + 
                               as.integer(dataTemp[184]) + 
                               as.integer(dataTemp[189]) + 
                               as.integer(dataTemp[190]))
  dataOut$SicknessQ_Total <- dataOut$SicknessQ_Emotion + 
    dataOut$SicknessQ_Fatigue + 
    dataOut$SicknessQ_Pain
  dataOut$SicknessQ_Total_reduced <- dataOut$SicknessQ_Emotion_reduced + 
    dataOut$SicknessQ_Fatigue + 
    dataOut$SicknessQ_Pain
  dataOut$ECS <- (
    as.integer(substr(dataTemp[193],0,1)) + 
      as.integer(substr(dataTemp[194],0,1)) + 
      as.integer(substr(dataTemp[195],0,1)) +
      as.integer(substr(dataTemp[196],0,1)) + 
      as.integer(substr(dataTemp[197],0,1)) +
      as.integer(substr(dataTemp[198],0,1)) + 
      as.integer(substr(dataTemp[199],0,1)) +
      as.integer(substr(dataTemp[200],0,1)) + 
      as.integer(substr(dataTemp[201],0,1)) + 
      as.integer(substr(dataTemp[202],0,1)) +
      as.integer(substr(dataTemp[203],0,1)) + 
      as.integer(substr(dataTemp[204],0,1)) + 
      as.integer(substr(dataTemp[205],0,1)) + 
      as.integer(substr(dataTemp[206],0,1)) +                 
      as.integer(substr(dataTemp[207],0,1)))/15
  dataOut$"BIS-11(total)" <- (
    5 - parseBISAnswer(dataTemp[208]) + #1
      parseBISAnswer(dataTemp[209]) + #2
      parseBISAnswer(dataTemp[210]) + #3
      parseBISAnswer(dataTemp[211]) + #4
      parseBISAnswer(dataTemp[212]) + #5
      parseBISAnswer(dataTemp[213]) + #6
      5 - parseBISAnswer(dataTemp[214]) + #7
      5 - parseBISAnswer(dataTemp[215]) + #8
      5 - parseBISAnswer(dataTemp[216]) + #9
      5 - parseBISAnswer(dataTemp[217]) + #10
      parseBISAnswer(dataTemp[218]) + #11
      5 - parseBISAnswer(dataTemp[219]) + #12
      5 - parseBISAnswer(dataTemp[220]) + #13
      parseBISAnswer(dataTemp[221]) + #14
      5 - parseBISAnswer(dataTemp[222]) + #15
      parseBISAnswer(dataTemp[223]) + #16
      parseBISAnswer(dataTemp[224]) + #17
      parseBISAnswer(dataTemp[225]) + #18
      parseBISAnswer(dataTemp[226]) + #19
      5 - parseBISAnswer(dataTemp[227]) + #20
      parseBISAnswer(dataTemp[228]) + #21
      parseBISAnswer(dataTemp[229]) + #22
      parseBISAnswer(dataTemp[230]) + #23 
      parseBISAnswer(dataTemp[231]) + #24
      parseBISAnswer(dataTemp[232]) + #25
      parseBISAnswer(dataTemp[233]) + #26
      parseBISAnswer(dataTemp[234]) + #27 
      parseBISAnswer(dataTemp[235]) + #28
      5 - parseBISAnswer(dataTemp[236]) + #29
      5 - parseBISAnswer(dataTemp[237]))/30   #30 
  dataOut$"BIS-11(Attentional)" <- (
    parseBISAnswer(dataTemp[212]) + #5
      parseBISAnswer(dataTemp[213]) + #6
      5 - parseBISAnswer(dataTemp[216]) + #9
      parseBISAnswer(dataTemp[218]) + #11
      5 - parseBISAnswer(dataTemp[227]) + #20  
      parseBISAnswer(dataTemp[231]) + #24  
      parseBISAnswer(dataTemp[233]) + #26  
      parseBISAnswer(dataTemp[235]))/8 #28
  dataOut$"BIS-11(Motor)" <- (
    parseBISAnswer(dataTemp[209]) + #2
      parseBISAnswer(dataTemp[210]) + #3
      parseBISAnswer(dataTemp[211]) + #4
      parseBISAnswer(dataTemp[223]) + #16
      parseBISAnswer(dataTemp[224]) + #17  
      parseBISAnswer(dataTemp[226]) + #19
      parseBISAnswer(dataTemp[228]) + #21
      parseBISAnswer(dataTemp[229]) + #22
      parseBISAnswer(dataTemp[230]) + #23 
      parseBISAnswer(dataTemp[232]) + #25  
      5 - parseBISAnswer(dataTemp[237]))/11 #30   
  dataOut$"BIS-11(Nonplanning)" <- (
    5 - parseBISAnswer(dataTemp[208]) + #1
      5 - parseBISAnswer(dataTemp[214]) + #7
      5 - parseBISAnswer(dataTemp[215]) + #8  
      5 - parseBISAnswer(dataTemp[217]) + #10
      5 - parseBISAnswer(dataTemp[219]) + #12
      5 - parseBISAnswer(dataTemp[220]) + #13
      parseBISAnswer(dataTemp[221]) + #14
      5 - parseBISAnswer(dataTemp[222]) + #15  
      parseBISAnswer(dataTemp[225]) + #18  
      parseBISAnswer(dataTemp[234]) + #27   
      5 - parseBISAnswer(dataTemp[236]))/11 #29  
  
  if (i == 1){
    BaselineDataOut <- dataOut
  } else {
    BaselineDataOut <- rbind(BaselineDataOut, dataOut)
  }
}
