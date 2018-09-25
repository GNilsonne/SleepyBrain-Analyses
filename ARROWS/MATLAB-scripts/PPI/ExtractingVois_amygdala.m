spm_jobman('initcfg');
root_path = '/data/stress/ARROWS/ARROWS_Young2/45Slices';
folders = dir(root_path);
folders = folders(arrayfun(@(folder) ~strcmp(folder.name(1), '.'),folders));


for i = 1:length(folders)
    subject_session = folders(i).name;
    subject = subject_session(1:3);
    session = subject_session(5);
    cd(strcat('/data/stress/ARROWS/ARROWS_Young2/45Slices/', subject_session, '/1st_level_151208'));

    matlabbatch{1}.spm.util.voi.spmmat = {'SPM.mat'};
    matlabbatch{1}.spm.util.voi.adjust = 0;
    matlabbatch{1}.spm.util.voi.session = 1;
    matlabbatch{1}.spm.util.voi.name = 'Amygdala_R';
    %matlabbatch{1}.spm.util.voi.roi{1}.spm.spmmat = {''};
    %matlabbatch{1}.spm.util.voi.roi{1}.spm.contrast = 1;
    %matlabbatch{1}.spm.util.voi.roi{1}.spm.threshdesc = 'none';
    %matlabbatch{1}.spm.util.voi.roi{1}.spm.thresh = 0.05;
    %matlabbatch{1}.spm.util.voi.roi{1}.spm.extent = 0;
    %matlabbatch{1}.spm.util.voi.roi{2}.mask.image = {'/data/stress/ARROWS/RegionsOfInterest/Amygdala_R_WFU.nii'};
    matlabbatch{1}.spm.util.voi.roi{1}.sphere.centre = [22 -3 -12]; 
    matlabbatch{1}.spm.util.voi.roi{1}.sphere.radius = 6;
    matlabbatch{1}.spm.util.voi.roi{1}.sphere.move.fixed = 1;
    %matlabbatch{1}.spm.util.voi.roi{3}.sphere.move.global.mask = 'i2';
    matlabbatch{1}.spm.util.voi.expression = 'i1';

    matlabbatch{2}.spm.util.voi.spmmat = {'SPM.mat'};
    matlabbatch{2}.spm.util.voi.adjust = 0;
    matlabbatch{2}.spm.util.voi.session = 1;
    matlabbatch{2}.spm.util.voi.name = 'Amygdala_L';
    %matlabbatch{2}.spm.util.voi.roi{1}.spm.spmmat = {''};
    %matlabbatch{2}.spm.util.voi.roi{1}.spm.contrast = 1;
    %matlabbatch{2}.spm.util.voi.roi{1}.spm.threshdesc = 'none';
    %matlabbatch{2}.spm.util.voi.roi{1}.spm.thresh = 0.05;
    %matlabbatch{2}.spm.util.voi.roi{1}.spm.extent = 0;
    %matlabbatch{2}.spm.util.voi.roi{2}.mask.image = {'/data/stress/ARROWS/RegionsOfInterest/Amygdala_L_WFU.nii'};
    matlabbatch{2}.spm.util.voi.roi{1}.sphere.centre = [-21 -2 -16];
    matlabbatch{2}.spm.util.voi.roi{1}.sphere.radius = 6;
    matlabbatch{2}.spm.util.voi.roi{1}.sphere.move.fixed = 1;
    %matlabbatch{2}.spm.util.voi.roi{3}.sphere.move.global.mask = 'i2';
    matlabbatch{2}.spm.util.voi.expression = 'i1'; 

    spm_jobman('run', matlabbatch)

    clear matlabbatch 
end


root_path = '/data/stress/ARROWS/ARROWS_Young2/46Slices';
folders = dir(root_path);
folders = folders(arrayfun(@(folder) ~strcmp(folder.name(1), '.'),folders));


