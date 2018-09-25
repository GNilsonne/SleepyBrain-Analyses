
%-----------------------------------------------------------------------
% Script to create the ppi term after extracting the VOI


root_path = '/data/stress/ARROWS/ARROWS_Young2/45Slices';
folders = dir(root_path);
folders = folders(arrayfun(@(folder) ~strcmp(folder.name(1), '.'),folders));



for i = 1:length(folders)
    subject_session = folders(i).name;
    subject = subject_session(1:3);
    session = subject_session(5);
  
    files = dir(strcat('/data/stress/ARROWS/ARROWS_Young2/45Slices/', subject_session, '/1st_level_151208/SPM.mat'));
    data = arrayfun(@(file) strcat('/data/stress/ARROWS/ARROWS_Young2/45Slices/', subject_session, '/1st_level_151208/', file.name), files, 'UniformOutput', false);
    
    VOI = dir(strcat('/data/stress/ARROWS/ARROWS_Young2/45Slices/', subject_session, '/1st_level_151208/VOI_Amygdala_R_1.mat'));
    voi = arrayfun(@(file) strcat('/data/stress/ARROWS/ARROWS_Young2/45Slices/', subject_session, '/1st_level_151208/', file.name), VOI, 'UniformOutput', false);
    
    matlabbatch{1}.spm.stats.ppi.spmmat = data;
    matlabbatch{1}.spm.stats.ppi.type.ppi.voi = voi;
    matlabbatch{1}.spm.stats.ppi.type.ppi.u = [4 1 1; 7 1 -1];
    matlabbatch{1}.spm.stats.ppi.name = 'Amygdala_R_Neg_neu';
    matlabbatch{1}.spm.stats.ppi.disp = 1;

    
    spm_jobman('run', matlabbatch)
    clear('matlabbatch');
end

root_path = '/data/stress/ARROWS/ARROWS_Young2/46Slices';
folders = dir(root_path);
folders = folders(arrayfun(@(folder) ~strcmp(folder.name(1), '.'),folders));



for j = 1:length(folders)
    subject_session = folders(j).name;
    subject = subject_session(1:3);
    session = subject_session(5);
  
    files = dir(strcat('/data/stress/ARROWS/ARROWS_Young2/46Slices/', subject_session, '/1st_level_151208/SPM.mat'));
    data = arrayfun(@(file) strcat('/data/stress/ARROWS/ARROWS_Young2/46Slices/', subject_session, '/1st_level_151208/', file.name), files, 'UniformOutput', false);
    
    VOI = dir(strcat('/data/stress/ARROWS/ARROWS_Young2/46Slices/', subject_session, '/1st_level_151208/VOI_Amygdala_R_1.mat'));
    voi = arrayfun(@(file) strcat('/data/stress/ARROWS/ARROWS_Young2/46Slices/', subject_session, '/1st_level_151208/', file.name), VOI, 'UniformOutput', false);
    
    matlabbatch{1}.spm.stats.ppi.spmmat = data;
    matlabbatch{1}.spm.stats.ppi.type.ppi.voi = voi;
    matlabbatch{1}.spm.stats.ppi.type.ppi.u = [4 1 1; 7 1 -1];
    matlabbatch{1}.spm.stats.ppi.name = 'Amygdala_R_Neg_neu';
    matlabbatch{1}.spm.stats.ppi.disp = 1;

    
    spm_jobman('run', matlabbatch)
    clear('matlabbatch');
end


root_path = '/data/stress/ARROWS/ARROWS_Old';
folders = dir(root_path);
folders = folders(arrayfun(@(folder) ~strcmp(folder.name(1), '.'),folders));

for k = 1:length(folders)
    subject_session = folders(k).name;
    subject = subject_session(1:3);
    session = subject_session(5);
  
    files = dir(strcat('/data/stress/ARROWS/ARROWS_Old/', subject_session, '/1st_level_151208/SPM.mat'));
    data = arrayfun(@(file) strcat('/data/stress/ARROWS/ARROWS_Old/', subject_session, '/1st_level_151208/', file.name), files, 'UniformOutput', false);
    
    VOI = dir(strcat('/data/stress/ARROWS/ARROWS_Old/', subject_session, '/1st_level_151208/VOI_Amygdala_R_1.mat'));
    voi = arrayfun(@(file) strcat('/data/stress/ARROWS/ARROWS_Old/', subject_session, '/1st_level_151208/', file.name), VOI, 'UniformOutput', false);
    
    matlabbatch{1}.spm.stats.ppi.spmmat = data;
    matlabbatch{1}.spm.stats.ppi.type.ppi.voi = voi;
    matlabbatch{1}.spm.stats.ppi.type.ppi.u = [4 1 1; 7 1 -1];
    matlabbatch{1}.spm.stats.ppi.name = 'Amygdala_R_Neg_neu';
    matlabbatch{1}.spm.stats.ppi.disp = 1;

    
    spm_jobman('run', matlabbatch)
    clear('matlabbatch');
end