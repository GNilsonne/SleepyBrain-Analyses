%-----------------------------------------------------------------------
% Job saved on 13-Jan-2015 10:43:19 by cfg_util (rev $Rev: 6134 $)
% spm SPM - SPM12 (6225)
% cfg_basicio BasicIO - Unknown
%---------------------------------------
% Script to perform 1st level analysis in the ARROWS experiment. Onsetfiles contains onsetfiles without parametric modulations 
%--------------------------------
% Preprocessing is done throug separate scripts for every step. Following
% steps are performed: Slice timing, realign and unwarp (fieldmap for
% subjects who have one for all sessions included), coregistration (EPI to
% structural), structural segmentation, DARTEL teplate and normalisation to MNI
% + SMOOTH.
% Script to realign and unwarp subjects 

spm_jobman('initcfg');

% root_path = '/data/stress/ARROWS/ARROWS_Young2/46Slices';
% HANDSfolders = dir(root_path);
% HANDSfolders = HANDSfolders(arrayfun(@(HANDSfolders) ~strcmp(HANDSfolders.name(1), '.'),HANDSfolders));
% 
% root_path = '/data/stress/Fieldmaps/Echotime_68_88';
% fieldmap_68_88 = dir(root_path);
% fieldmap_68_88 = fieldmap_68_88(arrayfun(@(fieldmap_68_88) ~strcmp(fieldmap_68_88.name(1), '.'),fieldmap_68_88));
% 
% % Subjects with phase map and 46 slices
% phasemap = {'188_1', '188_2', '190_1', '190_2', '191_1', '191_2', '197_1', '197_2', '202_1', '202_2', '210_1', '210_2', '215_1', '215_2',...
%     '222_1', '222_2', '227_1', '227_2', '229_1', '229_2', '233_1', '233_2', '240_1', '240_2', '245_1', '245_2', '249_1', '249_2',...
%     '250_1', '250_2', '253_1', '253_2', '497_1', '497_2'};
% 
% 
% for i = 1:length(phasemap)
%     subject_session = phasemap{i};
%     
%     files = dir(strcat('/data/stress/ARROWS/ARROWS_Young2/46Slices/', subject_session, '/a*.nii'));
%     data = arrayfun(@(file) strcat('/data/stress/ARROWS/ARROWS_Young2/46Slices/', subject_session, '/', file.name), files, 'UniformOutput', false);
%     VDM = dir(strcat('/data/stress/Fieldmaps/Echotime_68_88/', subject_session, '/vdm*.nii'));
%     fieldmap = arrayfun(@(file) strcat('/data/stress/Fieldmaps/Echotime_68_88/', subject_session, '/', file.name), VDM, 'UniformOutput', false);
%     
%     
%     matlabbatch{1}.spm.spatial.realignunwarp.data.scans = data;
%     matlabbatch{1}.spm.spatial.realignunwarp.data.pmscan = fieldmap;
%     matlabbatch{1}.spm.spatial.realignunwarp.eoptions.quality = 0.9;
%     matlabbatch{1}.spm.spatial.realignunwarp.eoptions.sep = 4;
%     matlabbatch{1}.spm.spatial.realignunwarp.eoptions.fwhm = 5;
%     matlabbatch{1}.spm.spatial.realignunwarp.eoptions.rtm = 0;
%     matlabbatch{1}.spm.spatial.realignunwarp.eoptions.einterp = 2;
%     matlabbatch{1}.spm.spatial.realignunwarp.eoptions.ewrap = [0 1 0];
%     matlabbatch{1}.spm.spatial.realignunwarp.eoptions.weight = '';
%     matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.basfcn = [12 12];
%     matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.regorder = 1;
%     matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.lambda = 100000;
%     matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.jm = 0;
%     matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.fot = [4 5];
%     matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.sot = [];
%     matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.uwfwhm = 4;
%     matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.rem = 1;
%     matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.noi = 5;
%     matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.expround = 'Average';
%     matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.uwwhich = [2 1];
%     matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.rinterp = 4;
%     matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.wrap = [0 1 0];
%     matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.mask = 1;
%     matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.prefix = 'u';
%     
%     spm_jobman('run', matlabbatch)
% 
%     clear matlabbatch 
% 
% end
% 
% 
% root_path = '/data/stress/ARROWS/ARROWS_Young2/46Slices';
% HANDSfolders = dir(root_path);
% HANDSfolders = HANDSfolders(arrayfun(@(HANDSfolders) ~strcmp(HANDSfolders.name(1), '.'),HANDSfolders));
% 
% root_path = '/data/stress/Fieldmaps/Echotime_10_12';
% fieldmap_10_12 = dir(root_path);
% fieldmap_10_12 = fieldmap_10_12(arrayfun(@(fieldmap_10_12) ~strcmp(fieldmap_10_12.name(1), '.'),fieldmap_10_12));
% 
% 
% % Subjects with phase map (10 and 12 ET) and 45 slices
% phasemap = {'002_1', '015_1'};
% 
% for i = 1:length(phasemap)
%     subject_session = phasemap{i};
%     
%     files = dir(strcat('/data/stress/ARROWS/ARROWS_Young2/46Slices/', subject_session, '/a*.nii'));
%     data = arrayfun(@(file) strcat('/data/stress/ARROWS/ARROWS_Young2/46Slices/', subject_session, '/', file.name), files, 'UniformOutput', false);
%     VDM = dir(strcat('/data/stress/Fieldmaps/Echotime_10_12/', subject_session, '/vdm*.nii'));
%     fieldmap = arrayfun(@(file) strcat('/data/stress/Fieldmaps/Echotime_10_12/', subject_session, '/', file.name), VDM, 'UniformOutput', false);
%     
%     matlabbatch{1}.spm.spatial.realignunwarp.data.scans = data;
%     matlabbatch{1}.spm.spatial.realignunwarp.data.pmscan = fieldmap;
%     matlabbatch{1}.spm.spatial.realignunwarp.eoptions.quality = 0.9;
%     matlabbatch{1}.spm.spatial.realignunwarp.eoptions.sep = 4;
%     matlabbatch{1}.spm.spatial.realignunwarp.eoptions.fwhm = 5;
%     matlabbatch{1}.spm.spatial.realignunwarp.eoptions.rtm = 0;
%     matlabbatch{1}.spm.spatial.realignunwarp.eoptions.einterp = 2;
%     matlabbatch{1}.spm.spatial.realignunwarp.eoptions.ewrap = [0 1 0];
%     matlabbatch{1}.spm.spatial.realignunwarp.eoptions.weight = '';
%     matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.basfcn = [12 12];
%     matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.regorder = 1;
%     matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.lambda = 100000;
%     matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.jm = 0;
%     matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.fot = [4 5];
%     matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.sot = [];
%     matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.uwfwhm = 4;
%     matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.rem = 1;
%     matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.noi = 5;
%     matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.expround = 'Average';
%     matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.uwwhich = [2 1];
%     matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.rinterp = 4;
%     matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.wrap = [0 1 0];
%     matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.mask = 1;
%     matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.prefix = 'u';
%     
%     spm_jobman('run', matlabbatch)
% 
%     clear matlabbatch
% 
% end

