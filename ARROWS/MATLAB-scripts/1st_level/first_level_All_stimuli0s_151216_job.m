%-----------------------------------------------------------------------
% Job saved on 13-Jan-2015 10:43:19 by cfg_util (rev $Rev: 6134 $)
% spm SPM - SPM12 (6225)
% cfg_basicio BasicIO - Unknown
%---------------------------------------
% Script to perform 1st level analysis in the ARROWS experiment. Onsetfiles contains onsetfiles without parametric modulations 
%--------------------------------

spm_jobman('initcfg');

% Subjects who had 45 slices
% root_path = '/data/stress/ARROWS/ARROWS_Young2/45Slices';
% folders = dir(root_path);
% folders = folders(arrayfun(@(folder) ~strcmp(folder.name(1), '.'),folders));
% 
% 
% for i = 1:length(folders)
%     subject_session = folders(i).name
%     subject = subject_session(1:3);
%     session = subject_session(5);
%     
%     files = dir(strcat('/data/stress/ARROWS/ARROWS_Young2/45Slices/', subject_session, '/swua*.nii'));
%     data = arrayfun(@(file) strcat('/data/stress/ARROWS/ARROWS_Young2/45Slices/', subject_session, '/', file.name), files, 'UniformOutput', false);
%     motionparameters = dir(strcat('/data/stress/ARROWS/ARROWS_Young2/45Slices/', subject_session, '/rp*.txt'));
%     motionparameters = arrayfun(@(file) strcat('/data/stress/ARROWS/ARROWS_Young2/45Slices/', subject_session, '/', file.name), motionparameters, 'UniformOutput', false);
%     mkdir(strcat('/data/stress/ARROWS/ARROWS_Young2/45Slices/', subject_session, '/1st_level_stimuli0s_151216'));
%     directory = cellstr(strcat('/data/stress/ARROWS/ARROWS_Young2/45Slices/', subject_session, '/1st_level_stimuli0s_151216'));
% 
%     onsets = dir(strcat('/data/stress/ARROWS/Onsetfiles_stimuli0s/', subject_session, '*.mat'));
%     onsets = arrayfun(@(file) strcat('/data/stress/ARROWS/Onsetfiles_stimuli0s/', file.name), onsets, 'UniformOutput', false);
%    
% 
%     matlabbatch{1}.spm.stats.fmri_spec.dir = directory;
%     matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
%     matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 3;
%     matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 45;
%     matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 2;
% 
%     matlabbatch{1}.spm.stats.fmri_spec.sess.scans = data;
%     matlabbatch{1}.spm.stats.fmri_spec.sess.cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
%     matlabbatch{1}.spm.stats.fmri_spec.sess.multi = onsets;
%     matlabbatch{1}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
%     matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = motionparameters;
%     matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 128;
%     matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
%     matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
%     matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
%     matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
%     matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
%     matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
%     matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
%     matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
%     matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
%     matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
%     matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
%     matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Neagative vs neutral (maintain)';
%     matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [0 0 0 1 0 0 -1];
%     matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
%     matlabbatch{3}.spm.stats.con.delete = 1;
% 
%     
%     spm_jobman('run', matlabbatch)
% 
%     clear matlabbatch 
% 
% end
% 
% % Subjects who had 46 slices
% root_path = '/data/stress/ARROWS/ARROWS_Young2/46Slices';
% folders = dir(root_path);
% folders = folders(arrayfun(@(folder) ~strcmp(folder.name(1), '.'),folders));
% 
% 
% for i = 1:length(folders)
%     subject_session = folders(i).name
%     subject = subject_session(1:3);
%     session = subject_session(5);
%     
%     files = dir(strcat('/data/stress/ARROWS/ARROWS_Young2/46Slices/', subject_session, '/swua*.nii'));
%     data = arrayfun(@(file) strcat('/data/stress/ARROWS/ARROWS_Young2/46Slices/', subject_session, '/', file.name), files, 'UniformOutput', false);
%     motionparameters = dir(strcat('/data/stress/ARROWS/ARROWS_Young2/46Slices/', subject_session, '/rp*.txt'));
%     motionparameters = arrayfun(@(file) strcat('/data/stress/ARROWS/ARROWS_Young2/46Slices/', subject_session, '/', file.name), motionparameters, 'UniformOutput', false);
%     mkdir(strcat('/data/stress/ARROWS/ARROWS_Young2/46Slices/', subject_session, '/1st_level_stimuli0s_151216'));
%     directory = cellstr(strcat('/data/stress/ARROWS/ARROWS_Young2/46Slices/', subject_session, '/1st_level_stimuli0s_151216'));
% 
%     onsets = dir(strcat('/data/stress/ARROWS/Onsetfiles_stimuli0s/', subject_session, '*.mat'));
%     onsets = arrayfun(@(file) strcat('/data/stress/ARROWS/Onsetfiles_stimuli0s/', file.name), onsets, 'UniformOutput', false);
%    
% 
%     matlabbatch{1}.spm.stats.fmri_spec.dir = directory;
%     matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
%     matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 3;
%     matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 46;
%     matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 2;
% 
%     matlabbatch{1}.spm.stats.fmri_spec.sess.scans = data;
%     matlabbatch{1}.spm.stats.fmri_spec.sess.cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
%     matlabbatch{1}.spm.stats.fmri_spec.sess.multi = onsets;
%     matlabbatch{1}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
%     matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = motionparameters;
%     matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 128;
%     matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
%     matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
%     matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
%     matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
%     matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
%     matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
%     matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
%     matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
%     matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
%     matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
%     matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
%     matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Neagative vs neutral (maintain)';
%     matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [0 0 0 1 0 0 -1];
%     matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
%     matlabbatch{3}.spm.stats.con.delete = 1;
% 
% 
%     spm_jobman('run', matlabbatch)
% 
%     clear matlabbatch 
% 
% end


