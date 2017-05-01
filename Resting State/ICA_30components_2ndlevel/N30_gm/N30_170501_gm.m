% List of open inputs
nrun = X; % enter the number of runs here
jobfile = {'/data/stress/Resting_State/2nd level networks 170419/N30_gm/N30_170501_gm_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(0, nrun);
for crun = 1:nrun
end
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
