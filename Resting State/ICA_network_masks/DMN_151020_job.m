%-----------------------------------------------------------------------
% Job saved on 20-Oct-2015 09:52:32 by cfg_util (rev $Rev: 6134 $)
% spm SPM - SPM12 (6225)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
%%
matlabbatch{1}.spm.util.imcalc.input = {
                                        '/data/stress/Resting_State/RS network templates from GIFT/RSN.nii,16'
                                        '/data/stress/Resting_State/RS network templates from GIFT/RSN.nii,17'
                                        '/data/stress/Resting_State/RS network templates from GIFT/RSN.nii,18'
                                        '/data/stress/Resting_State/RS network templates from GIFT/RSN.nii,19'
                                        '/data/stress/Resting_State/RS network templates from GIFT/RSN.nii,20'
                                        '/data/stress/Resting_State/RS network templates from GIFT/RSN.nii,21'
                                        '/data/stress/Resting_State/RS network templates from GIFT/RSN.nii,22'
                                        '/data/stress/Resting_State/RS network templates from GIFT/RSN.nii,23'
                                        '/data/stress/Resting_State/RS network templates from GIFT/RSN.nii,24'
                                        '/data/stress/Resting_State/RS network templates from GIFT/RSN.nii,40'
                                        '/data/stress/Resting_State/RS network templates from GIFT/RSN.nii,41'
                                        '/data/stress/Resting_State/RS network templates from GIFT/RSN.nii,42'
                                        '/data/stress/Resting_State/RS network templates from GIFT/RSN.nii,43'
                                        '/data/stress/Resting_State/RS network templates from GIFT/RSN.nii,44'
                                        '/data/stress/Resting_State/RS network templates from GIFT/RSN.nii,45'
                                        '/data/stress/Resting_State/RS network templates from GIFT/RSN.nii,46'
                                        '/data/stress/Resting_State/RS network templates from GIFT/RSN.nii,47'
                                        '/data/stress/Resting_State/RS network templates from GIFT/RSN.nii,48'
                                        '/data/stress/Resting_State/RS network templates from GIFT/RSN.nii,49'
                                        '/data/stress/Resting_State/RS network templates from GIFT/RSN.nii,50'
                                        '/data/stress/Resting_State/RS network templates from GIFT/RSN.nii,51'
                                        };
%%
matlabbatch{1}.spm.util.imcalc.output = 'DMN_151020';
matlabbatch{1}.spm.util.imcalc.outdir = {'/data/stress/Resting_State/RS network templates from GIFT'};
matlabbatch{1}.spm.util.imcalc.expression = '(i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10 + i11 + i12 + i13 + i14 + i15 + i16 + i17 + i18+ i19 + i20 + i21) > 0.01';
matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 4;
