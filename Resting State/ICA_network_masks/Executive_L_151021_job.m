%-----------------------------------------------------------------------
% Job saved on 21-Oct-2015 10:42:17 by cfg_util (rev $Rev: 6134 $)
% spm SPM - SPM12 (6225)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
matlabbatch{1}.spm.util.imcalc.input = {
                                        '/data/stress/Resting_State/RS network templates from GIFT/Functional_ROIs/LECN/01/1.nii,1'
                                        '/data/stress/Resting_State/RS network templates from GIFT/Functional_ROIs/LECN/02/2.nii,1'
                                        '/data/stress/Resting_State/RS network templates from GIFT/Functional_ROIs/LECN/03/3.nii,1'
                                        '/data/stress/Resting_State/RS network templates from GIFT/Functional_ROIs/LECN/04/4.nii,1'
                                        '/data/stress/Resting_State/RS network templates from GIFT/Functional_ROIs/LECN/05/5.nii,1'
                                        '/data/stress/Resting_State/RS network templates from GIFT/Functional_ROIs/LECN/06/6.nii,1'
                                        };
matlabbatch{1}.spm.util.imcalc.output = 'Executive_L_151021';
matlabbatch{1}.spm.util.imcalc.outdir = {'/data/stress/Resting_State/RS network templates from GIFT'};
matlabbatch{1}.spm.util.imcalc.expression = 'i1 + i2 + i3 + i4 + i5 + i6';
matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 4;