%-----------------------------------------------------------------------
% Job saved on 01-Dec-2018 21:26:40 by cfg_util (rev $Rev: 6942 $)
% spm SPM - SPM12 (7219)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
matlabbatch{1}.spm.spatial.coreg.estimate.ref = {'/data/stress/FACES_BIDS/ds201_R1.0.0/sub-9001/ses-1/func/sub-9001_ses-1_task-faces_bold.nii,1'};
matlabbatch{1}.spm.spatial.coreg.estimate.source = {'/data/stress/FACES_BIDS/ds201_R1.0.0/sub-9001/ses-1/func/vdm5.nii,1'};
matlabbatch{1}.spm.spatial.coreg.estimate.other = {''};
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
