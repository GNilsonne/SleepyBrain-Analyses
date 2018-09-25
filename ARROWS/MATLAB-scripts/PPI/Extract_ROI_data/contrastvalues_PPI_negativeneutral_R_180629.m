root_path = '/data/stress/ARROWS/ARROWS_Young2/45Slices';
folders = dir(root_path);
folders = folders(arrayfun(@(folders) ~strcmp(folders.name(1), '.'),folders));

for i = 1:length(folders)
    subject_session = folders(i).name;
    s = subject_session(1:3);
    subject = str2num(s);
    ses = subject_session(5);
    session = str2num(ses);
    dlPFCL = mean(spm_summarise(strcat('/data/stress/ARROWS/ARROWS_Young2/45Slices/', subject_session, '/PPI_180621_Neg_neu_R/con_0001.nii'), struct('def', 'mask', 'spec', '/data/stress/ARROWS/RegionsOfInterest/dlPFCL_mask.nii')));
    a = size(spm_summarise(strcat('/data/stress/ARROWS/ARROWS_Young2/45Slices/', subject_session, '/PPI_180621_Neg_neu_R/con_0001.nii'), struct('def', 'mask', 'spec', '/data/stress/ARROWS/RegionsOfInterest/dlPFCL_mask.nii')));
    dlPFCR = mean(spm_summarise(strcat('/data/stress/ARROWS/ARROWS_Young2/45Slices/', subject_session, '/PPI_180621_Neg_neu_R/con_0001.nii'), struct('def', 'mask', 'spec', '/data/stress/ARROWS/RegionsOfInterest/dlPFCR_mask.nii')));
    b = size(spm_summarise(strcat('/data/stress/ARROWS/ARROWS_Young2/45Slices/', subject_session, '/PPI_180621_Neg_neu_R/con_0001.nii'), struct('def', 'mask', 'spec', '/data/stress/ARROWS/RegionsOfInterest/dlPFCR_mask.nii')));
    lOFCL = mean(spm_summarise(strcat('/data/stress/ARROWS/ARROWS_Young2/45Slices/', subject_session, '/PPI_180621_Neg_neu_R/con_0001.nii'), struct('def', 'mask', 'spec', '/data/stress/ARROWS/RegionsOfInterest/lOFCL_mask.nii')));
    c = size(spm_summarise(strcat('/data/stress/ARROWS/ARROWS_Young2/45Slices/', subject_session, '/PPI_180621_Neg_neu_R/con_0001.nii'), struct('def', 'mask', 'spec', '/data/stress/ARROWS/RegionsOfInterest/lOFCL_mask.nii')));
    lOFCR = mean(spm_summarise(strcat('/data/stress/ARROWS/ARROWS_Young2/45Slices/', subject_session, '/PPI_180621_Neg_neu_R/con_0001.nii'), struct('def', 'mask', 'spec', '/data/stress/ARROWS/RegionsOfInterest/lOFCR_mask.nii')));
    d = size(spm_summarise(strcat('/data/stress/ARROWS/ARROWS_Young2/45Slices/', subject_session, '/PPI_180621_Neg_neu_R/con_0001.nii'), struct('def', 'mask', 'spec', '/data/stress/ARROWS/RegionsOfInterest/lOFCR_mask.nii')));
   if i == 1   
        data = [subject, session, dlPFCL, a(2), dlPFCR, b(2), lOFCL, c(2), lOFCR, d(2)];
   else
       data = [data; subject, session, dlPFCL, a(2), dlPFCR, b(2), lOFCL, c(2), lOFCR, d(2)];
   end
end

root_path = '/data/stress/ARROWS/ARROWS_Young2/46Slices';
folders = dir(root_path);
folders = folders(arrayfun(@(folders) ~strcmp(folders.name(1), '.'),folders));

