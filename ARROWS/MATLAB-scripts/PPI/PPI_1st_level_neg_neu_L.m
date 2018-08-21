
root_path = '/data/stress/ARROWS/ARROWS_Young2/45Slices';
folders = dir(root_path);
folders = folders(arrayfun(@(folder) ~strcmp(folder.name(1), '.'),folders));


for i = 1:length(folders)
    subject_session = folders(i).name;
    subject = subject_session(1:3);
    session = subject_session(5);
  
    files = dir(strcat('/data/stress/ARROWS/ARROWS_Young2/45Slices/', subject_session, '/swua*.nii'));
    data = arrayfun(@(file) strcat('/data/stress/ARROWS/ARROWS_Young2/45Slices/', subject_session, '/', file.name), files, 'UniformOutput', false);
    mkdir(strcat('/data/stress/ARROWS/ARROWS_Young2/45Slices/', subject_session, '/PPI_180621_Neg_neu_L'));
    directory = cellstr(strcat('/data/stress/ARROWS/ARROWS_Young2/45Slices/', subject_session, '/PPI_180621_Neg_neu_L'));
    copyfile(strcat('/data/stress/ARROWS/ARROWS_Young2/45Slices/', subject_session, '/1st_level_151208/PPI_Amygdala_L_Neg_neu.mat'), strcat('/data/stress/ARROWS/ARROWS_Young2/45Slices/', subject_session, '/PPI_180621_Neg_neu_L/PPI_Amygdala_L_Neg_neu.mat'))
    load(strcat('/data/stress/ARROWS/ARROWS_Young2/45Slices/', subject_session, '/PPI_180621_Neg_neu_L/PPI_Amygdala_L_Neg_neu.mat'));
    
 
    matlabbatch{1}.spm.stats.fmri_spec.dir = directory;
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 3;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 45;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 2;
    matlabbatch{1}.spm.stats.fmri_spec.sess.scans = data;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.multi = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress(1).name = 'PPI-interaction';
 
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress(1).val = PPI.ppi;
   
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress(2).name = 'Amygdala_BOLD';
    
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress(2).val = PPI.Y;
    
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress(3).name = 'Neg>neutral';
    
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
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 0 0];
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Amygdala_BOLD';
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [0 1 0];
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'Neg>neu';
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.weights = [0 0 1];
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.delete = 0;

    
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
  
    files = dir(strcat('/data/stress/ARROWS/ARROWS_Young2/46Slices/', subject_session, '/swua*.nii'));
    data = arrayfun(@(file) strcat('/data/stress/ARROWS/ARROWS_Young2/46Slices/', subject_session, '/', file.name), files, 'UniformOutput', false);
    mkdir(strcat('/data/stress/ARROWS/ARROWS_Young2/46Slices/', subject_session, '/PPI_180621_Neg_neu_L'));
    directory = cellstr(strcat('/data/stress/ARROWS/ARROWS_Young2/46Slices/', subject_session, '/PPI_180621_Neg_neu_L'));
    copyfile(strcat('/data/stress/ARROWS/ARROWS_Young2/46Slices/', subject_session, '/1st_level_151208/PPI_Amygdala_L_Neg_neu.mat'), strcat('/data/stress/ARROWS/ARROWS_Young2/46Slices/', subject_session, '/PPI_180621_Neg_neu_L/PPI_Amygdala_L_Neg_neu.mat'))
    load(strcat('/data/stress/ARROWS/ARROWS_Young2/46Slices/', subject_session, '/PPI_180621_Neg_neu_L/PPI_Amygdala_L_Neg_neu.mat'));
    
 
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
   
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress(2).name = 'Amygdala_BOLD';
    
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress(2).val = PPI.Y;
    
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress(3).name = 'Neg>neutral';
    
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
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 0 0];
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Amygdala_BOLD';
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [0 1 0];
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'Neg>neu';
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.weights = [0 0 1];
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.delete = 0;

    
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
  
    files = dir(strcat('/data/stress/ARROWS/ARROWS_Old/', subject_session, '/swua*.nii'));
    data = arrayfun(@(file) strcat('/data/stress/ARROWS/ARROWS_Old/', subject_session, '/', file.name), files, 'UniformOutput', false);
    mkdir(strcat('/data/stress/ARROWS/ARROWS_Old/', subject_session, '/PPI_180621_Neg_neu_L'));
    directory = cellstr(strcat('/data/stress/ARROWS/ARROWS_Old/', subject_session, '/PPI_180621_Neg_neu_L'));
    copyfile(strcat('/data/stress/ARROWS/ARROWS_Old/', subject_session, '/1st_level_151208/PPI_Amygdala_L_Neg_neu.mat'), strcat('/data/stress/ARROWS/ARROWS_Old/', subject_session, '/PPI_180621_Neg_neu_L/PPI_Amygdala_L_Neg_neu.mat'))
    load(strcat('/data/stress/ARROWS/ARROWS_Old/', subject_session, '/PPI_180621_Neg_neu_L/PPI_Amygdala_L_Neg_neu.mat'));
    
 
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
   
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress(2).name = 'Amygdala_BOLD';
    
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress(2).val = PPI.Y;
    
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress(3).name = 'Neg>neutral';
    
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
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 0 0];
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Amygdala_BOLD';
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [0 1 0];
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'Neg>neu';
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.weights = [0 0 1];
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.delete = 0;

    
    spm_jobman('run', matlabbatch)
    clear('matlabbatch');
end


