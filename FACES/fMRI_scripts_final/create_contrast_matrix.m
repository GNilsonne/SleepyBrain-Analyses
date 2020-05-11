function con = create_contrast_matrix(contrasts, numtypes, numruns, regress, basis)
%creates SPM contrast matrix. 
% contrasts is the contrast matrix with jsut one column per event type 
% numtypes is number of event types, 
% numruns is number of runs, 
% regress is number of regressors for easch run (e.g. 6 if you include  
% motion regressors), 
% numbasis is the number of basis functions used in your analysis 
%(HRF only = 1, plus dervivative = 2, plus dispersion = 3)


if size(contrasts,2) < numtypes
    contrasts(:,size(contrasts,2)+1:numtypes) = 0
end

for cdx = 1:size(contrasts,1)
    
    runcontrast = []; %event contrast for each run
    for bdx = 1:numtypes %add basis functions to contrast matrix
        runcontrast = [runcontrast contrasts(cdx,bdx) zeros(1,basis-1)];
    end
    
    fcontrasts = []; %final contrast matrix for this run
    for rdx = 1:numruns
        fcontrasts = [fcontrasts runcontrast zeros(1,regress)];
    end
    fcontrasts = [fcontrasts zeros(1,numruns)]; %mean of each run
    
    con(cdx,:) = fcontrasts;
    
end
