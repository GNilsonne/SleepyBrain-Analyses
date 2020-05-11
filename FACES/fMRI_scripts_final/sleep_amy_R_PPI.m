function sleep_amy_R_PPI(pt)


cd(['/data/stress/FACES_BIDS/ds201_R1.0.0/GLMs/glm_t-tests/' pt '/'])

SPMmat = ['/data/stress/FACES_BIDS/ds201_R1.0.0/GLMs/glm_t-tests/' pt '/SPM.mat'];

matlabbatch{1}.spm.util.voi.spmmat = {['/data/stress/FACES_BIDS/ds201_R1.0.0/GLMs/glm_t-tests/' pt '/SPM.mat']};
matlabbatch{1}.spm.util.voi.adjust = 0;
matlabbatch{1}.spm.util.voi.session = 1;
matlabbatch{1}.spm.util.voi.name = 'amygdala_right';
matlabbatch{1}.spm.util.voi.roi{1}.sphere.centre = [22 -6 -14];
matlabbatch{1}.spm.util.voi.roi{1}.sphere.radius = 6;
matlabbatch{1}.spm.util.voi.roi{1}.sphere.move.fixed = 1;
matlabbatch{1}.spm.util.voi.expression = 'i1';

spm_jobman('run',matlabbatch)

ppiflag = 'ppi';
VOI_name = ['/data/stress/FACES_BIDS/ds201_R1.0.0/GLMs/glm_t-tests/' pt '/VOI_amygdala_right_1.mat'];
design = [1 1 1; 2 1 -1];
PPI_name = 'HA_AN_NE';

spm_peb_ppi(SPMmat,ppiflag,VOI_name,design, PPI_name, 0)

mkdir PPI_amy_R
movefile(['PPI_' PPI_name '.mat'], ['PPI_amy_R/PPI_' PPI_name '.mat'])
cd PPI_amy_R

load(['PPI_' PPI_name '.mat'])

load ppi_1st_job.mat 


job.dir = {['/data/stress/FACES_BIDS/ds201_R1.0.0/GLMs/glm_t-tests/' pt '/PPI_amy_R']}
job.sess.regress(1).val = PPI.ppi;
job.sess.regress(2).val = PPI.Y;
job.sess.regress(3).val = PPI.P;


cd(['/data/stress/FACES_BIDS/ds201_R1.0.0/' pt(1:8) '/ses-' pt(end) '/func']);
fname = strtrim(ls('swuasub*.nii'));
V=spm_vol(fname);
nscans = size(V,1); % number of TRs in the scan
job.sess.scans = {};
%set up scan names as SPM wants them
for rdx = 1:nscans
    ff=([pwd '/' fname ',' num2str(rdx)]);
    job.sess.scans(rdx) = {ff};
end
cd(job.dir{1})
if exist('SPM.mat', 'file');
    delete('SPM.mat')
end
spm_run_fmri_spec(job)

cd(job.dir{1} )
load SPM
spm_spm(SPM);
%the following line can be enabled to save residuals. 
% VRes = spm_write_residuals(SPM,NaN);

contrasts = [1 0 0 0]

analyze_spm_contrasts( job.dir{1}, contrasts, {'PPI_inter'});

