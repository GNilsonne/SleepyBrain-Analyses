function  analyze_spm12_design(directory, files, HRF, TR, ons, regress, pmod)
%  analyze_spm_design(directory, files, HRF, TR, ons, regress, pmod)
%
% creates tyhe design matrix and the SPM.mat file for an eveent-related
% fmri design to be analyzed in spm8. Calls spm_run_fmri_spec.m, with the
% appropriatly set up inut matrix.
%
% directory is the directory into which the SPM.mat file will be saved.
% Idially, his should probably be a directory for that particulair participant
%
% files is a list of files to be included in the analysis, in a 3-d array.
% The 3rd dimention separated files into different scanning sessions. Note
% that the program will assume that there are the same number of scans in
% each session. This array can be created by calling
% analyze_spm_create_filelist.m
%
% hrf tells the program what HRF you want to use. This variable can be a 1
% (for standard HRF alone), 2, for HRF plus derivative, or 3, for HRF plus
% the derivative and dispersion
%
% TR is the TR of the scans, in seconds
%
% ons is a matrix contraining event information. It should have the columns
% [session, type, onset time, duration]
% the session column indicates which scanning session (run) that event belongs 
% to, and will be associated with the scans in the 3rd dimention of the files
% array. Type is an indicator of event types, indicated by an intiger.
% Event types should be sequential, starting at 1. Event types of 0 will be
% ignored. Onset time is the time of trial onset relative to the beginning
% of the scanning session, in seconds. Duration is the duration of each event.
% 
% Missing event types in any run will cause SPM to request an array of
% onsets for that event type, and thus should be avoided. 
%
% regress is the regressors to be included in the analysis. Thic can be a
% matrix, or filename. If it is a matrix, there must be 1 row per scan, 1
% column per regressor, and the 3rd dimention should be for scanning
% sessions. If it is a text filenames, there should be a filename for
% each session, or one file that includes all sessions. This is useful to 
% load the motion parameters, which SPM saves as a text file. Filenames 
% must have the full path included.
%
% ---- NOTE REGRESSORS NOT FULLY IMPLIMENTED,  .txt FILE ONLY
%
% regress is an optional variables
%
% pmod is an optional input for parametric modulators. It can take 2 forms.
% The first hase size(numconds,1), with one number for each event type.
% This will add a time modulation of the order specified by the number in
% pmod. So with 2 event types, pmod = [1 2] will fit a first order time
% polynomial to type 1 and a second order to type 2 (adding 2 columns to
% the design matrix). 
% otherwise, pmod can be a list with one number per event in 'ons'. This
% will match with each event in ons. For any events in which you do not
% wish to add any parametric modulators, add all zeros for that event type.
% 
% Note that this function requires the mat file 'basejob.mat', which has
% certain base variables cfoded into it (I couldn't figure out how to
% properly code a size 0 object with sub-objects, so i just stole the file
% from an SMP analysis)
%
% Colin Hawco, Winter 2011
% updated to spm12 Spring 2016

load basejob2
job.dir = {directory};

%timing info
job.timing.units='secs';
job.timing.RT=TR;
job.timing.fmri_t= 16;
job.timing.fmri_t0= 8;
job.mthresh = 0.5;

pmodtemp = job.sess(1).cond(1).pmod;
%HRF to use
if HRF == 1
    disp('Using HRF alone')
    job.bases.hrf.derivs=[0 0];
elseif HRF == 2
    job.bases.hrf.derivs=[1 0];
    disp('Using HRF plus derivative')
elseif HRF == 3
    job.bases.hrf.derivs=[1 1];
    disp('Using HRF plus derivative and dispersion')
else
    disp('Inproper input for variable HRF, assuming we should use HRF alone')
    job.bases.hrf.derivs=[0 0];
end

% again, more basic values that should probably be left alone. AR is the
% autocorrolation 
job.volt= 1;
job.global= 'None';
job.mask= {''};
job.cvi='AR(1)';

numconds = max(ons(:,2));