% Subjects with phase map (7 and 9 ET) and 45 slices

% phasemap = {'002_2', '015_2','037_1', '037_2', '043_1', '043_2', '049_1', '049_2', '062_2', '070_1', '075_1', '075_2', '079_1', '081_1', '081_2',...
%     '082_1', '086_1', '086_2', '090_1', '090_2', '094_1', '094_2', '115_1', '115_2', '127_1', '127_2', '129_1', '129_2', '137_2', '140_1', '140_2',...
%     '143_1', '143_2', '146_1', '146_2', '156_1', '156_2', '164_1', '164_2'};
% 
% root_path = '/data/stress/ARROWS/ARROWS_Young2/45Slices';
% HANDSfolders = dir(root_path);
% HANDSfolders = HANDSfolders(arrayfun(@(HANDSfolders) ~strcmp(HANDSfolders.name(1), '.'),HANDSfolders));
% 
% 
% root_path = '/data/stress/Fieldmaps/Echotime_7_9';
% fieldmap_7_9 = dir(root_path);
% fieldmap_7_9 = fieldmap_7_9(arrayfun(@(fieldmap_7_9) ~strcmp(fieldmap_7_9.name(1), '.'),fieldmap_7_9));
% 
% 
% for i = 28:length(phasemap)
%     subject_session = phasemap{i};
%     
%     files = dir(strcat('/data/stress/ARROWS/ARROWS_Young2/45Slices/', subject_session, '/a*.nii'));
%     data = arrayfun(@(file) strcat('/data/stress/ARROWS/ARROWS_Young2/45Slices/', subject_session, '/', file.name), files, 'UniformOutput', false);
%     VDM = dir(strcat('/data/stress/Fieldmaps/Echotime_7_9/', subject_session, '/vdm*.nii'));
%     fieldmap = arrayfun(@(file) strcat('/data/stress/Fieldmaps/Echotime_7_9/', subject_session, '/', file.name), VDM, 'UniformOutput', false);
%     
%     
%     matlabbatch{1}.spm.spatial.realignunwarp.data.scans = data;
%     matlabbatch{1}.spm.spatial.realignunwarp.data.pmscan = fieldmap;
%     matlabbatch{1}.spm.spatial.realignunwarp.eoptions.quality = 0.9;
%     matlabbatch{1}.spm.spatial.realignunwarp.eoptions.sep = 4;
%     matlabbatch{1}.spm.spatial.realignunwarp.eoptions.fwhm = 5;
%     matlabbatch{1}.spm.spatial.realignunwarp.eoptions.rtm = 0;
%     matlabbatch{1}.spm.spatial.realignunwarp.eoptions.einterp = 2;
%     matlabbatch{1}.spm.spatial.realignunwarp.eoptions.ewrap = [0 1 0];
%     matlabbatch{1}.spm.spatial.realignunwarp.eoptions.weight = '';
%     matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.basfcn = [12 12];
%     matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.regorder = 1;
%     matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.lambda = 100000;
%     matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.jm = 0;
%     matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.fot = [4 5];
%     matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.sot = [];
%     matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.uwfwhm = 4;
%     matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.rem = 1;
%     matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.noi = 5;
%     matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.expround = 'Average';
%     matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.uwwhich = [2 1];
%     matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.rinterp = 4;
%     matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.wrap = [0 1 0];
%     matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.mask = 1;
%     matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.prefix = 'u';
%     
%     spm_jobman('run', matlabbatch)
% 
%     clear matlabbatch
% 
% end

