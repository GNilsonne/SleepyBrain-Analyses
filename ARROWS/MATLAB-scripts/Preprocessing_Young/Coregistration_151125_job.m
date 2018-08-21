% Preprocessing is done throug separate scripts for every step. Following
% steps are performed: Slice timing, realign and unwarp (fieldmap for
% subjects who have one for all sessions included), coregistration (EPI to
% structural), structural segmentation, DARTEL teplate and normalisation to MNI
% + SMOOTH.
%-----------------------------------------------------------------------
% Script to coregister all the functional scans to the structural.
% Segmentation of the structural scans was done, while preprocessing the
% HANDS experiment
%-----------------------------------------------------------------------

% Subjects who had 45 slices
root_path = '/data/stress/ARROWS/ARROWS_Young2/45Slices';
folders = dir(root_path);
folders = folders(arrayfun(@(folder) ~strcmp(folder.name(1), '.'),folders));

for i = 1:length(folders)
    
    subject_session = folders(i).name;
    subject = subject_session(1:3);
    session = subject_session(5);
    anatomical = dir(strcat('/data/stress/Structural_ARROWS_All/', subject, '*001.nii'));
    structural = arrayfun(@(file) strcat('/data/stress/Structural_ARROWS_All/', file.name), anatomical, 'UniformOutput', false);
    mean = dir(strcat('/data/stress/ARROWS/ARROWS_Young2/45Slices/', subject_session, '/m*.nii'));
    meanEPI = arrayfun(@(file) strcat('/data/stress/ARROWS/ARROWS_Young2/45Slices/', subject_session, '/', file.name), mean, 'UniformOutput', false);
    files = dir(strcat('/data/stress/ARROWS/ARROWS_Young2/45Slices/', subject_session, '/', 'ua*.nii'));
    data = arrayfun(@(file) strcat('/data/stress/ARROWS/ARROWS_Young2/45Slices/', subject_session, '/', file.name), files, 'UniformOutput', false);
    
    matlabbatch{i}.spm.spatial.coreg.estimate.ref = structural;
    matlabbatch{i}.spm.spatial.coreg.estimate.source = meanEPI;
    matlabbatch{i}.spm.spatial.coreg.estimate.other = data;
    matlabbatch{i}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
    matlabbatch{i}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
    matlabbatch{i}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    matlabbatch{i}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];

end

% Subjects who had 46 slices


root_path = '/data/stress/ARROWS/ARROWS_Young2/46Slices';
folders = dir(root_path);
folders = folders(arrayfun(@(folder) ~strcmp(folder.name(1), '.'),folders));

for j = 1:length(folders)
    
    subject_session = folders(j).name;
    subject = subject_session(1:3);
    session = subject_session(5);
    anatomical = dir(strcat('/data/stress/Structural_ARROWS_All/', subject, '*001.nii'));
    structural = arrayfun(@(file) strcat('/data/stress/Structural_ARROWS_All/', file.name), anatomical, 'UniformOutput', false);
    mean = dir(strcat('/data/stress/ARROWS/ARROWS_Young2/46Slices/', subject_session, '/m*.nii'));
    meanEPI = arrayfun(@(file) strcat('/data/stress/ARROWS/ARROWS_Young2/46Slices/', subject_session, '/', file.name), mean, 'UniformOutput', false);
    files = dir(strcat('/data/stress/ARROWS/ARROWS_Young2/46Slices/', subject_session, '/', 'ua*.nii'));
    data = arrayfun(@(file) strcat('/data/stress/ARROWS/ARROWS_Young2/46Slices/', subject_session, '/', file.name), files, 'UniformOutput', false);
    
    matlabbatch{j+i}.spm.spatial.coreg.estimate.ref = structural;
    matlabbatch{j+i}.spm.spatial.coreg.estimate.source = meanEPI;
    matlabbatch{j+i}.spm.spatial.coreg.estimate.other = data;
    matlabbatch{j+i}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
    matlabbatch{j+i}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
    matlabbatch{j+i}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    matlabbatch{j+i}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];

end