% Old subjects who
root_path = '/data/stress/ARROWS/ARROWS_Old';
folders = dir(root_path);
folders = folders(arrayfun(@(folder) ~strcmp(folder.name(1), '.'),folders));


for i = 55:length(folders)
    subject_session = folders(i).name
    subject = subject_session(1:3);
    session = subject_session(5);
    
    files = dir(strcat('/data/stress/ARROWS/ARROWS_Old/', subject_session, '/swua*.nii'));
    data = arrayfun(@(file) strcat('/data/stress/ARROWS/ARROWS_Old/', subject_session, '/', file.name), files, 'UniformOutput', false);
    motionparameters = dir(strcat('/data/stress/ARROWS/ARROWS_Old/', subject_session, '/rp*.txt'));
    motionparameters = arrayfun(@(file) strcat('/data/stress/ARROWS/ARROWS_Old/', subject_session, '/', file.name), motionparameters, 'UniformOutput', false);
    mkdir(strcat('/data/stress/ARROWS/ARROWS_Old/', subject_session, '/1st_level_stimuli0s_151216'));
    directory = cellstr(strcat('/data/stress/ARROWS/ARROWS_Old/', subject_session, '/1st_level_stimuli0s_151216'));

    onsets = dir(strcat('/data/stress/ARROWS/Onsetfiles_stimuli0s/', subject_session, '*.mat'));
    onsets = arrayfun(@(file) strcat('/data/stress/ARROWS/Onsetfiles_stimuli0s/', file.name), onsets, 'UniformOutput', false);
   

    matlabbatch{1}.spm.stats.fmri_spec.dir = directory;
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 3;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 46;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 2;

    matlabbatch{1}.spm.stats.fmri_spec.sess.scans = data;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.multi = onsets;
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = motionparameters;
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
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Neagative vs neutral (maintain)';
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [0 0 0 1 0 0 -1];
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.delete = 1;


    spm_jobman('run', matlabbatch)

    clear matlabbatch 

end