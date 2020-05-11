%-----------------------------------------------------------------------
% Job saved on 21-Nov-2018 12:08:12 by cfg_util (rev $Rev: 6942 $)
% spm SPM - SPM12 (7219)
% cfg_basicio BasicIO - Unknown
%- 17, 20, 23

cd /data/stress/FACES_Sandra/Data;

folders = dir();
for i = 24:length(folders)
    cd /data/stress/FACES_Sandra/Data;
    cd(strcat(folders(i).name, '/'));
    sessions = dir();
    for j = 3:length(sessions)
       cd(strcat('/data/stress/FACES_Sandra/Data/', folders(i).name, '/', sessions(j).name, '/')); 
       files = dir(strcat('/data/stress/FACES_Sandra/Data/', folders(i).name, '/', sessions(j).name, '/2*.nii'));
       data = arrayfun(@(file) strcat('/data/stress/FACES_Sandra/Data/', folders(i).name, '/', sessions(j).name, '/', file.name), files, 'UniformOutput', false);
       matlabbatch{1}.spm.util.cat.vols = data;
       matlabbatch{1}.spm.util.cat.name = '4D.nii';
       matlabbatch{1}.spm.util.cat.dtype = 4;
       spm_jobman('run',matlabbatch);
       clear('matlabbatch');
    end
    
end

%%

