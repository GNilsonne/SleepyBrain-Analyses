function sleep_group_Ftest
% an f test using flexible factorial for group by condition
% WARNING OVerwrites old data without prompting. 

basedir ='e:\sleepdata\ds201_R0.9.0\';

subs=[];
load Fjob.mat
load('sleep_ons.mat')

con_names ={'HA_AN';'HA_NE'; 'AN_NE';'HA';'AN'; 'NE'; 'HA+AN'; 'HA+AN+NE'}
condir = [basedir '\GLMs\ftest\'];
mkdir(condir)

%participants to exclude, by index in subs variable
exclude = [20  28 48 49 ]
% matlabbatch{1}.spm.stats.factorial_design.masking.em={'D:\work\FACES\output\ROI_masks\ROI_mask_IPC_right_MNI.img,1'};
for cdx = 1:size(con_names,1) % loop over contrast numbers
    cdx
    job.dir = {[condir '\' con_names{cdx}  '\']};
    mkdir([condir '\' con_names{cdx}  '\'])
    cd([ condir '\' con_names{cdx}  '\']);
    n1=1;
    n2=1;
    
    for pdx = 1:size(subs,1)
        if isempty(find(exclude == pdx, 1))
            % is sleep deprived session was first or second
            if sleepsess(pdx)==1
                s1=1; s2=2;
            else
                s1=2; s2=1;
            end
            
            job.des.fblock.fsuball.specall.scans(n1) = {[basedir  'GLMs\glm_t-tests\sub-' num2str(subs(pdx)) '_' num2str(s1) '\con_000' num2str(cdx) '.nii,1']};
            job.des.fblock.fsuball.specall.imatrix(n1,:)  = [1 age(pdx)  1 n2] ;
            n1=n1+1;
            
            job.des.fblock.fsuball.specall.scans(n1) = {[basedir  'GLMs\glm_t-tests\sub-' num2str(subs(pdx)) '_' num2str(s2) '\con_000' num2str(cdx) '.nii,1']};
            job.des.fblock.fsuball.specall.imatrix(n1,:)  = [1 age(pdx)  2 n2] ;
            n1=n1+1;
            n2=n2+1;
            
        end
    end
    
    if ~isempty(ls('SPM.mat'))
        delete SPM.mat
    end
    
    job.des.fblock.fac(2).name = 'condition'
    spm_run_factorial_design(job)
    load SPM
    SPM=spm_spm(SPM)
    save('SPM', 'SPM')
    
    analyze_spm_Fcontrasts(job.dir{1}, [zeros(1,75) 1 -1 -1 1], {'Ftest_inter'})
    
end
