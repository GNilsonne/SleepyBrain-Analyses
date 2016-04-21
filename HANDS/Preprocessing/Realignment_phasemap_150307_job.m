% Preprocessing is done throug separate scripts for every step. Following
% steps are performed: Slice timing, realign and unwarp (fieldmap for
% subjects who have one for all sessions included), coregistration (EPI to
% structural), structural segmentation, DARTEL teplate and normalisation to MNI
% + SMOOTH.
% Script to realign and unwarp subjects that have a phase map for all
% included sessions

root_path = '/data/stress/HANDS_AGE/46Slices';
HANDS_AGEfolders = dir(root_path);
HANDS_AGEfolders = HANDS_AGEfolders(arrayfun(@(HANDS_AGEfolders) ~strcmp(HANDS_AGEfolders.name(1), '.'),HANDS_AGEfolders));

root_path = '/data/stress/Fieldmaps/Echotime_68_88';
fieldmap_68_88 = dir(root_path);
fieldmap_68_88 = fieldmap_68_88(arrayfun(@(fieldmap_68_88) ~strcmp(fieldmap_68_88.name(1), '.'),fieldmap_68_88));

% Subjects with phase map (68_88) and 46 slices

%% Subject ID:s redacted
phasemap = {};

for i = 1:length(phasemap)
    subject_session = phasemap{i};
    
    files = dir(strcat('/data/stress/HANDS_AGE/46Slices/', subject_session, '/a*.nii'));
    data = arrayfun(@(file) strcat('/data/stress/HANDS_AGE/46Slices/', subject_session, '/', file.name), files, 'UniformOutput', false);
    VDM = dir(strcat('/data/stress/Fieldmaps/Echotime_68_88/', subject_session, '/vdm*.nii'));
    fieldmap = arrayfun(@(file) strcat('/data/stress/Fieldmaps/Echotime_68_88/', subject_session, '/', file.name), VDM, 'UniformOutput', false);
    
    
    matlabbatch{i}.spm.spatial.realignunwarp.data.scans = data;
    matlabbatch{i}.spm.spatial.realignunwarp.data.pmscan = fieldmap;
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

root_path = '/data/stress/HANDS_AGE/46Slices';
HANDS_AGEfolders = dir(root_path);
HANDS_AGEfolders = HANDS_AGEfolders(arrayfun(@(HANDSfolders) ~strcmp(HANDSfolders.name(1), '.'),HANDS_AGEfolders));

root_path = '/data/stress/Fieldmaps/Echotime_10_12';
fieldmap_10_12 = dir(root_path);
fieldmap_10_12 = fieldmap_10_12(arrayfun(@(fieldmap_10_12) ~strcmp(fieldmap_10_12.name(1), '.'),fieldmap_10_12));


% Subjects with phase map (10 and 12 ET) and 46 slices

%% Subject ID:s redacted
phasemap = {};

for i = 1:length(phasemap)
    subject_session = phasemap{i};
    
    files = dir(strcat('/data/stress/HANDS_AGE/46Slices/', subject_session, '/a*.nii'));
    data = arrayfun(@(file) strcat('/data/stress/HANDS_AGE/46Slices/', subject_session, '/', file.name), files, 'UniformOutput', false);
    VDM = dir(strcat('/data/stress/Fieldmaps/Echotime_10_12/', subject_session, '/vdm*.nii'));
    fieldmap = arrayfun(@(file) strcat('/data/stress/Fieldmaps/Echotime_10_12/', subject_session, '/', file.name), VDM, 'UniformOutput', false);
    
    matlabbatch{103+i}.spm.spatial.realignunwarp.data.scans = data;
    matlabbatch{103+i}.spm.spatial.realignunwarp.data.pmscan = fieldmap;
    matlabbatch{103+i}.spm.spatial.realignunwarp.eoptions.quality = 0.9;
    matlabbatch{103+i}.spm.spatial.realignunwarp.eoptions.sep = 4;
    matlabbatch{103+i}.spm.spatial.realignunwarp.eoptions.fwhm = 5;
    matlabbatch{103+i}.spm.spatial.realignunwarp.eoptions.rtm = 0;
    matlabbatch{103+i}.spm.spatial.realignunwarp.eoptions.einterp = 2;
    matlabbatch{103+i}.spm.spatial.realignunwarp.eoptions.ewrap = [0 1 0];
    matlabbatch{103+i}.spm.spatial.realignunwarp.eoptions.weight = '';
    matlabbatch{103+i}.spm.spatial.realignunwarp.uweoptions.basfcn = [12 12];
    matlabbatch{103+i}.spm.spatial.realignunwarp.uweoptions.regorder = 1;
    matlabbatch{103+i}.spm.spatial.realignunwarp.uweoptions.lambda = 100000;
    matlabbatch{103+i}.spm.spatial.realignunwarp.uweoptions.jm = 0;
    matlabbatch{103+i}.spm.spatial.realignunwarp.uweoptions.fot = [4 5];
    matlabbatch{103+i}.spm.spatial.realignunwarp.uweoptions.sot = [];
    matlabbatch{103+i}.spm.spatial.realignunwarp.uweoptions.uwfwhm = 4;
    matlabbatch{103+i}.spm.spatial.realignunwarp.uweoptions.rem = 1;
    matlabbatch{103+i}.spm.spatial.realignunwarp.uweoptions.noi = 5;
    matlabbatch{103+i}.spm.spatial.realignunwarp.uweoptions.expround = 'Average';
    matlabbatch{103+i}.spm.spatial.realignunwarp.uwroptions.uwwhich = [2 1];
    matlabbatch{103+i}.spm.spatial.realignunwarp.uwroptions.rinterp = 4;
    matlabbatch{103+i}.spm.spatial.realignunwarp.uwroptions.wrap = [0 1 0];
    matlabbatch{103+i}.spm.spatial.realignunwarp.uwroptions.mask = 1;
    matlabbatch{103+i}.spm.spatial.realignunwarp.uwroptions.prefix = 'u';

