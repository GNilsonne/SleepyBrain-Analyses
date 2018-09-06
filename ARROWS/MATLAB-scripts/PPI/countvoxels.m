root_path = '/data/stress/ARROWS/ARROWS_Young/45Slices';
folders = dir(root_path);
folders = folders(arrayfun(@(folders) ~strcmp(folders.name(1), '.'),folders));

for i = 1:length(folders)
   subject_session = folders(i).name;
   s = subject_session(1:3);
   subject = str2num(s);
   ses = subject_session(5);
   session = str2num(ses);
    
   Amygdala_L = mean(spm_summarise(strcat('/data/stress/ARROWS/ARROWS_Young/45Slices/', subject_session, '/1st_level_SPM/con_0016.nii'), '/data/stress/ARROWS/RegionsOfInterest/Amygdala_L_WFU.nii')); 
   Amygdala_R = mean(spm_summarise(strcat('/data/stress/ARROWS/ARROWS_Young/45Slices/', subject_session, '/1st_level_SPM/con_0016.nii'), '/data/stress/ARROWS/RegionsOfInterest/Amygdala_R_WFU.nii')); 
   lOFC_L = mean(spm_summarise(strcat('/data/stress/ARROWS/ARROWS_Young/45Slices/', subject_session, '/1st_level_SPM/con_0016.nii'), '/data/stress/ARROWS/RegionsOfInterest/lOFC_L_WFU.nii')); 
   lOFC_R = mean(spm_summarise(strcat('/data/stress/ARROWS/ARROWS_Young/45Slices/', subject_session, '/1st_level_SPM/con_0016.nii'), '/data/stress/ARROWS/RegionsOfInterest/lOFC_R_WFU.nii')); 
   dlPFC_bilat = mean(spm_summarise(strcat('/data/stress/ARROWS/ARROWS_Young/45Slices/', subject_session, '/1st_level_SPM/con_0016.nii'), '/data/stress/ARROWS/RegionsOfInterest/dlPFC_bilat_WFU.nii')); 
   
   if i == 1
       data = [subject, session, Amygdala_L, Amygdala_R, lOFC_L, lOFC_R, dlPFC_bilat];
   else
       data = [data; subject, session, Amygdala_L, Amygdala_R, lOFC_L, lOFC_R, dlPFC_bilat];
   end
end

root_path = '/data/stress/ARROWS/ARROWS_Young/46Slices';
folders = dir(root_path);
folders = folders(arrayfun(@(folders) ~strcmp(folders.name(1), '.'),folders));

for i = 1:length(folders)
    subject_session = folders(i).name;
    s = subject_session(1:3);
    subject = str2num(s);
    ses = subject_session(5);
    session = str2num(ses);
    Amygdala_L = mean(spm_summarise(strcat('/data/stress/ARROWS/ARROWS_Young/46Slices/', subject_session, '/1st_level_SPM/con_0016.nii'), '/data/stress/ARROWS/RegionsOfInterest/Amygdala_L_WFU.nii')); 
    Amygdala_R = mean(spm_summarise(strcat('/data/stress/ARROWS/ARROWS_Young/46Slices/', subject_session, '/1st_level_SPM/con_0016.nii'), '/data/stress/ARROWS/RegionsOfInterest/Amygdala_R_WFU.nii')); 
    lOFC_L = mean(spm_summarise(strcat('/data/stress/ARROWS/ARROWS_Young/46Slices/', subject_session, '/1st_level_SPM/con_0016.nii'), '/data/stress/ARROWS/RegionsOfInterest/lOFC_L_WFU.nii')); 
    lOFC_R = mean(spm_summarise(strcat('/data/stress/ARROWS/ARROWS_Young/46Slices/', subject_session, '/1st_level_SPM/con_0016.nii'), '/data/stress/ARROWS/RegionsOfInterest/lOFC_R_WFU.nii')); 
    dlPFC_bilat = mean(spm_summarise(strcat('/data/stress/ARROWS/ARROWS_Young/46Slices/', subject_session, '/1st_level_SPM/con_0016.nii'), '/data/stress/ARROWS/RegionsOfInterest/dlPFC_bilat_WFU.nii')); 
   
   if i == 1
       data2 = [subject, session, Amygdala_L, Amygdala_R, lOFC_L, lOFC_R, dlPFC_bilat];
   else
       data2 = [data2; subject, session, Amygdala_L, Amygdala_R, lOFC_L, lOFC_R, dlPFC_bilat];
   end
end

data = [data; data2];

csvwrite('/data/stress/ARROWS/ARROWS_Young/Data_Amygdala_LR_lOFC_LR_dlPFC_bilat_contrast_16', data)