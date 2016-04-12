%-----------------------------------------------------------------------
% Job saved on 20-Oct-2015 12:11:25 by cfg_util (rev $Rev: 6134 $)
% spm SPM - SPM12 (6225)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
%%
matlabbatch{1}.spm.util.imcalc.input = {
                                        '/data/stress/Resting_State/RS network templates from GIFT/Functional_ROIs/anterior_Salience/01/1.nii,1'
                                        '/data/stress/Resting_State/RS network templates from GIFT/Functional_ROIs/anterior_Salience/02/2.nii,1'
                                        '/data/stress/Resting_State/RS network templates from GIFT/Functional_ROIs/anterior_Salience/03/3.nii,1'
                                        '/data/stress/Resting_State/RS network templates from GIFT/Functional_ROIs/anterior_Salience/04/4.nii,1'
                                        '/data/stress/Resting_State/RS network templates from GIFT/Functional_ROIs/anterior_Salience/05/5.nii,1'
                                        '/data/stress/Resting_State/RS network templates from GIFT/Functional_ROIs/anterior_Salience/06/6.nii,1'
                                        '/data/stress/Resting_State/RS network templates from GIFT/Functional_ROIs/anterior_Salience/07/7.nii,1'
                                        '/data/stress/Resting_State/RS network templates from GIFT/Functional_ROIs/post_Salience/01/1.nii,1'
                                        '/data/stress/Resting_State/RS network templates from GIFT/Functional_ROIs/post_Salience/02/2.nii,1'
                                        '/data/stress/Resting_State/RS network templates from GIFT/Functional_ROIs/post_Salience/03/3.nii,1'
                                        '/data/stress/Resting_State/RS network templates from GIFT/Functional_ROIs/post_Salience/04/4.nii,1'
                                        '/data/stress/Resting_State/RS network templates from GIFT/Functional_ROIs/post_Salience/05/5.nii,1'
                                        '/data/stress/Resting_State/RS network templates from GIFT/Functional_ROIs/post_Salience/06/6.nii,1'
                                        '/data/stress/Resting_State/RS network templates from GIFT/Functional_ROIs/post_Salience/07/7.nii,1'
                                        '/data/stress/Resting_State/RS network templates from GIFT/Functional_ROIs/post_Salience/08/8.nii,1'
                                        '/data/stress/Resting_State/RS network templates from GIFT/Functional_ROIs/post_Salience/09/9.nii,1'
                                        '/data/stress/Resting_State/RS network templates from GIFT/Functional_ROIs/post_Salience/10/10.nii,1'
                                        '/data/stress/Resting_State/RS network templates from GIFT/Functional_ROIs/post_Salience/11/11.nii,1'
                                        '/data/stress/Resting_State/RS network templates from GIFT/Functional_ROIs/post_Salience/12/12.nii,1'
                                        };
%%
matlabbatch{1}.spm.util.imcalc.output = 'Salience_151020';
matlabbatch{1}.spm.util.imcalc.outdir = {'/data/stress/Resting_State/RS network templates from GIFT'};
matlabbatch{1}.spm.util.imcalc.expression = 'i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10 + i11 + i12 + i13 + i14 + i15 + i16 + i17 + i18 +i19';
matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 4;