end

% Subjects with phase map (7 and 9 ET) and 45 slices

%% Subject ID:s redacted
phasemap = {};

root_path = '/data/stress/HANDS_AGE/45Slices';
HANDS_AGEfolders = dir(root_path);
HANDS_AGEfolders = HANDS_AGEfolders(arrayfun(@(HANDS_AGEfolders) ~strcmp(HANDS_AGEfolders.name(1), '.'),HANDS_AGEfolders));


root_path = '/data/stress/Fieldmaps/Echotime_7_9';
fieldmap_7_9 = dir(root_path);
fieldmap_7_9 = fieldmap_7_9(arrayfun(@(fieldmap_7_9) ~strcmp(fieldmap_7_9.name(1), '.'),fieldmap_7_9));


for i = 1:length(phasemap)
    subject_session = phasemap{i};
    
    files = dir(strcat('/data/stress/HANDS_AGE/45Slices/', subject_session, '/a*.nii'));
    data = arrayfun(@(file) strcat('/data/stress/HANDS_AGE/45Slices/', subject_session, '/', file.name), files, 'UniformOutput', false);
    VDM = dir(strcat('/data/stress/Fieldmaps/Echotime_7_9/', subject_session, '/vdm*.nii'));
    fieldmap = arrayfun(@(file) strcat('/data/stress/Fieldmaps/Echotime_7_9/', subject_session, '/', file.name), VDM, 'UniformOutput', false);
    
    matlabbatch{105+i}.spm.spatial.realignunwarp.data.scans = data;
    matlabbatch{105+i}.spm.spatial.realignunwarp.data.pmscan = fieldmap;
    matlabbatch{105+i}.spm.spatial.realignunwarp.eoptions.quality = 0.9;
    matlabbatch{105+i}.spm.spatial.realignunwarp.eoptions.sep = 4;
    matlabbatch{105+i}.spm.spatial.realignunwarp.eoptions.fwhm = 5;
    matlabbatch{105+i}.spm.spatial.realignunwarp.eoptions.rtm = 0;
    matlabbatch{105+i}.spm.spatial.realignunwarp.eoptions.einterp = 2;
    matlabbatch{105+i}.spm.spatial.realignunwarp.eoptions.ewrap = [0 1 0];
    matlabbatch{105+i}.spm.spatial.realignunwarp.eoptions.weight = '';
    matlabbatch{105+i}.spm.spatial.realignunwarp.uweoptions.basfcn = [12 12];
    matlabbatch{105+i}.spm.spatial.realignunwarp.uweoptions.regorder = 1;
    matlabbatch{105+i}.spm.spatial.realignunwarp.uweoptions.lambda = 100000;
    matlabbatch{105+i}.spm.spatial.realignunwarp.uweoptions.jm = 0;
    matlabbatch{105+i}.spm.spatial.realignunwarp.uweoptions.fot = [4 5];
    matlabbatch{105+i}.spm.spatial.realignunwarp.uweoptions.sot = [];
    matlabbatch{105+i}.spm.spatial.realignunwarp.uweoptions.uwfwhm = 4;
    matlabbatch{105+i}.spm.spatial.realignunwarp.uweoptions.rem = 1;
    matlabbatch{105+i}.spm.spatial.realignunwarp.uweoptions.noi = 5;
    matlabbatch{105+i}.spm.spatial.realignunwarp.uweoptions.expround = 'Average';
    matlabbatch{105+i}.spm.spatial.realignunwarp.uwroptions.uwwhich = [2 1];
    matlabbatch{105+i}.spm.spatial.realignunwarp.uwroptions.rinterp = 4;
    matlabbatch{105+i}.spm.spatial.realignunwarp.uwroptions.wrap = [0 1 0];
    matlabbatch{105+i}.spm.spatial.realignunwarp.uwroptions.mask = 1;
    matlabbatch{105+i}.spm.spatial.realignunwarp.uwroptions.prefix = 'u';

end