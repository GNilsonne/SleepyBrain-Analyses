function sleep_group_test
% one-sample t-tests for contrasts, separatly for each condition (sleep
% deprived and not sleep deprived). Requires bsedir variable in file to be
% modified. 
%
% WARNING this will over-write any old data without prompting.

basedir ='e:\sleepdata\ds201_R0.9.0\';

subs=[];
load group_t12.mat
load('sleep_ons.mat') % This file was produced manually by Colin Hawco 

con_names ={'HA_AN';'HA_NE'; 'AN_NE';'HA';'AN'; 'NE'; 'HA+AN'; 'HA+AN+NE'}



for ses=1:2; %ses in this case actually refers to comdditions,
    % 1 = sleep deprved, 2 = not sleep deprived
    
    %some  partiicpants excluded due to motion or other issues
    if ses == 1
        ex = [20   49]; %ex 9028 (failed normalization), 9038-2 (bad signal), 9067-1 (head motion)
        condir = [basedir 'GLMs\glm_t-tests\group_sleepderived\'];
    else
        ex = [20  28 48]; %ex 9028, 9038-2, 9067-1
        condir = [basedir 'GLMs\glm_t-tests\group_notdeprived\'];
    end

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
        
        n=1; % a tracker to keep participant data sequential
        for pdx = 1:size(subs,1)
            if isempty(find(ex == pdx))
                %sleepses is a variable sowing in which session (first or
                %second scan session) the particpant was sleep deprived. 
                %the variable s is used to properly group the data
                if sleepsess(pdx)==1
                    s=[1 2];
                else
                    s=[2 1];
                end
                
                % load subjects con files for this contrast
                if cdx < 10
                    job.des.t1.scans(n) = {[basedir  'GLMs\glm_t-tests\sub-' num2str(subs(pdx)) '_' num2str(s(ses)) '\con_000' num2str(cdx) '.nii,1']};
                else
                    job.des.t1.scans(n) = {[basedir  'GLMs\glm_t-tests\sub-' num2str(subs(pdx)) '_' num2str(s(ses)) '\con_00' num2str(cdx) '.nii,1']};
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
        %run second level design
        spm_run_factorial_design(job)
        
        load SPM
        %estimate data
        SPM=spm_spm(SPM)
        save('SPM', 'SPM')
        
        cons = [1; -1];
        names = {'pos', 'neg'};
        curdir = pwd;
        %run contrasts and generate t-tests
        analyze_spm_contrasts(curdir, cons, names);
    end
end