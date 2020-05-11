function coreg_vdm(base, pt,t1)
% preproc1(base, pt)
% performs coregistering of fieldmaps to EPI


cd([base '/ds201_R1.0.0/' pt ])
numsess = size(dir('ses-*'), 1)
fmap = 1;

for sess =1:numsess
    cd([base '/ds201_R1.0.0/' pt '/ses-' num2str(sess) '/func'])
    
    if isempty(dir('vdm*.nii'))
        fmap = 0;
    end
    

    if fmap
        
        file=strtrim(ls('sub*bold.nii'));
        vdm = strtrim(ls('vdm*.nii'));
        data = strcat(base, 'ds201_R1.0.0/', pt, '/ses-', num2str(sess), '/func/', file, ',1');
        fieldmap = strcat(base, 'ds201_R1.0.0/', pt, '/ses-', num2str(sess), '/func/', vdm, ',1');
       
        
        matlabbatch{1}.spm.spatial.coreg.estimate.ref = {data};
        matlabbatch{1}.spm.spatial.coreg.estimate.source = {fieldmap};
        %matlabbatch{1}.spm.spatial.coreg.estimate.other = {};
        matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
        matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
        matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
        matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
        spm_jobman('run', matlabbatch);
        clear('matlabbatch');
    else

    end
    
    
end 

