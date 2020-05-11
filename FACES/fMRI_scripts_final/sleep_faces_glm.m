function sleep_faces_glm(pt, s, ons)
% sleep_faces_glm(pt, ses, ons)
% perform first-level analysis of fMRI for faces in sleep data set. All
% trials are treated as events ratehr than blocks. Only event types 1, 2,
% and 3 (happy, angry, neutral) are of interest. Motion regressors included
% in analysis, modeled using HRF plus derivative and dispersion functions. 


% the  directory where each participant data is found
base='/data/stress/FACES_BIDS/ds201_R1.0.0/';

% where the GLM output will be stored
% e.g. SPM.mat, beta files, con files
outdir = [ base 'GLMs/glm_t-tests/' pt '_' num2str(s)];
mkdir(outdir);

%directory of functional data
direc = ([base pt '/ses-' num2str(s) '/func']);

cd(direc)

fname = strtrim(ls('swuasub*.nii'));
V=spm_vol(fname);
nscans = size(V,1); % number of TRs in the scan

%set up scan names as SPM wants them

for rdx = 1:nscans
    ff=([pwd '/' fname ',' num2str(rdx)]);
    nii_files(rdx,1:length(ff)) = ff;
end
%motion regressors
mv_file = strtrim(ls('rp*.txt'));
mregress=textread(mv_file);

cd(outdir)

if exist('SPM.mat', 'file')
    delete('SPM.mat')
end

% specifiy design and estyimate first level model. analyze_spm12_design is
% my costume designed scrips for generating models with potentially varying
% inputs (e.g. regressors, pmods, etc). 
analyze_spm12_design(outdir, nii_files, 3, 3, ons, mregress);

% events 1 2 and 3 are happy angry neutral
%generate our basic contrast matrixies. 
contrasts = [
    1 -1 0 0 0 0 0
    1 0 -1 0 0 0 0
    0 1 -1 0 0 0 0 
    1 0 0 0 0 0 0 
    0 1 0 0 0 0 0 
    0 0 1 0 0 0 0 
    1 1 0 0 0 0 0  
    1 1 1 0 0 0 0];

% names of each contrast in order. 
names = {'HA_AN';'HA_NE'; 'AN_NE';'HA';'AN'; 'NE'; 'HA+AN'; 'HA+AN+NE'}

% this fucntion adjusts t he above matrix, adding zeros for derivative and
% dispersion columns, as well as columns for motion regressors and constant
con_mat = create_contrast_matrix(contrasts, 7, 1, 6, 3);

% generate the spm con and tmap files for the first level analysis. 
analyze_spm_contrasts( outdir, con_mat, names)
    
    
    
