function dartel_scripts
% creates dartel templates. Note the templates get saved in the first
% participant folder and need to be manually moved. 


subs=[];
load e:\sleepdata\scripts\sub_list
base = 'e:\sleepdata\ds201_R0.9.0\';

% dartel settings, generally the SPM defaults. 
job.settings.template = 'Template';
job.settings.rform = 0;
job.settings.param(1).its = 3;
job.settings.param(1).rparam = [4 2 1e-06];
job.settings.param(1).K = 0;
job.settings.param(1).slam = 16;
job.settings.param(2).its = 3;
job.settings.param(2).rparam = [2 1 1e-06];
job.settings.param(2).K = 0;
job.settings.param(2).slam = 8;
job.settings.param(3).its = 3;
job.settings.param(3).rparam = [1 0.5 1e-06];
job.settings.param(3).K = 1;
job.settings.param(3).slam = 4;
job.settings.param(4).its = 3;
job.settings.param(4).rparam = [0.5 0.25 1e-06];
job.settings.param(4).K = 2;
job.settings.param(4).slam = 2;
job.settings.param(5).its = 3;
job.settings.param(5).rparam = [0.25 0.125 1e-06];
job.settings.param(5).K = 4;
job.settings.param(5).slam = 1;
job.settings.param(6).its = 3;
job.settings.param(6).rparam = [0.25 0.125 1e-06];
job.settings.param(6).K = 6;
job.settings.param(6).slam = 0.5;
job.settings.optim.lmreg = 0.01;
job.settings.optim.cyc = 3;
job.settings.optim.its = 3;

for idx = 1:size(subs,1)
    anadir = ([base 'sub-' num2str(subs(idx,:)) '\ses-' num2str(bt1(idx)) '\anat\']);
    cd(anadir)
    c1 = ls('rc1sub*_T1w.nii');
    c2 = ls('rc2sub*_T1w.nii');
    c3 = ls('rc3sub*_T1w.nii');
    
    job.images{1}{idx} = [anadir c1 ',1'];
    job.images{2}{idx} = [anadir c2 ',1'];
    job.images{3}{idx} = [anadir c3 ',1'];
end

spm_dartel_template(job)