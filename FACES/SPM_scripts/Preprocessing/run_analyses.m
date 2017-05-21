% a seriers of wrapper scipt calls for running the analysis of the sleep
% deprived data set on faces. 
%
% Colin Hawco, Neuranalysis Consulting, 2016. 


% sub_list.mat is a file containing a lsit of subjects included in the
% analysis. 

load sub_list.mat

% base if the folder in which the raw data extracted from openfmri was
% stored. 
base = 'e:/sleepdata/'

% note some functions have basic .mat file dependances, which generally
% store extra job structure information. 

%% UNGZIP
% as the data comes in a gzip format, it is necessary to unzip it for SPM
% to work properly. 
for idx =1:size(subs,1)
    disp(subs(idx,:))
    for sess =1:2
        cd([base '\ds201_R0.9.0\sub-' num2str(subs(idx,:)) '\ses-' num2str(sess)])
        try
            cd anat\
            gunzip *.gz
            cd ../func
            gunzip *.gz
        end
    end
end

%% PREPROCESSING
%Initial preprocessing broken into steps. First, segment the T1 images for
%later DARTEL normalize. Requires segjob.mat

for pdx = 1:size(subs,1)
    disp(subs(idx,:)) % to keep track of progress
    % segment T1s. bt1 is a ariable containing a 1 or 2 for each pt.,
    % telling us which T1 was deteremined to be the best to use. 
    sleep_segmentT1(base, ['sub-' num2str(subs(pdx,:))],bt1(pdx));
    % QC the segmented T1s. Saves two jpg files with swegmentations in the
    % participsn root folder. 
    segment_QC(base, ['sub-' num2str(subs(pdx,:))]);
end
% CHECK Segmentations. 

% now calcualte dartel normalization for each T1. 
% this is done in a single script file. It may need editing depending on
% the data organization. 
dartel_scripts

% MOVE THE TEMPLATES
% the template gets saved into the first partiicpants T1 folder. Move it to
% [base '/ds201_R0.9.0/dartel/Template_6.nii']


%slice time correction and unwarping using fieldmaps. Note that in some cases, extra
%steps needed to be taken using coregister or manually moving the origin in
%files to properly align the fieldmaps to the EPI images. 
for pdx = 1:size(subs,1)
   disp(subs(idx,:)) % to keep track of progress
   
   % preproc 1 does slicetime and unwarping using field maps. vdm files
   % must be in the directory. 
   preproc1(base, ['sub-' num2str(subs(pdx,:))],bt1(pdx));
   % motion_qc saves a jpeg image of motion parameters, including the raw
   % paramters and scan to scan motion (first derivative) in  
   % [base 'ds201_R0.9.0\motion_qc\'], jpged labeled by sub ID
   motion_qc(base, ['sub-' num2str(subs(pdx,:))])

end

% at this point it may be preferable to check the data to see if the ua
% files look good. In some cases, the field maps and EPI images did not
% align well. If it generaly necessary to kove the origins of the EPI or
% vdm file to approximarlty the CC usinf SPms display function. 

% preproc 2 coregisters the EPI data to the T1, and applies the DARTEL flow
% fields to normalize the data. Note that smoothing is incorporated into
% the DARTEL normlizartion, at 8mm FWHM. 
for pdx = 1:size(subs,1)
   disp(subs(idx,:)) % to keep track of progress
    
   preproc2(base, ['sub-' num2str(subs(pdx,:))],bt1(pdx));
   % normalize_qc saves a jpeg image of selected slices of the normalized
   % EPI images for QC checking. Jpgegs stored in [base
   % '\ds201_R0.9.0\norm_qc']. jpegs should be checked for bad
   % normalizations and distortions. In most cases, problems arise from the
   % unwarping stage, and represent misgingments between vdm and EPI files.
   normalize_qc(base, ['sub-' num2str(subs(pdx,:))])
end
   
 % PREPROCESSING COMPLETE NOW
 
%% 1st level GLMs. 
% perform first level GLMs with basic model. All trials treated as events,
% not blocks. 

% for reference, here is the function used to evaluate the subject event
% onset variables:
% eval(['ons_' num2str(subs(pdx)) '_' num2str(s) '= get_sleep_faces_events(subs(pdx),s);' ])
 
% onsets are in the format required by my SPM scrips, a .mat file with
% columns, representing 
% [run(always 1) event_type time(seconds) duration]

% loop over participants
for pdx= 1:size(subs,1)
    disp( subs(pdx,:))
    for s = 1:2 % sessions 1 and 2
        try % we use a try here because 1 sub is missing session 2. 
            % first make sure we call that partiicpants specific onsets
            eval(['ons = ons_' num2str(subs(pdx)) '_' num2str(s)])
            %run GLM in this wrapper script, which called my GLM 1st level
            %functions. SPecifies model, estimates,a nd generates con and
            %t-maps. 
            sleep_faces_glm(['sub-' num2str(subs(pdx))], s, ons)
         end
    end
end

% first level GLMs run, now do group analyses

% one-sample t-tests for contrasts, separatly for each condition (sleep
% deprived and not sleep deprived)
% requites group_t12.mat, sleep_ons.mat
sleep_group_test.m      


% 2nd level analysis for differeces between sleep deprived and not sleep
% deprived sessions. Paired t-test. 
%requires group_pt12.mat, sleep_ons.mat
sleep_group_sesstest.m  

% 2nd level idependant samples t-test, checking for group differences in
% young and old, separatly for sleep deprived and nor seprived sessions. 
% requires group_2t.mat, sleep_ons.mat
sleep_group_agetest.m  

% an f test using flexible factorial for group by condition
% requires Fjob.mat, sleep_ons.mat
sleep_group_Ftest.m  



%% ADDITIONAL ANALYSIS FILES

% do PPI on each pt, using pre-extracts MPFC data
sleep_MPFC_PPI(pt)
sleep_group_test_PPI.m

% extract ROIs from pre-defined regions
sleep_FFA_rois
sleep_amyg_rois
sleep_rois_mpfc