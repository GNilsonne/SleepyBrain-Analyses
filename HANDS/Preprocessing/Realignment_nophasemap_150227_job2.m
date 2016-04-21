% Preprocessing is done throug separate scripts for every step. Following
% steps are performed: Slice timing, realign and unwarp (fieldmap for
% subjects who have one for all sessions included), coregistration (EPI to
% structural), structural segmentation, DARTEL teplate and normalisation to MNI
% + SMOOTH.
% Script to realign and unwarp subjects that don't have a phase map. (Or
% only from one session, if both sessions are used.)
root_path = '/data/stress/HANDS_AGE/46Slices';
%HANDS_AGEfolders = dir(root_path);
%HANDS_AGEfolders = HANDS_AGEfolders(arrayfun(@(HANDS_AGEfolders) ~strcmp(HANDS_AGEfolders.name(1), '.'),HANDS_AGEfolders));

% Subjects with no phase map (or only for one session) and 46 slices
%% Subject ID:s redacted
nophasemap = {};

for i = 1:length(nophasemap)
    subject_session = nophasemap{i};
    
    files = dir(strcat('/data/stress/HANDS_AGE/46Slices/', subject_session, '/a*.nii'));
    data = arrayfun(@(file) strcat('/data/stress/HANDS_AGE/46Slices/', subject_session, '/', file.name), files, 'UniformOutput', false);
    
    matlabbatch{i}.spm.spatial.realignunwarp.data.scans = data;
    matlabbatch{i}.spm.spatial.realignunwarp.data.pmscan = '';
    matlabbatch{i}.spm.spatial.realignunwarp.eoptions.quality = 0.9;
    matlabbatch{i}.spm.spatial.realignunwarp.eoptions.sep = 4;
    matlabbatch{i}.spm.spatial.realignunwarp.eoptions.fwhm = 5;
    matlabbatch{i}.spm.spatial.realignunwarp.eoptions.rtm = 0;
    matlabbatch{i}.spm.spatial.realignunwarp.eoptions.einterp = 2;
    matlabbatch{i}.spm.spatial.realignunwarp.eoptions.ewrap = [0 1 0];
    matlabbatch{i}.spm.spatial.realignunwarp.eoptions.weight = '';
    matlabbatch{i}.spm.spatial.realignunwarp.uweoptions.basfcn = [12 12];
    matlabbatch{i}.spm.spatial.realignunwarp.uweoptions.regorder = 1;
    matlabbatch{i}.spm.spatial.realignunwarp.uweoptions.lambda = 100000;
    matlabbatch{i}.spm.spatial.realignunwarp.uweoptions.jm = 0;
    matlabbatch{i}.spm.spatial.realignunwarp.uweoptions.fot = [4 5];
    matlabbatch{i}.spm.spatial.realignunwarp.uweoptions.sot = [];
    matlabbatch{i}.spm.spatial.realignunwarp.uweoptions.uwfwhm = 4;
    matlabbatch{i}.spm.spatial.realignunwarp.uweoptions.rem = 1;
    matlabbatch{i}.spm.spatial.realignunwarp.uweoptions.noi = 5;
    matlabbatch{i}.spm.spatial.realignunwarp.uweoptions.expround = 'Average';
    matlabbatch{i}.spm.spatial.realignunwarp.uwroptions.uwwhich = [2 1];
    matlabbatch{i}.spm.spatial.realignunwarp.uwroptions.rinterp = 4;
    matlabbatch{i}.spm.spatial.realignunwarp.uwroptions.wrap = [0 1 0];
    matlabbatch{i}.spm.spatial.realignunwarp.uwroptions.mask = 1;
    matlabbatch{i}.spm.spatial.realignunwarp.uwroptions.prefix = 'u';

end

%root_path = '/data/stress/HANDS_AGE/45Slices';
%HANDS_AGEfolders = dir(root_path);
%HANDS_AGEfolders = HANDS_AGEfolders(arrayfun(@(HANDS_AGEfolders) ~strcmp(HANDS_AGEfolders.name(1), '.'),HANDS_AGEfolders));

% Subjects with no phase map (or only for one session) and 45 slices
%% Subject ID:s redacted
%nophasemap = {};

%for i = 1:length(nophasemap)
 %   subject_session = nophasemap{i};
  %  
   % files = dir(strcat('/data/stress/HANDS_AGE/45Slices/', subject_session, '/a*.nii'));
    %data = arrayfun(@(file) strcat('/data/stress/HANDS_AGE/45Slices/', subject_session, '/', file.name), files, 'UniformOutput', false);
    
%    matlabbatch{15+i}.spm.spatial.realignunwarp.data.scans = data;
 %   matlabbatch{15+i}.spm.spatial.realignunwarp.data.pmscan = '';
  %  matlabbatch{15+i}.spm.spatial.realignunwarp.eoptions.quality = 0.9;
   % matlabbatch{15+i}.spm.spatial.realignunwarp.eoptions.sep = 4;
    %matlabbatch{15+i}.spm.spatial.realignunwarp.eoptions.fwhm = 5;
 %   matlabbatch{15+i}.spm.spatial.realignunwarp.eoptions.rtm = 0;
 %   matlabbatch{15+i}.spm.spatial.realignunwarp.eoptions.einterp = 2;
 %   matlabbatch{15+i}.spm.spatial.realignunwarp.eoptions.ewrap = [0 1 0];
 %   matlabbatch{15+i}.spm.spatial.realignunwarp.eoptions.weight = '';
 %   matlabbatch{15+i}.spm.spatial.realignunwarp.uweoptions.basfcn = [12 12];
 %   matlabbatch{15+i}.spm.spatial.realignunwarp.uweoptions.regorder = 1;
 %   matlabbatch{15+i}.spm.spatial.realignunwarp.uweoptions.lambda = 100000;
 %   matlabbatch{15+i}.spm.spatial.realignunwarp.uweoptions.jm = 0;
 %   matlabbatch{15+i}.spm.spatial.realignunwarp.uweoptions.fot = [4 5];
 %   matlabbatch{15+i}.spm.spatial.realignunwarp.uweoptions.sot = [];
  %  matlabbatch{15+i}.spm.spatial.realignunwarp.uweoptions.uwfwhm = 4;
%    matlabbatch{15+i}.spm.spatial.realignunwarp.uweoptions.rem = 1;
%    matlabbatch{15+i}.spm.spatial.realignunwarp.uweoptions.noi = 5;
 %   matlabbatch{15+i}.spm.spatial.realignunwarp.uweoptions.expround = 'Average';
 %   matlabbatch{15+i}.spm.spatial.realignunwarp.uwroptions.uwwhich = [2 1];
 %   matlabbatch{15+i}.spm.spatial.realignunwarp.uwroptions.rinterp = 4;
 %   matlabbatch{15+i}.spm.spatial.realignunwarp.uwroptions.wrap = [0 1 0];
 %   matlabbatch{15+i}.spm.spatial.realignunwarp.uwroptions.mask = 1;
 %   matlabbatch{15+i}.spm.spatial.realignunwarp.uwroptions.prefix = 'u';

%end