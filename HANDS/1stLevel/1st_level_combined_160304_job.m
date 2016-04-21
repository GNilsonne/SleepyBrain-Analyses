%-----------------------------------------------------------------------
% Job saved on 02-Mar-2016 15:05:43 by cfg_util (rev $Rev: 6134 $)
% spm SPM - SPM12 (6225)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
spm_jobman('initcfg')
subjects = xlsread('ListScans.xlsx');

for i = 46:80
    subject = num2str(subjects(i,1),'%03d');
    s1no = num2str(subjects(i, 2));
    s2no = num2str(subjects(i, 3));
    
    directory = cellstr(strcat('/data/stress/HANDS_AGE/1st_level/', subject));
    
    files1 = dir(strcat('/data/stress/HANDS_AGE/', s1no, 'Slices/', subject, '_1/swua*.nii'));
    data1 = arrayfun(@(file) strcat('/data/stress/HANDS_AGE/', s1no, 'Slices/', subject, '_1/', file.name), files1, 'UniformOutput', false);
    motionparameters1 = dir(strcat('/data/stress/HANDS_AGE/', s1no, 'Slices/', subject, '_1/rp*.txt'));
    motionparameters1 = arrayfun(@(file) strcat('/data/stress/HANDS_AGE/', s1no, 'Slices/', subject, '_1/', file.name), motionparameters1, 'UniformOutput', false);
 
    onsets1 = dir(strcat('/data/stress/HANDS_AGE/Onsetfiles_150319/', subject, '_1', '*.mat'));
    onsets1 = arrayfun(@(file) strcat('/data/stress/HANDS_AGE/Onsetfiles_150319/', file.name), onsets1, 'UniformOutput', false);
    
    
    files2 = dir(strcat('/data/stress/HANDS_AGE/', s2no, 'Slices/', subject, '_2/swua*.nii'));
    data2 = arrayfun(@(file) strcat('/data/stress/HANDS_AGE/', s2no, 'Slices/', subject, '_2/', file.name), files2, 'UniformOutput', false);
    motionparameters2 = dir(strcat('/data/stress/HANDS_AGE/', s2no, 'Slices/', subject, '_2/rp*.txt'));
    motionparameters2 = arrayfun(@(file) strcat('/data/stress/HANDS_AGE/', s2no, 'Slices/', subject, '_2/', file.name), motionparameters2, 'UniformOutput', false);
 
    onsets2 = dir(strcat('/data/stress/HANDS_AGE/Onsetfiles_150319/', subject, '_2', '*.mat'));
    onsets2 = arrayfun(@(file) strcat('/data/stress/HANDS_AGE/Onsetfiles_150319/', file.name), onsets2, 'UniformOutput', false);

    
    matlabbatch{1}.spm.stats.fmri_spec.dir = directory;
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 3;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;
    %%
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).scans = data1;
    %%
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi = onsets1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi_reg = motionparameters1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).hpf = 128;
    %%
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).scans = data2;
    %%
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi = onsets2;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi_reg = motionparameters2;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).hpf = 128;
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
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Pain vs Baseline';
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 0];
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'bothsc';
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'No Pain vs Baseline';
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [0 1];
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'bothsc';
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'Pain vs No Pain';
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.weights = [1 -1];
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'bothsc';
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.name = 'No Pain vs Pain';
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.weights = [-1 1];
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.sessrep = 'bothsc';
    matlabbatch{3}.spm.stats.con.delete = 0;
    
    spm_jobman('run', matlabbatch)

    clear matlabbatch 

end
