%-----------------------------------------------------------------------
% Job saved on 18-Dec-2015 11:14:37 by cfg_util (rev $Rev: 6134 $)
% spm SPM - SPM12 (6225)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
spm_jobman('initcfg');

% Subjects who had 45 slices
root_path = '/data/stress/ARROWS/ARROWS_Young2/45Slices';
folders = dir(root_path);
folders = folders(arrayfun(@(folder) ~strcmp(folder.name(1), '.'),folders));


for i = 1:length(folders)
    subject_session = folders(i).name
    subject = subject_session(1:3);
    session = subject_session(5);
    
    files = dir(strcat('/data/stress/ARROWS/ARROWS_Young2/45Slices/', subject_session, '/1st_level_151208/SPM.mat'));
    data = arrayfun(@(file) strcat('/data/stress/ARROWS/ARROWS_Young2/45Slices/', subject_session, '/1st_level_151208/', file.name), files, 'UniformOutput', false);


    matlabbatch{1}.spm.stats.results.spmmat = data;
    matlabbatch{1}.spm.stats.results.conspec.titlestr = '';
    matlabbatch{1}.spm.stats.results.conspec.contrasts = 4;
    matlabbatch{1}.spm.stats.results.conspec.threshdesc = 'none';
    matlabbatch{1}.spm.stats.results.conspec.thresh = 1;
    matlabbatch{1}.spm.stats.results.conspec.extent = 0;
    matlabbatch{1}.spm.stats.results.conspec.mask.image.name = {'/data/stress/ARROWS/RegionsOfInterest/lOFCL_mask.nii,1'};
    matlabbatch{1}.spm.stats.results.conspec.mask.image.mtype = 0;
    matlabbatch{1}.spm.stats.results.units = 1;
    matlabbatch{1}.spm.stats.results.print = 'ps';
    matlabbatch{1}.spm.stats.results.write.none = 1;
    
    spm_jobman('run', matlabbatch)
    
    copyfile('spm_2015Dec22.ps', strcat('/data/stress/ARROWS/lOFC_L/', subject_session, '.ps'))

    clear matlabbatch 

end

root_path = '/data/stress/ARROWS/ARROWS_Young2/46Slices';
folders = dir(root_path);
folders = folders(arrayfun(@(folder) ~strcmp(folder.name(1), '.'),folders));


for i = 1:length(folders)
    subject_session = folders(i).name
    subject = subject_session(1:3);
    session = subject_session(5);
    
    files = dir(strcat('/data/stress/ARROWS/ARROWS_Young2/46Slices/', subject_session, '/1st_level_151208/SPM.mat'));
    data = arrayfun(@(file) strcat('/data/stress/ARROWS/ARROWS_Young2/46Slices/', subject_session, '/1st_level_151208/', file.name), files, 'UniformOutput', false);


    matlabbatch{1}.spm.stats.results.spmmat = data;
    matlabbatch{1}.spm.stats.results.conspec.titlestr = '';
    matlabbatch{1}.spm.stats.results.conspec.contrasts = 4;
    matlabbatch{1}.spm.stats.results.conspec.threshdesc = 'none';
    matlabbatch{1}.spm.stats.results.conspec.thresh = 1;
    matlabbatch{1}.spm.stats.results.conspec.extent = 0;
    matlabbatch{1}.spm.stats.results.conspec.mask.image.name = {'/data/stress/ARROWS/RegionsOfInterest/lOFCL_mask.nii,1'};
    matlabbatch{1}.spm.stats.results.conspec.mask.image.mtype = 0;
    matlabbatch{1}.spm.stats.results.units = 1;
    matlabbatch{1}.spm.stats.results.print = 'ps';
    matlabbatch{1}.spm.stats.results.write.none = 1;
    
    spm_jobman('run', matlabbatch)
    
    copyfile('spm_2015Dec22.ps', strcat('/data/stress/ARROWS/lOFC_L/', subject_session, '.ps'))

    clear matlabbatch 

end

root_path = '/data/stress/ARROWS/ARROWS_Old';
folders = dir(root_path);
folders = folders(arrayfun(@(folder) ~strcmp(folder.name(1), '.'),folders));


for i = 1:length(folders)
    subject_session = folders(i).name
    subject = subject_session(1:3);
    session = subject_session(5);
    
    files = dir(strcat('/data/stress/ARROWS/ARROWS_Old/', subject_session, '/1st_level_151208/SPM.mat'));
    data = arrayfun(@(file) strcat('/data/stress/ARROWS/ARROWS_Old/', subject_session, '/1st_level_151208/', file.name), files, 'UniformOutput', false);


    matlabbatch{1}.spm.stats.results.spmmat = data;
    matlabbatch{1}.spm.stats.results.conspec.titlestr = '';
    matlabbatch{1}.spm.stats.results.conspec.contrasts = 4;
    matlabbatch{1}.spm.stats.results.conspec.threshdesc = 'none';
    matlabbatch{1}.spm.stats.results.conspec.thresh = 1;
    matlabbatch{1}.spm.stats.results.conspec.extent = 0;
    matlabbatch{1}.spm.stats.results.conspec.mask.image.name = {'/data/stress/ARROWS/RegionsOfInterest/lOFCL_mask.nii,1'};
    matlabbatch{1}.spm.stats.results.conspec.mask.image.mtype = 0;
    matlabbatch{1}.spm.stats.results.units = 1;
    matlabbatch{1}.spm.stats.results.print = 'ps';
    matlabbatch{1}.spm.stats.results.write.none = 1;
    
    spm_jobman('run', matlabbatch)
    
    copyfile('spm_2015Dec22.ps', strcat('/data/stress/ARROWS/lOFC_L/', subject_session, '.ps'))

    clear matlabbatch 

end