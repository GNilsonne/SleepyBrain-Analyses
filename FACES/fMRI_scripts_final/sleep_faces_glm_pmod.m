function sleep_faces_glm_pmod(pt, ses, ons)
%pmods 2 has a resting linear increase in activity for each block of AN HA
%NE

% the  directory where each participant data is found
base='e:\sleepdata\ds201_R0.9.0\';

% where the GLM output will be stored
% e.g. SPM.mat, beta files, con files
outdir = [ base '\GLMs\glm_pmods2\' pt '_' num2str(ses)];
mkdir(outdir);

%directory of functional data
direc = ([base pt '\ses-' num2str(ses) '\func']);

cd(direc)

fname = ls('swuasub*.nii');
V=spm_vol(fname);
nscans = size(V,1); % number of TRs in the scan

%set up scan names as SPM wants them
for rdx = 1:nscans
    ff=([pwd '\' fname ',' num2str(rdx)]);
    nii_files(rdx,1:length(ff)) = ff;
end
%motion regressors
mv_file = ls('rp*.txt');
mregress=textread(mv_file);

cd(outdir)

if exist('SPM.mat', 'file')
    delete('SPM.mat')
end

pmods = zeros(size(ons,1),1)
pmods(1:240) = [1:20 1:20  1:20 1:20 1:20  1:20 1:20 1:20 1:20  1:20 1:20 1:20; ]';

analyze_spm12_design(outdir, nii_files, 3, 3, ons, mregress, pmods);

% happy angry neutral
contrasts = [
    1 zeros(1,5) -1 zeros(1,5) 0 zeros(1,24)
    1 zeros(1,5) 0 zeros(1,5)  -1 zeros(1,24)
    0 zeros(1,5) 1 zeros(1,5)  -1 zeros(1,24)
    1 zeros(1,5) 0 zeros(1,5)  0  zeros(1,24)
    0 zeros(1,5) 1 zeros(1,5)  0  zeros(1,24)
    0 zeros(1,5) 0 zeros(1,5)  1  zeros(1,24)
    1 zeros(1,5) 1 zeros(1,5)  0  zeros(1,24)  
    1 zeros(1,5) 1 zeros(1,5) 1  zeros(1,24)
    0 0 0 1 0 0 0 0 0 1 0 0 0 1 zeros(1,23)
    0 0 0 1 0 0 0 0 0 0 0 0 0 0 zeros(1,23)
    0 0 0 0 0 0 0 0 0 1 0 0 0 0 zeros(1,23)
    0 0 0 0 0 0 0 0 0 0 0 0 0 1 zeros(1,23)];



names = {'HA_AN';'HA_NE'; 'AN_NE';'HA';'AN'; 'NE'; 'HA+AN'; 'HA+AN+NE'; ...
    'pmod_all'; 'pmod_HA'; 'pmod_AN'; 'pmod_NE'}

analyze_spm_contrasts( outdir, contrasts, names)
    
    
    
