% List of open inputs
nrun = X; % enter the number of runs here
jobfile = {'/data/stress/Resting_State/2nd level networks 151208/N8_masked/N8_151208_masked_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(0, nrun);
for crun = 1:nrun
end
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
