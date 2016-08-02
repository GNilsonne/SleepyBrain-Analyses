
root_path = '/data/stress/HANDS_AGE/46Slices';
folders = dir(root_path);
folders = folders(arrayfun(@(folder) ~strcmp(folder.name(1), '.'),folders));
subjects_R = {'263_1', '267_1', '267_2', '276_1',...
    '286_1', '286_2', '295_2', '299_1', '299_2', '306_1', '306_2',... 
    '313_2', '315_1', '342_1', '342_2', '354_1', '354_2',...
    '356_1', '356_2', '357_1', '357_2', '358_1', '358_2', '364_1', '364_2', '376_2',...
    '379_2', '383_1', '383_2', '389_1', '389_2', '410_1', '410_2', '411_2',...
    '425_1', '425_2', '426_1', '426_2', '427_1', '427_2', '429_1', '429_2', '431_1', '431_2',...
    '433_1', '433_2', '441_1', '441_2', '446_2', '448_2', '451_1',...
    '457_1', '457_2', '460_1', '466_1', '466_2', '470_1', '470_2', '472_1',...
    '475_1', '475_2'};

for i = 1:length(subjects_R)
    subject_session = subjects_R{i};
  
    files = dir(strcat('/data/stress/HANDS_AGE/46Slices/', subject_session, '/swua*.nii'));
    data = arrayfun(@(file) strcat('/data/stress/HANDS_AGE/46Slices/', subject_session, '/', file.name), files, 'UniformOutput', false);
    mkdir(strcat('/data/stress/HANDS_AGE/46Slices/', subject_session, '/PPI_150827_R'));
    directory = cellstr(strcat('/data/stress/HANDS_AGE/46Slices/', subject_session, '/PPI_150827_R'));
    copyfile(strcat('/data/stress/HANDS_AGE/46Slices/', subject_session, '/1st_level_150320/PPI_FG_R_pain.mat'), strcat('/data/stress/HANDS_AGE/46Slices/', subject_session, '/PPI_150827_R/PPI_FG_R_pain.mat'))
    load(strcat('/data/stress/HANDS_AGE/46Slices/', subject_session, '/PPI_150827_R/PPI_FG_R_pain.mat'));
    
 
    matlabbatch{1}.spm.stats.fmri_spec.dir = directory;
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 3;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 46;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 2;
    matlabbatch{1}.spm.stats.fmri_spec.sess.scans = data;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.multi = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress(1).name = 'PPI-interaction';
 
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress(1).val = PPI.ppi;
   
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress(2).name = 'FG-BOLD';
    
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress(2).val = PPI.Y;
    
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress(3).name = 'Psych_pain';
    
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress(3).val = PPI.P;
    
    matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 128;
    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
    matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
    matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'PPI-interaction';
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = 1;
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.delete = 0;

    
    spm_jobman('run', matlabbatch)
    clear('matlabbatch');
end

subjects_L = {'263_1', '267_1', '267_2', '276_1',...
    '286_1', '286_2', '295_2', '299_1', '299_2', '306_1', '306_2',... 
    '315_1', '315_2', '342_1', '342_2', '352_1', '354_1', '354_2',...
    '356_1', '356_2', '357_1', '357_2', '358_1', '358_2', '364_1', '364_2', '376_2',...
    '379_2', '383_1', '383_2', '389_1', '389_2', '410_1', '410_2', '411_1', '411_2',...
    '425_1', '425_2', '427_1', '427_2', '429_1', '429_2', '433_1',...
    '433_2', '436_2', '441_2', '446_2', '448_1', '448_2', '451_1', '451_2',...
    '457_1', '457_2', '460_1', '460_2', '466_1', '466_2', '470_1', '470_2', '472_1', '472_2',...
    '475_1', '475_2'};

for i = 42:length(subjects_L)
    subject_session = subjects_L{i};
  
    files = dir(strcat('/data/stress/HANDS_AGE/46Slices/', subject_session, '/swua*.nii'));
    data = arrayfun(@(file) strcat('/data/stress/HANDS_AGE/46Slices/', subject_session, '/', file.name), files, 'UniformOutput', false);
    mkdir(strcat('/data/stress/HANDS_AGE/46Slices/', subject_session, '/PPI_150827_L'));
    directory = cellstr(strcat('/data/stress/HANDS_AGE/46Slices/', subject_session, '/PPI_150827_L'));
    copyfile(strcat('/data/stress/HANDS_AGE/46Slices/', subject_session, '/1st_level_150320/PPI_FG_L_pain.mat'), strcat('/data/stress/HANDS_AGE/46Slices/', subject_session, '/PPI_150827_L/PPI_FG_L_pain.mat'))
    load(strcat('/data/stress/HANDS_AGE/46Slices/', subject_session, '/PPI_150827_L/PPI_FG_L_pain.mat'));
    
 
    matlabbatch{1}.spm.stats.fmri_spec.dir = directory;
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 3;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 46;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 2;
    matlabbatch{1}.spm.stats.fmri_spec.sess.scans = data;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.multi = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress(1).name = 'PPI-interaction';
 
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress(1).val = PPI.ppi;
   
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress(2).name = 'FG-BOLD';
    
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress(2).val = PPI.Y;
    
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress(3).name = 'Psych_pain';
    
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress(3).val = PPI.P;
    
    matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 128;
    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
    matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
    matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'PPI-interaction';
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = 1;
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.delete = 0;

    
    spm_jobman('run', matlabbatch)
    clear('matlabbatch');
end

