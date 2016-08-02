root_path = '/data/stress/HANDS_AGE/45Slices';
folders = dir(root_path);
folders = folders(arrayfun(@(folders) ~strcmp(folders.name(1), '.'),folders));

for i = 1:length(folders)
    subject_session = folders(i).name;
    s = subject_session(1:3);
    subject = str2num(s);
    ses = subject_session(5);
    session = str2num(ses);
    ACC = mean(spm_summarise(strcat('/data/stress/HANDS_AGE/45Slices/', subject_session, '/1st_level_150320/con_0003.nii'), struct('def', 'mask', 'spec', '/data/stress/HANDS_AGE/Sphere_ROIs/ACC_sphere.nii')));
    AI_L = mean(spm_summarise(strcat('/data/stress/HANDS_AGE/45Slices/', subject_session, '/1st_level_150320/con_0003.nii'), struct('def', 'mask', 'spec', '/data/stress/HANDS_AGE/Sphere_ROIs/AI_L_sphere.nii')));
    AI_R = mean(spm_summarise(strcat('/data/stress/HANDS_AGE/45Slices/', subject_session, '/1st_level_150320/con_0003.nii'), struct('def', 'mask', 'spec', '/data/stress/HANDS_AGE/Sphere_ROIs/AI_R_sphere.nii')));
    
    if i == 1
       data = [subject, session, ACC, AI_L, AI_R];
   else
       data = [data; subject, session, ACC, AI_L, AI_R];
   end
end

root_path = '/data/stress/HANDS_AGE/46Slices';
folders = dir(root_path);
folders = folders(arrayfun(@(folders) ~strcmp(folders.name(1), '.'),folders));

for i = 1:length(folders)
    subject_session = folders(i).name;
    s = subject_session(1:3);
    subject = str2num(s);
    ses = subject_session(5);
    session = str2num(ses);
    ACC = mean(spm_summarise(strcat('/data/stress/HANDS_AGE/46Slices/', subject_session, '/1st_level_150320/con_0003.nii'), struct('def', 'mask', 'spec', '/data/stress/HANDS_AGE/Sphere_ROIs/ACC_sphere.nii')));
    AI_L = mean(spm_summarise(strcat('/data/stress/HANDS_AGE/46Slices/', subject_session, '/1st_level_150320/con_0003.nii'), struct('def', 'mask', 'spec', '/data/stress/HANDS_AGE/Sphere_ROIs/AI_L_sphere.nii')));
    AI_R = mean(spm_summarise(strcat('/data/stress/HANDS_AGE/46Slices/', subject_session, '/1st_level_150320/con_0003.nii'), struct('def', 'mask', 'spec', '/data/stress/HANDS_AGE/Sphere_ROIs/AI_R_sphere.nii')));
    
   if i == 1
       data2 = [subject, session, ACC, AI_L, AI_R];
   else
       data2 = [data2; subject, session, ACC, AI_L, AI_R];
   end
end

data = [data; data2];

cd /data/stress/HANDS_AGE/ExtractedData_150622/
csvwrite('Data_151027_painvsnopain_spheres', data)