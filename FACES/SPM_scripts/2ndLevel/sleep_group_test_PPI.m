function sleep_group_test_PPI
subs=[];
load group_t12.mat
load('sleep_ons.mat')

con_names ={'PPI';}

% basedir ='D:\work\CAMH_TMS_fMRI\study1\HCP_spm\';
basedir ='e:\sleepdata\ds201_R0.9.0\';

for ses=1:2;
    %some  partiicpants excluded due to motion or other issues
    if ses == 1
        ex = [20   49] 
    else
        ex = [20  28 48]
    end

    condir = [basedir 'GLMs\glm_t-tests\PPIgroup_ses' num2str(ses) '\'];
    mkdir(condir)
    % matlabbatch{1}.spm.stats.factorial_design.masking.em={'D:\work\FACES\output\ROI_masks\ROI_mask_IPC_right_MNI.img,1'};
    for cdx = 1:size(con_names,1) % loop over contrast numbers
        cdx
        %output dir, must exist, assumes c1, c2, c3 structures
        job.dir = {[condir '\' con_names{cdx}  '\']};
        mkdir([condir '\' con_names{cdx}  '\'])
        cd([ condir '\' con_names{cdx}  '\']);
        %clear scans in current batch
        job.des.t1.scans = {};
        
        n=1;
        for pdx = 1:size(subs,1)
            if isempty(find(ex == pdx))
                if sleepsess(pdx)==1
                    s=[1 2];
                else
                    s=[2 1];
                end
                if cdx < 10
                    job.des.t1.scans(n) = {[basedir  'GLMs\glm_t-tests\sub-' num2str(subs(pdx)) '_' num2str(s(ses)) '\PPI\con_000' num2str(cdx) '.nii,1']};
                else
                    job.des.t1.scans(n) = {[basedir  'GLMs\glm_t-tests\sub-' num2str(subs(pdx)) '_' num2str(s(ses)) '\PPI\con_00' num2str(cdx) '.nii,1']};
                end
                n=n+1;
            end
        end
        
        if ~isempty(ls('SPM.mat'))
            delete SPM.mat
        end
        
        job.masking.tm.tm_none=1;
        job.masking.im= 0;
        job.masking.em= {''};
        job.globalc.g_omit=1;
        job.globalm.glonorm=1;
        job.globalm.gmsca.gmsca_no=1;
        spm_run_factorial_design(job)
        
        load SPM
        SPM=spm_spm(SPM)
        save('SPM', 'SPM')
        
        cons = [1; -1];
        names = {'pos', 'neg'};
        curdir = pwd;
        analyze_spm_contrasts(curdir, cons, names);
    end
end
