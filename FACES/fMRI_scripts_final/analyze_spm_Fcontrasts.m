function analyze_spm_Fcontrasts( directory, contrast_matrix, names)
% function analyze_spm_contrasts( directory, contrast_matrix, [names])
% Colin Hawco, revised March 2012
% calculate the t-maps and contrast beta files for an individual (one
% person's data)
% note that all old contrasts are deleted, and replaced by the contrasts
% contained within this file.
%
% Inputs:
% directory: The directory where the SPM.mat file for this participant is
% found
%
% contrast_matrix: the complete contrast matrix. Note that zeros will not
% be added to pad out the contrast matrix (which SPM's contrast managaer
% will do for you). Thus, it is important to add zeros for any regressors
% (such as motion) and a zero for the mean of each run at the end of the
% cotnrast.
%
% names: an optional variable, indicating the names of the individual
% contrast. If given, it should have one value per contrast. Two types of
% input are possible: a text file with one contrast name per line, or an
% arrary of cells (one name per cell).
%
%

if ~isempty(names)
    if isstr(names)
        name = textread(name,'%s','delimiter','\n')
        for idx =  1:size(contasts, 1)
            contrasts.names{idx} = in(idx);
        end
    end
    
    if iscell(names)
        for idx =  1:size(contrast_matrix, 1)
            contrasts.names{1,idx} = names{idx};
        end
    end % if iscell
    
else %names not provided
    for idx =  1:size(contrast_matrix, 1)
        contrasts.names{1,idx} = ['F' num2str(idx)];
    end
end

for idx = 1:size(contrast_matrix, 1)
    tc{idx} = contrast_matrix(idx,:);
    contrasts.types{idx} = 'F';
end

cd(directory)
load SPM
% any existing contrasts are removed, to make sure we know what is what
% after the program is finished.
% this also removes an empty contrast field SPM writes into the SPM.mat
% file, which gave problems in the for loop below.
SPM = rmfield(SPM, 'xCon') %#ok<NOPRT>
for c=1:length(tc)
    c
    SPM.xCon(c)= spm_FcUtil('Set',contrasts.names{c},contrasts.types{c},'c',tc{c}',SPM.xX.xKXs);
end
spm_contrasts(SPM, 1:length(tc));
clear SPM