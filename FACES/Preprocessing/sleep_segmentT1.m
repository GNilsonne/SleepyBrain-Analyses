function sleep_segmentT1(base, pt,t1)
%base is the directory in which the data is stored. 
%pt is the folder in which the data is stored, e.g. sub-9001
%
%function assumes data was pulled and stored in a folder named ds201_R0.9.0

load([base '/scripts/segjob.mat'])
job.tissue(1).native =[1 1];
job.tissue(2).native =[1 1];
job.tissue(3).native =[1 1];
job.tissue(4).native =[1 1];
job.tissue(5).native =[1 1];
curdir = pwd; 
disp( pt)
sess = t1;
cd([base '\ds201_R0.9.0\' pt])
try
    cd(['ses-' num2str(sess) '\anat\'])
    if ~isempty(ls('*T1w.nii'))
        job.channel.vols = {ls('sub*T1w.nii')};
        spm_preproc_run(job,'run')
    end
end


cd(curdir)