% Subjects with no phase map (or only for one session) and 46 slices
nophasemap = {'038_1', '104_1', '104_2', '165_1', '165_2', '173_1', '173_2', '177_1', '177_2', '194_1', '194_2'};

for i = 10:length(nophasemap)
    subject_session = nophasemap{i};
    
    files = dir(strcat('/data/stress/ARROWS/ARROWS_Young2/46Slices/', subject_session, '/a*.nii'));
    data = arrayfun(@(file) strcat('/data/stress/ARROWS/ARROWS_Young2/46Slices/', subject_session, '/', file.name), files, 'UniformOutput', false);
    
    matlabbatch{1}.spm.spatial.realignunwarp.data.scans = data;
    matlabbatch{1}.spm.spatial.realignunwarp.data.pmscan = '';
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.quality = 0.9;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.sep = 4;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.fwhm = 5;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.rtm = 0;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.einterp = 2;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.ewrap = [0 1 0];
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.weight = '';
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.basfcn = [12 12];
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.regorder = 1;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.lambda = 100000;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.jm = 0;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.fot = [4 5];
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.sot = [];
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.uwfwhm = 4;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.rem = 1;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.noi = 5;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.expround = 'Average';
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.uwwhich = [2 1];
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.rinterp = 4;
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.wrap = [0 1 0];
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.mask = 1;
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.prefix = 'u';
    
    spm_jobman('run', matlabbatch)

    clear matlabbatch    

end

root_path = '/data/stress/ARROWS/ARROWS_Young/45Slices';

% Subjects with no phase map (or only for one session) and 45 slices
nophasemap = {'038_2', '040_1', '040_2'};

for i = 1:length(nophasemap)
    subject_session = nophasemap{i};
    
    files = dir(strcat('/data/stress/ARROWS/ARROWS_Young2/45Slices/', subject_session, '/a*.nii'));
    data = arrayfun(@(file) strcat('/data/stress/ARROWS/ARROWS_Young2/45Slices/', subject_session, '/', file.name), files, 'UniformOutput', false);
    
    matlabbatch{1}.spm.spatial.realignunwarp.data.scans = data;
    matlabbatch{1}.spm.spatial.realignunwarp.data.pmscan = '';
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.quality = 0.9;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.sep = 4;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.fwhm = 5;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.rtm = 0;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.einterp = 2;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.ewrap = [0 1 0];
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.weight = '';
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.basfcn = [12 12];
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.regorder = 1;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.lambda = 100000;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.jm = 0;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.fot = [4 5];
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.sot = [];
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.uwfwhm = 4;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.rem = 1;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.noi = 5;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.expround = 'Average';
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.uwwhich = [2 1];
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.rinterp = 4;
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.wrap = [0 1 0];
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.mask = 1;
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.prefix = 'u';
    
    spm_jobman('run', matlabbatch)

    clear matlabbatch

end