% values for sess variables
for idx =1:size(files,3)
    
    for jdx = 1:length((files(:,1,idx))) % allows for runs of different lengths
        if ~isempty(deblank([files(jdx,:,idx)])) %doesn't include blank entries
            job.sess(idx).scans(jdx) = {[files(jdx,:,idx)]};
        end
    end
    
    job.sess(idx).hpf = 128;
    
    % infor for each condition
    for jdx = 1:numconds
        
        % conditions are just named 'condition1', 'condition2', etc.
        job.sess(idx).cond(jdx).name = ['condition' num2str(jdx)];
        
        %timing of events in this condition in this session
        t = find(ons(:,1) == idx & ons(:,2)==jdx);
        job.sess(idx).cond(jdx).onset = ons(t,3);
        
        %duration of events in this condition in this session
        job.sess(idx).cond(jdx).duration = ons(t,4);
        job.sess(idx).cond(jdx).orth = 1; 
        
        job.sess(idx).multi = job.sess(1).multi;
        job.sess(idx).multi_reg = job.sess(1).multi_reg;
        job.sess(idx).hpf = 128;
                
        % parametric modulators, if needed
        if nargin == 7
            if length(pmod) == numconds %there is one paramtric modulator per event type
                %we assume it is a time modulatation
                job.sess(idx).cond(jdx).tmod = pmod(jdx);
                job.sess(idx).cond(jdx).pmod = job.sess(1).cond(1).pmod;
            else
                for  mdx = 1:size(pmod,2)
                    pcur = pmod(:,mdx);
                    mdx = 1;
                    if sum(pmod(t)) ~= 0
                        job.sess(idx).cond(jdx).pmod(mdx).name = ['pmod' num2str(jdx)];
                        job.sess(idx).cond(jdx).pmod(mdx).param = pcur(t);
                        job.sess(idx).cond(jdx).pmod(mdx).poly= 1; %hard coded to first order polynomial
                        job.sess(idx).cond(jdx).tmod(mdx) = 0;
                    else %if all modulators are zero, don't add it
                        job.sess(idx).cond(jdx).pmod = pmodtemp; %job.sess(1).cond(1).pmod;
                        job.sess(idx).cond(jdx).tmod(mdx) = 0;
                    end
                end
            end
        else
            job.sess(idx).cond(jdx).tmod = 0;
            job.sess(idx).cond(jdx).pmod = job.sess(1).cond(1).pmod;
        end
    end %end conditions
    
end


%now, the regressos
if nargin > 5
    %regressors
    if ischar(regress) %text files for regressors loaded
        if size(regress, 1) == 1
            Rtemp = textread(regress);
            curnum = 1;
            %write regressors for each session
            for idx = 1:size(files,3)
                
                for jdx = 1:size(Rtemp,2)
                    job.sess(idx).regress(jdx).name = ['R' num2str(jdx)];
                    job.sess(idx).regress(jdx).val = Rtemp(curnum: curnum + size(job.sess(idx).scans,2)-1,jdx);
                end
                curnum = curnum + size(job.sess(idx).scans,2);
            end
        end
        
        
    elseif isnumeric(regress)
        
        Rtemp = regress;
        curnum = 1;
        %write regressors for each session
        for idx = 1:size(files,3)
            
            for jdx = 1:size(Rtemp,2)
                job.sess(idx).regress(jdx).name = ['R' num2str(jdx)];
                job.sess(idx).regress(jdx).val = Rtemp(curnum: curnum + size(job.sess(idx).scans,2)-1,jdx);
            end
            curnum = curnum + size(job.sess(idx).scans,2);
            
        end
        
    else % regressors not number or string
        disp(' ')
        disp(' ')
        disp(' ')
        disp('Warning: regressors in unknown format, not included in analysis')
        disp(' ')
        disp(' ')
        disp(' ')
    end
    
end

% SPM function to Set up the design matrix and run a design
spm_run_fmri_spec(job)

% Call spm_spm to estimate the paramters
curdir = pwd;

cd(directory)
load SPM
spm_spm(SPM);
%the following line can be enabled to save residuals. 
% VRes = spm_write_residuals(SPM,NaN);
