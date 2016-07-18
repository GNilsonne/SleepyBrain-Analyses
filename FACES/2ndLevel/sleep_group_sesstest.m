function sleep_group_sesstest
% 2nd level analysis for differeces between sleep deprived and not sleep
% deprived sessions. Paired t-test. 
% WARNING Overwrites old data without prompting. 

basedir ='e:\sleepdata\ds201_R0.9.0\';

subs=[];
load group_pt12.mat
load('sleep_ons.mat')

con_names ={'HA_AN';'HA_NE'; 'AN_NE';'HA';'AN'; 'NE'; 'HA+AN'; 'HA+AN+NE'}

condir = [basedir '\GLMs\glm_t-tests\group_sess\'];
mkdir(condir)

%participants to exclude, by index in subs variable
exclude = [20  28 48 49 ] %ex 28, 38-2, 67-1
% matlabbatch{1}.spm.stats.factorial_design.masking.em={'D:\work\FACES\output\ROI_masks\ROI_mask_IPC_right_MNI.img,1'};
for cdx = 1:size(con_names,1) % loop over contrast numbers
    cdx
    %output dir, must exist, assumes c1, c2, c3 structures
    job.dir = {[condir '\' con_names{cdx}  '\']};
    mkdir([condir '\' con_names{cdx}  '\'])
    cd([ condir '\' con_names{cdx}  '\']);
    %clear scans in current batch
    job.des.pt.pair = {}
    
    n=1;
    
    for pdx = 1:size(subs,1)
        if isempty(find(exclude == pdx, 1))
            if sleepsess(pdx)==1
                s1=1; s2=2;
            else
                s1=2; s2=1;
            end
            job.des.pt.pair(n).scans(1) = {[basedir  'GLMs\glm_t-tests\sub-' num2str(subs(pdx)) '_' num2str(s1) '\con_000' num2str(cdx) '.nii,1']};
            job.des.pt.pair(n).scans(2) = {[basedir  'GLMs\glm_t-tests\sub-' num2str(subs(pdx)) '_' num2str(s2) '\con_000' num2str(cdx) '.nii,1']};
            n=n+1;
        end
    end
    
    if ~isempty(ls('SPM.mat'))
        delete SPM.mat
    end
    
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
    
    cons = [1 -1 zeros(1, n-1); -1 1 zeros(1, n-1)];
    names = {'pos', 'neg'};
    curdir = pwd;
    analyze_spm_contrasts(curdir, cons, names);
end

