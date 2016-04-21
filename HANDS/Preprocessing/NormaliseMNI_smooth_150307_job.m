% Preprocessing is done throug separate scripts for every step. Following
% steps are performed: Slice timing, realign and unwarp (fieldmap for
% subjects who have one for all sessions included), coregistration (EPI to
% structural), structural segmentation, DARTEL teplate and normalisation to MNI
% + SMOOTH.
% Script to normalise subjects to MNI using a DARTEL template + smooth the
% images

root_path = '/data/stress/HANDS_AGE/46Slices';
folders = dir(root_path);
folders = folders(arrayfun(@(folder) ~strcmp(folder.name(1), '.'),folders));

for i = 1:length(folders)
    
    subject_session = folders(i).name;
    subject = subject_session(1:3);
    session = subject_session(5);
    flowfield = dir(strcat('/data/stress/Structural_HANDSAll/u_rc1', subject, '*.nii'));
    flowfield = arrayfun(@(file) strcat('/data/stress/Structural_HANDSAll/', file.name), flowfield, 'UniformOutput', false);
    files = dir(strcat('/data/stress/HANDS_AGE/46Slices/', subject_session, '/', 'ua*.nii'));
    data = arrayfun(@(file) strcat('/data/stress/HANDS_AGE/46Slices/', subject_session, '/', file.name), files, 'UniformOutput', false);

    matlabbatch{i}.spm.tools.dartel.mni_norm.template = {'/data/stress/Structural_HANDSAll/Template_6.nii'};
    matlabbatch{i}.spm.tools.dartel.mni_norm.data.subj(1).flowfield = flowfield;
    matlabbatch{i}.spm.tools.dartel.mni_norm.data.subj(1).images = data;
    matlabbatch{i}.spm.tools.dartel.mni_norm.vox = [NaN NaN NaN];
    matlabbatch{i}.spm.tools.dartel.mni_norm.bb = [NaN NaN NaN
                                                   NaN NaN NaN];
    matlabbatch{i}.spm.tools.dartel.mni_norm.preserve = 0;
    matlabbatch{i}.spm.tools.dartel.mni_norm.fwhm = [8 8 8];
end


root_path = '/data/stress/HANDS_AGE/45Slices';
folders = dir(root_path);
folders = folders(arrayfun(@(folder) ~strcmp(folder.name(1), '.'),folders));

for j = 1:length(folders)
    
    subject_session = folders(j).name;
    subject = subject_session(1:3);
    session = subject_session(5);
    flowfield = dir(strcat('/data/stress/Structural_HANDSAll/u_rc1', subject, '*.nii'));
    flowfield = arrayfun(@(file) strcat('/data/stress/Structural_HANDSAll/', file.name), flowfield, 'UniformOutput', false);
    files = dir(strcat('/data/stress/HANDS_AGE/45Slices/', subject_session, '/', 'ua*.nii'));
    data = arrayfun(@(file) strcat('/data/stress/HANDS_AGE/45Slices/', subject_session, '/', file.name), files, 'UniformOutput', false);

    matlabbatch{j+i}.spm.tools.dartel.mni_norm.template = {'/data/stress/Structural_HANDSAll/Template_6.nii'};
    matlabbatch{j+i}.spm.tools.dartel.mni_norm.data.subj(1).flowfield = flowfield;
    matlabbatch{j+i}.spm.tools.dartel.mni_norm.data.subj(1).images = data;
    matlabbatch{j+i}.spm.tools.dartel.mni_norm.vox = [NaN NaN NaN];
    matlabbatch{j+i}.spm.tools.dartel.mni_norm.bb = [NaN NaN NaN
                                                   NaN NaN NaN];
    matlabbatch{j+i}.spm.tools.dartel.mni_norm.preserve = 0;
    matlabbatch{j+i}.spm.tools.dartel.mni_norm.fwhm = [8 8 8];
end

