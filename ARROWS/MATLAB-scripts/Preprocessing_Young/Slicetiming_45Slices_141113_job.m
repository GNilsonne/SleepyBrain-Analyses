% Preprocessing is done throug separate scripts for every step. Following
% steps are performed: Slice timing, realign and unwarp (fieldmap for
% subjects who have one for all sessions included), coregistration (EPI to
% structural), structural segmentation, DARTEL teplate and normalisation to MNI
% + SMOOTH.
%-----------------------------------------------------------------------
% Script to slice time correct all the young subjects/sessions with 45 slices,
% ARROWS experiment. Subjects/sessions with 46 slices are done separately.
% TR is 3 seconds, slice aquisition is interleaved bottom up. Ref slice is
% no 2. SPM12.

root_path = '/data/stress/ARROWS/ARROWS_Young2/45Slices';
folders = dir(root_path);
folders = folders(arrayfun(@(folders) ~strcmp(folders.name(1), '.'),folders));


for i = 1:length(folders)
    subject_session = folders(i).name;
    
    files = dir(strcat('/data/stress/ARROWS/ARROWS_Young2/45Slices/', subject_session, '/2*.nii'));
    data = arrayfun(@(file) strcat('/data/stress/ARROWS/ARROWS_Young2/45Slices/', subject_session, '/', file.name), files, 'UniformOutput', false);
    
    
        matlabbatch{i}.spm.temporal.st.scans = {
                                            data
                                                }';
    matlabbatch{i}.spm.temporal.st.nslices = 45;
    matlabbatch{i}.spm.temporal.st.tr = 3;
    matlabbatch{i}.spm.temporal.st.ta = 2.93333333333333;
    matlabbatch{i}.spm.temporal.st.so = [1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31 33 35 37 39 41 43 45 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 42 44];    
    matlabbatch{i}.spm.temporal.st.refslice = 2;
    matlabbatch{i}.spm.temporal.st.prefix = 'a';
end

