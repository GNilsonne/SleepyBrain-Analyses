function sleep_group_agetest
% 2nd level idependant samples t-test, checking for group differences in
% young and old, separatly for sleep deprived and nor seprived sessions. 
% requires group_2t.mat, sleep_ons.mat
% WARNING Overwrites old data without prompting. 
basedir ='/data/stress/FACES_BIDS/ds201_R1.0.0/';

subs=[];
load  group_2t
load('sleep_ons.mat')

con_names ={'HA_AN';'HA_NE'; 'AN_NE';'HA';'AN'; 'NE'; 'HA+AN'; 'HA+AN+NE'}

for ses = 1:2
    %some  partiicpants excluded due to motion or other issues
    if ses == 1
        ex = [20  48 49]; %ex 9028, 9066-1, 9067-1 (as before)
        condir = [basedir 'GLMs/glm_t-tests/group_age_sleepderived/'];
    else
        ex = [20  28]; %ex 9028, 9038-2
        condir = [basedir 'GLMs/glm_t-tests/group_age_notdeprived/'];
    end
    
    mkdir(condir)
   
    for cdx = 1:size(con_names,1) % loop over contrast numbers
        cdx;
        
        job.dir = {[condir '/' con_names{cdx}  '/']};
        mkdir([condir '/' con_names{cdx}  '/'])
        cd([ condir '/' con_names{cdx}  '/']);
        %clear scans in current batch
        job.des.t2.scans1 = {};
        job.des.t2.scans2 = {};
        n1=1; n2=1;
        for pdx = 1:size(subs,1)
            if isempty(find(ex == pdx))
                if sleepsess(pdx)==1
                    s=[1 2];
                else
                    s=[2 1];
                end
                if age(pdx)==1
                    job.des.t2.scans1(n1,1) = {[basedir  'GLMs/glm_t-tests/sub-' num2str(subs(pdx)) '_' num2str(s(ses)) '/con_000' num2str(cdx) '.nii,1']};
                    n1=n1+1;
                else
                    job.des.t2.scans2(n2,1) = {[basedir  'GLMs/glm_t-tests/sub-' num2str(subs(pdx)) '_' num2str(s(ses)) '/con_000' num2str(cdx) '.nii,1']};
                    n2=n2+1;
                end
            end
        end
        
        if ~isempty(dir('SPM.mat'))
            delete SPM.mat
        end
        
        job.des.t2.dept= 0;
        job.des.t2.variance= 1;
        job.des.t2.gmsca= 0;
        job.des.t2.ancova= 0;
        
        job.masking.tm.tm_none=1;
        job.masking.im= 1;
        job.masking.em= {''};
        job.globalc.g_omit=1;
        job.globalm.glonorm=1;
        job.globalm.gmsca.gmsca_no=1;
        spm_run_factorial_design(job)
        
        load SPM
        SPM=spm_spm(SPM)
        save('SPM', 'SPM')
        
        cons = [1 -1; -1 1];
        names = {'pos', 'neg'};
        curdir = pwd;
        analyze_spm_contrasts(curdir, cons, names);
    end
end