for i = 1:length(folders)
    subject_session = folders(i).name;
    s = subject_session(1:3);
    subject = str2num(s);
    ses = subject_session(5);
    session = str2num(ses);
    dlPFCL = mean(spm_summarise(strcat('/data/stress/ARROWS/ARROWS_Young2/46Slices/', subject_session, '/PPI_180621_Neg_neu_R/con_0001.nii'), struct('def', 'mask', 'spec', '/data/stress/ARROWS/RegionsOfInterest/dlPFCL_mask.nii')));
    a = size(spm_summarise(strcat('/data/stress/ARROWS/ARROWS_Young2/46Slices/', subject_session, '/PPI_180621_Neg_neu_R/con_0001.nii'), struct('def', 'mask', 'spec', '/data/stress/ARROWS/RegionsOfInterest/dlPFCL_mask.nii')));
    dlPFCR = mean(spm_summarise(strcat('/data/stress/ARROWS/ARROWS_Young2/46Slices/', subject_session, '/PPI_180621_Neg_neu_R/con_0001.nii'), struct('def', 'mask', 'spec', '/data/stress/ARROWS/RegionsOfInterest/dlPFCR_mask.nii')));
    b = size(spm_summarise(strcat('/data/stress/ARROWS/ARROWS_Young2/46Slices/', subject_session, '/PPI_180621_Neg_neu_R/con_0001.nii'), struct('def', 'mask', 'spec', '/data/stress/ARROWS/RegionsOfInterest/dlPFCR_mask.nii')));
    lOFCL = mean(spm_summarise(strcat('/data/stress/ARROWS/ARROWS_Young2/46Slices/', subject_session, '/PPI_180621_Neg_neu_R/con_0001.nii'), struct('def', 'mask', 'spec', '/data/stress/ARROWS/RegionsOfInterest/lOFCL_mask.nii')));
    c = size(spm_summarise(strcat('/data/stress/ARROWS/ARROWS_Young2/46Slices/', subject_session, '/PPI_180621_Neg_neu_R/con_0001.nii'), struct('def', 'mask', 'spec', '/data/stress/ARROWS/RegionsOfInterest/lOFCL_mask.nii')));
    lOFCR = mean(spm_summarise(strcat('/data/stress/ARROWS/ARROWS_Young2/46Slices/', subject_session, '/PPI_180621_Neg_neu_R/con_0001.nii'), struct('def', 'mask', 'spec', '/data/stress/ARROWS/RegionsOfInterest/lOFCR_mask.nii')));
    d = size(spm_summarise(strcat('/data/stress/ARROWS/ARROWS_Young2/46Slices/', subject_session, '/PPI_180621_Neg_neu_R/con_0001.nii'), struct('def', 'mask', 'spec', '/data/stress/ARROWS/RegionsOfInterest/lOFCR_mask.nii')));

    data = [data; subject, session, dlPFCL, a(2), dlPFCR, b(2), lOFCL, c(2), lOFCR, d(2)];
 
end

root_path = '/data/stress/ARROWS/ARROWS_Old';
folders = dir(root_path);
folders = folders(arrayfun(@(folders) ~strcmp(folders.name(1), '.'),folders));


for i = 1:length(folders)
    subject_session = folders(i).name;
    s = subject_session(1:3);
    subject = str2num(s);
    ses = subject_session(5);
    session = str2num(ses);
    dlPFCL = mean(spm_summarise(strcat('/data/stress/ARROWS/ARROWS_Old/', subject_session, '/PPI_180621_Neg_neu_R/con_0001.nii'), struct('def', 'mask', 'spec', '/data/stress/ARROWS/RegionsOfInterest/dlPFCL_mask.nii')));
    a = size(spm_summarise(strcat('/data/stress/ARROWS/ARROWS_Old/', subject_session, '/PPI_180621_Neg_neu_R/con_0001.nii'), struct('def', 'mask', 'spec', '/data/stress/ARROWS/RegionsOfInterest/dlPFCL_mask.nii')));
    dlPFCR = mean(spm_summarise(strcat('/data/stress/ARROWS/ARROWS_Old/', subject_session, '/PPI_180621_Neg_neu_R/con_0001.nii'), struct('def', 'mask', 'spec', '/data/stress/ARROWS/RegionsOfInterest/dlPFCR_mask.nii')));
    b = size(spm_summarise(strcat('/data/stress/ARROWS/ARROWS_Old/', subject_session, '/PPI_180621_Neg_neu_R/con_0001.nii'), struct('def', 'mask', 'spec', '/data/stress/ARROWS/RegionsOfInterest/dlPFCR_mask.nii')));
    lOFCL = mean(spm_summarise(strcat('/data/stress/ARROWS/ARROWS_Old/', subject_session, '/PPI_180621_Neg_neu_R/con_0001.nii'), struct('def', 'mask', 'spec', '/data/stress/ARROWS/RegionsOfInterest/lOFCL_mask.nii')));
    c = size(spm_summarise(strcat('/data/stress/ARROWS/ARROWS_Old/', subject_session, '/PPI_180621_Neg_neu_R/con_0001.nii'), struct('def', 'mask', 'spec', '/data/stress/ARROWS/RegionsOfInterest/lOFCL_mask.nii')));
    lOFCR = mean(spm_summarise(strcat('/data/stress/ARROWS/ARROWS_Old/', subject_session, '/PPI_180621_Neg_neu_R/con_0001.nii'), struct('def', 'mask', 'spec', '/data/stress/ARROWS/RegionsOfInterest/lOFCR_mask.nii')));
    d = size(spm_summarise(strcat('/data/stress/ARROWS/ARROWS_Old/', subject_session, '/PPI_180621_Neg_neu_R/con_0001.nii'), struct('def', 'mask', 'spec', '/data/stress/ARROWS/RegionsOfInterest/lOFCR_mask.nii')));

    data = [data; subject, session, dlPFCL, a(2), dlPFCR, b(2), lOFCL, c(2), lOFCR, d(2)];
 
end


colNames = {'Subject', 'Session', 'dlPFC_L', 'size_dlPFC_L', 'dlPFC_R', 'size_dlPFC_R', 'lOFC_L', 'size_lOFC_L', 'lOFC_R', 'size_lOFC_R'};
Table = array2table(data, 'VariableNames', colNames);

cd /data/stress/ARROWS/Extractedfiles/
writetable(Table, 'PPI_Negative_vs_neutral_right_Amygdala')