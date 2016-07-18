function dartel_normMNI(base)
subs=[];
load([base '\scripts\sub_list.mat'])

job.template = {[base '/ds201_R0.9.0/dartel/Template_6.nii']};
job.vox = [2 2 2];
job.bb = [-78 -112 -79
    78 76 85];
job.preserve = 0;
job.fwhm = [8 8 8]
n=1;

for sess =1:2
    for pdx = 1:size(subs,1)  
        
        pt= ['sub-' num2str(subs(pdx,:))];
        
        cd([base '\ds201_R0.9.0\' pt '\ses-' num2str(bt1(pdx)) '\anat']);
        ffeild= {[pwd '\' ls('u_rc1sub*_T1w_Template.nii')]};
        
        try
            cd([base '\ds201_R0.9.0\' pt '\ses-' num2str(sess) '\func'])
            files(n,1)={[pwd '\' ls('uasub*.nii')]};
            flowfield(n,1) = ffeild;
            n=n+1;
        end
    end
    
    job.data.subjs(1).flowfields = flowfield;
    job.data.subjs(1).images = {files};
    spm_dartel_norm_fun(job)
    
    clear flowfield files
    
end




