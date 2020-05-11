function preproc2(base, pt,t1)
%%% COREGISTER %%%
cd([base 'ds201_R1.0.0/' pt '/ses-' num2str(t1) '/anat']);
anat = [pwd '/' strtrim(ls('sub*.nii'))];
numsess = size(dir([base 'ds201_R1.0.0/' pt '/ses-*']),1)

%coreg basic opton
job1.eoptions.cost_fun = 'nmi';
job1.eoptions.sep = [4 2];
job1.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
job1.eoptions.fwhm = [7 7];

%Dartel normalize
job.template = {[base 'ds201_R1.0.0/dartel/Template_6.nii']};
job.vox = [2 2 2];
job.bb = [-78 -112 -79
    78 76 85];
job.preserve = 0;
job.fwhm = [8 8 8]
n=1;
cd([base 'ds201_R1.0.0/' pt '/ses-' num2str(t1) '/anat'])
flowfield= {[pwd '/' ls('u_rc1sub*_T1w_Template.nii')]};

for sess = 1:numsess
    
    cd([base 'ds201_R1.0.0/' pt '/ses-' num2str(sess) '/func'])
    file=ls('sub*bold.nii');
    meanEPI =[pwd '/' ls('meanuasub*.nii')];
    
    file=ls('sub*bold.nii');
    V=spm_vol(file);
    nscans = size(V,1); % number of TRs in the scan
    
    P={''};
    for rdx = 1:nscans
        ff=([pwd '/ua' file ',' num2str(rdx)]);
        P{rdx} = ff;  %(rdx,1:length(ff)) = ff;
    end
    job1.ref = {anat};
    job1.source = {meanEPI};
    job1.other = P';

     spm_run_coreg(job1);

    try
        cd([base '/ds201_R1.0.0/' pt '/ses-' num2str(sess) '/func'])
        files(n,1)={[pwd '/' ls('uasub*.nii')]};
        flowfield(n,1) = ffeild;
        n=n+1;
    end
    job.data.subjs(1).flowfields = flowfield;
    job.data.subjs(1).images = {files};
    spm_dartel_norm_fun(job)
    clear  files
end

