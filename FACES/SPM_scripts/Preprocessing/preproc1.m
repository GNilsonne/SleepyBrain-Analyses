function preproc1(base, pt,t1)
% preproc1(base, pt)
% performs slicetime correction and realignment with unwarp


cd([base '\ds201_R0.9.0\' pt ])
numsess = size(ls('ses-*'),1)
fmap = 1;

for sess =1:numsess
    cd([base '\ds201_R0.9.0\' pt '\ses-' num2str(sess) '\func'])
    
    file=ls('sub*bold.nii');
    V=spm_vol(file);
    nslices = V(1).dim(3);
    nscans = size(V,1); % number of TRs in the scan
    
    %set up scan names as SPM wants them
    P='';
    for rdx = 1:nscans
        ff=([pwd '\' file ',' num2str(rdx)]);
        P(rdx,1:length(ff)) = ff;
    end
    
    tr = 3;
    ta = 2.93333333333333;
    refslice = 2;
    prefix = 'a';
    nslices = nslices;
    
    % participants can have 5 or 6 slices, so we need different slice time
    % onsets for each.
    if nslices == 45
        sliceorder = [1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31 33 35 37 39 41 43 45 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 42 44];
        
    elseif nslices == 46
        sliceorder = [1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31 33 35 37 39 41 43 45 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 42 44 46];
    else
        disp('WARNING WRONG NUMBER OF SLICES DETECTED!!!!!')
        return
    end
    
    timing = tr - ta;
    spm_slice_timing(P, sliceorder, refslice, [timing timing], prefix)
    clear P
    
    if isempty(ls('vdm*.nii'))
        fmap = 0;
    end
    
end % end of reslicing

%realisgn and unwarp

%define base job parameters. 
job.eoptions.quality= 0.9000;
job.eoptions.sep= 4;
job.eoptions.fwhm=5;
job.eoptions.rtm= 0;
job.eoptions.einterp= 4;
job.eoptions.ewrap= [0 0 0];
job.eoptions.weight= '';

job.uweoptions.basfcn= [12 12];
job.uweoptions.regorder= 1;
job.uweoptions.lambda= 100000;
job.uweoptions.jm= 0;
job.uweoptions. fot= [4 5];
job.uweoptions.sot= [];
job.uweoptions.uwfwhm= 4;
job.uweoptions.rem= 1;
job.uweoptions.noi= 5;
job.uweoptions.expround= 'Average'

job.uwroptions.uwwhich= [2 1];
job.uwroptions.rinterp= 4;
job.uwroptions.wrap= [0 0 0];
job.uwroptions.mask= 1;
job.uwroptions.prefix= 'u';


%loops through sessions
for sess =1:numsess
    
    cd([base '\ds201_R0.9.0\' pt '\ses-' num2str(sess) '\func'])
    file=ls('sub*bold.nii');
    for rdx = 1:nscans
        ff=([pwd '\a' file ',' num2str(rdx)]);
        P(rdx,1:length(ff)) = ff;
    end
    job.data.scans= {P};
    
    %add fmap file to use field maps if vdm file is found
    if fmap
        job.data.pmscan= {ls('vdm*.nii')};
    else
        job.data.pmscan= {''};
    end
    
    %run realignment with unwarping
    spm_run_realignunwarp(job);
end