for j = 1:length(folders)
    subject_session = folders(j).name;
    subject = subject_session(1:3);
    session = subject_session(5);
    cd(strcat('/data/stress/ARROWS/ARROWS_Young2/46Slices/', subject_session, '/1st_level_151208'));

    matlabbatch{1}.spm.util.voi.spmmat = {'SPM.mat'};
    matlabbatch{1}.spm.util.voi.adjust = 0;
    matlabbatch{1}.spm.util.voi.session = 1;
    matlabbatch{1}.spm.util.voi.name = 'Amygdala_R';
    %matlabbatch{1}.spm.util.voi.roi{1}.spm.spmmat = {''};
    %matlabbatch{1}.spm.util.voi.roi{1}.spm.contrast = 1;
    %matlabbatch{1}.spm.util.voi.roi{1}.spm.threshdesc = 'none';
    %matlabbatch{1}.spm.util.voi.roi{1}.spm.thresh = 0.05;
    %matlabbatch{1}.spm.util.voi.roi{1}.spm.extent = 0;
    %matlabbatch{1}.spm.util.voi.roi{2}.mask.image = {'/data/stress/ARROWS/RegionsOfInterest/Amygdala_R_WFU.nii'};
    matlabbatch{1}.spm.util.voi.roi{1}.sphere.centre = [22 -3 -12]; 
    matlabbatch{1}.spm.util.voi.roi{1}.sphere.radius = 6;
    matlabbatch{1}.spm.util.voi.roi{1}.sphere.move.fixed = 1;
    %matlabbatch{1}.spm.util.voi.roi{3}.sphere.move.global.mask = 'i2';
    matlabbatch{1}.spm.util.voi.expression = 'i1';

    matlabbatch{2}.spm.util.voi.spmmat = {'SPM.mat'};
    matlabbatch{2}.spm.util.voi.adjust = 0;
    matlabbatch{2}.spm.util.voi.session = 1;
    matlabbatch{2}.spm.util.voi.name = 'Amygdala_L';
    %matlabbatch{2}.spm.util.voi.roi{1}.spm.spmmat = {''};
    %matlabbatch{2}.spm.util.voi.roi{1}.spm.contrast = 1;
    %matlabbatch{2}.spm.util.voi.roi{1}.spm.threshdesc = 'none';
    %matlabbatch{2}.spm.util.voi.roi{1}.spm.thresh = 0.05;
    %matlabbatch{2}.spm.util.voi.roi{1}.spm.extent = 0;
    %matlabbatch{2}.spm.util.voi.roi{2}.mask.image = {'/data/stress/ARROWS/RegionsOfInterest/Amygdala_L_WFU.nii'};
    matlabbatch{2}.spm.util.voi.roi{1}.sphere.centre = [-21 -2 -16];
    matlabbatch{2}.spm.util.voi.roi{1}.sphere.radius = 6;
    matlabbatch{2}.spm.util.voi.roi{1}.sphere.move.fixed = 1;
    %matlabbatch{2}.spm.util.voi.roi{3}.sphere.move.global.mask = 'i2';
    matlabbatch{2}.spm.util.voi.expression = 'i1'; 

    spm_jobman('run', matlabbatch)

    clear matlabbatch 
end


root_path = '/data/stress/ARROWS/ARROWS_Old';
folders = dir(root_path);
folders = folders(arrayfun(@(folder) ~strcmp(folder.name(1), '.'),folders));


for k = 1:length(folders)
    subject_session = folders(k).name;
    subject = subject_session(1:3);
    session = subject_session(5);
    cd(strcat('/data/stress/ARROWS/ARROWS_Old/', subject_session, '/1st_level_151208'));

    matlabbatch{1}.spm.util.voi.spmmat = {'SPM.mat'};
    matlabbatch{1}.spm.util.voi.adjust = 0;
    matlabbatch{1}.spm.util.voi.session = 1;
    matlabbatch{1}.spm.util.voi.name = 'Amygdala_R';
    %matlabbatch{1}.spm.util.voi.roi{1}.spm.spmmat = {''};
    %matlabbatch{1}.spm.util.voi.roi{1}.spm.contrast = 1;
    %matlabbatch{1}.spm.util.voi.roi{1}.spm.threshdesc = 'none';
    %matlabbatch{1}.spm.util.voi.roi{1}.spm.thresh = 0.05;
    %matlabbatch{1}.spm.util.voi.roi{1}.spm.extent = 0;
    %matlabbatch{1}.spm.util.voi.roi{2}.mask.image = {'/data/stress/ARROWS/RegionsOfInterest/Amygdala_R_WFU.nii'};
    matlabbatch{1}.spm.util.voi.roi{1}.sphere.centre = [22 -3 -12]; 
    matlabbatch{1}.spm.util.voi.roi{1}.sphere.radius = 6;
    matlabbatch{1}.spm.util.voi.roi{1}.sphere.move.fixed = 1;
    %matlabbatch{1}.spm.util.voi.roi{3}.sphere.move.global.mask = 'i2';
    matlabbatch{1}.spm.util.voi.expression = 'i1';

    matlabbatch{2}.spm.util.voi.spmmat = {'SPM.mat'};
    matlabbatch{2}.spm.util.voi.adjust = 0;
    matlabbatch{2}.spm.util.voi.session = 1;
    matlabbatch{2}.spm.util.voi.name = 'Amygdala_L';
    %matlabbatch{2}.spm.util.voi.roi{1}.spm.spmmat = {''};
    %matlabbatch{2}.spm.util.voi.roi{1}.spm.contrast = 1;
    %matlabbatch{2}.spm.util.voi.roi{1}.spm.threshdesc = 'none';
    %matlabbatch{2}.spm.util.voi.roi{1}.spm.thresh = 0.05;
    %matlabbatch{2}.spm.util.voi.roi{1}.spm.extent = 0;
    %matlabbatch{2}.spm.util.voi.roi{2}.mask.image = {'/data/stress/ARROWS/RegionsOfInterest/Amygdala_L_WFU.nii'};
    matlabbatch{2}.spm.util.voi.roi{1}.sphere.centre = [-21 -2 -16];
    matlabbatch{2}.spm.util.voi.roi{1}.sphere.radius = 6;
    matlabbatch{2}.spm.util.voi.roi{1}.sphere.move.fixed = 1;
    %matlabbatch{2}.spm.util.voi.roi{3}.sphere.move.global.mask = 'i2';
    matlabbatch{2}.spm.util.voi.expression = 'i1'; 

    spm_jobman('run', matlabbatch)

    clear matlabbatch 
end

