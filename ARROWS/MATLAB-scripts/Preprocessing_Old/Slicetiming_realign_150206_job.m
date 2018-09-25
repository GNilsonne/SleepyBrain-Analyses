%-----------------------------------------------------------------------
% Job saved on 13-Jan-2015 10:43:19 by cfg_util (rev $Rev: 6134 $)
% spm SPM - SPM12 (6225)
% cfg_basicio BasicIO - Unknown
%---------------------------------------
% Script to perform slice timing in old subjects 
%--------------------------------

root_path = '/data/stress/ARROWS/ARROWS_Old';
folders = dir(root_path);
folders = folders(arrayfun(@(folder) ~strcmp(folder.name(1), '.'),folders));


for i = 1:length(folders)
    subject_session = folders(i).name;
    
    files = dir(strcat('/data/stress/ARROWS/ARROWS_Old/', subject_session, '/2*.nii'));
    data = arrayfun(@(file) strcat('/data/stress/ARROWS/ARROWS_Old/', subject_session, '/', file.name), files, 'UniformOutput', false);
    
    matlabbatch{1}.spm.temporal.st.scans = {
                                            data
                                                }';
    matlabbatch{1}.spm.temporal.st.nslices = 46;
    matlabbatch{1}.spm.temporal.st.tr = 3;
    matlabbatch{1}.spm.temporal.st.ta = 2.93478260869565;
    matlabbatch{1}.spm.temporal.st.so = [1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31 33 35 37 39 41 43 45 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 42 44 46];
    matlabbatch{1}.spm.temporal.st.refslice = 2;
    matlabbatch{1}.spm.temporal.st.prefix = 'a';

    
    spm_jobman('run', matlabbatch)

    clear matlabbatch 

end

