%-----------------------------------------------------------------------
% Job saved on 20-Oct-2015 11:52:34 by cfg_util (rev $Rev: 6134 $)
% spm SPM - SPM12 (6225)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
%%
matlabbatch{1}.spm.util.imcalc.input = {
                                        '/data/stress/Resting_State/RS network templates from GIFT/Functional_ROIs/Language/01/1.nii,1'
                                        '/data/stress/Resting_State/RS network templates from GIFT/Functional_ROIs/Language/03/3.nii,1'
                                        '/data/stress/Resting_State/RS network templates from GIFT/Functional_ROIs/Language/04/4.nii,1'
                                        '/data/stress/Resting_State/RS network templates from GIFT/Functional_ROIs/Language/05/5.nii,1'
                                        '/data/stress/Resting_State/RS network templates from GIFT/Functional_ROIs/Language/06/6.nii,1'
                                        '/data/stress/Resting_State/RS network templates from GIFT/Functional_ROIs/Language/07/7.nii,1'
                                        '/data/stress/Resting_State/RS network templates from GIFT/Functional_ROIs/Visuospatial/01/1.nii,1'
                                        '/data/stress/Resting_State/RS network templates from GIFT/Functional_ROIs/Visuospatial/02/2.nii,1'
                                        '/data/stress/Resting_State/RS network templates from GIFT/Functional_ROIs/Visuospatial/03/3.nii,1'
                                        '/data/stress/Resting_State/RS network templates from GIFT/Functional_ROIs/Visuospatial/04/4.nii,1'
                                        '/data/stress/Resting_State/RS network templates from GIFT/Functional_ROIs/Visuospatial/05/5.nii,1'
                                        '/data/stress/Resting_State/RS network templates from GIFT/Functional_ROIs/Visuospatial/06/6.nii,1'
                                        '/data/stress/Resting_State/RS network templates from GIFT/Functional_ROIs/Visuospatial/07/7.nii,1'
                                        '/data/stress/Resting_State/RS network templates from GIFT/Functional_ROIs/Visuospatial/08/8.nii,1'
                                        '/data/stress/Resting_State/RS network templates from GIFT/Functional_ROIs/Visuospatial/09/9.nii,1'
                                        '/data/stress/Resting_State/RS network templates from GIFT/Functional_ROIs/Visuospatial/10/10.nii,1'
                                        '/data/stress/Resting_State/RS network templates from GIFT/Functional_ROIs/Language/02/2.nii,1'
                                        '/data/stress/Resting_State/RS network templates from GIFT/Functional_ROIs/Visuospatial/11/11.nii,1'
                                        };
%%
matlabbatch{1}.spm.util.imcalc.output = 'Frontoparietal_151020';
matlabbatch{1}.spm.util.imcalc.outdir = {'/data/stress/Resting_State/RS network templates from GIFT'};
matlabbatch{1}.spm.util.imcalc.expression = 'i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10 + i11 + i12 + i13 + i14 + i15 + i16 + i17 + i18';
matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 4;
